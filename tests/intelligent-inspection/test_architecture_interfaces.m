function tests = test_architecture_interfaces
%TEST_ARCHITECTURE_INTERFACES Verify Phase 4 interface conformance.

tests = functiontests(localfunctions);
end

function setupOnce(testCase)
testFile = mfilename("fullpath");
repositoryRoot = fileparts(fileparts(fileparts(testFile)));
architectureRoot = fullfile(repositoryRoot, "extensions", ...
    "intelligent-inspection", "architecture");
testCase.TestData.ModelDirectory = fullfile(architectureRoot, "models");
testCase.TestData.DictionaryDirectory = fullfile(architectureRoot, "data");
testCase.TestData.ModelName = "intelligent_inspection_reference_architecture";
testCase.TestData.ModelPath = fullfile(testCase.TestData.ModelDirectory, ...
    testCase.TestData.ModelName + ".slx");
testCase.TestData.DictionaryPath = fullfile(architectureRoot, "data", ...
    "intelligent_inspection_interfaces.sldd");
testCase.TestData.ContractPath = fullfile(architectureRoot, ...
    "interface_contracts.md");
end

function setup(testCase)
addpath(testCase.TestData.ModelDirectory, testCase.TestData.DictionaryDirectory);
testCase.addTeardown(@() rmpath(testCase.TestData.ModelDirectory, ...
    testCase.TestData.DictionaryDirectory));
testCase.verifyTrue(isfile(testCase.TestData.ModelPath));
testCase.verifyTrue(isfile(testCase.TestData.DictionaryPath));
testCase.TestData.Model = systemcomposer.loadModel(testCase.TestData.ModelName);
testCase.addTeardown(@() closeModel(testCase.TestData.ModelName));
testCase.TestData.Architecture = testCase.TestData.Model.Architecture;
testCase.TestData.Dictionary = systemcomposer.openDictionary( ...
    testCase.TestData.DictionaryPath);
testCase.addTeardown(@() closeDictionary(testCase.TestData.Dictionary));
end

function testApprovedInterfaceInventoryAndElements(testCase)
expected = parseApprovedSchemas(testCase.TestData.ContractPath);
actualNames = string(testCase.TestData.Dictionary.getInterfaceNames);
actualNames = sort(actualNames(:));
expectedNames = sort(string(fieldnames(expected)));
testCase.verifyEqual(actualNames, expectedNames);

for interfaceName = expectedNames'
    specification = expected.(interfaceName);
    interface = testCase.TestData.Dictionary.getInterface(interfaceName);
    actualElements = sort(string({interface.Elements.Name})');
    expectedElements = sort(string({specification.Name})');
    testCase.verifyEqual(actualElements, expectedElements, ...
        "Element inventory mismatch for " + interfaceName);

    for index = 1:numel(specification)
        required = specification(index);
        element = interface.getElement(required.Name);
        valueType = element.Type;
        testCase.verifyEqual(string(valueType.DataType), required.Type, ...
            "Type mismatch for " + interfaceName + "." + required.Name);
        testCase.verifyEqual(normalizeDimension(valueType.Dimensions), ...
            normalizeDimension(required.Dimension), ...
            "Dimension mismatch for " + interfaceName + "." + required.Name);
        testCase.verifyEqual(string(valueType.Units), required.Unit, ...
            "Unit mismatch for " + interfaceName + "." + required.Name);
        description = string(element.Description);
        testCase.verifyTrue(contains(description, "RangeOrEncoding=" + ...
            required.RangeOrEncoding));
        testCase.verifyTrue(contains(description, "ValidityAndDefault=" + ...
            required.ValidityAndDefault));
    end
end
end

function testApprovedBoundaryPorts(testCase)
expected = [
    "inspectionDataIn", "Input", "InspectionData"
    "inspectionMetadataIn", "Input", "InspectionMetadata"
    "approvalDecisionIn", "Input", "ApprovalDecision"
    "approvalRequestOut", "Output", "ApprovalRequest"
    "recommendedActionOut", "Output", "RecommendedAction"
    "evidenceRecordOut", "Output", "EvidenceRecord"];
verifyPorts(testCase, testCase.TestData.Architecture.Ports, expected, ...
    "architecture boundary");
end

function testApprovedComponentPortsAndAssignments(testCase)
expected = componentPortSpecification();
architecture = testCase.TestData.Architecture;
expectedComponents = sort(unique(expected(:, 1)));
actualComponents = sort(string({architecture.Components.Name})');
testCase.verifyEqual(actualComponents, expectedComponents);
testCase.verifyNumElements(actualComponents, 10);

for componentName = expectedComponents'
    component = architecture.getComponent(componentName);
    rows = expected(expected(:, 1) == componentName, 2:4);
    verifyPorts(testCase, component.Ports, rows, componentName);
end
end

function testApprovedConnectorStructure(testCase)
expected = connectorSpecification();
architecture = testCase.TestData.Architecture;
for index = 1:size(expected, 1)
    source = resolvePort(architecture, expected(index, 1), expected(index, 2));
    destination = resolvePort(architecture, expected(index, 3), expected(index, 4));
    testCase.verifyNotEmpty(source.getConnectorTo(destination), ...
        "Missing connection: " + expected(index, 1) + "." + ...
        expected(index, 2) + "->" + expected(index, 3) + "." + ...
        expected(index, 4));
end
testCase.verifyEmpty(testCase.TestData.Architecture.getUnconnectedPorts());
end

function testEvidenceAndApprovalAuthorityIsolation(testCase)
architecture = testCase.TestData.Architecture;
externalDecision = architecture.getPort("approvalDecisionIn");
gateDecision = architecture.getComponent("HumanApprovalGate").getPort( ...
    "approvalDecisionIn");
gateRequest = architecture.getComponent("HumanApprovalGate").getPort( ...
    "approvalRequestOut");
externalRequest = architecture.getPort("approvalRequestOut");
testCase.verifyNotEmpty(externalDecision.getConnectorTo(gateDecision));
testCase.verifyNotEmpty(gateRequest.getConnectorTo(externalRequest));

recorder = architecture.getComponent("EvidenceRecorder");
outputPorts = recorder.Ports(string({recorder.Ports.Direction}) == "Output");
testCase.verifyNumElements(outputPorts, 1);
testCase.verifyEqual(string(outputPorts.Name), "evidenceRecordOut");
testCase.verifyNotEmpty(outputPorts.getConnectorTo( ...
    architecture.getPort("evidenceRecordOut")));
end

function testNoUntypedOrProjectSpecificNames(testCase)
architecture = testCase.TestData.Architecture;
names = string({architecture.Components.Name});
names = [names, string({architecture.Ports.Name})];
for component = architecture.Components
    names = [names, string({component.Ports.Name})]; %#ok<AGROW>
end
interfaceNames = string(testCase.TestData.Dictionary.getInterfaceNames);
for interfaceName = interfaceNames(:)'
    interface = testCase.TestData.Dictionary.getInterface(interfaceName);
    names = [names, interfaceName, string({interface.Elements.Name})]; %#ok<AGROW>
end

prohibited = ["uav", "pipeline", "battery", "landing", ...
    "returntohome", "safelanding", "crack", "corrosion"];
joined = lower(join(names, " "));
for term = prohibited
    testCase.verifyFalse(contains(joined, term), ...
        "Prohibited project-specific term found: " + term);
end

for port = architecture.Ports
    testCase.verifyNotEmpty(string(port.InterfaceName), ...
        "Untyped required port: " + string(port.Name));
end
for component = architecture.Components
    for port = component.Ports
        testCase.verifyNotEmpty(string(port.InterfaceName), ...
            "Untyped required port: " + string(component.Name) + "." + ...
            string(port.Name));
    end
end
end

function testModelDictionaryLifecycle(testCase)
set_param(testCase.TestData.ModelName, "SimulationCommand", "update");
save_system(testCase.TestData.ModelName);
testCase.TestData.Dictionary.save();
close_system(testCase.TestData.ModelName, 0);
testCase.TestData.Dictionary.close();

dictionary = systemcomposer.openDictionary(testCase.TestData.DictionaryPath);
testCase.verifyTrue(dictionary.isOpen());
testCase.verifyNumElements(dictionary.getInterfaceNames, 12);
dictionary.close();

model = systemcomposer.loadModel(testCase.TestData.ModelName);
testCase.verifyTrue(bdIsLoaded(testCase.TestData.ModelName));
set_param(testCase.TestData.ModelName, "SimulationCommand", "update");
testCase.verifyEmpty(model.Architecture.getUnconnectedPorts());
close_system(testCase.TestData.ModelName, 0);
end

function verifyPorts(testCase, ports, expected, owner)
actualNames = sort(string({ports.Name})');
testCase.verifyEqual(actualNames, sort(expected(:, 1)), ...
    "Port inventory mismatch for " + owner);
for index = 1:size(expected, 1)
    port = ports(strcmp({ports.Name}, expected(index, 1)));
    testCase.verifyEqual(string(port.Direction), expected(index, 2));
    testCase.verifyTrue(endsWith(string(port.InterfaceName), expected(index, 3)), ...
        "Interface mismatch for " + owner + "." + expected(index, 1));
end
end

function expected = componentPortSpecification
expected = [
"InspectionSource","inspectionDataIn","Input","InspectionData"
"InspectionSource","inspectionMetadataIn","Input","InspectionMetadata"
"InspectionSource","inspectionData","Output","InspectionData"
"InspectionSource","inspectionMetadata","Output","InspectionMetadata"
"InspectionSource","evidenceOut","Output","InspectionMetadata"
"DataQualityValidation","inspectionData","Input","InspectionData"
"DataQualityValidation","inspectionMetadata","Input","InspectionMetadata"
"DataQualityValidation","qualityResult","Output","DataQualityResult"
"DataQualityValidation","evidenceOut","Output","DataQualityResult"
"Preprocessing","inspectionData","Input","InspectionData"
"Preprocessing","inspectionMetadata","Input","InspectionMetadata"
"Preprocessing","qualityResult","Input","DataQualityResult"
"Preprocessing","processedData","Output","ProcessedData"
"Preprocessing","evidenceOut","Output","ProcessedData"
"Detection","processedData","Input","ProcessedData"
"Detection","detectionResult","Output","DetectionResult"
"Detection","evidenceOut","Output","DetectionResult"
"FeatureExtraction","processedData","Input","ProcessedData"
"FeatureExtraction","detectionResult","Input","DetectionResult"
"FeatureExtraction","numericalFeatures","Output","NumericalFeatureSet"
"FeatureExtraction","evidenceOut","Output","NumericalFeatureSet"
"HealthPrediction","numericalFeatures","Input","NumericalFeatureSet"
"HealthPrediction","healthPrediction","Output","HealthPrediction"
"HealthPrediction","evidenceOut","Output","HealthPrediction"
"RiskAssessment","qualityResult","Input","DataQualityResult"
"RiskAssessment","detectionResult","Input","DetectionResult"
"RiskAssessment","numericalFeatures","Input","NumericalFeatureSet"
"RiskAssessment","healthPrediction","Input","HealthPrediction"
"RiskAssessment","riskAssessment","Output","RiskAssessment"
"RiskAssessment","evidenceOut","Output","RiskAssessment"
"HumanApprovalGate","riskAssessment","Input","RiskAssessment"
"HumanApprovalGate","approvalDecisionIn","Input","ApprovalDecision"
"HumanApprovalGate","approvalRequestOut","Output","ApprovalRequest"
"HumanApprovalGate","approvalDecision","Output","ApprovalDecision"
"HumanApprovalGate","evidenceOut","Output","ApprovalDecision"
"RecommendedAction","riskAssessment","Input","RiskAssessment"
"RecommendedAction","approvalDecision","Input","ApprovalDecision"
"RecommendedAction","recommendedActionOut","Output","RecommendedAction"
"RecommendedAction","evidenceOut","Output","RecommendedAction"
"EvidenceRecorder","sourceEvidence","Input","InspectionMetadata"
"EvidenceRecorder","qualityEvidence","Input","DataQualityResult"
"EvidenceRecorder","preprocessingEvidence","Input","ProcessedData"
"EvidenceRecorder","detectionEvidence","Input","DetectionResult"
"EvidenceRecorder","featureEvidence","Input","NumericalFeatureSet"
"EvidenceRecorder","predictionEvidence","Input","HealthPrediction"
"EvidenceRecorder","riskEvidence","Input","RiskAssessment"
"EvidenceRecorder","approvalEvidence","Input","ApprovalDecision"
"EvidenceRecorder","recommendationEvidence","Input","RecommendedAction"
"EvidenceRecorder","evidenceRecordOut","Output","EvidenceRecord"];
end

function expected = connectorSpecification
expected = [
"<architecture>","inspectionDataIn","InspectionSource","inspectionDataIn"
"<architecture>","inspectionMetadataIn","InspectionSource","inspectionMetadataIn"
"<architecture>","approvalDecisionIn","HumanApprovalGate","approvalDecisionIn"
"InspectionSource","inspectionData","DataQualityValidation","inspectionData"
"InspectionSource","inspectionMetadata","DataQualityValidation","inspectionMetadata"
"InspectionSource","inspectionData","Preprocessing","inspectionData"
"InspectionSource","inspectionMetadata","Preprocessing","inspectionMetadata"
"DataQualityValidation","qualityResult","Preprocessing","qualityResult"
"Preprocessing","processedData","Detection","processedData"
"Preprocessing","processedData","FeatureExtraction","processedData"
"Detection","detectionResult","FeatureExtraction","detectionResult"
"FeatureExtraction","numericalFeatures","HealthPrediction","numericalFeatures"
"DataQualityValidation","qualityResult","RiskAssessment","qualityResult"
"Detection","detectionResult","RiskAssessment","detectionResult"
"FeatureExtraction","numericalFeatures","RiskAssessment","numericalFeatures"
"HealthPrediction","healthPrediction","RiskAssessment","healthPrediction"
"RiskAssessment","riskAssessment","HumanApprovalGate","riskAssessment"
"RiskAssessment","riskAssessment","RecommendedAction","riskAssessment"
"HumanApprovalGate","approvalDecision","RecommendedAction","approvalDecision"
"HumanApprovalGate","approvalRequestOut","<architecture>","approvalRequestOut"
"RecommendedAction","recommendedActionOut","<architecture>","recommendedActionOut"
"InspectionSource","evidenceOut","EvidenceRecorder","sourceEvidence"
"DataQualityValidation","evidenceOut","EvidenceRecorder","qualityEvidence"
"Preprocessing","evidenceOut","EvidenceRecorder","preprocessingEvidence"
"Detection","evidenceOut","EvidenceRecorder","detectionEvidence"
"FeatureExtraction","evidenceOut","EvidenceRecorder","featureEvidence"
"HealthPrediction","evidenceOut","EvidenceRecorder","predictionEvidence"
"RiskAssessment","evidenceOut","EvidenceRecorder","riskEvidence"
"HumanApprovalGate","evidenceOut","EvidenceRecorder","approvalEvidence"
"RecommendedAction","evidenceOut","EvidenceRecorder","recommendationEvidence"
"EvidenceRecorder","evidenceRecordOut","<architecture>","evidenceRecordOut"];
end

function port = resolvePort(architecture, owner, portName)
if owner == "<architecture>"
    port = architecture.getPort(portName);
else
    port = architecture.getComponent(owner).getPort(portName);
end
end

function schemas = parseApprovedSchemas(contractPath)
text = fileread(contractPath);
interfaceNames = ["InspectionData", "InspectionMetadata", ...
    "DataQualityResult", "ProcessedData", "DetectionResult", ...
    "NumericalFeatureSet", "HealthPrediction", "RiskAssessment", ...
    "ApprovalRequest", "ApprovalDecision", "RecommendedAction", ...
    "EvidenceRecord"];
schemas = struct;
for index = 1:numel(interfaceNames)
    name = interfaceNames(index);
    marker = "### `" + name + "`";
    startIndex = strfind(text, marker);
    assert(isscalar(startIndex), "Schema heading is not unique: %s", name);
    tail = extractAfter(string(text), startIndex + strlength(marker) - 1);
    nextHeading = regexp(tail, "\r?\n##", "once");
    if ~isempty(nextHeading)
        tail = extractBefore(tail, nextHeading);
    end
    lines = splitlines(tail);
    rows = struct("Name", {}, "Type", {}, "Dimension", {}, "Unit", {}, ...
        "RangeOrEncoding", {}, "ValidityAndDefault", {});
    for line = lines'
        if ~startsWith(strtrim(line), "| `")
            continue
        end
        cells = split(line, "|");
        if numel(cells) < 8
            continue
        end
        elementName = firstCodeToken(cells(2));
        type = firstCodeToken(cells(3));
        if strlength(type) == 0 || contains(cells(3), "Logical concept only")
            continue
        end
        row.Name = char(elementName);
        row.Type = type;
        row.Dimension = firstCodeToken(cells(4));
        row.Unit = firstCodeToken(cells(5));
        row.RangeOrEncoding = strtrim(cells(6));
        row.ValidityAndDefault = strtrim(cells(7));
        rows(end + 1) = row; %#ok<AGROW>
    end
    schemas.(name) = rows;
end
end

function token = firstCodeToken(cellText)
match = regexp(cellText, "`([^`]*)`", "tokens", "once");
if isempty(match)
    token = "";
else
    token = string(match{1});
end
end

function value = normalizeDimension(value)
value = erase(string(value), ["[", "]", " "]);
end

function closeModel(modelName)
if bdIsLoaded(modelName)
    close_system(modelName, 0);
end
end

function closeDictionary(dictionary)
if ~isempty(dictionary) && isvalid(dictionary) && dictionary.isOpen()
    dictionary.close();
end
end
