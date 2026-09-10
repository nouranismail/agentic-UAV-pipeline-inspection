classdef test_feature_extraction < matlab.unittest.TestCase
    properties
        Fixture
    end

    methods (TestClassSetup)
        function addCorePath(testCase)
            testFolder = fileparts(mfilename("fullpath"));
            repositoryRoot = fileparts(fileparts(testFolder));
            testCase.applyFixture(matlab.unittest.fixtures.PathFixture( ...
                fullfile(repositoryRoot, "extensions", "intelligent-inspection", "core")));
        end
    end

    methods (TestMethodSetup)
        function loadFixture(testCase)
            loaded = load(fullfile(fileparts(mfilename("fullpath")), ...
                "fixtures", "feature_contract_fixtures.mat"), "fixture");
            testCase.Fixture = loaded.fixture;
        end
    end

    methods (Test)
        function nominalDetection(testCase)
            result = runExtractor(testCase, testCase.Fixture.nominal);
            testCase.verifyTrue(iiw.features.validateFeatureSet(result));
            testCase.verifyEqual(result.featureValues(1:6), ...
                single([1; 0.75; 1; 1.5; -2.25; 3.75]));
            testCase.verifyTrue(all(result.validity(1:6)));
        end

        function noDetectionBehavior(testCase)
            result = runExtractor(testCase, testCase.Fixture.noDetection);
            testCase.verifyEqual(result.featureCount, uint8(6));
            testCase.verifyEqual(result.featureValues(1:6), zeros(6,1,"single"));
            testCase.verifyEqual(result.validity(1:6), ...
                logical([1; 1; 1; 0; 0; 0]));
        end

        function invalidConfidenceIsEmpty(testCase)
            input = testCase.Fixture.nominal;
            input.confidence = single(NaN);
            verifyEmpty(testCase, runExtractor(testCase, input));
        end

        function unavailableLocation(testCase)
            input = testCase.Fixture.nominal;
            input.location = zeros(3,1);
            input.locationValid = false;
            input.frameId = uint16(0);
            result = runExtractor(testCase, input);
            testCase.verifyEqual(result.featureValues(3:6), zeros(4,1,"single"));
            testCase.verifyEqual(result.validity(3:6), logical([1; 0; 0; 0]));
        end

        function nonfiniteLocationIsEmpty(testCase)
            input = testCase.Fixture.nominal;
            input.location(2) = Inf;
            verifyEmpty(testCase, runExtractor(testCase, input));
        end

        function malformedInputIsEmpty(testCase)
            input = rmfield(testCase.Fixture.nominal, "frameId");
            verifyEmpty(testCase, runExtractor(testCase, input));
        end

        function schemaMismatchIsEmpty(testCase)
            input = testCase.Fixture.nominal;
            input.schemaVersion = uint16(2);
            verifyEmpty(testCase, runExtractor(testCase, input));
        end

        function unsupportedConfigurationIsEmpty(testCase)
            configuration = testCase.Fixture.configuration;
            configuration.catalogVersion = uint16(2);
            result = iiw.features.extractNumericalFeatures( ...
                testCase.Fixture.nominal, configuration);
            verifyEmpty(testCase, result);
        end

        function deterministicRepetition(testCase)
            first = runExtractor(testCase, testCase.Fixture.nominal);
            second = runExtractor(testCase, testCase.Fixture.nominal);
            testCase.verifyEqual(second, first);
        end

        function exactFeatureOrderValidityAndUnits(testCase)
            result = runExtractor(testCase, testCase.Fixture.nominal);
            testCase.verifyEqual(result.featureIds(1:6), uint16((1:6).'));
            testCase.verifyEqual(result.unitDeclarations(1:6), ...
                uint16([1; 1; 1; 2; 2; 2]));
            testCase.verifyTrue(all(result.validity(1:6)));
            testCase.verifyEqual(result.extractorVersion, uint16(1));
            testCase.verifyEqual(result.schemaVersion, uint16(1));
        end

        function exactSchema(testCase)
            result = runExtractor(testCase, testCase.Fixture.nominal);
            expected = ["featureSetId"; "sourceRefs"; "unitDeclarations"; ...
                "validity"; "extractorVersion"; "schemaVersion"; ...
                "featureIds"; "featureValues"; "featureCount"; "referenceCount"];
            testCase.verifyEqual(string(fieldnames(result)), expected);
        end

        function exactEmptyOutput(testCase)
            empty = runExtractor(testCase, struct);
            testCase.verifyTrue(iiw.features.validateFeatureSet(empty));
            verifyEmpty(testCase, empty);
        end

        function validatorRejectsMisalignment(testCase)
            result = runExtractor(testCase, testCase.Fixture.nominal);
            result.featureIds(2) = uint16(1);
            testCase.verifyFalse(iiw.features.validateFeatureSet(result));
        end

        function prohibitedTerminologyAbsent(testCase)
            folder = fileparts(which("iiw.features.extractNumericalFeatures"));
            content = lower(string(fileread(fullfile(folder, ...
                "extractNumericalFeatures.m"))) + newline + ...
                string(fileread(fullfile(folder, "validateFeatureSet.m"))));
            prohibited = ["u"+"av", "pipe"+"line", "ks"+"dd2", ...
                "def"+"ect", "dam"+"age", "bat"+"tery", ...
                "remain"+"ingusefullife"];
            testCase.verifyFalse(any(contains(content, prohibited)));
        end
    end
end

function result = runExtractor(testCase, input)
result = iiw.features.extractNumericalFeatures(input, ...
    testCase.Fixture.configuration);
end

function verifyEmpty(testCase, result)
testCase.verifyEqual(result.featureSetId, uint32(0));
testCase.verifyEqual(result.featureCount, uint8(0));
testCase.verifyEqual(result.referenceCount, uint8(0));
testCase.verifyFalse(any(result.validity));
testCase.verifyTrue(all(result.sourceRefs == 0));
testCase.verifyTrue(all(result.unitDeclarations == 0));
testCase.verifyTrue(all(result.featureIds == 0));
testCase.verifyTrue(all(result.featureValues == 0));
testCase.verifyEqual(result.extractorVersion, uint16(0));
testCase.verifyEqual(result.schemaVersion, uint16(0));
end
