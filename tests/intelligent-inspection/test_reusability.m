classdef test_reusability < matlab.unittest.TestCase
    %TEST_REUSABILITY Phase 15 read-only reusability evaluation.

    methods (Test)
        function canonicalCoreHashEquality(testCase)
            root = repositoryRoot();
            [paths,hashes,aggregate] = reusableCoreInventory(root);
            [expectedPaths,expectedHashes] = approvedInventory();

            testCase.verifyEqual(numel(paths),17);
            testCase.verifyEqual(paths,expectedPaths);
            testCase.verifyEqual(hashes,expectedHashes);
            testCase.verifyEqual(aggregate, ...
                "cb92fed88d4818d9f55ff94b3ff25f23bdca04b37db5fc01f29995bacfda0096");
        end

        function crossConfigurationContractConformance(testCase)
            root = repositoryRoot();
            uav = adapterContract(fullfile(root,"extensions","intelligent-inspection", ...
                "configurations","uav-pipeline"));
            fixed = adapterContract(fullfile(root,"extensions","intelligent-inspection", ...
                "configurations","fixed-camera"));

            testCase.verifyEqual(uav.sourceInputs,fixed.sourceInputs);
            testCase.verifyEqual(uav.sourceOutputs,fixed.sourceOutputs);
            testCase.verifyEqual(uav.recommendationInputs,fixed.recommendationInputs);
            testCase.verifyEqual(uav.recommendationOutputs,fixed.recommendationOutputs);
            testCase.verifyEqual(uav.dataSchema,fixed.dataSchema);
            testCase.verifyEqual(uav.metadataSchema,fixed.metadataSchema);
            testCase.verifyEqual(uav.sourceStatusSchema,fixed.sourceStatusSchema);
            testCase.verifyEqual(uav.actionSchema,fixed.actionSchema);
            testCase.verifyEqual(uav.boundarySchema,fixed.boundarySchema);
            testCase.verifyEqual(uav.schemaSignature,fixed.schemaSignature);
        end

        function applicationTerminologySeparation(testCase)
            root = repositoryRoot();
            coreText = lower(readTree(fullfile(root,"extensions","intelligent-inspection","core")));
            uavSource = lower(fileread(fullfile(root,"extensions","intelligent-inspection", ...
                "configurations","uav-pipeline","source_adapter.m")));
            fixedSource = lower(fileread(fullfile(root,"extensions","intelligent-inspection", ...
                "configurations","fixed-camera","source_adapter.m")));

            testCase.verifyFalse(containsAny(coreText,["uav","pipeline","stationid", ...
                "partid","fixedreferenceframeid","missionsupervisor"]));
            testCase.verifyFalse(containsAny(uavSource,["stationid","partid", ...
                "fixedreferenceframeid"]));
            testCase.verifyFalse(containsAny(fixedSource,["pipelinesectionid", ...
                "simulationrunid","platformposition","platformorientation"]));
        end

        function detectorSubstitutionHasNoConsumerChanges(testCase)
            root = repositoryRoot();
            addpath(fullfile(root,"extensions","intelligent-inspection","core"));
            cleanup = onCleanup(@() rmpath(fullfile(root,"extensions", ...
                "intelligent-inspection","core"))); %#ok<NASGU>
            conventional = iiw.detection.DetectorContract.create(@identityDetector, ...
                uint32(1),uint16(1));
            optionalDeepLearning = iiw.detection.DetectorContract.create(@identityDetector, ...
                uint32(2),uint16(1));
            consumerText = lower(readConsumers(root));
            runnerText = lower(fileread(fullfile(root,"extensions","intelligent-inspection", ...
                "core","+iiw","+detection","runDetector.m")));

            testCase.verifyTrue(iiw.detection.DetectorContract.isConformingDetector(conventional));
            testCase.verifyTrue(iiw.detection.DetectorContract.isConformingDetector(optionalDeepLearning));
            testCase.verifyEqual(fieldnames(conventional),fieldnames(optionalDeepLearning));
            testCase.verifyFalse(containsAny(consumerText,["conventionaldetector", ...
                "deeplearningdetector"]));
            testCase.verifyTrue(contains(runnerText,"detector.execute"));
        end
    end
end

function root = repositoryRoot()
root = fileparts(fileparts(fileparts(mfilename("fullpath"))));
end

function [paths,hashes,aggregate] = reusableCoreInventory(root)
folder = fullfile(root,"extensions","intelligent-inspection","core");
info = dir(fullfile(folder,"**","*"));
info = info(~[info.isdir]);
fullPaths = strings(numel(info),1);
for fileIndex = 1:numel(info)
    fullPaths(fileIndex) = fullfile(info(fileIndex).folder,info(fileIndex).name);
end
paths = replace(erase(fullPaths,string(root)+filesep),"\","/");
[paths,order] = sort(paths);
fullPaths = fullPaths(order);
hashes = strings(numel(paths),1);
serialized = uint8([]);
for fileIndex = 1:numel(paths)
    hashes(fileIndex) = fileHash(fullPaths(fileIndex));
    entry = paths(fileIndex)+newline+hashes(fileIndex)+newline;
    serialized = [serialized unicode2native(char(entry),"UTF-8")]; %#ok<AGROW>
end
aggregate = sha256(serialized);
end

function [paths,hashes] = approvedInventory()
rows = [
"extensions/intelligent-inspection/core/+iiw/+approval/evaluateApproval.m 073aa510c317da11509d61ccde03a5151b63b15e1193cffd255264ff73650f9b"
"extensions/intelligent-inspection/core/+iiw/+detection/DetectorContract.m e2d31ed0e1d72db56afb192f1adead360bf5feab674d3af601e82d5007fea74f"
"extensions/intelligent-inspection/core/+iiw/+detection/conventionalDetector.m 4af788d0a54fd983673768b9dd33eafcf9dd8ba996795972c95ab84e391aba63"
"extensions/intelligent-inspection/core/+iiw/+detection/deepLearningDetector.m 67225ba0a29507fa710be31b4ae95be5f3b0ce0ea49edf900b83480a2fb81b2a"
"extensions/intelligent-inspection/core/+iiw/+detection/runDetector.m c16dbb86d1d3826ae4286803c160d707ab82928c6b60313a26e8b39eb9968700"
"extensions/intelligent-inspection/core/+iiw/+evidence/recordEvidence.m 721072ae947e001153f36ed077c6ca7b85b0dc60609032715a594d58b7d61209"
"extensions/intelligent-inspection/core/+iiw/+evidence/validateEvidenceChain.m be35ca1eb6830a15f5d47a674d998ea36bbc6fca56881b58755245f287616e11"
"extensions/intelligent-inspection/core/+iiw/+features/extractNumericalFeatures.m 0d9a80b4e40c2f654209a155683427eac425561d4e570d48137064a2d9dad41d"
"extensions/intelligent-inspection/core/+iiw/+features/validateFeatureSet.m 985ea57898dfabaf0ffc2ba900d4990d734e7cb6955f3b3d3cad489cbfb34f15"
"extensions/intelligent-inspection/core/+iiw/+prediction/PredictorContract.m 8c78ad7e1e320d99d2d8a948cfe8cce9fb601ae605e349d1d9964a8b349e135b"
"extensions/intelligent-inspection/core/+iiw/+prediction/predictHealth.m 62d9c6189cee10a2bd5f5fb1be49605082be320b0b416a662004a41a1ac76e38"
"extensions/intelligent-inspection/core/+iiw/+prediction/validateHealthPrediction.m 90cfa2075458c6cb484543b02f9da8d9e09e4af53b9e953de0fff0259afd691f"
"extensions/intelligent-inspection/core/+iiw/+preprocessing/preprocessInspectionData.m d3c6b91dd6ae34171d44d793fa0704ab9b37718d37afe6086062763747774e35"
"extensions/intelligent-inspection/core/+iiw/+preprocessing/recordTransform.m 1ca785947d085fb5bad25591e5788004b15dcf5cbaafc7b7f915b9b5e8e8d663"
"extensions/intelligent-inspection/core/+iiw/+quality/validateInspectionData.m 428c4dca2beb9a14eef13cd4d55156594daca021828b77b4a3d0cf8b278049ec"
"extensions/intelligent-inspection/core/+iiw/+risk/assessRisk.m 614455edd32cac38bc5d9df4e94cbe7043d7dd7f9dbaf41f064785cb9a808135"
"extensions/intelligent-inspection/core/+iiw/+risk/validateRiskPolicy.m 9841ccd05aa92688f93b8520828bd517000fcca8f3b285081738eb56ee98ac6a"];
parts = split(rows," ");
paths = parts(:,1);
hashes = parts(:,2);
end

function contract = adapterContract(folder)
originalPath = path;
cleanup = onCleanup(@() path(originalPath)); %#ok<NASGU>
addpath(folder,"-begin");
clear source_adapter recommendation_adapter
[data,metadata,status] = source_adapter([],struct(),struct());
[action,boundary] = recommendation_adapter(struct(),struct(),struct(),struct(),struct());
contract = struct("sourceInputs",nargin("source_adapter"), ...
    "sourceOutputs",nargout("source_adapter"), ...
    "recommendationInputs",nargin("recommendation_adapter"), ...
    "recommendationOutputs",nargout("recommendation_adapter"), ...
    "dataSchema",string(fieldnames(data)), ...
    "metadataSchema",string(fieldnames(metadata)), ...
    "sourceStatusSchema",string(fieldnames(status)), ...
    "actionSchema",string(fieldnames(action)), ...
    "boundarySchema",string(fieldnames(boundary)), ...
    "schemaSignature",schemaSignature({data,metadata,status,action,boundary}));
clear source_adapter recommendation_adapter
end

function signature = schemaSignature(values)
signature = strings(0,1);
for valueIndex = 1:numel(values)
    value = values{valueIndex};
    names = fieldnames(value);
    for fieldIndex = 1:numel(names)
        fieldValue = value.(names{fieldIndex});
        signature(end+1,1) = valueIndex+":"+names{fieldIndex}+":"+ ...
            class(fieldValue)+":"+join(string(size(fieldValue)),"x"); %#ok<AGROW>
    end
end
end

function text = readTree(folder)
info = dir(fullfile(folder,"**","*"));
info = info(~[info.isdir]);
text = "";
for fileIndex = 1:numel(info)
    text = text+newline+string(fileread(fullfile(info(fileIndex).folder,info(fileIndex).name)));
end
end

function text = readConsumers(root)
paths = [
fullfile(root,"extensions","intelligent-inspection","core","+iiw","+features")
fullfile(root,"extensions","intelligent-inspection","core","+iiw","+prediction")
fullfile(root,"extensions","intelligent-inspection","core","+iiw","+risk")
fullfile(root,"extensions","intelligent-inspection","core","+iiw","+approval")
fullfile(root,"extensions","intelligent-inspection","core","+iiw","+evidence")
fullfile(root,"extensions","intelligent-inspection","configurations","uav-pipeline")
fullfile(root,"extensions","intelligent-inspection","configurations","fixed-camera")];
text = "";
for pathIndex = 1:numel(paths)
    text = text+newline+readTree(paths(pathIndex));
end
end

function matched = containsAny(text,terms)
matched = any(contains(text,terms));
end

function result = identityDetector(~,processedData,configuration)
result = iiw.detection.DetectorContract.invalidResult();
result.resultId = uint32(1);
result.processedItemId = processedData.processedItemId;
result.labelId = uint8(0);
result.confidence = single(1);
result.modelVersion = uint16(1);
result.schemaVersion = configuration.resultSchemaVersion;
result.confidenceValid = true;
end

function value = fileHash(filePath)
identifier = fopen(filePath,"rb");
cleanup = onCleanup(@() fclose(identifier)); %#ok<NASGU>
value = sha256(fread(identifier,Inf,"*uint8")');
end

function value = sha256(bytes)
digest = java.security.MessageDigest.getInstance("SHA-256");
digest.update(typecast(uint8(bytes),"int8"));
raw = typecast(digest.digest(),"uint8");
value = lower(join(compose("%02x",raw),""));
end
