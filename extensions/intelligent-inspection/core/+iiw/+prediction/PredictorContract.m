classdef PredictorContract
    %PREDICTORCONTRACT Base contract for replaceable numerical predictors.

    properties (SetAccess = immutable)
        ModelId
        ModelVersion
        SupportedFeatureSchemaVersions
        SupportedExtractorVersions
        SupportedFeatureIds
        ExecuteFunction
    end

    methods
        function obj = PredictorContract(modelId, modelVersion, ...
                schemaVersions, extractorVersions, featureIds, executeFunction)
            obj.ModelId = modelId;
            obj.ModelVersion = modelVersion;
            obj.SupportedFeatureSchemaVersions = schemaVersions;
            obj.SupportedExtractorVersions = extractorVersions;
            obj.SupportedFeatureIds = featureIds;
            obj.ExecuteFunction = executeFunction;
        end

        function output = execute(obj, featureSet)
            if ~isa(obj.ExecuteFunction, "function_handle")
                error("iiw:prediction:NotImplemented", ...
                    "A conforming predictor requires an execution function.");
            end
            output = obj.ExecuteFunction(featureSet);
        end
    end
end
