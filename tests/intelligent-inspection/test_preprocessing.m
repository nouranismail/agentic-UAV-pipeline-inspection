classdef test_preprocessing < matlab.unittest.TestCase
    properties
        Fixture
        CorePath
    end

    methods (TestMethodSetup)
        function addCorePathAndCreateFixture(testCase)
            repositoryRoot = fileparts(fileparts(fileparts(mfilename("fullpath"))));
            testCase.CorePath = fullfile(repositoryRoot, "extensions", ...
                "intelligent-inspection", "core");
            addpath(testCase.CorePath);
            testCase.addTeardown(@() rmpath(testCase.CorePath));
            testCase.Fixture = test_preprocessing.createFixture();
        end
    end

    methods (Test)
        function passQualityInputIsProcessed(testCase)
            f = testCase.Fixture;
            [record, image, history] = runPreprocessor(f, f.qualityPass, f.configuration);
            testCase.verifyNotEmpty(image);
            testCase.verifyEqual(record.processedItemId, f.configuration.processedItemId);
            testCase.verifyEqual(numel(history), numel(f.configuration.operationOrder));
        end

        function rejectQualityInputIsNotProcessed(testCase)
            f = testCase.Fixture;
            [record, image, history] = runPreprocessor(f, f.qualityReject, f.configuration);
            verifyBypassed(testCase, record, image, history);
        end

        function reviewQualityInputIsNotProcessed(testCase)
            f = testCase.Fixture;
            quality = f.qualityPass;
            quality.status = uint8(2);
            [record, image, history] = runPreprocessor(f, quality, f.configuration);
            verifyBypassed(testCase, record, image, history);
        end

        function formatAndChannelNormalization(testCase)
            f = testCase.Fixture;
            configuration = f.configuration;
            configuration.operationOrder = uint8(1);
            configuration.targetChannels = uint8(3);
            [~, colorImage] = iiw.preprocessing.preprocessInspectionData( ...
                f.inspectionData, f.qualityPass, uint8(f.grayImage * 255), configuration);
            testCase.verifyClass(colorImage, "single");
            testCase.verifySize(colorImage, [12 16 3]);

            configuration.targetChannels = uint8(1);
            [~, grayImage] = iiw.preprocessing.preprocessInspectionData( ...
                f.inspectionData, f.qualityPass, f.colorImage, configuration);
            testCase.verifyClass(grayImage, "single");
            testCase.verifySize(grayImage, [12 16]);
        end

        function configuredResizeAndInterpolation(testCase)
            f = testCase.Fixture;
            configuration = f.configuration;
            configuration.operationOrder = uint8([1 2]);
            configuration.targetChannels = uint8(1);
            configuration.targetSize = uint32([7; 9]);
            configuration.interpolationMethod = uint8(1);
            [~, nearestImage] = runPreprocessor(f, f.qualityPass, configuration);
            configuration.interpolationMethod = uint8(2);
            [~, bilinearImage, history] = runPreprocessor(f, f.qualityPass, configuration);
            testCase.verifySize(nearestImage, [7 9]);
            testCase.verifySize(bilinearImage, [7 9]);
            testCase.verifyNotEqual(nearestImage, bilinearImage);
            testCase.verifyEqual(history(2).parameterValues(3), single(2));
        end

        function intensityNormalization(testCase)
            f = testCase.Fixture;
            configuration = f.configuration;
            configuration.operationOrder = uint8([1 3]);
            configuration.targetChannels = uint8(1);
            configuration.intensityInputRange = single([0.2; 0.8]);
            input = single([0.2 0.5 0.8]);
            [~, output] = iiw.preprocessing.preprocessInspectionData( ...
                f.inspectionData, f.qualityPass, input, configuration);
            testCase.verifyEqual(output, single([0 0.5 1]), AbsTol=single(1e-6));
        end

        function denoisingEnabledAndDisabled(testCase)
            f = testCase.Fixture;
            input = zeros(9, 9, "single");
            input(5, 5) = 1;
            disabled = f.configuration;
            disabled.operationOrder = uint8(1);
            disabled.targetChannels = uint8(1);
            enabled = disabled;
            enabled.operationOrder = uint8([1 4]);
            enabled.denoiseSigma = single(1);
            enabled.denoiseFilterSize = uint8(5);
            [~, unchanged] = iiw.preprocessing.preprocessInspectionData( ...
                f.inspectionData, f.qualityPass, input, disabled);
            [~, filtered] = iiw.preprocessing.preprocessInspectionData( ...
                f.inspectionData, f.qualityPass, input, enabled);
            testCase.verifyEqual(unchanged, input);
            testCase.verifyLessThan(filtered(5, 5), unchanged(5, 5));
        end

        function contrastAdjustmentEnabledAndDisabled(testCase)
            f = testCase.Fixture;
            input = single([0.2 0.4 0.6 0.8]);
            disabled = f.configuration;
            disabled.operationOrder = uint8(1);
            disabled.targetChannels = uint8(1);
            enabled = disabled;
            enabled.operationOrder = uint8([1 5]);
            enabled.contrastInputRange = single([0.1; 0.9]);
            enabled.contrastGamma = single(0.5);
            [~, unchanged] = iiw.preprocessing.preprocessInspectionData( ...
                f.inspectionData, f.qualityPass, input, disabled);
            [~, adjusted] = iiw.preprocessing.preprocessInspectionData( ...
                f.inspectionData, f.qualityPass, input, enabled);
            testCase.verifyEqual(unchanged, input);
            testCase.verifyNotEqual(adjusted, unchanged);
        end

        function configuredOperationOrderIsPreserved(testCase)
            f = testCase.Fixture;
            configuration = f.configuration;
            configuration.operationOrder = uint8([1 5 3 2 4]);
            [~, ~, history] = runPreprocessor(f, f.qualityPass, configuration);
            testCase.verifyEqual(vertcat(history.operationCode), ...
                configuration.operationOrder(:));
            testCase.verifyEqual(vertcat(history.order), uint8((1:5).'));
        end

        function transformationProvenanceIsRecorded(testCase)
            f = testCase.Fixture;
            [record, ~, history] = runPreprocessor(f, f.qualityPass, f.configuration);
            testCase.verifyEqual(record.sourceItemId, f.inspectionData.itemId);
            testCase.verifyEqual(record.transformRecordRef, ...
                f.configuration.transformRecordRef);
            testCase.verifyEqual(history(1).inputReference, f.inspectionData.payloadRef);
            testCase.verifyEqual(history(end).outputReference, ...
                f.configuration.representationRef);
            testCase.verifyTrue(all(vertcat(history.parameterCount) > 0));
            testCase.verifyTrue(all(vertcat(history.implementationVersion) == ...
                f.configuration.implementationVersion));
            testCase.verifyEqual(vertcat(history(2:end).inputReference), ...
                vertcat(history(1:end-1).outputReference));
        end

        function inputImageRemainsUnchanged(testCase)
            f = testCase.Fixture;
            original = f.colorImage;
            runPreprocessor(f, f.qualityPass, f.configuration);
            testCase.verifyEqual(f.colorImage, original);
        end

        function processedDataMatchesApprovedSchema(testCase)
            f = testCase.Fixture;
            [record] = runPreprocessor(f, f.qualityPass, f.configuration);
            expected = ["processedItemId"; "sourceItemId"; "representationRef"; ...
                "transformRecordRef"; "configurationVersion"; "schemaVersion"];
            testCase.verifyEqual(string(fieldnames(record)), expected);
            testCase.verifyClass(record.processedItemId, "uint32");
            testCase.verifyClass(record.sourceItemId, "uint32");
            testCase.verifyClass(record.representationRef, "uint32");
            testCase.verifyClass(record.transformRecordRef, "uint32");
            testCase.verifyClass(record.configurationVersion, "uint16");
            testCase.verifyClass(record.schemaVersion, "uint16");
        end

        function repeatedExecutionIsDeterministic(testCase)
            f = testCase.Fixture;
            [firstRecord, firstImage, firstHistory] = ...
                runPreprocessor(f, f.qualityPass, f.configuration);
            [secondRecord, secondImage, secondHistory] = ...
                runPreprocessor(f, f.qualityPass, f.configuration);
            testCase.verifyEqual(secondRecord, firstRecord);
            testCase.verifyEqual(secondImage, firstImage);
            testCase.verifyEqual(secondHistory, firstHistory);
        end

        function invalidConfigurationIsHandled(testCase)
            f = testCase.Fixture;
            configuration = f.configuration;
            configuration.operationOrder = uint8([2 1]);
            [record, image, history] = runPreprocessor(f, f.qualityPass, configuration);
            verifyBypassed(testCase, record, image, history);
        end

        function implementationUsesNoProhibitedTerminology(testCase)
            repositoryRoot = fileparts(fileparts(fileparts(mfilename("fullpath"))));
            folder = fullfile(repositoryRoot, "extensions", ...
                "intelligent-inspection", "core", "+iiw", "+preprocessing");
            content = lower(string(fileread(fullfile(folder, ...
                "preprocessInspectionData.m"))) + newline + ...
                string(fileread(fullfile(folder, "recordTransform.m"))));
            prohibited = ["uav", "pipeline", "damage", "defect", "battery", ...
                "landing", "returntohome", "safelanding"];
            for index = 1:numel(prohibited)
                testCase.verifyFalse(contains(content, prohibited(index)));
            end
        end

        function rejectedDataCannotBeRepaired(testCase)
            f = testCase.Fixture;
            configuration = f.configuration;
            configuration.operationOrder = uint8([1 3 5]);
            rejectedImage = zeros(12, 16, "single");
            [record, image, history] = iiw.preprocessing.preprocessInspectionData( ...
                f.inspectionData, f.qualityReject, rejectedImage, configuration);
            verifyBypassed(testCase, record, image, history);
        end
    end

    methods (Static, Access = private)
        function fixture = createFixture()
            fixture.inspectionData = struct( ...
                "itemId", uint32(101), ...
                "payloadRef", uint32(201), ...
                "modality", uint8(1), ...
                "sourceId", uint32(301), ...
                "sequenceId", uint32(401), ...
                "timestamp", uint64(1000), ...
                "schemaVersion", uint16(1));

            fixture.qualityPass = qualityResult(fixture.inspectionData.itemId, uint8(1));
            fixture.qualityReject = qualityResult(fixture.inspectionData.itemId, uint8(3));

            fixture.grayImage = reshape(single(linspace(0.05, 0.95, 12 * 16)), 12, 16);
            fixture.colorImage = cat(3, fixture.grayImage, ...
                flip(fixture.grayImage, 2), sqrt(fixture.grayImage));

            fixture.configuration = struct( ...
                "processedItemId", uint32(501), ...
                "representationRef", uint32(601), ...
                "transformRecordRef", uint32(701), ...
                "configurationVersion", uint16(2), ...
                "schemaVersion", uint16(1), ...
                "implementationVersion", uint16(1), ...
                "intermediateReferenceBase", uint32(800), ...
                "operationOrder", uint8([1 2 3 4 5]), ...
                "targetChannels", uint8(1), ...
                "targetSize", uint32([10; 14]), ...
                "interpolationMethod", uint8(2), ...
                "intensityInputRange", single([0; 1]), ...
                "intensityOutputRange", single([0; 1]), ...
                "denoiseSigma", single(0.5), ...
                "denoiseFilterSize", uint8(3), ...
                "contrastInputRange", single([0.1; 0.9]), ...
                "contrastOutputRange", single([0; 1]), ...
                "contrastGamma", single(1));
        end
    end
end

function [record, image, history] = runPreprocessor(fixture, quality, configuration)
[record, image, history] = iiw.preprocessing.preprocessInspectionData( ...
    fixture.inspectionData, quality, fixture.colorImage, configuration);
end

function verifyBypassed(testCase, record, image, history)
testCase.verifyEmpty(image);
testCase.verifyEmpty(history);
testCase.verifyEqual(record.processedItemId, uint32(0));
testCase.verifyEqual(record.sourceItemId, uint32(0));
end

function result = qualityResult(itemId, status)
result = struct( ...
    "itemId", itemId, ...
    "status", status, ...
    "measures", zeros(32, 1, "single"), ...
    "thresholdRefs", zeros(32, 1, "uint32"), ...
    "reasonCodes", zeros(16, 1, "uint8"), ...
    "validatorVersion", uint16(1), ...
    "measureCount", uint8(0), ...
    "reasonCodeCount", uint8(0));
end
