classdef test_detector_replacement < matlab.unittest.TestCase
    properties
        Fixture
    end

    methods (TestClassSetup)
        function addCorePath(testCase)
            testFolder = fileparts(mfilename("fullpath"));
            repositoryRoot = fileparts(fileparts(testFolder));
            coreFolder = fullfile(repositoryRoot, "extensions", ...
                "intelligent-inspection", "core");
            testCase.applyFixture(matlab.unittest.fixtures.PathFixture(coreFolder));
        end
    end

    methods (TestMethodSetup)
        function loadFixture(testCase)
            fixturePath = fullfile(fileparts(mfilename("fullpath")), ...
                "fixtures", "detection_contract_fixtures.mat");
            loaded = load(fixturePath, "fixture");
            testCase.Fixture = loaded.fixture;
        end
    end

    methods (Test)
        function twoImplementationsUseSameConsumer(testCase)
            first = iiw.detection.DetectorContract.create( ...
                @firstDetector, uint32(601), uint16(4));
            second = iiw.detection.DetectorContract.create( ...
                @secondDetector, uint32(602), uint16(5));
            [firstResult, firstStatus] = execute(testCase, first);
            [secondResult, secondStatus] = execute(testCase, second);
            testCase.verifyEqual(string(fieldnames(secondResult)), ...
                string(fieldnames(firstResult)));
            testCase.verifyEqual(firstStatus, uint8(0));
            testCase.verifyEqual(secondStatus, uint8(0));
        end

        function replacementIdentityIsRecorded(testCase)
            first = iiw.detection.DetectorContract.create( ...
                @firstDetector, uint32(601), uint16(4));
            second = iiw.detection.DetectorContract.create( ...
                @secondDetector, uint32(602), uint16(5));
            [firstResult, ~] = execute(testCase, first);
            [secondResult, ~] = execute(testCase, second);
            testCase.verifyEqual(firstResult.modelVersion, uint16(4));
            testCase.verifyEqual(secondResult.modelVersion, uint16(5));
            testCase.verifyNotEqual(firstResult.modelVersion, secondResult.modelVersion);
        end

        function invalidDetectorOutputIsRejected(testCase)
            detector = iiw.detection.DetectorContract.create( ...
                @invalidDetector, uint32(603), uint16(6));
            [result, status] = execute(testCase, detector);
            testCase.verifyEqual(status, uint8(5));
            testCase.verifyEqual(result.labelId, uint8(255));
            testCase.verifyEqual(result.resultId, uint32(0));
        end

        function detectorExecutionFailureIsControlled(testCase)
            detector = iiw.detection.DetectorContract.create( ...
                @failingDetector, uint32(604), uint16(7));
            [result, status] = execute(testCase, detector);
            testCase.verifyEqual(status, uint8(4));
            testCase.verifyEqual(result.labelId, uint8(255));
            testCase.verifyFalse(result.confidenceValid);
        end

        function malformedDetectorContractIsControlled(testCase)
            detector = struct("execute", @firstDetector);
            [result, status] = execute(testCase, detector);
            testCase.verifyEqual(status, uint8(3));
            testCase.verifyEqual(result.labelId, uint8(255));
        end
    end
end

function [result, status] = execute(testCase, detector)
[result, status] = iiw.detection.runDetector( ...
    testCase.Fixture.processedData, testCase.Fixture.nominalImage, detector, ...
    testCase.Fixture.configuration);
end

function result = firstDetector(processedData, ~, configuration, detector)
result = validMockResult(processedData, configuration, detector, uint8(21), single(0.9));
end

function result = secondDetector(processedData, ~, configuration, detector)
result = validMockResult(processedData, configuration, detector, uint8(22), single(0.8));
end

function result = invalidDetector(~, ~, ~, ~)
result = struct("unexpected", uint8(1));
end

function result = failingDetector(~, ~, ~, ~)
result = iiw.detection.DetectorContract.invalidResult();
error("IIW:Detection:InjectedFailure", "Injected deterministic failure.");
end

function result = validMockResult(processedData, configuration, detector, labelId, confidence)
result = struct( ...
    "resultId", configuration.resultId, ...
    "processedItemId", processedData.processedItemId, ...
    "labelId", labelId, ...
    "confidence", confidence, ...
    "location", zeros(3, 1, "double"), ...
    "modelVersion", detector.implementationVersion, ...
    "schemaVersion", configuration.resultSchemaVersion, ...
    "confidenceValid", true, ...
    "locationValid", false, ...
    "frameId", uint16(0));
end
