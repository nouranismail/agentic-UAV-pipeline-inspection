function result = train_deep_learning_detector()
%TRAIN_DEEP_LEARNING_DETECTOR Execute the authorized Phase 7 corrective run.

seed = 7092026;
rng(seed, "twister");
started = datetime("now", TimeZone="UTC");
repositoryRoot = fileparts(fileparts(fileparts(fileparts(mfilename("fullpath")))));
datasetRoot = getenv("IIW_DATASET_ROOT");
assert(strlength(datasetRoot) > 0, "IIW_DATASET_ROOT is not defined.");
datasetRoot = char(datasetRoot);
assert(~startsWith(string(datasetRoot), string(repositoryRoot), IgnoreCase=true), ...
    "IIW_DATASET_ROOT must be outside the repository.");

archivePath = fullfile(datasetRoot, "KSDD2", "source", "KolektorSDD2.zip");
dataRoot = fullfile(datasetRoot, "KSDD2", "extracted");
expectedHash = "EDCDB486809B24F1D17B785E30C52FAFC5999554DD5FE18DDF77B61CEB6F36A8";
assert(isfile(archivePath) && upper(string(fileHash(archivePath))) == expectedHash, ...
    "The dataset archive does not match the approved manifest.");

[trainImages, trainMasks, trainPositive] = inventory(fullfile(dataRoot, "train"));
[testImages, testMasks, testPositive] = inventory(fullfile(dataRoot, "test"));
assert(numel(trainImages) == 2331 && nnz(trainPositive) == 246, ...
    "Official training counts do not match the manifest.");
assert(numel(testImages) == 1004 && nnz(testPositive) == 110, ...
    "Official test counts do not match the manifest.");
assert(isempty(intersect(fileHashes(trainImages), fileHashes(testImages))), ...
    "An exact source-image duplicate crosses the official partition boundary.");

[trainingIndex, validationIndex, splitRecord] = deterministicSplit( ...
    trainImages, trainPositive, seed);
% KSDD2 is portrait-oriented. [192 72 3] is the documented, authorized
% downsampling-compatible equivalent to the preferred [72 192 3] and avoids
% changing the source aspect ratio through a centered letterbox transform.
inputSize = [192 72 3];
classNames = ["background", "anomaly"];
labelIDs = [0 255];
trainingData = pairedData(trainImages(trainingIndex), trainMasks(trainingIndex), ...
    inputSize, classNames, labelIDs, true);
validationData = pairedData(trainImages(validationIndex), trainMasks(validationIndex), ...
    inputSize, classNames, labelIDs, false);

classWeights = single([1 8]);
thresholdCandidates = single([0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75]);
earlyStoppingPatience = 4;
maximumEpochs = 10;
candidateDefinitions = struct("candidateId", "corrective-01", ...
    "encoderDepth", 2, "firstEncoderFilters", 8, ...
    "initialLearnRate", 1e-3, "classWeights", classWeights);
candidateResults = cell(numel(candidateDefinitions), 1);

for candidateIndex = 1:numel(candidateDefinitions)
candidate = candidateDefinitions(candidateIndex);
rng(seed + candidateIndex - 1, "twister");
network = unet(inputSize, 2, EncoderDepth=candidate.encoderDepth, ...
    NumFirstEncoderFilters=candidate.firstEncoderFilters);
loss = dlaccelerate(@(Y,T) crossentropy(Y, T, classWeights, ...
    WeightsFormat="C", NormalizationFactor="all-elements"));
options = trainingOptions("adam", InitialLearnRate=candidate.initialLearnRate, ...
    MaxEpochs=maximumEpochs, ...
    MiniBatchSize=16, Shuffle="every-epoch", ValidationData=validationData, ...
    ValidationFrequency=50, ValidationPatience=earlyStoppingPatience, ...
    OutputNetwork="best-validation", ...
    ExecutionEnvironment="cpu", Verbose=true, Plots="none");

trainingStart = tic;
[candidateNetwork, candidateInfo] = trainnet(trainingData, network, loss, options);
candidateSeconds = toc(trainingStart);

validationMetrics = evaluatePartition(candidateNetwork, trainImages(validationIndex), ...
    trainMasks(validationIndex), inputSize, thresholdCandidates);
[thresholdIndex, selectedValidation] = selectValidationThreshold(validationMetrics);
candidateResults{candidateIndex} = struct("candidateId", candidate.candidateId, ...
    "network", candidateNetwork, "trainingInfo", candidateInfo, ...
    "trainingSeconds", candidateSeconds, "validationMetrics", selectedValidation, ...
    "thresholdIndex", thresholdIndex, "configuration", candidate);
end
candidateResults = vertcat(candidateResults{:});

selectedCandidateIndex = selectCandidate(candidateResults);
selectedCandidate = candidateResults(selectedCandidateIndex);
network = selectedCandidate.network;
trainingInfo = selectedCandidate.trainingInfo;
trainingSeconds = selectedCandidate.trainingSeconds;
selectedValidation = selectedCandidate.validationMetrics;
pixelThreshold = thresholdCandidates(selectedCandidate.thresholdIndex);

% Everything above this point uses only training and validation data. The
% following call is the single authorized additional official-test exposure.
testMetrics = evaluatePartition(network, testImages, testMasks, inputSize, pixelThreshold);

modelArtifact = struct();
modelArtifact.network = network;
modelArtifact.inputSize = inputSize;
modelArtifact.pixelThreshold = pixelThreshold;
modelArtifact.modelVersion = uint16(2);
modelArtifact.datasetArchiveSha256 = char(expectedHash);
modelArtifact.splitConfiguration = splitRecord;
modelArtifact.trainingConfiguration = struct("seed", seed, ...
    "maximumEpochs", maximumEpochs, ...
    "miniBatchSize", 16, "initialLearnRate", 1e-3, ...
    "classWeights", classWeights, "executionEnvironment", "cpu", ...
    "architecture", "compact U-Net", "encoderDepth", 2, ...
    "firstEncoderFilters", 8, "pretrainedWeights", false, ...
    "inputRepresentation", "aspect-ratio-preserving centered letterbox", ...
    "inputSize", inputSize, "maskInterpolation", "nearest-neighbor", ...
    "augmentation", struct("horizontalReflection", true, ...
        "maximumTranslationPixels", 4, "maximumIntensityVariation", 0.05), ...
    "validationPatience", earlyStoppingPatience, ...
    "thresholdGrid", thresholdCandidates, ...
    "candidateCount", numel(candidateDefinitions), ...
    "candidateSelectionRule", "recall>=0.75, then Dice, F1, lower FPR", ...
    "officialTestExposureNumber", 3, "fullyBlindEvaluation", false);
modelArtifact.trainingSeconds = trainingSeconds;
modelArtifact.trainingStartedUTC = char(started);
modelArtifact.trainingFinishedUTC = char(datetime("now", TimeZone="UTC"));
modelArtifact.validationMetrics = selectedValidation;
modelArtifact.testMetrics = testMetrics;
modelArtifact.trainingInfo = trainingInfo;
modelArtifact.candidateSelection = stripCandidateNetworks(candidateResults, selectedCandidateIndex);

modelPath = fullfile(repositoryRoot, "extensions", "intelligent-inspection", ...
    "models", "deep_learning_detector.mat");
save(modelPath, "modelArtifact", "-v7.3");

result = struct("modelPath", modelPath, "trainingCount", nnz(trainingIndex), ...
    "validationCount", nnz(validationIndex), "testCount", numel(testImages), ...
    "trainingPositive", nnz(trainPositive(trainingIndex)), ...
    "validationPositive", nnz(trainPositive(validationIndex)), ...
    "testPositive", nnz(testPositive), "selectedThreshold", pixelThreshold, ...
    "validationMetrics", selectedValidation, "testMetrics", testMetrics, ...
    "trainingSeconds", trainingSeconds, "seed", seed, ...
    "candidateResults", modelArtifact.candidateSelection, ...
    "officialTestExposureNumber", 3);
disp(result)
end

function ds = pairedData(images, masks, inputSize, classNames, labelIDs, augment)
imds = imageDatastore(images);
pxds = pixelLabelDatastore(masks, classNames, labelIDs);
ds = transform(combine(imds, pxds), ...
    @(data) preparePair(data, inputSize, classNames, augment));
end

function output = preparePair(data, inputSize, classNames, augment)
image = im2single(data{1});
if ismatrix(image), image = repmat(image, 1, 1, 3); end
mask = data{2} == classNames(2);
if augment
    reflect = rand() < 0.5;
    translation = randi([-4 4], 1, 2);
    intensityDelta = single((2 * rand() - 1) * 0.05);
    if reflect
        image = fliplr(image);
        mask = fliplr(mask);
    end
    image = imtranslate(image, translation, "bilinear", ...
        FillValues=0, OutputView="same");
    mask = imtranslate(mask, translation, "nearest", ...
        FillValues=0, OutputView="same");
    image = min(single(1), max(single(0), image + intensityDelta));
end
[image, mask] = letterboxPair(image, mask, inputSize(1:2));
labels = categorical(mask, [false true], classNames);
output = {image, labels};
end

function [imageOut, maskOut] = letterboxPair(image, mask, targetSize)
sourceSize = size(mask);
scale = min(double(targetSize(1)) / double(sourceSize(1)), ...
    double(targetSize(2)) / double(sourceSize(2)));
resizedSize = max([1 1], round(double(sourceSize(1:2)) * scale));
resizedImage = imresize(image, resizedSize, "bilinear");
resizedMask = imresize(mask, resizedSize, "nearest");
imageOut = zeros([targetSize 3], "single");
maskOut = false(targetSize);
rowStart = floor((targetSize(1) - resizedSize(1)) / 2) + 1;
columnStart = floor((targetSize(2) - resizedSize(2)) / 2) + 1;
rows = rowStart:(rowStart + resizedSize(1) - 1);
columns = columnStart:(columnStart + resizedSize(2) - 1);
imageOut(rows, columns, :) = resizedImage;
maskOut(rows, columns) = resizedMask;
end

function [images, masks, positive] = inventory(folder)
entries = dir(fullfile(folder, "*.png"));
names = string({entries.name});
names = names(~contains(names, "(copy)"));
imageNames = names(~endsWith(names, "_GT.png"));
images = fullfile(folder, cellstr(imageNames));
masks = fullfile(folder, cellstr(erase(imageNames, ".png") + "_GT.png"));
assert(all(isfile(masks)), "Every canonical image must have a mask.");
positive = false(numel(masks), 1);
for index = 1:numel(masks)
    mask = imread(masks{index});
    assert(all(mask(:) == 0 | mask(:) == 255), "Mask values must be 0 or 255.");
    positive(index) = any(mask(:) ~= 0);
end
end

function [trainIndex, validationIndex, record] = deterministicSplit(images, positive, seed)
keys = strings(numel(images), 1);
for index = 1:numel(images)
    [~, name, extension] = fileparts(images{index});
    keys(index) = sha256Text("KSDD2-validation-v1|" + seed + "|" + name + extension);
end
validationIndex = false(numel(images), 1);
for disposition = [false true]
    members = find(positive == disposition);
    [~, order] = sort(keys(members));
    count = round(0.20 * numel(members));
    validationIndex(members(order(1:count))) = true;
end
trainIndex = ~validationIndex;
record = struct("method", "stratified SHA-256 ordering", ...
    "seedConfiguration", "KSDD2-validation-v1", "seed", seed, ...
    "trainingSampleIds", sampleIds(images(trainIndex)), ...
    "validationSampleIds", sampleIds(images(validationIndex)), ...
    "officialTestUntouched", true);
end

function ids = sampleIds(files)
ids = strings(numel(files), 1);
for index = 1:numel(files), [~, ids(index)] = fileparts(files{index}); end
end

function metrics = evaluatePartition(network, images, masks, inputSize, thresholds)
metrics = repmat(emptyMetrics(), numel(thresholds), 1);
for thresholdIndex = 1:numel(thresholds)
    threshold = thresholds(thresholdIndex);
    tpImage=0; fpImage=0; tnImage=0; fnImage=0;
    intersection=0; unionCount=0; diceNumerator=0; diceDenominator=0;
    positiveDice = [];
    inferenceSeconds = zeros(numel(images), 1);
    for index = 1:numel(images)
        image = im2single(imread(images{index}));
        truth = imread(masks{index}) ~= 0;
        [image, truth] = letterboxPair(image, truth, inputSize(1:2));
        timer = tic;
        scores = minibatchpredict(network, reshape(image, [inputSize 1]), MiniBatchSize=1);
        inferenceSeconds(index) = toc(timer);
        if isa(scores,"dlarray"), scores=extractdata(scores); end
        scores = gather(single(scores));
        predicted = squeeze(scores(:,:,2,1)) >= threshold;
        truthPositive = any(truth,"all"); predictedPositive = any(predicted,"all");
        tpImage = tpImage + (truthPositive && predictedPositive);
        fpImage = fpImage + (~truthPositive && predictedPositive);
        tnImage = tnImage + (~truthPositive && ~predictedPositive);
        fnImage = fnImage + (truthPositive && ~predictedPositive);
        inter = nnz(predicted & truth); denom = nnz(predicted) + nnz(truth);
        uni = nnz(predicted | truth);
        intersection = intersection + inter; unionCount = unionCount + uni;
        diceNumerator = diceNumerator + 2*inter; diceDenominator = diceDenominator + denom;
        if truthPositive, positiveDice(end+1,1) = safeDivide(2*inter,denom); end %#ok<AGROW>
    end
    metrics(thresholdIndex) = struct("threshold",single(threshold), ...
        "pixelDice",safeDivide(diceNumerator,diceDenominator), ...
        "pixelIoU",safeDivide(intersection,unionCount), ...
        "imagePrecision",safeDivide(tpImage,tpImage+fpImage), ...
        "imageRecall",safeDivide(tpImage,tpImage+fnImage), ...
        "imageF1",safeDivide(2*tpImage,2*tpImage+fpImage+fnImage), ...
        "negativeFalsePositiveRate",safeDivide(fpImage,fpImage+tnImage), ...
        "positiveImageMeanDice",mean(positiveDice), ...
        "confusionMatrix",[tnImage fpImage; fnImage tpImage], ...
        "meanInferenceSeconds",mean(inferenceSeconds), ...
        "uncontrolledFailures",0);
end
end

function [index, selected] = selectValidationThreshold(metrics)
recall = [metrics.imageRecall];
dice = [metrics.positiveImageMeanDice];
f1 = [metrics.imageF1];
fpr = [metrics.negativeFalsePositiveRate];
eligible = recall >= 0.75;
if any(eligible)
    candidateIndices = find(eligible);
    ranking = [-dice(candidateIndices).' -f1(candidateIndices).' fpr(candidateIndices).'];
else
    candidateIndices = 1:numel(metrics);
    ranking = [-recall(:) -dice(:) -f1(:) fpr(:)];
end
[~, order] = sortrows(ranking, 1:size(ranking, 2));
index = candidateIndices(order(1));
selected = metrics(index);
end

function index = selectCandidate(results)
% Each candidate already stores its best threshold. Reapply the same ordered
% rule across candidate-level selected validation results.
if isscalar(results)
    index = 1;
    return
end
candidateMetrics = [results.validationMetrics];
recall = [candidateMetrics.imageRecall];
dice = [candidateMetrics.positiveImageMeanDice];
f1 = [candidateMetrics.imageF1];
fpr = [candidateMetrics.negativeFalsePositiveRate];
eligible = recall >= 0.75;
if any(eligible)
    candidates = find(eligible);
    ranking = [-dice(candidates).' -f1(candidates).' fpr(candidates).'];
else
    candidates = 1:numel(results);
    ranking = [-recall(:) -dice(:) -f1(:) fpr(:)];
end
[~, order] = sortrows(ranking, 1:size(ranking, 2));
index = candidates(order(1));
end

function records = stripCandidateNetworks(results, selectedIndex)
records = cell(numel(results), 1);
for index = 1:numel(results)
    info = results(index).trainingInfo;
    records{index} = struct("candidateId", results(index).candidateId, ...
        "selected", index == selectedIndex, ...
        "configuration", results(index).configuration, ...
        "selectedThreshold", results(index).validationMetrics.threshold, ...
        "validationMetrics", results(index).validationMetrics, ...
        "trainingSeconds", results(index).trainingSeconds, ...
        "stopReason", string(info.StopReason), ...
        "outputNetworkIteration", info.OutputNetworkIteration);
end
records = vertcat(records{:});
end

function value = emptyMetrics()
value = struct("threshold",single(0),"pixelDice",0,"pixelIoU",0, ...
    "imagePrecision",0,"imageRecall",0,"imageF1",0, ...
    "negativeFalsePositiveRate",0,"positiveImageMeanDice",0, ...
    "confusionMatrix",zeros(2),"meanInferenceSeconds",0,"uncontrolledFailures",0);
end

function value = safeDivide(numerator, denominator)
if denominator == 0, value = 0; else, value = double(numerator)/double(denominator); end
end

function values = fileHashes(files)
values = strings(numel(files),1);
for index = 1:numel(files)
    values(index) = fileHashSmall(files{index});
end
end

function value = fileHashSmall(path)
md = javaMethod("getInstance", "java.security.MessageDigest", "SHA-256");
javaFile = javaObject("java.io.File", path);
bytes = javaMethod("readAllBytes", "java.nio.file.Files", javaFile.toPath());
value = upper(string(reshape(dec2hex(typecast(md.digest(bytes),"uint8"),2).',1,[])));
end

function value = fileHash(path)
escaped = strrep(path, "'", "''");
quote = string(char(34));
command = "powershell.exe -NoProfile -Command " + quote + ...
    "(Get-FileHash -Algorithm SHA256 -LiteralPath '" + escaped + "').Hash" + quote;
[status, output] = system(command);
assert(status == 0, "Unable to calculate the archive SHA-256.");
value = upper(strtrim(output));
end

function value = sha256Text(text)
md = javaMethod("getInstance", "java.security.MessageDigest", "SHA-256");
md.update(unicode2native(char(text), "UTF-8"));
value = lower(string(reshape(dec2hex(typecast(md.digest(),"uint8"),2).',1,[])));
end
