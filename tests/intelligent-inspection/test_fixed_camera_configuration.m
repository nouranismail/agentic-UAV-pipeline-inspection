classdef test_fixed_camera_configuration < matlab.unittest.TestCase
    methods(TestClassSetup)
        function addAdapterPath(testCase)
            root=repoRoot();
            testCase.applyFixture(matlab.unittest.fixtures.PathFixture(fullfile(root, ...
                "extensions","intelligent-inspection","configurations","fixed-camera")));
        end
    end
    methods(Test)
        function IIW_TST_FIX_001_validSourceMapping(testCase)
            [frame,context,config]=sourceFixture();
            [data,metadata,status]=source_adapter(frame,context,config);
            testCase.verifyTrue(status.accepted);
            testCase.verifyEqual(string(fieldnames(data)),["itemId";"payloadRef";"modality";"sourceId";"sequenceId";"timestamp";"schemaVersion"]);
            testCase.verifyEqual(string(fieldnames(metadata)),["itemId";"acquisitionContext";"calibrationRef";"contextSchemaVersion"]);
            testCase.verifyEqual(data.itemId,context.itemId);
            testCase.verifyEqual(metadata.itemId,data.itemId);
        end
        function IIW_TST_FIX_002_malformedHandling(testCase)
            [frame,context,config]=sourceFixture();
            cases={rmfield(context,"stationId"),setfield(context,"partId",uint32(0)), ... %#ok<SFLD>
                setfield(context,"captureTimestamp",uint64(0)),setfield(context,"stationary",false)}; %#ok<SFLD>
            for index=1:numel(cases)
                [data,~,status]=source_adapter(frame,cases{index},config);
                testCase.verifyFalse(status.accepted);testCase.verifyEqual(data.itemId,uint32(0));
            end
            [~,~,status]=source_adapter(frame(:,:,1),context,config);
            testCase.verifyFalse(status.accepted);
        end
        function IIW_TST_FIX_003_taxonomyAndBoundary(testCase)
            text=fileread(configPath());
            testCase.verifySubstring(text,"0: UNASSIGNED_OR_NO_DETECTION");
            testCase.verifySubstring(text,"1: SURFACE_ANOMALY_INDICATION");
            testCase.verifySubstring(text,"255: INVALID");
            [q,d,r,a,c]=recommendationFixture();d.confidence=single(0.50);
            [action,boundary]=recommendation_adapter(q,d,r,a,c);
            testCase.verifyEqual(action.actionCode,uint8(2));testCase.verifyTrue(boundary.forwardingEligible);
            d.confidence=single(0.49999997);[action,boundary]=recommendation_adapter(q,d,r,a,c);
            testCase.verifyEqual(action.actionCode,uint8(1));testCase.verifyFalse(boundary.forwardingEligible);
        end
        function IIW_TST_FIX_004_passOnlyQuality(testCase)
            [q,d,r,a,c]=recommendationFixture();
            for status=uint8([2 3])
                q.status=status;[action,boundary]=recommendation_adapter(q,d,r,a,c);
                testCase.verifyEqual(action.actionCode,uint8(4));testCase.verifyFalse(boundary.forwardingEligible);
            end
            q.status=uint8(1);[~,boundary]=recommendation_adapter(q,d,r,a,c);testCase.verifyTrue(boundary.forwardingEligible);
            q.status=uint8(0);[action,boundary]=recommendation_adapter(q,d,r,a,c);
            testCase.verifyEqual(action.recommendationId,uint32(0));testCase.verifyFalse(boundary.forwardingEligible);
        end
        function IIW_TST_FIX_005_advisoryMapping(testCase)
            [q,d,r,a,c]=recommendationFixture();expected=uint8([0 2 3 1]);
            for level=uint8(1:4)
                r.riskLevel=level;[action,boundary]=recommendation_adapter(q,d,r,a,c);
                testCase.verifyEqual(action.actionCode,expected(level));
                testCase.verifyTrue(boundary.advisoryOnly);
            end
            d.confidence=single(NaN);[action,boundary]=recommendation_adapter(q,d,r,a,c);
            testCase.verifyEqual(action.actionCode,uint8(1));testCase.verifyFalse(boundary.forwardingEligible);
        end
        function IIW_TST_FIX_006_approvalAndNoEndpoints(testCase)
            [q,d,r,a,c]=recommendationFixture();a.approvalState=uint8(1);a.forwardingEligible=false;
            [~,boundary]=recommendation_adapter(q,d,r,a,c);testCase.verifyFalse(boundary.forwardingEligible);
            prohibited=["missionsupervisor","returntohome","safelanding","actuatorcommand", ...
                "productionlinecommand","machinecontrolcommand","flightcommand","safetycommand"];
            for file=[string(which("source_adapter")),string(which("recommendation_adapter"))]
                text=lower(string(fileread(file)));
                for term=prohibited,testCase.verifyFalse(contains(text,term));end
            end
        end
        function IIW_TST_FIX_007_repeatabilityHashesAndScope(testCase)
            [frame,context,config]=sourceFixture();
            [d1,m1,s1]=source_adapter(frame,context,config);[d2,m2,s2]=source_adapter(frame,context,config);
            testCase.verifyEqual(d1,d2);testCase.verifyEqual(m1,m2);testCase.verifyEqual(s1,s2);
            root=repoRoot();
            testCase.verifyEqual(treeHash(fullfile(root,"extensions","intelligent-inspection","core"),root), ...
                "cb92fed88d4818d9f55ff94b3ff25f23bdca04b37db5fc01f29995bacfda0096");
            phase13=phase13Files(root);
            testCase.verifyEqual(aggregateHash(phase13,root), ...
                "3446e6aadd70c609234e273423d73c37f89bc2ce13ca5935108b9d3ace49cd8b");
            files=phase14Files(root);testCase.verifyEqual(numel(files),6);testCase.verifyTrue(all(isfile(files)));
            disclaimer="Integration and workflow demonstration only; not evidence of real-world inspection, production-line performance, machine-control suitability, or production readiness.";
            for file=files([1 4 6])',testCase.verifySubstring(fileread(file),disclaimer);end
        end
    end
end

function [frame,context,configuration]=sourceFixture()
frame=uint8(repmat(reshape(uint8([40 100 160]),1,1,3),20,30,1));
context=struct("itemId",uint32(140001),"payloadRef",uint32(140101), ...
 "acquisitionContextRef",uint32(140201),"stationId",uint32(11),"partId",uint32(12), ...
 "cameraId",uint32(13),"cameraCalibrationRef",uint32(14),"sequenceId",uint32(15), ...
 "captureTimestamp",uint64(1789257600000),"fixedReferenceFrameId",uint16(2), ...
 "imageWidth",uint16(30),"imageHeight",uint16(20),"channelCount",uint8(3), ...
 "metadataVersion",uint16(1),"configurationVersion",uint16(1),"stationary",true);
configuration=struct("sourceId",uint32(14001),"inspectionDataSchemaVersion",uint16(1),"metadataSchemaVersion",uint16(1));
end

function [q,d,r,a,c]=recommendationFixture()
q=struct("itemId",uint32(140001),"status",uint8(1),"validatorVersion",uint16(1));
d=struct("resultId",uint32(1),"processedItemId",uint32(2),"labelId",uint8(1), ...
 "confidence",single(.75),"schemaVersion",uint16(1),"confidenceValid",true);
refs=zeros(16,1,"uint32");refs(1)=1;
r=struct("assessmentId",uint32(1),"evidenceRefs",refs,"referenceCount",uint8(1), ...
 "riskLevel",uint8(2),"confidenceStatus",uint8(1),"policyVersion",uint16(1));
a=struct("recommendationId",uint32(14),"approvalState",uint8(5), ...
 "forwardingEligible",true,"safetyBypass",false,"auditValid",true);
c=struct("configurationVersion",uint16(1),"recommendationId",uint32(14), ...
 "validFrom",uint64(1000),"validUntil",uint64(2000), ...
 "detectionSchemaVersion",uint16(1),"minimumConfidence",single(.50));
end

function root=repoRoot(),root=fileparts(fileparts(fileparts(mfilename("fullpath"))));end
function path=configPath(),path=fullfile(repoRoot(),"extensions","intelligent-inspection","configurations","fixed-camera","configuration.yaml");end
function files=phase13Files(root)
files=[fullfile(root,"extensions","intelligent-inspection","configurations","uav-pipeline","configuration.yaml");fullfile(root,"extensions","intelligent-inspection","configurations","uav-pipeline","source_adapter.m");fullfile(root,"extensions","intelligent-inspection","configurations","uav-pipeline","recommendation_adapter.m");fullfile(root,"extensions","intelligent-inspection","configurations","uav-pipeline","dataset_manifest.yaml");fullfile(root,"tests","intelligent-inspection","test_uav_pipeline_configuration.m");fullfile(root,"extensions","intelligent-inspection","evidence","uav_pipeline_configuration_results.md")];
end
function files=phase14Files(root)
files=[fullfile(root,"extensions","intelligent-inspection","configurations","fixed-camera","configuration.yaml");fullfile(root,"extensions","intelligent-inspection","configurations","fixed-camera","source_adapter.m");fullfile(root,"extensions","intelligent-inspection","configurations","fixed-camera","recommendation_adapter.m");fullfile(root,"extensions","intelligent-inspection","configurations","fixed-camera","dataset_manifest.yaml");fullfile(root,"tests","intelligent-inspection","test_fixed_camera_configuration.m");fullfile(root,"extensions","intelligent-inspection","evidence","fixed_camera_configuration_results.md")];
end
function value=treeHash(folder,root),value=aggregateHash(filesUnder(folder),root);end
function paths=filesUnder(folder),info=dir(fullfile(folder,"**","*"));info=info(~[info.isdir]);paths=strings(numel(info),1);for i=1:numel(info),paths(i)=fullfile(info(i).folder,info(i).name);end,end
function value=aggregateHash(paths,root)
rel=replace(erase(paths,string(root)+filesep),"\","/");[rel,order]=sort(rel);paths=paths(order);bytes=uint8([]);
for i=1:numel(paths),entry=rel(i)+newline+fileHash(paths(i))+newline;bytes=[bytes unicode2native(char(entry),"UTF-8")];end %#ok<AGROW>
value=sha256(bytes);
end
function value=fileHash(path),id=fopen(path,"rb");cleanup=onCleanup(@()fclose(id));value=sha256(fread(id,Inf,"*uint8")');end %#ok<NASGU>
function value=sha256(bytes),md=java.security.MessageDigest.getInstance("SHA-256");md.update(typecast(uint8(bytes),"int8"));raw=typecast(md.digest(),"uint8");value=lower(join(compose("%02x",raw),""));end
