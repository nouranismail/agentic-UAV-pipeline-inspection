classdef test_uav_pipeline_configuration < matlab.unittest.TestCase
    methods (TestClassSetup)
        function addAdapterPath(testCase)
            root = fileparts(fileparts(fileparts(mfilename("fullpath"))));
            adapterPath = fullfile(root,"extensions","intelligent-inspection", ...
                "configurations","uav-pipeline");
            testCase.applyFixture(matlab.unittest.fixtures.PathFixture(adapterPath));
        end
    end

    methods (Test)
        function sourceContractAndFrameMapping(testCase)
            [frame,context,sourceConfig] = sourceFixture();
            [data,metadata,status] = source_adapter(frame,context,sourceConfig);
            testCase.verifyTrue(status.accepted);
            testCase.verifyEqual(string(fieldnames(data)),inspectionDataFields());
            testCase.verifyEqual(string(fieldnames(metadata)),metadataFields());
            testCase.verifyEqual(data.itemId,context.itemId);
            testCase.verifyEqual(metadata.itemId,data.itemId);
            testCase.verifyEqual(data.modality,uint8(1));
        end

        function metadataTypesAndMalformedHandling(testCase)
            [frame,context,sourceConfig] = sourceFixture();
            [~,~,validStatus] = source_adapter(frame,context,sourceConfig);
            testCase.verifyTrue(validStatus.contextValid);
            invalid = context; invalid.cameraId = uint32(0);
            [data,metadata,status] = source_adapter(frame,invalid,sourceConfig);
            testCase.verifyFalse(status.accepted);
            testCase.verifyEqual(data.itemId,uint32(0));
            testCase.verifyEqual(metadata.itemId,uint32(0));
            invalid = context; invalid.platformOrientation = [1;0;0;1];
            [~,~,invalidStatus] = source_adapter(frame,invalid,sourceConfig);
            testCase.verifyFalse(invalidStatus.accepted);
        end

        function exactTaxonomyAndScope(testCase)
            text = fileread(configurationPath());
            testCase.verifySubstring(text,"0: UNASSIGNED_OR_NO_DETECTION");
            testCase.verifySubstring(text,"1: SURFACE_ANOMALY_INDICATION");
            testCase.verifySubstring(text,"255: INVALID");
            prohibited = ["crack","corrosion","leak","severity","physical_dimension"];
            lowerText = lower(string(text));
            for term = prohibited, testCase.verifyFalse(contains(lowerText,term)); end
        end

        function passOnlyQualityGate(testCase)
            [quality,detection,risk,approval,config] = recommendationFixture();
            [passAction,passBoundary] = recommendation_adapter(quality,detection,risk,approval,config);
            testCase.verifyEqual(passAction.actionCode,uint8(2));
            testCase.verifyTrue(passBoundary.forwardingEligible);
            for status = uint8([2 3])
                quality.status = status;
                [action,boundary] = recommendation_adapter(quality,detection,risk,approval,config);
                testCase.verifyEqual(action.actionCode,uint8(4));
                testCase.verifyFalse(boundary.forwardingEligible);
            end
        end

        function inclusiveConfidenceBoundary(testCase)
            [quality,detection,risk,approval,config] = recommendationFixture();
            detection.confidence = single(0.50);
            [action,boundary] = recommendation_adapter(quality,detection,risk,approval,config);
            testCase.verifyEqual(action.actionCode,uint8(2));
            testCase.verifyTrue(boundary.forwardingEligible);
            detection.confidence = single(0.49999997);
            [action,boundary] = recommendation_adapter(quality,detection,risk,approval,config);
            testCase.verifyEqual(action.actionCode,uint8(1));
            testCase.verifyFalse(boundary.forwardingEligible);
            detection.confidence = single(NaN);
            [~,boundary] = recommendation_adapter(quality,detection,risk,approval,config);
            testCase.verifyFalse(boundary.forwardingEligible);
        end

        function advisoryMappingAndApproval(testCase)
            [quality,detection,risk,approval,config] = recommendationFixture();
            expected = uint8([0 2 3 1]);
            for level = uint8(1:4)
                risk.riskLevel = level;
                [action,boundary] = recommendation_adapter(quality,detection,risk,approval,config);
                testCase.verifyEqual(action.actionCode,expected(level));
                if level == 1
                    testCase.verifyFalse(boundary.humanApprovalRequired);
                    testCase.verifyFalse(boundary.forwardingEligible);
                else
                    testCase.verifyTrue(boundary.forwardingEligible);
                end
            end
            risk.riskLevel = uint8(3); approval.approvalState = uint8(1);
            approval.forwardingEligible = false;
            [~,boundary] = recommendation_adapter(quality,detection,risk,approval,config);
            testCase.verifyFalse(boundary.forwardingEligible);
        end

        function noCommandOrSupervisorEndpoint(testCase)
            paths = [string(which("source_adapter"));string(which("recommendation_adapter"))];
            prohibited = ["missionsupervisor","returntohome","safelanding", ...
                "flightcommand","safetycommand","actuatorcommand"];
            for path = paths'
                text = lower(string(fileread(path)));
                for term = prohibited, testCase.verifyFalse(contains(text,term)); end
            end
            [quality,detection,risk,approval,config] = recommendationFixture();
            [~,boundary] = recommendation_adapter(quality,detection,risk,approval,config);
            testCase.verifyEqual(sort(string(fieldnames(boundary))), ...
                sort(["forwardingEligible";"humanApprovalRequired";"advisoryOnly";"controlled";"statusCode"]));
        end

        function determinismScopeAndDisclaimer(testCase)
            [frame,context,sourceConfig] = sourceFixture();
            [d1,m1,s1] = source_adapter(frame,context,sourceConfig);
            [d2,m2,s2] = source_adapter(frame,context,sourceConfig);
            testCase.verifyEqual(d1,d2); testCase.verifyEqual(m1,m2); testCase.verifyEqual(s1,s2);
            root = fileparts(fileparts(fileparts(mfilename("fullpath"))));
            disclaimer = "Integration and workflow demonstration only; not evidence of real-world inspection, anomaly-detection, pipeline-condition, flight, or production readiness.";
            files = phaseFiles(root);
            for file = files([1 4 6])', testCase.verifySubstring(fileread(file),disclaimer); end
            testCase.verifyEqual(numel(files),6);
            exampleModel = fullfile(getenv("USERPROFILE"),"Documents","MATLAB", ...
                "Examples","R2026a","uav","SimpleFlightAndSensorInUE4Example", ...
                "uav_simple_flight_model.slx");
            testCase.verifyTrue(isfile(exampleModel));
            testCase.verifyFalse(startsWith(exampleModel,root,"IgnoreCase",true));
            testCase.verifyEqual(treeHash(fullfile(root,"extensions","intelligent-inspection","core")), ...
                "cb92fed88d4818d9f55ff94b3ff25f23bdca04b37db5fc01f29995bacfda0096");
            testCase.verifyEqual(protectedHash(root), ...
                "d17c504b8ae794008c769757c31674d1728de8d55c7c21e5908aa0d627208afb");
        end
    end
end

function [frame,context,configuration] = sourceFixture()
frame = uint8(repmat(reshape(uint8([32 96 160]),1,1,3),24,32,1));
context = struct("itemId",uint32(130001),"payloadRef",uint32(130101), ...
    "acquisitionContextRef",uint32(130201),"assetId",uint32(1), ...
    "pipelineSectionId",uint32(2),"inspectionPlanId",uint32(3), ...
    "simulationRunId",uint32(4),"sceneConfigurationId",uint32(5), ...
    "cameraId",uint32(6),"cameraCalibrationRef",uint32(7), ...
    "sequenceId",uint32(8),"coordinateFrameId",uint16(1), ...
    "captureTimestamp",uint64(1789257600000),"imageWidth",uint16(32), ...
    "imageHeight",uint16(24),"channelCount",uint8(3), ...
    "platformPosition",[1;2;3],"platformOrientation",[1;0;0;0], ...
    "metadataVersion",uint16(1),"configurationVersion",uint16(1));
configuration = struct("sourceId",uint32(13001), ...
    "inspectionDataSchemaVersion",uint16(1),"metadataSchemaVersion",uint16(1));
end

function [quality,detection,risk,approval,configuration] = recommendationFixture()
quality = struct("itemId",uint32(130001),"status",uint8(1),"validatorVersion",uint16(1));
detection = struct("resultId",uint32(1),"processedItemId",uint32(2), ...
    "labelId",uint8(1),"confidence",single(0.75),"schemaVersion",uint16(1), ...
    "confidenceValid",true);
refs = zeros(16,1,"uint32"); refs(1) = uint32(1);
risk = struct("assessmentId",uint32(1),"evidenceRefs",refs, ...
    "referenceCount",uint8(1),"riskLevel",uint8(2), ...
    "confidenceStatus",uint8(1),"policyVersion",uint16(1));
approval = struct("recommendationId",uint32(13),"approvalState",uint8(5), ...
    "forwardingEligible",true,"safetyBypass",false,"auditValid",true);
configuration = struct("configurationVersion",uint16(1), ...
    "recommendationId",uint32(13),"validFrom",uint64(1000), ...
    "validUntil",uint64(2000),"detectionSchemaVersion",uint16(1), ...
    "minimumConfidence",single(0.50));
end

function fields = inspectionDataFields()
fields = ["itemId";"payloadRef";"modality";"sourceId";"sequenceId";"timestamp";"schemaVersion"];
end

function fields = metadataFields()
fields = ["itemId";"acquisitionContext";"calibrationRef";"contextSchemaVersion"];
end

function path = configurationPath()
root = fileparts(fileparts(fileparts(mfilename("fullpath"))));
path = fullfile(root,"extensions","intelligent-inspection","configurations","uav-pipeline","configuration.yaml");
end

function files = phaseFiles(root)
files = [fullfile(root,"extensions","intelligent-inspection","configurations","uav-pipeline","configuration.yaml"); ...
    fullfile(root,"extensions","intelligent-inspection","configurations","uav-pipeline","source_adapter.m"); ...
    fullfile(root,"extensions","intelligent-inspection","configurations","uav-pipeline","recommendation_adapter.m"); ...
    fullfile(root,"extensions","intelligent-inspection","configurations","uav-pipeline","dataset_manifest.yaml"); ...
    fullfile(root,"tests","intelligent-inspection","test_uav_pipeline_configuration.m"); ...
    fullfile(root,"extensions","intelligent-inspection","evidence","uav_pipeline_configuration_results.md")];
end

function value = protectedHash(root)
relativeFiles = ["models/uav_mission_supervisor.slx"; ...
    "models/uav_mission_supervisor.sldd";"models/uav_mission_supervisor~mdl.slmx"; ...
    "models/uav_mission_supervisor_harnessInfo.xml"; ...
    "requirements/uav_mission_supervisor_requirements.slreqx"; ...
    "tests/uav_mission_supervisor_harness.slx"; ...
    "tests/uav_mission_supervisor_tests.mldatx"; ...
    "tests/uav_mission_supervisor_tests~mldatx.slmx"; ...
    "reports/uav_mission_supervisor_coverage.cvt"; ...
    "reports/uav_mission_supervisor_coverage_report.html"; ...
    "reports/uav_mission_supervisor_change_report.md"; ...
    "reports/uav_mission_supervisor_independent_review.md"; ...
    "data/system_mode_definitions.m";"scripts/initialize_mission_supervisor.m"];
paths = fullfile(root,relativeFiles);
paths = paths(isfile(paths));
paths = [paths; filesUnder(fullfile(root,"tests","test_data")); ...
    filesUnder(fullfile(root,"reports","uav_mission_supervisor_coverage_report.html"))];
value = aggregateHash(paths,root);
end

function value = treeHash(folder)
root = fileparts(fileparts(fileparts(folder)));
value = aggregateHash(filesUnder(folder),root);
end

function paths = filesUnder(folder)
info = dir(fullfile(folder,"**","*"));
info = info(~[info.isdir]);
paths = strings(numel(info),1);
for index = 1:numel(info), paths(index) = fullfile(info(index).folder,info(index).name); end
end

function value = aggregateHash(paths,root)
relative = replace(erase(paths,string(root)+filesep),"\","/");
[relative,order] = sort(relative);
paths = paths(order);
bytes = uint8([]);
for index = 1:numel(paths)
    entry = relative(index)+newline+fileHash(paths(index))+newline;
    bytes = [bytes unicode2native(char(entry),"UTF-8")]; %#ok<AGROW>
end
value = sha256(bytes);
end

function value = fileHash(path)
fileId = fopen(path,"rb");
cleanup = onCleanup(@() fclose(fileId)); %#ok<NASGU>
value = sha256(fread(fileId,Inf,"*uint8")');
end

function value = sha256(bytes)
digest = java.security.MessageDigest.getInstance("SHA-256");
digest.update(typecast(uint8(bytes),"int8"));
raw = typecast(digest.digest(),"uint8");
value = lower(join(compose("%02x",raw),""));
end
