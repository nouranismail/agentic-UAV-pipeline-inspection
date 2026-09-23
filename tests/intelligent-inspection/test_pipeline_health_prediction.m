classdef test_pipeline_health_prediction < matlab.unittest.TestCase
    properties
        Root
        Dataset
        Model
        Evaluation
    end

    methods (TestClassSetup)
        function setup(testCase)
            folder=fileparts(mfilename("fullpath"));
            testCase.Root=fileparts(fileparts(folder));
            testCase.applyFixture(matlab.unittest.fixtures.PathFixture( ...
                fullfile(testCase.Root,"extensions","intelligent-inspection","core")));
            testCase.applyFixture(matlab.unittest.fixtures.PathFixture( ...
                fullfile(testCase.Root,"extensions","intelligent-inspection", ...
                "configurations","uav-pipeline")));
            data=load(fullfile(testCase.Root,"extensions","intelligent-inspection", ...
                "datasets","generated","pipeline_degradation_synthetic.mat"),"dataset");
            model=load(fullfile(testCase.Root,"extensions","intelligent-inspection", ...
                "models","pipeline_health_regression.mat"),"modelData","evaluation");
            testCase.Dataset=data.dataset; testCase.Model=model.modelData;
            testCase.Evaluation=model.evaluation;
        end
    end

    methods (Test)
        function exactDatasetCounts(t)
            t.verifyEqual(size(t.Dataset.features),[600 15]);
            t.verifyEqual([sum(t.Dataset.partition==1) sum(t.Dataset.partition==2) ...
                sum(t.Dataset.partition==3)],[420 90 90]);
            t.verifyEqual(numel(unique(t.Dataset.groupIds)),100);
        end

        function groupSafeSplit(t)
            a=unique(t.Dataset.groupIds(t.Dataset.partition==1));
            b=unique(t.Dataset.groupIds(t.Dataset.partition==2));
            c=unique(t.Dataset.groupIds(t.Dataset.partition==3));
            t.verifyEqual([numel(a) numel(b) numel(c)],[70 15 15]);
            t.verifyEmpty(intersect(a,b)); t.verifyEmpty(intersect(a,c));
            t.verifyEmpty(intersect(b,c));
        end

        function chronologicalObservations(t)
            ids=unique(t.Dataset.groupIds);
            for k=1:numel(ids)
                rows=t.Dataset.groupIds==ids(k);
                t.verifyEqual(double(t.Dataset.observationDays(rows)).',[0 30 60 90 120 150]);
            end
        end

        function frozenConfiguration(t)
            t.verifyEqual(t.Dataset.seed,uint32(20260910));
            t.verifyEqual(string(t.Dataset.generatorVersion),"1.1");
            t.verifyEqual(t.Model.lambda,0.1,"AbsTol",0);
            t.verifyEqual(t.Model.contextId,uint32(9001));
            t.verifyEqual(t.Evaluation.testEvaluationCount,uint8(1));
            t.verifyEqual(t.Evaluation.priorTestEvaluationCount,uint8(1));
            t.verifyEqual(t.Evaluation.totalTestEvaluationCount,uint8(2));
            t.verifyEqual(sum(t.Dataset.features(:,3)==1 & ...
                t.Dataset.features(:,1)==0),0);
        end

        function activeFeaturesExcludeCoordinates(t)
            expected=uint16([101;102;103;(106:115).']);
            t.verifyEqual(t.Model.activeFeatureIds,expected);
            t.verifyFalse(any(ismember(uint16([104 105]),t.Model.activeFeatureIds)));
        end

        function trainingOnlyStandardization(t)
            [~,columns]=ismember(t.Model.activeFeatureIds,t.Dataset.featureIds);
            values=double(t.Dataset.features(t.Dataset.partition==1,columns));
            expectedMean=mean(values,1); expectedStd=std(values,0,1);
            expectedStd(expectedStd==0)=1;
            t.verifyEqual(t.Model.trainingMeans,expectedMean,"AbsTol",1e-12);
            t.verifyEqual(t.Model.trainingStandardDeviations,expectedStd,"AbsTol",1e-12);
            t.verifyGreaterThan(t.Model.trainingStandardDeviations,zeros(1,13));
        end

        function uncertaintyUsesValidationRMSE(t)
            t.verifyEqual(t.Model.validationRMSE,t.Evaluation.validation.rmse,"AbsTol",1e-12);
            t.verifyEqual(t.Model.uncertainty,min(t.Model.validationRMSE/100,1),"AbsTol",1e-12);
        end

        function adapterProducesApprovedSchema(t)
            featureSet=makeFeatureSet(t);
            expected=["featureSetId";"sourceRefs";"unitDeclarations";"validity"; ...
                "extractorVersion";"schemaVersion";"featureIds";"featureValues"; ...
                "featureCount";"referenceCount"];
            t.verifyEqual(string(fieldnames(featureSet)),expected);
            t.verifyEqual(featureSet.featureIds(1:15),uint16((101:115).'));
        end

        function predictorContractAndHealthSchema(t)
            featureSet=makeFeatureSet(t);
            predictor=makePredictor(t.Model);
            result=iiw.prediction.predictHealth(featureSet,predictor,predictionConfiguration(t.Model));
            t.verifyTrue(iiw.prediction.validateHealthPrediction(result));
            t.verifyTrue(result.estimateValid); t.verifyGreaterThanOrEqual(result.estimate,single(0));
            t.verifyLessThanOrEqual(result.estimate,single(100));
        end

        function deterministicPrediction(t)
            featureSet=makeFeatureSet(t); predictor=makePredictor(t.Model);
            configuration=predictionConfiguration(t.Model);
            a=iiw.prediction.predictHealth(featureSet,predictor,configuration);
            b=iiw.prediction.predictHealth(featureSet,predictor,configuration);
            t.verifyEqual(a,b);
        end

        function invalidFeatureReturnsControlledReview(t)
            featureSet=makeFeatureSet(t); featureSet.validity(6)=false;
            featureSet.featureValues(6)=single(0);
            result=iiw.prediction.predictHealth(featureSet,makePredictor(t.Model), ...
                predictionConfiguration(t.Model));
            t.verifyTrue(iiw.prediction.validateHealthPrediction(result));
            t.verifyFalse(result.estimateValid); t.verifyEqual(result.confidenceStatus,uint8(2));
        end

        function lockedMetrics(t)
            t.verifyLessThanOrEqual(t.Evaluation.test.mae,8.0);
            t.verifyLessThanOrEqual(t.Evaluation.test.rmse,12.0);
            t.verifyGreaterThanOrEqual(t.Evaluation.test.rSquared,0.65);
        end

        function noInterfaceViolationsOrFailures(t)
            featureSet=makeFeatureSet(t);
            t.verifyEqual(featureSet.featureCount,uint8(15));
            t.verifyTrue(iiw.prediction.validateHealthPrediction( ...
                iiw.prediction.predictHealth(featureSet,makePredictor(t.Model), ...
                predictionConfiguration(t.Model))));
        end

        function disclaimerAndRestrictions(t)
            required="Integration and workflow demonstration only; not evidence of real pipeline prognostic accuracy or production readiness.";
            files=[fullfile(t.Root,"extensions","intelligent-inspection","model_cards","pipeline_health_regression.md"); ...
                fullfile(t.Root,"extensions","intelligent-inspection","evidence","pipeline_health_prediction_results.md"); ...
                fullfile(t.Root,"extensions","intelligent-inspection","datasets","pipeline_degradation_dataset_manifest.yaml")];
            for k=1:numel(files), t.verifyTrue(contains(string(fileread(files(k))),required)); end
            code=string(fileread(fullfile(t.Root,"extensions","intelligent-inspection", ...
                "training","train_pipeline_health_regression.m")));
            prohibited=["fitrensemble","fitrtree","RegressionLearner","conformal"];
            t.verifyFalse(any(contains(lower(code),lower(prohibited))));
        end
    end
end

function featureSet=makeFeatureSet(t)
row=find(t.Dataset.partition==2,1);
detection=struct("featureSetId",uint32(7001),"sourceRefs",zeros(16,1,"uint32"), ...
    "unitDeclarations",zeros(32,1,"uint16"),"validity",false(32,1), ...
    "extractorVersion",uint16(1),"schemaVersion",uint16(1), ...
    "featureIds",zeros(32,1,"uint16"),"featureValues",zeros(32,1,"single"), ...
    "featureCount",uint8(6),"referenceCount",uint8(1));
detection.sourceRefs(1)=uint32(6001); detection.unitDeclarations(1:6)=uint16([1;1;1;2;2;2]);
detection.validity(1:3)=true; detection.featureIds(1:6)=uint16((1:6).');
detection.featureValues(1:5)=t.Dataset.features(row,1:5).';
detection.validity(4:6)=logical(detection.featureValues(3));
config=struct("featureSetId",uint32(8001),"projectSourceRef",uint32(8002));
featureSet=PipelineFeatureAdapter.adapt(detection,t.Dataset.features(row,6:15).', ...
    t.Dataset.validity(row,6:15).',config);
end
function predictor=makePredictor(model)
predictor=iiw.prediction.PredictorContract(model.modelId,model.modelVersion, ...
    model.featureSchemaVersion,model.extractorVersion,uint16((101:115).'), ...
    @(features) PipelineFeatureAdapter.execute(features,model));
end
function value=predictionConfiguration(model)
value=struct("predictionId",uint32(9101),"contextOrHorizon",model.contextId, ...
    "schemaVersion",uint16(1),"maximumUncertainty",single(1), ...
    "allowedModelVersions",model.modelVersion);
end
