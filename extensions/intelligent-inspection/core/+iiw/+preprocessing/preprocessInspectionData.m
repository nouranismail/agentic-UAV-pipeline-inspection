function [processedData, outputImage, transformHistory] = ...
    preprocessInspectionData(inspectionData, dataQualityResult, inputImage, configuration)
%PREPROCESSINSPECTIONDATA Apply configured deterministic image transformations.
%   Processing occurs only for a conforming quality result whose status is
%   PASS. Invalid or non-PASS input produces an empty image, an empty
%   transformation history, and the default ProcessedData representation.

processedData = emptyProcessedData();
outputImage = [];
transformHistory = emptyTransformHistory();

try
    if ~validInspectionData(inspectionData) || ...
            ~validQualityResult(dataQualityResult, inspectionData.itemId) || ...
            dataQualityResult.status ~= uint8(1) || ...
            ~validConfiguration(configuration)
        return
    end

    currentImage = inputImage;
    currentReference = inspectionData.payloadRef;
    operationOrder = configuration.operationOrder(:);

    for index = 1:numel(operationOrder)
        operationCode = operationOrder(index);
        [currentImage, parameterIds, parameterValues] = applyOperation( ...
            currentImage, operationCode, configuration);

        if index == numel(operationOrder)
            outputReference = configuration.representationRef;
        else
            outputReference = configuration.intermediateReferenceBase + uint32(index - 1);
        end

        entry = iiw.preprocessing.recordTransform(uint8(index), operationCode, ...
            parameterIds, parameterValues, configuration.implementationVersion, ...
            configuration.configurationVersion, currentReference, outputReference);
        transformHistory(end + 1, 1) = entry; %#ok<AGROW>
        currentReference = outputReference;
    end

    processedData.processedItemId = configuration.processedItemId;
    processedData.sourceItemId = inspectionData.itemId;
    processedData.representationRef = configuration.representationRef;
    processedData.transformRecordRef = configuration.transformRecordRef;
    processedData.configurationVersion = configuration.configurationVersion;
    processedData.schemaVersion = configuration.schemaVersion;
    outputImage = currentImage;
catch
    processedData = emptyProcessedData();
    outputImage = [];
    transformHistory = emptyTransformHistory();
end
end

function [image, parameterIds, parameterValues] = applyOperation(image, code, configuration)
switch code
    case uint8(1)
        image = normalizeFormatAndChannels(image, configuration.targetChannels);
        parameterIds = uint16(1);
        parameterValues = single(configuration.targetChannels);
    case uint8(2)
        method = interpolationName(configuration.interpolationMethod);
        image = imresize(image, double(configuration.targetSize(:).'), method);
        parameterIds = uint16([2; 3; 4]);
        parameterValues = [single(configuration.targetSize(:)); ...
            single(configuration.interpolationMethod)];
    case uint8(3)
        image = mapIntensity(image, configuration.intensityInputRange, ...
            configuration.intensityOutputRange, single(1));
        parameterIds = uint16((5:8).');
        parameterValues = single([configuration.intensityInputRange(:); ...
            configuration.intensityOutputRange(:)]);
    case uint8(4)
        image = imgaussfilt(image, double(configuration.denoiseSigma), ...
            FilterSize=double(configuration.denoiseFilterSize), Padding="replicate");
        parameterIds = uint16([9; 10]);
        parameterValues = [single(configuration.denoiseSigma); ...
            single(configuration.denoiseFilterSize)];
    case uint8(5)
        image = mapIntensity(image, configuration.contrastInputRange, ...
            configuration.contrastOutputRange, configuration.contrastGamma);
        parameterIds = uint16((11:15).');
        parameterValues = single([configuration.contrastInputRange(:); ...
            configuration.contrastOutputRange(:); configuration.contrastGamma]);
    otherwise
        error("iiw:preprocessing:UnsupportedOperation", ...
            "The configured preprocessing operation is unsupported.");
end
image = single(image);
end

function image = normalizeFormatAndChannels(inputImage, targetChannels)
if isempty(inputImage) || ~(isnumeric(inputImage) || islogical(inputImage)) || ...
        ~isreal(inputImage) || any(~isfinite(inputImage(:)))
    error("iiw:preprocessing:InvalidImage", "The input image is invalid.");
end

validDimensions = ismatrix(inputImage) || ...
    (ndims(inputImage) == 3 && size(inputImage, 3) == 3);
if ~validDimensions
    error("iiw:preprocessing:InvalidImage", "The input image dimensions are unsupported.");
end

if islogical(inputImage)
    image = single(inputImage);
elseif isa(inputImage, "uint8")
    image = single(inputImage) / single(intmax("uint8"));
elseif isa(inputImage, "uint16")
    image = single(inputImage) / single(intmax("uint16"));
elseif isa(inputImage, "single") || isa(inputImage, "double")
    if any(inputImage(:) < 0 | inputImage(:) > 1)
        error("iiw:preprocessing:InvalidImageRange", ...
            "Floating-point image values must be in the range [0,1].");
    end
    image = single(inputImage);
else
    error("iiw:preprocessing:InvalidImageType", "The input image type is unsupported.");
end

if targetChannels == uint8(1) && ndims(image) == 3
    image = im2gray(image);
elseif targetChannels == uint8(3) && ismatrix(image)
    image = repmat(image, 1, 1, 3);
end
end

function output = mapIntensity(input, inputRange, outputRange, gamma)
inputLow = single(inputRange(1));
inputHigh = single(inputRange(2));
outputLow = single(outputRange(1));
outputHigh = single(outputRange(2));
gamma = single(gamma);

scaled = (single(input) - inputLow) ./ (inputHigh - inputLow);
scaled = min(max(scaled, single(0)), single(1));
scaled = scaled .^ gamma;
output = outputLow + scaled .* (outputHigh - outputLow);
output = single(output);
end

function name = interpolationName(code)
switch code
    case uint8(1)
        name = "nearest";
    case uint8(2)
        name = "bilinear";
    case uint8(3)
        name = "bicubic";
    otherwise
        error("iiw:preprocessing:InvalidInterpolation", ...
            "The interpolation encoding is invalid.");
end
end

function valid = validInspectionData(value)
fields = ["itemId", "payloadRef", "modality", "sourceId", ...
    "sequenceId", "timestamp", "schemaVersion"];
valid = isstruct(value) && isscalar(value) && all(isfield(value, fields));
if ~valid
    return
end
valid = validScalar(value.itemId, "uint32", false) && ...
    validScalar(value.payloadRef, "uint32", false) && ...
    validScalar(value.modality, "uint8", false) && value.modality == uint8(1) && ...
    validScalar(value.sourceId, "uint32", false) && ...
    validScalar(value.sequenceId, "uint32", false) && ...
    validScalar(value.timestamp, "uint64", true) && ...
    validScalar(value.schemaVersion, "uint16", false);
end

function valid = validQualityResult(value, sourceItemId)
fields = ["itemId", "status", "measures", "thresholdRefs", ...
    "reasonCodes", "validatorVersion", "measureCount", "reasonCodeCount"];
valid = isstruct(value) && isscalar(value) && all(isfield(value, fields));
if ~valid
    return
end
valid = validScalar(value.itemId, "uint32", false) && value.itemId == sourceItemId && ...
    validScalar(value.status, "uint8", false) && value.status <= uint8(3) && ...
    isa(value.measures, "single") && isequal(size(value.measures), [32 1]) && ...
    all(isfinite(value.measures)) && all(value.measures >= 0 & value.measures <= 1) && ...
    isa(value.thresholdRefs, "uint32") && isequal(size(value.thresholdRefs), [32 1]) && ...
    isa(value.reasonCodes, "uint8") && isequal(size(value.reasonCodes), [16 1]) && ...
    validScalar(value.validatorVersion, "uint16", false) && ...
    validScalar(value.measureCount, "uint8", true) && value.measureCount <= uint8(32) && ...
    validScalar(value.reasonCodeCount, "uint8", true) && value.reasonCodeCount <= uint8(16);
end

function valid = validConfiguration(value)
fields = ["processedItemId", "representationRef", "transformRecordRef", ...
    "configurationVersion", "schemaVersion", "implementationVersion", ...
    "intermediateReferenceBase", "operationOrder", "targetChannels", ...
    "targetSize", "interpolationMethod", "intensityInputRange", ...
    "intensityOutputRange", "denoiseSigma", "denoiseFilterSize", ...
    "contrastInputRange", "contrastOutputRange", "contrastGamma"];
valid = isstruct(value) && isscalar(value) && all(isfield(value, fields));
if ~valid
    return
end

order = value.operationOrder;
valid = validScalar(value.processedItemId, "uint32", false) && ...
    validScalar(value.representationRef, "uint32", false) && ...
    validScalar(value.transformRecordRef, "uint32", false) && ...
    validScalar(value.configurationVersion, "uint16", false) && ...
    validScalar(value.schemaVersion, "uint16", false) && ...
    validScalar(value.implementationVersion, "uint16", false) && ...
    validScalar(value.intermediateReferenceBase, "uint32", false) && ...
    isa(order, "uint8") && isvector(order) && ~isempty(order) && ...
    order(1) == uint8(1) && all(order >= 1 & order <= 5) && ...
    numel(unique(order)) == numel(order) && ...
    validScalar(value.targetChannels, "uint8", false) && ...
    any(value.targetChannels == uint8([1 3])) && ...
    isa(value.targetSize, "uint32") && isequal(size(value.targetSize), [2 1]) && ...
    all(value.targetSize > 0) && ...
    validScalar(value.interpolationMethod, "uint8", false) && ...
    value.interpolationMethod <= uint8(3) && ...
    validRange(value.intensityInputRange, false) && ...
    validRange(value.intensityOutputRange, true) && ...
    validScalar(value.denoiseSigma, "single", true) && ...
    isfinite(value.denoiseSigma) && value.denoiseSigma >= 0 && ...
    validScalar(value.denoiseFilterSize, "uint8", false) && ...
    mod(value.denoiseFilterSize, uint8(2)) == uint8(1) && ...
    validRange(value.contrastInputRange, false) && ...
    validRange(value.contrastOutputRange, true) && ...
    validScalar(value.contrastGamma, "single", false) && ...
    isfinite(value.contrastGamma) && value.contrastGamma > 0;
end

function valid = validRange(value, allowEqual)
valid = isa(value, "single") && isequal(size(value), [2 1]) && ...
    all(isfinite(value)) && all(value >= 0 & value <= 1);
if valid && allowEqual
    valid = value(1) <= value(2);
elseif valid
    valid = value(1) < value(2);
end
end

function valid = validScalar(value, expectedClass, allowZero)
valid = isa(value, expectedClass) && isscalar(value) && isreal(value);
if valid && ~allowZero
    valid = value ~= 0;
end
end

function value = emptyProcessedData()
value = struct( ...
    "processedItemId", uint32(0), ...
    "sourceItemId", uint32(0), ...
    "representationRef", uint32(0), ...
    "transformRecordRef", uint32(0), ...
    "configurationVersion", uint16(0), ...
    "schemaVersion", uint16(0));
end

function history = emptyTransformHistory()
prototype = struct( ...
    "order", uint8(0), ...
    "operationCode", uint8(0), ...
    "parameterIds", zeros(16, 1, "uint16"), ...
    "parameterValues", zeros(16, 1, "single"), ...
    "parameterCount", uint8(0), ...
    "implementationVersion", uint16(0), ...
    "configurationVersion", uint16(0), ...
    "inputReference", uint32(0), ...
    "outputReference", uint32(0));
history = repmat(prototype, 0, 1);
end
