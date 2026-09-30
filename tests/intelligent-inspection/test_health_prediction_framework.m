classdef test_health_prediction_framework < matlab.unittest.TestCase
    properties, Fixture, end

    methods (TestClassSetup)
        function addCorePath(testCase)
            testFolder = fileparts(mfilename("fullpath"));
            root = fileparts(fileparts(testFolder));
            testCase.applyFixture(matlab.unittest.fixtures.PathFixture( ...
                fullfile(root,"extensions","intelligent-inspection","core")));
        end
    end

    methods (TestMethodSetup)
        function loadFixture(testCase)
            data = load(fullfile(fileparts(mfilename("fullpath")),"fixtures", ...
                "health_prediction_contract_fixtures.mat"));
            testCase.Fixture = data.fixture;
        end
    end

    methods (Test)
        function nominalPrediction(t)
            r = runPrediction(t, makePredictor(1,@(~) raw(72,.1,false)));
            t.verifyTrue(iiw.prediction.validateHealthPrediction(r));
            t.verifyEqual(r.estimate,single(72)); t.verifyEqual(r.confidenceStatus,uint8(1));
        end
        function exactSchema(t)
            r=runPrediction(t,makePredictor(1,@(~) raw(72,.1,false)));
            expected=["predictionId";"featureSetId";"estimate";"contextOrHorizon"; ...
                "uncertainty";"confidenceStatus";"modelVersion";"schemaVersion"; ...
                "estimateValid";"contextOrHorizonValid";"uncertaintyValid"];
            t.verifyEqual(string(fieldnames(r)),expected);
        end
        function healthBoundaries(t)
            a=runPrediction(t,makePredictor(1,@(~) raw(0,0,false)));
            b=runPrediction(t,makePredictor(1,@(~) raw(100,1,false)));
            t.verifyEqual([a.estimate b.estimate],single([0 100]));
        end
        function outsideRangeIsBounded(t)
            a=runPrediction(t,makePredictor(1,@(~) raw(-5,.1,false)));
            b=runPrediction(t,makePredictor(1,@(~) raw(105,.1,false)));
            t.verifyEqual([a.estimate b.estimate],single([0 100]));
        end
        function predictorReplacement(t)
            a=runPrediction(t,makePredictor(1,@(~) raw(72,.1,false)));
            b=runPrediction(t,makePredictor(2,@(~) raw(55,.2,false)));
            t.verifyEqual([a.estimate b.estimate],single([72 55]));
            t.verifyEqual(b.modelVersion,uint16(2));
        end
        function invalidFeatureSet(t)
            x=t.Fixture.featureSet; x.featureValues(1)=single(NaN);
            verifyInvalid(t,iiw.prediction.predictHealth(x,makePredictor(1,@(~) raw(72,.1,false)),t.Fixture.configuration));
        end
        function unsupportedSchemaCatalogExtractor(t)
            x=t.Fixture.featureSet; x.schemaVersion=uint16(2);
            verifyInvalid(t,iiw.prediction.predictHealth(x,makePredictor(1,@(~) raw(72,.1,false)),t.Fixture.configuration));
            x=t.Fixture.featureSet; x.featureIds(1)=uint16(99);
            verifyInvalid(t,iiw.prediction.predictHealth(x,makePredictor(1,@(~) raw(72,.1,false)),t.Fixture.configuration));
            x=t.Fixture.featureSet; x.extractorVersion=uint16(2);
            verifyInvalid(t,iiw.prediction.predictHealth(x,makePredictor(1,@(~) raw(72,.1,false)),t.Fixture.configuration));
        end
        function missingIncompatiblePredictor(t)
            verifyInvalid(t,iiw.prediction.predictHealth(t.Fixture.featureSet,[],t.Fixture.configuration));
            verifyInvalid(t,iiw.prediction.predictHealth(t.Fixture.featureSet,struct,t.Fixture.configuration));
        end
        function executionFailure(t)
            verifyInvalid(t,runPrediction(t,makePredictor(1,@(~) failExecution)));
        end
        function invalidOutput(t)
            verifyInvalid(t,runPrediction(t,makePredictor(1,@(~) struct("estimate",single(1)))));
        end
        function invalidUncertainty(t)
            verifyInvalid(t,runPrediction(t,makePredictor(1,@(~) raw(72,NaN,false))));
        end
        function unsupportedModelVersion(t)
            verifyInvalid(t,runPrediction(t,makePredictor(3,@(~) raw(72,.1,false))));
        end
        function outOfDistribution(t)
            r=runPrediction(t,makePredictor(1,@(~) raw(50,.2,true)));
            t.verifyTrue(iiw.prediction.validateHealthPrediction(r));
            t.verifyFalse(r.estimateValid); t.verifyEqual(r.confidenceStatus,uint8(2));
        end
        function deterministicRepetition(t)
            p=makePredictor(1,@(~) raw(72,.1,false));
            t.verifyEqual(runPrediction(t,p),runPrediction(t,p));
        end
        function featureReferenceHandling(t)
            r=runPrediction(t,makePredictor(1,@(~) raw(72,.1,false)));
            t.verifyEqual(r.featureSetId,t.Fixture.featureSet.featureSetId);
            x=t.Fixture.featureSet; x.featureSetId=uint32(0);
            verifyInvalid(t,iiw.prediction.predictHealth(x,makePredictor(1,@(~) raw(72,.1,false)),t.Fixture.configuration));
        end
        function prohibitedTerminologyAbsent(t)
            folder=fileparts(which("iiw.prediction.predictHealth"));
            content=lower(string(fileread(fullfile(folder,"PredictorContract.m")))+newline+ ...
                string(fileread(fullfile(folder,"predictHealth.m")))+newline+ ...
                string(fileread(fullfile(folder,"validateHealthPrediction.m"))));
            words=["u"+"av","pipe"+"line","g"+"as","pres"+"sure", ...
                "temper"+"ature","mo"+"tor","data"+"set"];
            t.verifyFalse(any(contains(content,words)));
        end
    end
end

function p=makePredictor(version,fcn)
p=iiw.prediction.PredictorContract(uint32(10),uint16(version),uint16(1), ...
    uint16(1),uint16((1:6).'),fcn);
end
function r=runPrediction(t,p), r=iiw.prediction.predictHealth(t.Fixture.featureSet,p,t.Fixture.configuration); end
function verifyInvalid(t,r)
t.verifyTrue(iiw.prediction.validateHealthPrediction(r));
t.verifyFalse(r.estimateValid); t.verifyEqual(r.confidenceStatus,uint8(4));
t.verifyEqual(r.predictionId,uint32(0)); t.verifyEqual(r.featureSetId,uint32(0));
end
function value=raw(estimate,uncertainty,ood)
value=struct("estimate",single(estimate),"uncertainty",single(uncertainty), ...
    "outOfDistribution",logical(ood));
end
function value=failExecution
error("iiw:test:ExpectedFailure","Expected test-double failure."); %#ok<NASGU>
end
