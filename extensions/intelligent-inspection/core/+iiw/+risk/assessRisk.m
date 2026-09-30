function result = assessRisk(prediction,evidence,policy)
%ASSESSRISK Apply the approved deterministic advisory risk policy.

result = fallback(uint8(10),policyVersionOrZero(policy));
try
    if ~iiw.risk.validateRiskPolicy(policy)
        result = fallback(uint8(16),policyVersionOrZero(policy));
        return
    end
    if ~validEvidenceEnvelope(evidence)
        return
    end
    result.assessmentId = evidence.assessmentId;
    result.evidenceRefs = evidence.evidenceRefs;
    result.referenceCount = evidence.referenceCount;
    result.policyVersion = policy.policyVersion;
    if evidence.internalAssessmentFailure
        result = preserveEvidence(result,fallback(uint8(17),policy.policyVersion));
        return
    end
    [validPrediction,unsupportedStatus] = validatePrediction(prediction);
    if ~validPrediction
        code = uint8(10);
        if unsupportedStatus, code = uint8(15); end
        result = preserveEvidence(result,fallback(code,policy.policyVersion));
        return
    end
    if evidence.referenceCount == 0 || prediction.featureSetId == 0
        result = preserveEvidence(result,fallback(uint8(11),policy.policyVersion));
        return
    end
    if evidence.qualitySupplied && ~evidence.qualityAccepted
        result = preserveEvidence(result,fallback(uint8(12),policy.policyVersion));
        return
    end
    if evidence.detectionSupplied && (~evidence.detectionConfidenceValid || ...
            ~isfinite(evidence.detectionConfidence) || ...
            evidence.detectionConfidence < 0 || evidence.detectionConfidence > 1)
        result = preserveEvidence(result,fallback(uint8(11),policy.policyVersion));
        return
    end
    confidence = single(1) - prediction.uncertainty;
    if prediction.uncertainty > policy.maximumUncertainty || ...
            confidence < policy.minimumConfidence
        result = preserveEvidence(result,fallback([uint8(14);uint8(13)],policy.policyVersion));
        result.confidenceStatus = uint8(2);
        return
    end
    result.confidenceStatus = uint8(1);
    if prediction.estimate < policy.mediumHealthThreshold
        result.riskLevel=uint8(3); result.rationaleCodes(1)=uint8(3);
    elseif prediction.estimate < policy.lowHealthThreshold
        result.riskLevel=uint8(2); result.rationaleCodes(1)=uint8(2);
    else
        result.riskLevel=uint8(1); result.rationaleCodes(1)=uint8(1);
    end
    result.rationaleCount=uint8(1);
catch
    result = preserveEvidence(result,fallback(uint8(17),policyVersionOrZero(policy)));
end
end

function [valid,unsupported] = validatePrediction(p)
required=["predictionId";"featureSetId";"estimate";"contextOrHorizon"; ...
    "uncertainty";"confidenceStatus";"modelVersion";"schemaVersion"; ...
    "estimateValid";"contextOrHorizonValid";"uncertaintyValid"];
unsupported=false;
valid=isstruct(p)&&isscalar(p)&&isequal(string(fieldnames(p)),required);
if ~valid, return, end
types=isa(p.predictionId,"uint32")&&isscalar(p.predictionId)&& ...
    isa(p.featureSetId,"uint32")&&isscalar(p.featureSetId)&& ...
    isa(p.estimate,"single")&&isscalar(p.estimate)&& ...
    isa(p.contextOrHorizon,"uint32")&&isscalar(p.contextOrHorizon)&& ...
    isa(p.uncertainty,"single")&&isscalar(p.uncertainty)&& ...
    isa(p.confidenceStatus,"uint8")&&isscalar(p.confidenceStatus)&& ...
    isa(p.modelVersion,"uint16")&&isscalar(p.modelVersion)&& ...
    isa(p.schemaVersion,"uint16")&&isscalar(p.schemaVersion)&& ...
    islogical(p.estimateValid)&&isscalar(p.estimateValid)&& ...
    islogical(p.contextOrHorizonValid)&&isscalar(p.contextOrHorizonValid)&& ...
    islogical(p.uncertaintyValid)&&isscalar(p.uncertaintyValid);
if ~types, valid=false; return, end
unsupported=~ismember(p.confidenceStatus,uint8([1 2]));
valid=~unsupported && p.predictionId~=0 && p.featureSetId~=0 && ...
    p.modelVersion~=0 && p.schemaVersion==1 && p.estimateValid && ...
    p.contextOrHorizonValid && p.contextOrHorizon~=0 && p.uncertaintyValid && ...
    isfinite(p.estimate) && p.estimate>=0 && p.estimate<=100 && ...
    isfinite(p.uncertainty) && p.uncertainty>=0 && p.uncertainty<=1;
end

function valid=validEvidenceEnvelope(e)
required=["assessmentId";"evidenceRefs";"referenceCount"; ...
    "qualitySupplied";"qualityAccepted";"detectionSupplied"; ...
    "detectionConfidence";"detectionConfidenceValid";"internalAssessmentFailure"];
valid=isstruct(e)&&isscalar(e)&&isequal(string(fieldnames(e)),required)&& ...
    isa(e.assessmentId,"uint32")&&isscalar(e.assessmentId)&&e.assessmentId~=0&& ...
    isa(e.evidenceRefs,"uint32")&&isequal(size(e.evidenceRefs),[16 1])&& ...
    isa(e.referenceCount,"uint8")&&isscalar(e.referenceCount)&&e.referenceCount<=16&& ...
    all(e.evidenceRefs(1:double(e.referenceCount))~=0)&& ...
    all(e.evidenceRefs(double(e.referenceCount)+1:end)==0)&& ...
    islogical(e.qualitySupplied)&&isscalar(e.qualitySupplied)&& ...
    islogical(e.qualityAccepted)&&isscalar(e.qualityAccepted)&& ...
    islogical(e.detectionSupplied)&&isscalar(e.detectionSupplied)&& ...
    isa(e.detectionConfidence,"single")&&isscalar(e.detectionConfidence)&& ...
    islogical(e.detectionConfidenceValid)&&isscalar(e.detectionConfidenceValid)&& ...
    islogical(e.internalAssessmentFailure)&&isscalar(e.internalAssessmentFailure);
end

function r=fallback(codes,version)
r=struct("assessmentId",uint32(0),"evidenceRefs",zeros(16,1,"uint32"), ...
    "riskLevel",uint8(4),"riskScore",single(0),"confidenceStatus",uint8(4), ...
    "rationaleCodes",zeros(16,1,"uint8"),"policyVersion",uint16(version), ...
    "referenceCount",uint8(0),"riskScoreValid",false,"rationaleCount",uint8(numel(codes)));
r.rationaleCodes(1:numel(codes))=codes;
end

function out=preserveEvidence(existing,replacement)
out=replacement; out.assessmentId=existing.assessmentId;
out.evidenceRefs=existing.evidenceRefs; out.referenceCount=existing.referenceCount;
end

function v=policyVersionOrZero(p)
v=uint16(0); if isstruct(p)&&isscalar(p)&&isfield(p,"policyVersion")&& ...
        isa(p.policyVersion,"uint16")&&isscalar(p.policyVersion), v=p.policyVersion; end
end
