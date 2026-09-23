function result = validateInspectionData(inspectionData, inspectionMetadata, payload, configuration)
%VALIDATEINSPECTIONDATA Validate generic inspection data and data quality.
%   RESULT = IIW.QUALITY.VALIDATEINSPECTIONDATA(DATA, METADATA, PAYLOAD,
%   CONFIGURATION) validates the approved InspectionData and
%   InspectionMetadata runtime structures and returns the approved
%   DataQualityResult representation. The function performs validation and
%   quality measurement only; it does not preprocess or transform PAYLOAD.

result = emptyResult();
codes = defaultReasonCodes();

try
    [configurationValid, codes] = validateConfiguration(configuration, codes);
    if configurationValid
        result.validatorVersion = configuration.validatorVersion;
    else
        result = addReason(result, codes(16));
        result.status = uint8(3);
        return
    end

    [dataValid, itemId, dataReasons] = validateInspectionDataRecord(inspectionData, codes);
    result.itemId = itemId;
    result = addReasons(result, dataReasons);

    [metadataValid, metadataReasons] = validateMetadataRecord( ...
        inspectionMetadata, itemId, codes);
    result = addReasons(result, metadataReasons);

    [payloadValid, payloadReasons] = validatePayload(payload, inspectionData, codes);
    result = addReasons(result, payloadReasons);

    if ~(dataValid && metadataValid && payloadValid)
        result.status = uint8(3);
        return
    end

    if inspectionData.modality == uint8(1)
        result = assessImage(result, payload, configuration, codes);
    else
        result.measures(1:2) = single([1; 1]);
        result.thresholdRefs(1:2) = configuration.thresholdRefs(1:2);
        result.measureCount = uint8(2);
        result.status = uint8(1);
    end
catch
    % The public contract is fail-controlled: unexpected malformed inputs
    % produce REJECT rather than an uncontrolled caller-visible exception.
    result = addReason(result, codes(16));
    result.status = uint8(3);
end
end

function result = assessImage(result, payload, configuration, codes)
normalizedImage = normalizeImage(payload);
if ndims(normalizedImage) == 3
    grayImage = im2gray(normalizedImage);
else
    grayImage = normalizedImage;
end

brightness = single(mean(grayImage(:), "double"));
contrast = single(min(2 * std(double(grayImage(:)), 0), 1));
laplacianKernel = [0 1 0; 1 -4 1; 0 1 0];
laplacianResponse = imfilter(grayImage, laplacianKernel, "replicate", "conv");
sharpness = single(min(mean(abs(laplacianResponse(:)), "double") / 4, 1));
saturationFraction = single(mean(grayImage(:) >= single(configuration.saturationLevel)));
validFraction = single(1);

brightnessScore = intervalScore(brightness, ...
    single(configuration.minBrightness), single(configuration.maxBrightness));
contrastScore = lowerBoundScore(contrast, single(configuration.minContrast));
sharpnessScore = lowerBoundScore(sharpness, single(configuration.minSharpness));
saturationScore = upperBoundScore(saturationFraction, ...
    single(configuration.maxSaturationFraction));
qualityScore = min([brightnessScore, contrastScore, sharpnessScore, saturationScore]);

result.measures(1:6) = single([qualityScore; brightness; contrast; ...
    sharpness; saturationFraction; validFraction]);
result.thresholdRefs(1:6) = configuration.thresholdRefs;
result.measureCount = uint8(6);

brightnessMeetsMinimum = single(brightness) >= single(configuration.minBrightness);
brightnessMeetsMaximum = single(brightness) <= single(configuration.maxBrightness);
contrastMeetsMinimum = single(contrast) >= single(configuration.minContrast);
sharpnessMeetsMinimum = single(sharpness) >= single(configuration.minSharpness);
saturationMeetsMaximum = single(saturationFraction) <= ...
    single(configuration.maxSaturationFraction);

if ~brightnessMeetsMinimum
    result = addReason(result, codes(11));
end
if ~brightnessMeetsMaximum
    result = addReason(result, codes(12));
end
if ~contrastMeetsMinimum
    result = addReason(result, codes(13));
end
if ~sharpnessMeetsMinimum
    result = addReason(result, codes(14));
end
if ~saturationMeetsMaximum
    result = addReason(result, codes(15));
end

if result.reasonCodeCount == 0
    result.status = uint8(1);
else
    result.status = uint8(3);
end
end

function normalizedImage = normalizeImage(payload)
if islogical(payload)
    normalizedImage = single(payload);
elseif isa(payload, "uint8")
    normalizedImage = single(payload) / single(intmax("uint8"));
elseif isa(payload, "uint16")
    normalizedImage = single(payload) / single(intmax("uint16"));
else
    normalizedImage = single(payload);
end
end

function [valid, codes] = validateConfiguration(configuration, codes)
valid = isstruct(configuration) && isscalar(configuration);
required = ["validatorVersion", "thresholdRefs", "reasonCodes", ...
    "minBrightness", "maxBrightness", "minContrast", "minSharpness", ...
    "maxSaturationFraction", "saturationLevel"];
if ~valid || ~all(isfield(configuration, required))
    valid = false;
    return
end

valid = isa(configuration.validatorVersion, "uint16") && ...
    isscalar(configuration.validatorVersion) && configuration.validatorVersion ~= 0;
valid = valid && isa(configuration.thresholdRefs, "uint32") && ...
    isequal(size(configuration.thresholdRefs), [6 1]) && ...
    all(configuration.thresholdRefs ~= 0);
valid = valid && isa(configuration.reasonCodes, "uint8") && ...
    isequal(size(configuration.reasonCodes), [16 1]) && ...
    all(configuration.reasonCodes ~= 0) && all(configuration.reasonCodes ~= 255);

scoreFields = ["minBrightness", "maxBrightness", "minContrast", ...
    "minSharpness", "maxSaturationFraction", "saturationLevel"];
for index = 1:numel(scoreFields)
    value = configuration.(scoreFields(index));
    valid = valid && isa(value, "single") && isscalar(value) && ...
        isfinite(value) && value >= 0 && value <= 1;
end

valid = valid && configuration.minBrightness <= configuration.maxBrightness;
if valid
    codes = configuration.reasonCodes;
end
end

function [valid, itemId, reasons] = validateInspectionDataRecord(record, codes)
valid = true;
itemId = uint32(0);
reasons = uint8.empty(0, 1);
if ~(isstruct(record) && isscalar(record))
    valid = false;
    reasons(end + 1, 1) = codes(3);
    return
end

fields = ["itemId", "payloadRef", "modality", "sourceId", ...
    "sequenceId", "timestamp", "schemaVersion"];
if ~all(isfield(record, fields))
    valid = false;
    reasons(end + 1, 1) = codes(1);
    return
end

if isa(record.itemId, "uint32") && isscalar(record.itemId)
    itemId = record.itemId;
end
valid = valid && validateScalar(record.itemId, "uint32", false);
valid = valid && validateScalar(record.payloadRef, "uint32", false);
valid = valid && validateScalar(record.modality, "uint8", false) && ...
    ismember(record.modality, uint8(1:5));
valid = valid && validateScalar(record.sourceId, "uint32", false);
valid = valid && validateScalar(record.sequenceId, "uint32", true);
valid = valid && validateScalar(record.timestamp, "uint64", false);
valid = valid && validateScalar(record.schemaVersion, "uint16", false);
if ~valid
    reasons(end + 1, 1) = codes(4);
end
end

function [valid, reasons] = validateMetadataRecord(record, itemId, codes)
valid = true;
reasons = uint8.empty(0, 1);
if ~(isstruct(record) && isscalar(record))
    valid = false;
    reasons(end + 1, 1) = codes(3);
    return
end

fields = ["itemId", "acquisitionContext", "calibrationRef", ...
    "contextSchemaVersion"];
if ~all(isfield(record, fields))
    valid = false;
    reasons(end + 1, 1) = codes(1);
    return
end

valid = valid && validateScalar(record.itemId, "uint32", false);
valid = valid && validateScalar(record.acquisitionContext, "uint32", false);
valid = valid && validateScalar(record.calibrationRef, "uint32", true);
valid = valid && validateScalar(record.contextSchemaVersion, "uint16", false);
if ~valid
    reasons(end + 1, 1) = codes(4);
elseif record.itemId ~= itemId
    valid = false;
    reasons(end + 1, 1) = codes(8);
end
end

function [valid, reasons] = validatePayload(payload, inspectionData, codes)
valid = true;
reasons = uint8.empty(0, 1);
if isempty(payload)
    valid = false;
    reasons(end + 1, 1) = codes(2);
    return
end
if ~(isnumeric(payload) || islogical(payload)) || ~isreal(payload)
    valid = false;
    reasons(end + 1, 1) = codes(4);
    return
end
if any(~isfinite(payload(:)))
    valid = false;
    reasons(end + 1, 1) = codes(7);
    return
end

if inspectionData.modality == uint8(1)
    validDimensions = ismatrix(payload) || ...
        (ndims(payload) == 3 && size(payload, 3) == 3);
    validType = islogical(payload) || isa(payload, "uint8") || ...
        isa(payload, "uint16") || isa(payload, "single") || isa(payload, "double");
    floatingRangeValid = ~(isa(payload, "single") || isa(payload, "double")) || ...
        all(payload(:) >= 0 & payload(:) <= 1);
    valid = validDimensions && validType && floatingRangeValid;
elseif inspectionData.modality == uint8(3)
    valid = ismatrix(payload) && ~islogical(payload);
else
    valid = false;
    reasons(end + 1, 1) = codes(10);
end

if ~valid && isempty(reasons)
    reasons(end + 1, 1) = codes(5);
end
end

function valid = validateScalar(value, expectedClass, allowZero)
valid = isa(value, expectedClass) && isscalar(value) && isreal(value);
if valid && ~allowZero
    valid = value ~= 0;
end
end

function score = intervalScore(value, lower, upper)
value = single(value);
lower = single(lower);
upper = single(upper);
if value < lower
    if lower == 0
        score = single(0);
    else
        score = value / lower;
    end
elseif value > upper
    if upper == 1
        score = single(0);
    else
        score = (single(1) - value) / (single(1) - upper);
    end
else
    score = single(1);
end
score = min(max(score, single(0)), single(1));
end

function score = lowerBoundScore(value, lower)
value = single(value);
lower = single(lower);
if lower == 0
    score = single(1);
else
    score = min(max(value / lower, single(0)), single(1));
end
end

function score = upperBoundScore(value, upper)
value = single(value);
upper = single(upper);
if value <= upper
    score = single(1);
elseif upper == 1
    score = single(0);
else
    score = (single(1) - value) / (single(1) - upper);
end
score = min(max(score, single(0)), single(1));
end

function result = addReasons(result, reasons)
for index = 1:numel(reasons)
    result = addReason(result, reasons(index));
end
end

function result = addReason(result, code)
count = double(result.reasonCodeCount);
if count < 16 && code ~= 0 && ~any(result.reasonCodes(1:count) == code)
    count = count + 1;
    result.reasonCodes(count) = code;
    result.reasonCodeCount = uint8(count);
end
end

function result = emptyResult()
result = struct( ...
    "itemId", uint32(0), ...
    "status", uint8(0), ...
    "measures", zeros(32, 1, "single"), ...
    "thresholdRefs", zeros(32, 1, "uint32"), ...
    "reasonCodes", zeros(16, 1, "uint8"), ...
    "validatorVersion", uint16(0), ...
    "measureCount", uint8(0), ...
    "reasonCodeCount", uint8(0));
end

function codes = defaultReasonCodes()
codes = uint8((1:16).');
end
