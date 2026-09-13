function result = train_pipeline_health_regression(datasetPath,modelPath)
%TRAIN_PIPELINE_HEALTH_REGRESSION Fit and evaluate the frozen ridge model once.

arguments
    datasetPath (1,1) string
    modelPath (1,1) string
end
loaded=load(datasetPath,"dataset"); dataset=loaded.dataset;
assert(dataset.testEvaluationCount==0,"iiw:pipeline:TestAlreadyEvaluated", ...
    "The synthetic test partition has already been evaluated.");
assert(string(dataset.generatorVersion)=="1.1","iiw:pipeline:GeneratorVersion", ...
    "Corrective training requires frozen generator version 1.1.");
assert(~any(dataset.features(:,3)==1 & dataset.features(:,1)==0), ...
    "iiw:pipeline:LocationInvariant", ...
    "Location availability requires detection presence.");
activeIds=uint16([101;102;103;(106:115).']);
[found,columns]=ismember(activeIds,dataset.featureIds);
assert(all(found) && all(dataset.validity(:,columns),"all"), ...
    "iiw:pipeline:InvalidTrainingData","Required predictors must be valid.");

trainMask=dataset.partition==1; validationMask=dataset.partition==2; testMask=dataset.partition==3;
X=double(dataset.features(:,columns)); y=double(dataset.targetHealth30Day);
trainingMeans=mean(X(trainMask,:),1);
trainingStandardDeviations=std(X(trainMask,:),0,1);
trainingStandardDeviations(trainingStandardDeviations==0)=1;
Ztrain=(X(trainMask,:)-trainingMeans)./trainingStandardDeviations;
lambda=0.1;
design=[ones(sum(trainMask),1) Ztrain];
penalty=diag([0 ones(1,size(Ztrain,2))]);
coefficients=(design.'*design+lambda*penalty)\(design.'*y(trainMask));

predict=@(values) min(max([ones(size(values,1),1) ...
    (values-trainingMeans)./trainingStandardDeviations]*coefficients,0),100);
trainPrediction=predict(X(trainMask,:));
validationPrediction=predict(X(validationMask,:));
validationMetrics=metrics(y(validationMask),validationPrediction);
validationRMSE=validationMetrics.rmse;
uncertainty=min(validationRMSE/100,1);

modelData=struct("modelId",uint32(9001001),"modelVersion",uint16(1), ...
    "featureSchemaVersion",uint16(1),"extractorVersion",uint16(1), ...
    "activeFeatureIds",activeIds,"lambda",lambda,"trainingMeans",trainingMeans, ...
    "trainingStandardDeviations",trainingStandardDeviations,"coefficients",coefficients, ...
    "validationRMSE",validationRMSE,"uncertainty",uncertainty, ...
    "contextId",uint32(9001),"generatorVersion",dataset.generatorVersion,"seed",dataset.seed);
trainingMetrics=metrics(y(trainMask),trainPrediction);
medianTarget=median(y(trainMask));
baselineValidation=metrics(y(validationMask),repmat(medianTarget,sum(validationMask),1));

% The configuration above is frozen before this single test-partition evaluation.
testPrediction=predict(X(testMask,:));
testMetrics=metrics(y(testMask),testPrediction);
dataset.testEvaluationCount=uint8(1);
save(datasetPath,"dataset","-v7.3");
evaluation=struct("training",trainingMetrics,"validation",validationMetrics, ...
    "test",testMetrics,"medianTarget",medianTarget, ...
    "baselineValidation",baselineValidation,"testEvaluationCount",uint8(1), ...
    "priorTestEvaluationCount",uint8(1),"totalTestEvaluationCount",uint8(2));
save(modelPath,"modelData","evaluation","-v7.3");
result=struct("modelData",modelData,"evaluation",evaluation);
end

function value=metrics(actual,predicted)
residual=actual-predicted;
value=struct("mae",mean(abs(residual)),"rmse",sqrt(mean(residual.^2)), ...
    "rSquared",1-sum(residual.^2)/sum((actual-mean(actual)).^2));
end
