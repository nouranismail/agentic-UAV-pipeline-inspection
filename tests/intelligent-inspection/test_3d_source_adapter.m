classdef test_3d_source_adapter < matlab.unittest.TestCase
    %TEST_3D_SOURCE_ADAPTER Phase 16 virtual-source adapter verification.

    methods (Test)
        function contractEquality(testCase)
            root = repositoryRoot();
            virtual = adapterContract(fullfile(root,"extensions","intelligent-inspection", ...
                "adapters","uav-3d"),"virtual_source_adapter");
            accepted = adapterContract(fullfile(root,"extensions","intelligent-inspection", ...
                "configurations","uav-pipeline"),"source_adapter");
            [data,metadata,status] = nominalVirtualResult(root);

            testCase.verifyEqual(virtual.inputs,accepted.inputs);
            testCase.verifyEqual(virtual.outputs,accepted.outputs);
            testCase.verifyEqual(virtual.dataSchema,accepted.dataSchema);
            testCase.verifyEqual(virtual.metadataSchema,accepted.metadataSchema);
            testCase.verifyEqual(virtual.statusSchema,accepted.statusSchema);
            testCase.verifyEqual(virtual.schemaSignature,accepted.schemaSignature);
            testCase.verifyTrue(status.accepted);
            testCase.verifyEqual(data.schemaVersion,uint16(1));
            testCase.verifyEqual(metadata.contextSchemaVersion,uint16(1));
        end

        function adapterSubstitution(testCase)
            root = repositoryRoot();
            virtual = adapterContract(fullfile(root,"extensions","intelligent-inspection", ...
                "adapters","uav-3d"),"virtual_source_adapter");
            accepted = adapterContract(fullfile(root,"extensions","intelligent-inspection", ...
                "configurations","uav-pipeline"),"source_adapter");

            testCase.verifyEqual(virtual.consumerSignature,accepted.consumerSignature);
            testCase.verifyEqual(virtual.inputs,3);
            testCase.verifyEqual(virtual.outputs,3);
            testCase.verifyEqual(countDownstreamChanges(root),0);
        end

        function metadataHandling(testCase)
            root = repositoryRoot();
            outcomes = malformedOutcomes(root);

            testCase.verifyTrue(all(outcomes));
            testCase.verifyEqual(numel(outcomes),14);
        end

        function provenance(testCase)
            root = repositoryRoot();
            [data,metadata,status,context,configuration] = nominalVirtualResult(root);

            testCase.verifyTrue(status.accepted);
            testCase.verifyEqual(data.sourceId,configuration.sourceId);
            testCase.verifyEqual(data.timestamp,context.captureTimestamp);
            testCase.verifyEqual(metadata.acquisitionContext,context.acquisitionContextRef);
            testCase.verifyNotEqual(context.sourceVersion,uint16(0));
            testCase.verifyNotEqual(context.adapterVersion,uint16(0));
            testCase.verifyNotEqual(context.scenarioVersion,uint16(0));
            testCase.verifyEqual(context.adapterVersion,configuration.adapterVersion);
            testCase.verifyEqual(numel(unique([context.sourceVersion; ...
                context.adapterVersion;context.scenarioVersion])),3);
        end

        function architectureBoundary(testCase)
            root = repositoryRoot();
            adapterRoot = fullfile(root,"extensions","intelligent-inspection","adapters","uav-3d");
            adapterText = lower(readTree(adapterRoot));
            testText = lower(fileread(mfilename("fullpath")+".m"));
            hashes = protectedHashes(root);
            external = externalModelEvidence();
            changed = changedPaths(root);
            expected = phase16Paths();

            testCase.verifyFalse(containsAny(adapterText,["assessrisk(","predicthealth(", ...
                "extractnumericalfeatures(","rundetector(","evaluateapproval(", ...
                "recordevidence(","missionsupervisor","returntohome","safelanding"]));
            testCase.verifyFalse(containsAny(adapterText,["flightcommand","missioncommand", ...
                "safetycommand","actuatorcommand","productioncontrol"]));
            testCase.verifyTrue(contains(testText,"deterministicframe"));
            testCase.verifyEqual(hashes.core,"cb92fed88d4818d9f55ff94b3ff25f23bdca04b37db5fc01f29995bacfda0096");
            testCase.verifyEqual(hashes.phase13,"3446e6aadd70c609234e273423d73c37f89bc2ce13ca5935108b9d3ace49cd8b");
            testCase.verifyEqual(hashes.phase14,"9cadf939e72f85c22ac4bb09ef330c8d8d1c08cbd5fd75cc010ad9cf2ab88a95");
            testCase.verifyEqual(hashes.phase15,"ecb14f420a298174bde217636a0a790931a742fd8bd40153cd4c46e37ef34d92");
            testCase.verifyEqual(hashes.realSources,"0a5995798e0dd1efbe6cc4f13af7a38e801f37af06385bf48d5ddfaffe41c213");
            testCase.verifyEqual(hashes.protectedUav,"d17c504b8ae794008c769757c31674d1728de8d55c7c21e5908aa0d627208afb");
            testCase.verifyEqual(external.hash,"c22ad392f20b15663f1ac21365f8f0a8ff621464a4a359fa9f1f0de48857e6b8");
            testCase.verifyTrue(external.outsideRepository);
            testCase.verifyEqual(changed,expected);
        end
    end
end

function root = repositoryRoot()
root = fileparts(fileparts(fileparts(mfilename("fullpath"))));
end

function contract = adapterContract(folder,functionName)
originalPath = path;
cleanup = onCleanup(@() path(originalPath)); %#ok<NASGU>
addpath(folder,"-begin");
functionHandle = str2func(functionName);
[data,metadata,status] = functionHandle([],struct(),struct());
contract = struct("inputs",nargin(functionName),"outputs",nargout(functionName), ...
    "dataSchema",string(fieldnames(data)), ...
    "metadataSchema",string(fieldnames(metadata)), ...
    "statusSchema",string(fieldnames(status)), ...
    "schemaSignature",schemaSignature({data,metadata,status}), ...
    "consumerSignature",[string(fieldnames(data));string(fieldnames(metadata))]);
end

function [data,metadata,status,context,configuration] = nominalVirtualResult(root)
folder = fullfile(root,"extensions","intelligent-inspection","adapters","uav-3d");
originalPath = path;
cleanup = onCleanup(@() path(originalPath)); %#ok<NASGU>
addpath(folder,"-begin");
clear virtual_source_adapter
configuration = nominalConfiguration();
context = nominalContext();
[data,metadata,status] = virtual_source_adapter(deterministicFrame(),context,configuration);
clear virtual_source_adapter
end

function configuration = nominalConfiguration()
configuration = struct("sourceId",uint32(16001), ...
    "inspectionDataSchemaVersion",uint16(1), ...
    "metadataSchemaVersion",uint16(1),"adapterVersion",uint16(2), ...
    "configurationVersion",uint16(1), ...
    "allowedReferenceFrameIds",uint16([1;2]), ...
    "environmentMinimum",single([-50;0;0;0]), ...
    "environmentMaximum",single([70;100000;200000;100]));
end

function context = nominalContext()
context = struct("itemId",uint32(1601),"payloadRef",uint32(1602), ...
    "acquisitionContextRef",uint32(1603),"cameraCalibrationRef",uint32(1604), ...
    "sequenceId",uint32(12),"scenarioId",uint32(99), ...
    "captureTimestamp",uint64(202609170001),"referenceFrameId",uint16(1), ...
    "imageWidth",uint16(8),"imageHeight",uint16(6),"channelCount",uint8(3), ...
    "projectionType",uint8(2),"position",[10;20;30], ...
    "orientation",[1;0;0;0], ...
    "environmentalContext",single([25;1000;5000;5]), ...
    "sourceVersion",uint16(3),"adapterVersion",uint16(2), ...
    "scenarioVersion",uint16(4),"metadataVersion",uint16(1), ...
    "configurationVersion",uint16(1));
end

function frame = deterministicFrame()
[row,column,channel] = ndgrid(uint16(0:5),uint16(0:7),uint16(0:2));
frame = uint8(mod(row*17+column*11+channel*53,256));
end

function outcomes = malformedOutcomes(root)
folder = fullfile(root,"extensions","intelligent-inspection","adapters","uav-3d");
originalPath = path;
cleanup = onCleanup(@() path(originalPath)); %#ok<NASGU>
addpath(folder,"-begin");
clear virtual_source_adapter
configuration = nominalConfiguration();
context = nominalContext();
frame = deterministicFrame();
cases = cell(14,3);
cases(1,:) = {frame,rmfield(context,"position"),configuration};
cases(2,:) = {frame,setField(context,"position",[1;2]),configuration};
cases(3,:) = {frame,setField(context,"position",[1;NaN;3]),configuration};
cases(4,:) = {frame,setField(context,"orientation",[2;0;0;0]),configuration};
cases(5,:) = {frame,setField(context,"environmentalContext",single([25;-1;5;2])),configuration};
cases(6,:) = {frame,setField(context,"scenarioId",uint32(0)),configuration};
cases(7,:) = {frame,setField(context,"captureTimestamp",uint64(0)),configuration};
cases(8,:) = {frame,setField(context,"referenceFrameId",uint16(9)),configuration};
cases(9,:) = {frame,setField(context,"sourceVersion",uint16(0)),configuration};
cases(10,:) = {frame,setField(context,"adapterVersion",uint16(9)),configuration};
cases(11,:) = {frame,setField(context,"scenarioVersion",uint16(0)),configuration};
cases(12,:) = {frame(:,:,1),context,configuration};
cases(13,:) = {single(frame),setField(context,"projectionType",uint8(9)),configuration};
cases(14,:) = {frame,context,setField(configuration,"environmentMaximum",single([0;0;0;0]))};
outcomes = false(14,1);
for caseIndex = 1:14
    [data,metadata,status] = virtual_source_adapter(cases{caseIndex,1}, ...
        cases{caseIndex,2},cases{caseIndex,3});
    outcomes(caseIndex) = ~status.accepted && data.itemId == 0 && ...
        metadata.itemId == 0 && status.statusCode == uint8(2);
end
clear virtual_source_adapter
end

function value = setField(value,name,newValue)
value.(name) = newValue;
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

function count = countDownstreamChanges(root)
protected = [fullfile(root,"extensions","intelligent-inspection","core"); ...
    fullfile(root,"extensions","intelligent-inspection","configurations","uav-pipeline"); ...
    fullfile(root,"extensions","intelligent-inspection","configurations","fixed-camera")];
count = 0;
for pathIndex = 1:numel(protected)
    command = sprintf('git -C "%s" status --porcelain -- "%s"', ...
        root,protected(pathIndex));
    [status,output] = system(command);
    count = count + status + strlength(strtrim(string(output)));
end
end

function hashes = protectedHashes(root)
hashes = struct( ...
    "core",aggregateHash(filesUnder(fullfile(root,"extensions","intelligent-inspection","core")),root), ...
    "phase13",aggregateHash(phase13Files(root),root), ...
    "phase14",aggregateHash(phase14Files(root),root), ...
    "phase15",aggregateHash(phase15Files(root),root), ...
    "realSources",aggregateHash(realSourceFiles(root),root), ...
    "protectedUav",aggregateHash(protectedUavFiles(root),root));
end

function files = phase13Files(root)
files = fullfile(root,["extensions/intelligent-inspection/configurations/uav-pipeline/configuration.yaml"; ...
    "extensions/intelligent-inspection/configurations/uav-pipeline/source_adapter.m"; ...
    "extensions/intelligent-inspection/configurations/uav-pipeline/recommendation_adapter.m"; ...
    "extensions/intelligent-inspection/configurations/uav-pipeline/dataset_manifest.yaml"; ...
    "tests/intelligent-inspection/test_uav_pipeline_configuration.m"; ...
    "extensions/intelligent-inspection/evidence/uav_pipeline_configuration_results.md"]);
end

function files = phase14Files(root)
files = fullfile(root,["extensions/intelligent-inspection/configurations/fixed-camera/configuration.yaml"; ...
    "extensions/intelligent-inspection/configurations/fixed-camera/source_adapter.m"; ...
    "extensions/intelligent-inspection/configurations/fixed-camera/recommendation_adapter.m"; ...
    "extensions/intelligent-inspection/configurations/fixed-camera/dataset_manifest.yaml"; ...
    "tests/intelligent-inspection/test_fixed_camera_configuration.m"; ...
    "extensions/intelligent-inspection/evidence/fixed_camera_configuration_results.md"]);
end

function files = phase15Files(root)
files = fullfile(root,["extensions/intelligent-inspection/evidence/reusability_evaluation.md"; ...
    "extensions/intelligent-inspection/evidence/reusable_core_hashes.txt"; ...
    "tests/intelligent-inspection/test_reusability.m"]);
end

function files = realSourceFiles(root)
files = fullfile(root,["extensions/intelligent-inspection/configurations/uav-pipeline/source_adapter.m"; ...
    "extensions/intelligent-inspection/configurations/fixed-camera/source_adapter.m"]);
end

function files = protectedUavFiles(root)
relative = ["models/uav_mission_supervisor.slx";"models/uav_mission_supervisor.sldd"; ...
    "models/uav_mission_supervisor~mdl.slmx";"models/uav_mission_supervisor_harnessInfo.xml"; ...
    "requirements/uav_mission_supervisor_requirements.slreqx"; ...
    "tests/uav_mission_supervisor_harness.slx";"tests/uav_mission_supervisor_tests.mldatx"; ...
    "tests/uav_mission_supervisor_tests~mldatx.slmx"; ...
    "reports/uav_mission_supervisor_coverage.cvt"; ...
    "reports/uav_mission_supervisor_coverage_report.html"; ...
    "reports/uav_mission_supervisor_change_report.md"; ...
    "reports/uav_mission_supervisor_independent_review.md"; ...
    "data/system_mode_definitions.m";"scripts/initialize_mission_supervisor.m"];
files = fullfile(root,relative);
files = files(isfile(files));
files = [files;filesUnder(fullfile(root,"tests","test_data")); ...
    filesUnder(fullfile(root,"reports","uav_mission_supervisor_coverage_report.html"))];
end

function evidence = externalModelEvidence()
root = fullfile(getenv("USERPROFILE"),"Documents","MATLAB","Examples","R2026a");
matches = dir(fullfile(root,"**","uav_simple_flight_model.slx"));
path = fullfile(matches(1).folder,matches(1).name);
evidence = struct("hash",fileHash(path),"outsideRepository", ...
    ~startsWith(path,repositoryRoot(),"IgnoreCase",true));
end

function changed = changedPaths(root)
command = sprintf('git -C "%s" status --porcelain --untracked-files=all',root);
[status,output] = system(command);
if status ~= 0
    changed = "git-status-failed";
    return
end
lines = splitlines(strtrim(string(output)));
changed = strings(numel(lines),1);
for lineIndex = 1:numel(lines)
    changed(lineIndex) = replace(extractAfter(lines(lineIndex),3),"\","/");
end
changed = sort(changed);
end

function paths = phase16Paths()
paths = sort(["extensions/intelligent-inspection/adapters/uav-3d/adapter_configuration.yaml"; ...
    "extensions/intelligent-inspection/adapters/uav-3d/scenario_metadata_schema.yaml"; ...
    "extensions/intelligent-inspection/adapters/uav-3d/virtual_source_adapter.m"; ...
    "extensions/intelligent-inspection/evidence/3d_adapter_scalability_results.md"; ...
    "tests/intelligent-inspection/test_3d_source_adapter.m"]);
end

function text = readTree(folder)
info = dir(fullfile(folder,"**","*"));
info = info(~[info.isdir]);
text = "";
for fileIndex = 1:numel(info)
    text = text+newline+string(fileread(fullfile(info(fileIndex).folder,info(fileIndex).name)));
end
end

function matched = containsAny(text,terms)
matched = any(contains(text,terms));
end

function files = filesUnder(folder)
info = dir(fullfile(folder,"**","*"));
info = info(~[info.isdir]);
files = strings(numel(info),1);
for fileIndex = 1:numel(info)
    files(fileIndex) = fullfile(info(fileIndex).folder,info(fileIndex).name);
end
end

function value = aggregateHash(files,root)
relative = replace(erase(files,string(root)+filesep),"\","/");
[relative,order] = sort(relative);
files = files(order);
bytes = uint8([]);
for fileIndex = 1:numel(files)
    entry = relative(fileIndex)+newline+fileHash(files(fileIndex))+newline;
    bytes = [bytes unicode2native(char(entry),"UTF-8")]; %#ok<AGROW>
end
value = sha256(bytes);
end

function value = fileHash(path)
identifier = fopen(path,"rb");
cleanup = onCleanup(@() fclose(identifier)); %#ok<NASGU>
value = sha256(fread(identifier,Inf,"*uint8")');
end

function value = sha256(bytes)
digest = java.security.MessageDigest.getInstance("SHA-256");
digest.update(typecast(uint8(bytes),"int8"));
raw = typecast(digest.digest(),"uint8");
value = lower(join(compose("%02x",raw),""));
end
