classdef test_data_quality < matlab.unittest.TestCase
    %TEST_DATA_QUALITY Phase 5 tests for generic data-quality validation.

    properties
        Fixture
    end

    methods (TestClassSetup)
        function addReusableCoreToPath(testCase)
            repositoryRoot = fileparts(fileparts(fileparts(mfilename("fullpath"))));
            coreFolder = fullfile(repositoryRoot, "extensions", ...
                "intelligent-inspection", "core");
            testCase.applyFixture(matlab.unittest.fixtures.PathFixture(coreFolder));
        end
    end

    methods (TestMethodSetup)
        function loadContractFixture(testCase)
            testFolder = fileparts(mfilename("fullpath"));
            fixtureFile = fullfile(testFolder, "fixtures", ...
                "quality_contract_fixtures.mat");
            testCase.Fixture = load(fixtureFile);
        end
    end

    methods (Test)
        function validNominalImagePasses(testCase)
            f = testCase.Fixture;
            result = iiw.quality.validateInspectionData( ...
                f.inspectionData, f.inspectionMetadata, f.nominalImage, f.configuration);
            testCase.verifyEqual(result.status, uint8(1));
            testCase.verifyEqual(result.measureCount, uint8(6));
            testCase.verifyEqual(result.reasonCodeCount, uint8(0));
            testCase.verifyGreaterThanOrEqual(result.measures(1), single(0));
            testCase.verifyLessThanOrEqual(result.measures(1), single(1));
        end

        function validNumericalSensorPasses(testCase)
            f = testCase.Fixture;
            data = f.inspectionData;
            data.modality = uint8(3);
            result = iiw.quality.validateInspectionData( ...
                data, f.inspectionMetadata, f.nominalSignal, f.configuration);
            testCase.verifyEqual(result.status, uint8(1));
            testCase.verifyEqual(result.measureCount, uint8(2));
            testCase.verifyEqual(result.measures(1:2), single([1; 1]));
        end

        function exactBrightnessBoundaryPasses(testCase)
            f = testCase.Fixture;
            configuration = f.configuration;
            configuration.minBrightness = single(0.5);
            configuration.maxBrightness = single(0.5);
            configuration.minContrast = single(0);
            configuration.minSharpness = single(0);
            configuration.maxSaturationFraction = single(1);
            result = iiw.quality.validateInspectionData( ...
                f.inspectionData, f.inspectionMetadata, f.nominalImage, configuration);
            testCase.verifyEqual(result.status, uint8(1));
            testCase.verifyEqual(result.measures(2), single(0.5), AbsTol=single(1e-6));
        end

        function missingRequiredFieldRejects(testCase)
            f = testCase.Fixture;
            data = rmfield(f.inspectionData, "sourceId");
            result = iiw.quality.validateInspectionData( ...
                data, f.inspectionMetadata, f.nominalImage, f.configuration);
            testCase.verifyEqual(result.status, uint8(3));
            testCase.verifyTrue(any(result.reasonCodes == f.configuration.reasonCodes(1)));
        end

        function emptyPayloadRejects(testCase)
            f = testCase.Fixture;
            result = iiw.quality.validateInspectionData( ...
                f.inspectionData, f.inspectionMetadata, [], f.configuration);
            testCase.verifyEqual(result.status, uint8(3));
            testCase.verifyTrue(any(result.reasonCodes == f.configuration.reasonCodes(2)));
        end

        function malformedFieldTypeRejects(testCase)
            f = testCase.Fixture;
            data = f.inspectionData;
            data.itemId = double(data.itemId);
            result = iiw.quality.validateInspectionData( ...
                data, f.inspectionMetadata, f.nominalImage, f.configuration);
            testCase.verifyEqual(result.status, uint8(3));
            testCase.verifyTrue(any(result.reasonCodes == f.configuration.reasonCodes(4)));
        end

        function malformedPayloadDimensionsReject(testCase)
            f = testCase.Fixture;
            malformedPayload = zeros(8, 8, 2, "uint8");
            result = iiw.quality.validateInspectionData( ...
                f.inspectionData, f.inspectionMetadata, malformedPayload, f.configuration);
            testCase.verifyEqual(result.status, uint8(3));
            testCase.verifyTrue(any(result.reasonCodes == f.configuration.reasonCodes(5)));
        end

        function nonfinitePayloadRejects(testCase)
            f = testCase.Fixture;
            result = iiw.quality.validateInspectionData( ...
                f.inspectionData, f.inspectionMetadata, f.nonfiniteImage, f.configuration);
            testCase.verifyEqual(result.status, uint8(3));
            testCase.verifyTrue(any(result.reasonCodes == f.configuration.reasonCodes(7)));
        end

        function darkImageRejects(testCase)
            f = testCase.Fixture;
            result = iiw.quality.validateInspectionData( ...
                f.inspectionData, f.inspectionMetadata, f.darkImage, f.configuration);
            testCase.verifyEqual(result.status, uint8(3));
            testCase.verifyTrue(any(result.reasonCodes == f.configuration.reasonCodes(11)));
        end

        function brightImageRejects(testCase)
            f = testCase.Fixture;
            result = iiw.quality.validateInspectionData( ...
                f.inspectionData, f.inspectionMetadata, f.brightImage, f.configuration);
            testCase.verifyEqual(result.status, uint8(3));
            testCase.verifyTrue(any(result.reasonCodes == f.configuration.reasonCodes(12)));
        end

        function lowContrastImageRejects(testCase)
            f = testCase.Fixture;
            result = iiw.quality.validateInspectionData( ...
                f.inspectionData, f.inspectionMetadata, f.lowContrastImage, f.configuration);
            testCase.verifyEqual(result.status, uint8(3));
            testCase.verifyTrue(any(result.reasonCodes == f.configuration.reasonCodes(13)));
        end

        function blurredImageRejects(testCase)
            f = testCase.Fixture;
            result = iiw.quality.validateInspectionData( ...
                f.inspectionData, f.inspectionMetadata, f.blurredImage, f.configuration);
            testCase.verifyEqual(result.status, uint8(3));
            testCase.verifyTrue(any(result.reasonCodes == f.configuration.reasonCodes(14)));
        end

        function overexposedImageRejects(testCase)
            f = testCase.Fixture;
            result = iiw.quality.validateInspectionData( ...
                f.inspectionData, f.inspectionMetadata, f.overexposedImage, f.configuration);
            testCase.verifyEqual(result.status, uint8(3));
            testCase.verifyTrue(any(result.reasonCodes == f.configuration.reasonCodes(15)));
        end

        function repeatedExecutionIsDeterministic(testCase)
            f = testCase.Fixture;
            first = iiw.quality.validateInspectionData( ...
                f.inspectionData, f.inspectionMetadata, f.nominalImage, f.configuration);
            second = iiw.quality.validateInspectionData( ...
                f.inspectionData, f.inspectionMetadata, f.nominalImage, f.configuration);
            testCase.verifyEqual(second, first);
        end

        function resultMatchesApprovedSchema(testCase)
            f = testCase.Fixture;
            result = iiw.quality.validateInspectionData( ...
                f.inspectionData, f.inspectionMetadata, f.nominalImage, f.configuration);
            actualFields = string(fieldnames(result));
            expectedFields = ["itemId"; "status"; "measures"; "thresholdRefs"; ...
                "reasonCodes"; "validatorVersion"; "measureCount"; "reasonCodeCount"];
            testCase.verifyEqual(actualFields, expectedFields);
            testCase.verifyClass(result.itemId, "uint32");
            testCase.verifyClass(result.status, "uint8");
            testCase.verifyClass(result.measures, "single");
            testCase.verifySize(result.measures, [32 1]);
            testCase.verifyClass(result.thresholdRefs, "uint32");
            testCase.verifySize(result.thresholdRefs, [32 1]);
            testCase.verifyClass(result.reasonCodes, "uint8");
            testCase.verifySize(result.reasonCodes, [16 1]);
            testCase.verifyClass(result.validatorVersion, "uint16");
            testCase.verifyClass(result.measureCount, "uint8");
            testCase.verifyClass(result.reasonCodeCount, "uint8");
        end

        function implementationUsesNoProjectTerminology(testCase)
            repositoryRoot = fileparts(fileparts(fileparts(mfilename("fullpath"))));
            functionFile = fullfile(repositoryRoot, "extensions", ...
                "intelligent-inspection", "core", "+iiw", "+quality", ...
                "validateInspectionData.m");
            source = lower(string(fileread(functionFile)));
            prohibited = ["uav", "pipeline", "battery", "landing", ...
                "returntohome", "safelanding", "crack", "corrosion"];
            testCase.verifyFalse(any(contains(source, prohibited)));
        end
    end
end
