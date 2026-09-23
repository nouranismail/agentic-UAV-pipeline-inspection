function result = deepLearningDetector(processedData, imageData, configuration, detector)
%DEEPLEARNINGDETECTOR Execute the approved replaceable learned detector.

result = iiw.detection.DetectorContract.invalidResult();
if ~iiw.detection.DetectorContract.isValidProcessedData(processedData) || ...
        ~iiw.detection.DetectorContract.isConformingDetector(detector) || ...
        isempty(imageData) || ~(isnumeric(imageData) || islogical(imageData)) || ...
        ~isreal(imageData) || any(~isfinite(imageData(:)))
    return
end

persistent cachedArtifact cachedPath cachedStamp
modelPath = defaultModelPath();
if ~isfile(modelPath)
    return
end
stamp = dir(modelPath);
if isempty(cachedArtifact) || cachedPath ~= string(modelPath) || ...
        cachedStamp ~= stamp.datenum
    loaded = load(modelPath, "modelArtifact");
    if ~isfield(loaded, "modelArtifact") || ~validArtifact(loaded.modelArtifact)
        return
    end
    cachedArtifact = loaded.modelArtifact;
    cachedPath = string(modelPath);
    cachedStamp = stamp.datenum;
end

try
    image = normalizeImage(imageData, cachedArtifact.inputSize);
    scores = minibatchpredict(cachedArtifact.network, reshape(image, ...
        [cachedArtifact.inputSize 1]), MiniBatchSize=1);
    if isa(scores, "dlarray")
        scores = extractdata(scores);
    end
    scores = gather(single(scores));
    anomalyScore = squeeze(scores(:, :, 2, 1));
    if any(~isfinite(anomalyScore(:)))
        return
    end

    mask = anomalyScore >= cachedArtifact.pixelThreshold;
    mask = bwareaopen(mask, double(configuration.minimumArea), 8);
    result = baseResult(processedData, configuration, detector);
    if ~any(mask, "all")
        return
    end

    components = bwconncomp(mask, 8);
    stats = regionprops(components, anomalyScore, "Area", "Centroid", "MeanIntensity");
    [~, index] = max([stats.Area]);
    selected = stats(index);
    result.labelId = configuration.labelId;
    result.confidence = min(single(1), max(single(0), single(selected.MeanIntensity)));
    if configuration.emitLocation
        centroid = selected.Centroid;
        result.location = [configuration.locationOrigin(1) + ...
            (centroid(1) - 1) * configuration.locationScale(1); ...
            configuration.locationOrigin(2) + ...
            (centroid(2) - 1) * configuration.locationScale(2); ...
            configuration.locationOrigin(3)];
        result.locationValid = true;
        result.frameId = configuration.frameId;
    end
catch
    result = iiw.detection.DetectorContract.invalidResult();
end
end

function image = normalizeImage(value, inputSize)
if islogical(value)
    image = single(value);
elseif isa(value, "uint8")
    image = single(value) / single(255);
elseif isa(value, "uint16")
    image = single(value) / single(65535);
else
    image = single(value);
end
if any(image(:) < 0 | image(:) > 1)
    error("iiw:detection:InvalidImageRange", "Image values must be in [0,1].");
end
if ismatrix(image)
    image = repmat(image, 1, 1, 3);
elseif ndims(image) ~= 3 || size(image, 3) ~= 3
    error("iiw:detection:InvalidImageShape", "Image shape is unsupported.");
end
image = imresize(image, inputSize(1:2), "bilinear");
end

function valid = validArtifact(value)
required = ["network"; "inputSize"; "pixelThreshold"; "modelVersion"; ...
    "datasetArchiveSha256"; "splitConfiguration"; "trainingConfiguration"];
valid = isstruct(value) && isscalar(value) && all(isfield(value, required)) && ...
    isa(value.network, "dlnetwork") && isequal(size(value.inputSize), [1 3]) && ...
    isa(value.pixelThreshold, "single") && isscalar(value.pixelThreshold) && ...
    value.pixelThreshold >= 0 && value.pixelThreshold <= 1 && ...
    isa(value.modelVersion, "uint16") && value.modelVersion ~= 0;
end

function result = baseResult(processedData, configuration, detector)
result = struct("resultId", configuration.resultId, ...
    "processedItemId", processedData.processedItemId, ...
    "labelId", uint8(0), "confidence", single(0), ...
    "location", zeros(3, 1, "double"), ...
    "modelVersion", detector.implementationVersion, ...
    "schemaVersion", configuration.resultSchemaVersion, ...
    "confidenceValid", true, "locationValid", false, "frameId", uint16(0));
end

function path = defaultModelPath()
source = fileparts(mfilename("fullpath"));
extensionRoot = fileparts(fileparts(fileparts(source)));
path = fullfile(extensionRoot, "models", "deep_learning_detector.mat");
end
