function tests = test_reference_architecture
%TEST_REFERENCE_ARCHITECTURE Verify the Phase 3 logical architecture.

tests = functiontests(localfunctions);
end

function setupOnce(testCase)
testFile = mfilename("fullpath");
repositoryRoot = fileparts(fileparts(fileparts(testFile)));
modelDirectory = fullfile(repositoryRoot, "extensions", ...
    "intelligent-inspection", "architecture", "models");
modelName = "intelligent_inspection_reference_architecture";
modelPath = fullfile(modelDirectory, modelName + ".slx");

testCase.verifyTrue(isfile(modelPath), "Architecture model is missing.");
addpath(modelDirectory);
testCase.addTeardown(@() rmpath(modelDirectory));

architectureModel = systemcomposer.loadModel(modelName);
testCase.addTeardown(@() closeModel(modelName));

testCase.TestData.ModelName = modelName;
testCase.TestData.ModelPath = modelPath;
testCase.TestData.ArchitectureModel = architectureModel;
testCase.TestData.Architecture = architectureModel.Architecture;
end

function testModelOpensSuccessfully(testCase)
testCase.verifyTrue(bdIsLoaded(testCase.TestData.ModelName));
actualPath = string(get_param(testCase.TestData.ModelName, "FileName"));
testCase.verifyEqual(actualPath, string(testCase.TestData.ModelPath));
end

function testRequiredComponentInventory(testCase)
expected = ["DataQualityValidation", "Detection", "EvidenceRecorder", ...
    "FeatureExtraction", "HealthPrediction", "HumanApprovalGate", ...
    "InspectionSource", "Preprocessing", "RecommendedAction", ...
    "RiskAssessment"];
actual = sort(string({testCase.TestData.Architecture.Components.Name}));

testCase.verifyNumElements(actual, 10);
testCase.verifyEqual(actual, sort(expected));
testCase.verifyEqual(numel(unique(actual)), 10);
end

function testCompleteConnectionInventory(testCase)
expected = [ ...
    "<architecture>.inspectionInput->InspectionSource.inspectionInput"
    "InspectionSource.inspectionData->DataQualityValidation.inspectionData"
    "DataQualityValidation.qualityResult->Preprocessing.qualityResult"
    "Preprocessing.processedData->Detection.processedData"
    "Detection.detectionResult->FeatureExtraction.detectionResult"
    "FeatureExtraction.numericalFeatures->HealthPrediction.numericalFeatures"
    "HealthPrediction.healthPrediction->RiskAssessment.healthPrediction"
    "RiskAssessment.riskAssessment->HumanApprovalGate.riskAssessment"
    "HumanApprovalGate.approvalDecision->RecommendedAction.approvalDecision"
    "InspectionSource.evidenceOut->EvidenceRecorder.sourceEvidence"
    "DataQualityValidation.evidenceOut->EvidenceRecorder.qualityEvidence"
    "Preprocessing.evidenceOut->EvidenceRecorder.preprocessingEvidence"
    "Detection.evidenceOut->EvidenceRecorder.detectionEvidence"
    "FeatureExtraction.evidenceOut->EvidenceRecorder.featureEvidence"
    "HealthPrediction.evidenceOut->EvidenceRecorder.predictionEvidence"
    "RiskAssessment.evidenceOut->EvidenceRecorder.riskEvidence"
    "HumanApprovalGate.evidenceOut->EvidenceRecorder.approvalEvidence"
    "RecommendedAction.evidenceOut->EvidenceRecorder.recommendationEvidence"
    "RecommendedAction.recommendedAction-><architecture>.recommendedAction"
    "EvidenceRecorder.evidenceRecord-><architecture>.evidenceRecord"];

actual = connectionInventory(testCase.TestData.Architecture);
testCase.verifyEqual(numel(actual), 20);
testCase.verifyEqual(sort(actual), sort(expected));
end

function testEvidenceRecorderIsObservationOnly(testCase)
connections = testCase.TestData.Architecture.Connectors;
incomingSources = strings(0, 1);
outgoingDestinations = strings(0, 1);

for index = 1:numel(connections)
    source = connections(index).SourcePort;
    destination = connections(index).DestinationPort;
    if isComponentParent(destination.Parent, "EvidenceRecorder")
        incomingSources(end + 1, 1) = string(source.Parent.Name); %#ok<AGROW>
    end
    if isComponentParent(source.Parent, "EvidenceRecorder")
        outgoingDestinations(end + 1, 1) = ...
            parentName(destination.Parent) + "." + string(destination.Name); %#ok<AGROW>
    end
end

expectedSources = ["DataQualityValidation"; "Detection"; ...
    "FeatureExtraction"; "HealthPrediction"; "HumanApprovalGate"; ...
    "InspectionSource"; "Preprocessing"; "RecommendedAction"; ...
    "RiskAssessment"];
testCase.verifyEqual(sort(incomingSources), sort(expectedSources));
testCase.verifyEqual(outgoingDestinations, "<architecture>.evidenceRecord");
end

function testNamesAreApplicationIndependent(testCase)
architecture = testCase.TestData.Architecture;
names = string({architecture.Components.Name});
names = [names, string({architecture.Ports.Name})];
for component = architecture.Components
    names = [names, string({component.Ports.Name})]; %#ok<AGROW>
end

prohibitedTerms = ["uav", "pipeline", "battery", "landing", ...
    "returntohome", "safelanding", "crack", "corrosion"];
joinedNames = lower(join(names, " "));
for term = prohibitedTerms
    testCase.verifyFalse(contains(joinedNames, term), ...
        "A component or port name contains prohibited terminology: " + term);
end
end

function testEmptyReplaceableComponents(testCase)
components = testCase.TestData.Architecture.Components;
for component = components
    testCase.verifyEmpty(component.Architecture.Components);
    testCase.verifyFalse(component.IsAdapterComponent);
end
end

function testModelUpdatesWithoutArchitectureErrors(testCase)
architecture = testCase.TestData.Architecture;
testCase.verifyEmpty(architecture.getUnconnectedPorts());
set_param(testCase.TestData.ModelName, "SimulationCommand", "update");
save_system(testCase.TestData.ModelName);
testCase.verifyTrue(isfile(testCase.TestData.ModelPath));
end

function inventory = connectionInventory(architecture)
connections = architecture.Connectors;
inventory = strings(numel(connections), 1);
for index = 1:numel(connections)
    source = connections(index).SourcePort;
    destination = connections(index).DestinationPort;
    inventory(index) = parentName(source.Parent) + "." + string(source.Name) ...
        + "->" + parentName(destination.Parent) + "." ...
        + string(destination.Name);
end
end

function name = parentName(parent)
if isa(parent, "systemcomposer.arch.Component")
    name = string(parent.Name);
else
    name = "<architecture>";
end
end

function result = isComponentParent(parent, expectedName)
result = isa(parent, "systemcomposer.arch.Component") ...
    && string(parent.Name) == expectedName;
end

function closeModel(modelName)
if bdIsLoaded(modelName)
    close_system(modelName, 0);
end
end
