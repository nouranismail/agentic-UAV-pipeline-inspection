classdef test_deep_learning_detector < matlab.unittest.TestCase
    properties
        CorePath
        ModelPath
        DatasetRoot
    end
    methods (TestClassSetup)
        function setup(testCase)
            root = fileparts(fileparts(fileparts(mfilename("fullpath"))));
            testCase.CorePath = fullfile(root,"extensions","intelligent-inspection","core");
            testCase.ModelPath = fullfile(root,"extensions","intelligent-inspection","models","deep_learning_detector.mat");
            testCase.DatasetRoot = fullfile(getenv("IIW_DATASET_ROOT"),"KSDD2","extracted");
            testCase.applyFixture(matlab.unittest.fixtures.PathFixture(testCase.CorePath));
        end
    end
    methods (Test)
        function modelLoads(testCase)
            loaded=load(testCase.ModelPath,"modelArtifact");
            testCase.verifyClass(loaded.modelArtifact.network,"dlnetwork");
            testCase.verifyEqual(loaded.modelArtifact.datasetArchiveSha256, ...
                'EDCDB486809B24F1D17B785E30C52FAFC5999554DD5FE18DDF77B61CEB6F36A8');
        end
        function detectorContractCompatibility(testCase)
            detector=testCase.detector();
            testCase.verifyTrue(iiw.detection.DetectorContract.isConformingDetector(detector));
        end
        function exactResultSchema(testCase)
            [result,~]=testCase.execute(testCase.sample("test",true));
            testCase.verifyTrue(iiw.detection.DetectorContract.hasDetectionResultSchema(result));
        end
        function nominalAnomalyIsControlled(testCase)
            [result,status]=testCase.execute(testCase.sample("test",true));
            testCase.verifyTrue(any(status==uint8([0 1 2])));
            testCase.verifyTrue(iiw.detection.DetectorContract.isValidDetectionResult(result));
        end
        function normalInputIsControlled(testCase)
            [result,status]=testCase.execute(testCase.sample("test",false));
            testCase.verifyTrue(any(status==uint8([0 1 2])));
            testCase.verifyTrue(iiw.detection.DetectorContract.isValidDetectionResult(result));
        end
        function malformedInputIsRejected(testCase)
            [result,status]=iiw.detection.runDetector(testCase.processedData(),NaN, ...
                testCase.detector(),testCase.configuration(single(0.5)));
            testCase.verifyEqual(status,uint8(3));
            testCase.verifyEqual(result.labelId,uint8(255));
        end
        function lowConfidenceIsControlled(testCase)
            [result,status]=testCase.execute(testCase.sample("test",true),single(1));
            testCase.verifyTrue(any(status==uint8([1 2])));
            testCase.verifyEqual(result.labelId,uint8(0));
        end
        function inferenceIsDeterministic(testCase)
            image=testCase.sample("test",true);
            [first,firstStatus]=testCase.execute(image);
            [second,secondStatus]=testCase.execute(image);
            testCase.verifyEqual(second,first);
            testCase.verifyEqual(secondStatus,firstStatus);
        end
        function provenanceAndVersionArePresent(testCase)
            [result,~]=testCase.execute(testCase.sample("test",true));
            testCase.verifyEqual(result.modelVersion,uint16(2));
            testCase.verifyEqual(result.schemaVersion,uint16(1));
            testCase.verifyEqual(result.processedItemId,uint32(7001));
        end
        function correctiveConfigurationIsFrozen(testCase)
            loaded=load(testCase.ModelPath,"modelArtifact");
            configuration=loaded.modelArtifact.trainingConfiguration;
            testCase.verifyEqual(loaded.modelArtifact.inputSize,[192 72 3]);
            testCase.verifyEqual(configuration.thresholdGrid, ...
                single([0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75]));
            testCase.verifyEqual(configuration.officialTestExposureNumber,3);
            testCase.verifyFalse(configuration.fullyBlindEvaluation);
            testCase.verifyLessThanOrEqual(configuration.candidateCount,3);
        end
    end
    methods (Access=private)
        function detector=detector(~)
            detector=iiw.detection.DetectorContract.create( ...
                @iiw.detection.deepLearningDetector,uint32(701),uint16(2));
        end
        function data=processedData(~)
            data=struct("processedItemId",uint32(7001),"sourceItemId",uint32(7000), ...
                "representationRef",uint32(7100),"transformRecordRef",uint32(7200), ...
                "configurationVersion",uint16(1),"schemaVersion",uint16(1));
        end
        function config=configuration(~,minimumConfidence)
            config=struct("resultId",uint32(7300),"labelId",uint8(1), ...
                "resultSchemaVersion",uint16(1),"minimumConfidence",minimumConfidence, ...
                "detectionMode",uint8(1),"intensityThreshold",single(0.5), ...
                "minimumArea",uint32(1),"smoothingSigma",single(0), ...
                "emitLocation",false,"locationScale",ones(2,1), ...
                "locationOrigin",zeros(3,1),"frameId",uint16(0));
        end
        function [result,status]=execute(testCase,image,minimumConfidence)
            if nargin<3, minimumConfidence=single(0.5); end
            [result,status]=iiw.detection.runDetector(testCase.processedData(),image, ...
                testCase.detector(),testCase.configuration(minimumConfidence));
        end
        function image=sample(testCase,partition,positive)
            folder=fullfile(testCase.DatasetRoot,partition);
            masks=dir(fullfile(folder,"*_GT.png"));
            for index=1:numel(masks)
                mask=imread(fullfile(folder,masks(index).name));
                if any(mask(:)~=0)==positive
                    imageName=erase(masks(index).name,"_GT");
                    image=imread(fullfile(folder,imageName)); return
                end
            end
            error("Required sample not found.");
        end
    end
end
