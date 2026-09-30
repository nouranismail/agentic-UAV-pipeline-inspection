function [action,boundary] = recommendation_adapter(quality,detection,risk,approval,configuration)
%RECOMMENDATION_ADAPTER Produce only a controlled advisory boundary record.

[action,boundary] = emptyOutputs();
try
    if ~validConfiguration(configuration) || ~validQuality(quality), return, end
    action.recommendationId = configuration.recommendationId;
    action.validFrom = configuration.validFrom;
    action.validUntil = configuration.validUntil;
    action.configurationVersion = configuration.configurationVersion;
    if quality.status ~= uint8(1)
        action.actionCode = uint8(4); boundary.statusCode = uint8(2); return
    end
    if ~validDetection(detection,configuration)
        action.actionCode = uint8(1); boundary.statusCode = uint8(3); return
    end
    if ~validRisk(risk)
        action.actionCode = uint8(1); boundary.statusCode = uint8(4); return
    end
    action.actionCode = mapRisk(risk.riskLevel);
    action.evidenceRefs = risk.evidenceRefs;
    action.referenceCount = risk.referenceCount;
    action.confidenceStatus = risk.confidenceStatus;
    action.approvalStatus = approvalState(approval);
    boundary.statusCode = uint8(1);
    boundary.controlled = true;
    boundary.humanApprovalRequired = action.actionCode ~= 0;
    boundary.forwardingEligible = boundary.humanApprovalRequired && ...
        validApproval(approval,action.recommendationId);
catch
    [action,boundary] = emptyOutputs();
end
end

function code = mapRisk(level)
switch level
    case uint8(1), code=uint8(0);
    case uint8(2), code=uint8(2);
    case uint8(3), code=uint8(3);
    otherwise, code=uint8(1);
end
end

function valid = validConfiguration(v)
r=["configurationVersion";"recommendationId";"validFrom";"validUntil"; ...
    "detectionSchemaVersion";"minimumConfidence"];
valid=isstruct(v)&&isscalar(v)&&all(isfield(v,r))&&scalar(v.configurationVersion,"uint16",true)&& ...
    scalar(v.recommendationId,"uint32",true)&&scalar(v.validFrom,"uint64",true)&& ...
    scalar(v.validUntil,"uint64",true)&&v.validUntil>v.validFrom&& ...
    scalar(v.detectionSchemaVersion,"uint16",true)&&isa(v.minimumConfidence,"single")&& ...
    isscalar(v.minimumConfidence)&&isfinite(v.minimumConfidence)&&v.minimumConfidence>=0&&v.minimumConfidence<=1;
end

function valid = validQuality(v)
r=["itemId";"status";"validatorVersion"];
valid=isstruct(v)&&isscalar(v)&&all(isfield(v,r))&&scalar(v.itemId,"uint32",true)&& ...
    scalar(v.status,"uint8",true)&&any(v.status==uint8([1 2 3]))&&scalar(v.validatorVersion,"uint16",true);
end

function valid = validDetection(v,c)
r=["resultId";"processedItemId";"labelId";"confidence";"schemaVersion";"confidenceValid"];
valid=isstruct(v)&&isscalar(v)&&all(isfield(v,r))&&scalar(v.resultId,"uint32",true)&& ...
    scalar(v.processedItemId,"uint32",true)&&scalar(v.labelId,"uint8",false)&& ...
    any(v.labelId==uint8([0 1]))&&isa(v.confidence,"single")&&isscalar(v.confidence)&& ...
    isfinite(v.confidence)&&v.confidence>=0&&v.confidence<=1&&islogical(v.confidenceValid)&& ...
    isscalar(v.confidenceValid)&&v.confidenceValid&&v.confidence>=c.minimumConfidence&& ...
    scalar(v.schemaVersion,"uint16",true)&&v.schemaVersion==c.detectionSchemaVersion;
end

function valid = validRisk(v)
r=["assessmentId";"evidenceRefs";"referenceCount";"riskLevel";"confidenceStatus";"policyVersion"];
valid=isstruct(v)&&isscalar(v)&&all(isfield(v,r))&&scalar(v.assessmentId,"uint32",true)&& ...
    isa(v.evidenceRefs,"uint32")&&isequal(size(v.evidenceRefs),[16 1])&& ...
    scalar(v.referenceCount,"uint8",false)&&v.referenceCount<=16&& ...
    all(v.evidenceRefs(1:double(v.referenceCount))~=0)&& ...
    all(v.evidenceRefs(double(v.referenceCount)+1:end)==0)&& ...
    scalar(v.riskLevel,"uint8",true)&&any(v.riskLevel==uint8(1:4))&& ...
    scalar(v.confidenceStatus,"uint8",true)&&scalar(v.policyVersion,"uint16",true);
end

function state = approvalState(v)
state=uint8(0);
if isstruct(v)&&isscalar(v)&&isfield(v,"approvalState")&&scalar(v.approvalState,"uint8",false)&&v.approvalState<=5
    state=v.approvalState;
end
end

function valid = validApproval(v,id)
r=["recommendationId";"approvalState";"forwardingEligible";"safetyBypass";"auditValid"];
valid=isstruct(v)&&isscalar(v)&&all(isfield(v,r))&&scalar(v.recommendationId,"uint32",true)&& ...
    v.recommendationId==id&&scalar(v.approvalState,"uint8",true)&&v.approvalState==5&& ...
    islogical(v.forwardingEligible)&&isscalar(v.forwardingEligible)&&v.forwardingEligible&& ...
    islogical(v.safetyBypass)&&isscalar(v.safetyBypass)&&~v.safetyBypass&& ...
    islogical(v.auditValid)&&isscalar(v.auditValid)&&v.auditValid;
end

function valid = scalar(v,className,nonzero)
valid=isa(v,className)&&isscalar(v)&&isreal(v)&&isfinite(double(v));if valid&&nonzero,valid=v~=0;end
end

function [action,boundary] = emptyOutputs()
action=struct("recommendationId",uint32(0),"actionCode",uint8(255), ...
    "parameters",zeros(16,1,"single"),"evidenceRefs",zeros(16,1,"uint32"), ...
    "confidenceStatus",uint8(0),"approvalStatus",uint8(0),"validFrom",uint64(0), ...
    "validUntil",uint64(0),"configurationVersion",uint16(0), ...
    "parameterCount",uint8(0),"referenceCount",uint8(0));
boundary=struct("forwardingEligible",false,"humanApprovalRequired",true, ...
    "advisoryOnly",true,"controlled",false,"statusCode",uint8(255));
end

