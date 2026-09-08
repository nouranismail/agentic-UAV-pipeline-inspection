function result = conventionalDetector(processedData, imageData, configuration, detector)
%CONVENTIONALDETECTOR Deterministic configurable region detector.

result = iiw.detection.DetectorContract.invalidResult();
if ~iiw.detection.DetectorContract.isValidProcessedData(processedData) || ...
        ~iiw.detection.DetectorContract.isConformingDetector(detector)
    return
end

image = im2single(imageData);
if ndims(image) == 3
    image = im2gray(image);
end
if configuration.smoothingSigma > 0
    image = imgaussfilt(image, configuration.smoothingSigma);
end

if configuration.detectionMode == uint8(1)
    candidateMask = image >= configuration.intensityThreshold;
else
    candidateMask = image <= configuration.intensityThreshold;
end
candidateMask = bwareaopen(candidateMask, double(configuration.minimumArea), 8);
components = bwconncomp(candidateMask, 8);

result = baseResult(processedData, configuration, detector);
if components.NumObjects == 0
    return
end

statistics = regionprops(components, image, "Area", "Centroid", "MeanIntensity");
areas = [statistics.Area];
[~, selectedIndex] = max(areas);
selected = statistics(selectedIndex);

if configuration.detectionMode == uint8(1)
    denominator = max(single(1) - configuration.intensityThreshold, eps("single"));
    confidence = (single(selected.MeanIntensity) - configuration.intensityThreshold) / denominator;
else
    denominator = max(configuration.intensityThreshold, eps("single"));
    confidence = (configuration.intensityThreshold - single(selected.MeanIntensity)) / denominator;
end

result.labelId = configuration.labelId;
result.confidence = min(single(1), max(single(0), confidence));
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
end

function result = baseResult(processedData, configuration, detector)
result = struct( ...
    "resultId", configuration.resultId, ...
    "processedItemId", processedData.processedItemId, ...
    "labelId", uint8(0), ...
    "confidence", single(0), ...
    "location", zeros(3, 1, "double"), ...
    "modelVersion", detector.implementationVersion, ...
    "schemaVersion", configuration.resultSchemaVersion, ...
    "confidenceValid", true, ...
    "locationValid", false, ...
    "frameId", uint16(0));
end
