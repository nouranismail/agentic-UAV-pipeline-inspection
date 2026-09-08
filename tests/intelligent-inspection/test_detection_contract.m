classdef test_detection_contract < matlab.unittest.TestCase
    properties
        Fixture
        Detector
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
            testCase.Detector = iiw.detection.DetectorContract.create( ...
                @iiw.detection.conventionalDetector, uint32(501), uint16(3));
        end
    end

    methods (Test)
        function exactDetectionResultSchema(testCase)
            [result, status] = runNominal(testCase);
            expected = ["resultId"; "processedItemId"; "labelId"; "confidence"; ...
                "location"; "modelVersion"; "schemaVersion"; ...
                "confidenceValid"; "locationValid"; "frameId"];
            testCase.verifyEqual(string(fieldnames(result)), expected);
            testCase.verifyTrue(iiw.detection.DetectorContract.hasDetectionResultSchema(result));
            testCase.verifyEqual(status, uint8(0));
        end

        function nominalRegionIsDetected(testCase)
            [result, status] = runNominal(testCase);
            testCase.verifyEqual(status, uint8(0));
            testCase.verifyEqual(result.labelId, testCase.Fixture.configuration.labelId);
            testCase.verifyGreaterThanOrEqual(result.confidence, ...
                testCase.Fixture.configuration.minimumConfidence);
        end

        function noDetectionIsControlled(testCase)
            [result, status] = iiw.detection.runDetector( ...
                testCase.Fixture.processedData, testCase.Fixture.emptyImage, ...
                testCase.Detector, testCase.Fixture.configuration);
            testCase.verifyEqual(status, uint8(1));
            testCase.verifyEqual(result.labelId, uint8(0));
            testCase.verifyTrue(result.confidenceValid);
            testCase.verifyFalse(result.locationValid);
        end

        function lowConfidenceAbstains(testCase)
            [result, status] = iiw.detection.runDetector( ...
                testCase.Fixture.processedData, testCase.Fixture.lowConfidenceImage, ...
                testCase.Detector, testCase.Fixture.configuration);
            testCase.verifyEqual(status, uint8(2));
            testCase.verifyEqual(result.labelId, uint8(0));
            testCase.verifyLessThan(result.confidence, ...
                testCase.Fixture.configuration.minimumConfidence);
            testCase.verifyFalse(result.locationValid);
        end

        function malformedProcessedDataIsControlled(testCase)
            malformed = rmfield(testCase.Fixture.processedData, "schemaVersion");
            [result, status] = iiw.detection.runDetector(malformed, ...
                testCase.Fixture.nominalImage, testCase.Detector, ...
                testCase.Fixture.configuration);
            testCase.verifyEqual(status, uint8(3));
            testCase.verifyEqual(result.labelId, uint8(255));
            testCase.verifyFalse(result.confidenceValid);
        end

        function nonfiniteImageIsControlled(testCase)
            image = testCase.Fixture.nominalImage;
            image(1) = single(NaN);
            [result, status] = iiw.detection.runDetector( ...
                testCase.Fixture.processedData, image, testCase.Detector, ...
                testCase.Fixture.configuration);
            testCase.verifyEqual(status, uint8(3));
            testCase.verifyEqual(result.labelId, uint8(255));
        end

        function confidenceAndLocationConform(testCase)
            [result, ~] = runNominal(testCase);
            testCase.verifyClass(result.confidence, "single");
            testCase.verifyGreaterThanOrEqual(result.confidence, single(0));
            testCase.verifyLessThanOrEqual(result.confidence, single(1));
            testCase.verifySize(result.location, [3 1]);
            testCase.verifyTrue(result.locationValid);
            testCase.verifyEqual(result.frameId, testCase.Fixture.configuration.frameId);
        end

        function provenanceIsPreserved(testCase)
            [result, ~] = runNominal(testCase);
            testCase.verifyEqual(result.processedItemId, ...
                testCase.Fixture.processedData.processedItemId);
            testCase.verifyEqual(result.resultId, testCase.Fixture.configuration.resultId);
            testCase.verifyEqual(result.modelVersion, testCase.Detector.implementationVersion);
            testCase.verifyEqual(result.schemaVersion, ...
                testCase.Fixture.configuration.resultSchemaVersion);
        end

        function repeatedExecutionIsDeterministic(testCase)
            [firstResult, firstStatus] = runNominal(testCase);
            [secondResult, secondStatus] = runNominal(testCase);
            testCase.verifyEqual(secondResult, firstResult);
            testCase.verifyEqual(secondStatus, firstStatus);
        end

        function configuredMinimumAreaChangesDisposition(testCase)
            configuration = testCase.Fixture.configuration;
            configuration.minimumArea = uint32(200);
            [result, status] = iiw.detection.runDetector( ...
                testCase.Fixture.processedData, testCase.Fixture.nominalImage, ...
                testCase.Detector, configuration);
            testCase.verifyEqual(status, uint8(1));
            testCase.verifyEqual(result.labelId, uint8(0));
        end

        function reusableImplementationHasNoProhibitedTerms(testCase)
            coreFolder = fileparts(which("iiw.detection.runDetector"));
            first = lower(string(fileread(fullfile(coreFolder, "DetectorContract.m"))));
            second = lower(string(fileread(fullfile(coreFolder, "runDetector.m"))));
            third = lower(string(fileread(fullfile(coreFolder, "conventionalDetector.m"))));
            content = first + second + third;
            prohibited = ["u" + "av", "pipe" + "line", "bat" + "tery", ...
                "land" + "ing", "return" + "tohome", "safe" + "landing", ...
                "cr" + "ack", "corro" + "sion", "mis" + "sion", ...
                "appro" + "val", "recommen" + "dation"];
            testCase.verifyFalse(any(contains(content, prohibited)));
        end
    end
end

function [result, status] = runNominal(testCase)
[result, status] = iiw.detection.runDetector( ...
    testCase.Fixture.processedData, testCase.Fixture.nominalImage, ...
    testCase.Detector, testCase.Fixture.configuration);
end
