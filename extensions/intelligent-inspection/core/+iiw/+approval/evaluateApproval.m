function audit = evaluateApproval(request,decision,context,policy)
%EVALUATEAPPROVAL Evaluate the approved advisory human-approval policy.

audit = fallbackAudit(uint16(21));
try
    if externalSafetyHasPriority(context)
        audit = copyAvailableAudit(audit,request,decision,context,policy);
        audit.safetyBypass = true;
        audit.rationaleCode = uint16(20);
        audit.auditValid = validSafetyAudit(audit);
        return
    end
    if ~validPolicy(policy)
        audit = copyAvailableAudit(audit,request,decision,context,policy);
        audit.rationaleCode = uint16(37);
        return
    end
    audit.policyVersion = policy.policyVersion;
    if ~validContext(context) || context.internalEvaluationFailure || ...
            (context.externalSafetyActive && ~context.externalSafetyAuthenticated)
        audit = copyAvailableAudit(audit,request,decision,context,policy);
        if validContext(context) && context.internalEvaluationFailure
            audit.rationaleCode = uint16(38);
        end
        return
    end
    audit.evaluationTimestamp = context.evaluationTimestamp;
    audit.recommendationId = context.recommendationId;
    audit.escalationRequired = context.escalationRequested;
    if ~context.requestPresent
        audit.rationaleCode = uint16(22);
        return
    end
    [requestValid,requestReason] = validateRequest(request,policy,context);
    if ~requestValid
        audit.rationaleCode = requestReason;
        return
    end
    audit = copyRequest(audit,request);
    if context.recommendationId ~= request.proposedRecommendation
        audit.rationaleCode = uint16(32);
        return
    end
    if ~context.decisionPresent
        audit.approvalState = uint8(0);
        audit.rationaleCode = uint16(23);
        audit.auditValid = completeAudit(audit,false);
        return
    end
    [decisionValid,decisionReason] = validateDecision(decision,request,context,policy);
    if ~decisionValid
        audit.rationaleCode = decisionReason;
        return
    end
    audit = copyDecision(audit,decision,context);
    if decision.decision == uint8(0)
        audit.approvalState = uint8(1);
        [audit,expired] = waitingDisposition(audit,request,context,policy);
        if ~expired, audit.rationaleCode = uint16(24); end
    elseif decision.decision == uint8(3)
        audit.approvalState = uint8(2);
        [audit,expired] = waitingDisposition(audit,request,context,policy);
        if ~expired, audit.rationaleCode = uint16(25); end
    elseif decision.decision == uint8(2)
        audit.approvalState = uint8(3);
        audit.rationaleCode = uint16(26);
    elseif decision.decision == uint8(4)
        audit.approvalState = uint8(4);
        audit.rationaleCode = uint16(28);
    else
        audit.approvalState = uint8(5);
        validUntil = addNoOverflow(decision.decidedAt,policy.approvalValidityMs);
        audit.validUntilTimestamp = validUntil;
        if validUntil == uint64(0) || context.evaluationTimestamp > validUntil
            audit.approvalState = uint8(4);
            audit.rationaleCode = uint16(28);
        else
            audit.forwardingEligible = true;
            audit.humanReviewRequired = false;
            audit.rationaleCode = uint16(29);
        end
    end
    if context.escalationRequested && ~audit.forwardingEligible && ...
            ismember(audit.rationaleCode,uint16([0 24 25]))
        audit.rationaleCode = uint16(39);
    end
    audit.auditValid = completeAudit(audit,audit.forwardingEligible);
    if ~audit.auditValid
        audit.forwardingEligible = false;
        audit.humanReviewRequired = true;
        if audit.rationaleCode == uint16(29), audit.rationaleCode = uint16(21); end
    end
catch
    audit = fallbackAudit(uint16(38));
end
end

function [audit,expired] = waitingDisposition(audit,request,context,policy)
expired = context.evaluationTimestamp > addNoOverflow(request.requestedAt,policy.waitingTimeoutMs);
if expired
    audit.approvalState = uint8(4);
    audit.rationaleCode = uint16(27);
    audit.escalationRequired = true;
end
end

function [valid,reason] = validateRequest(r,p,c)
reason=uint16(21); required=["requestId";"assessmentId";"proposedRecommendation"; ...
    "evidenceRefs";"requestedAt";"expiresAt";"policyVersion";"referenceCount"];
valid=isstruct(r)&&isscalar(r)&&isequal(string(fieldnames(r)),required);
if ~valid, return, end
valid=isa(r.requestId,"uint32")&&isscalar(r.requestId)&&r.requestId~=0&& ...
    isa(r.assessmentId,"uint32")&&isscalar(r.assessmentId)&&r.assessmentId~=0&& ...
    isa(r.proposedRecommendation,"uint32")&&isscalar(r.proposedRecommendation)&&r.proposedRecommendation~=0&& ...
    validReferences(r.evidenceRefs,r.referenceCount)&& ...
    isa(r.requestedAt,"uint64")&&isscalar(r.requestedAt)&&r.requestedAt~=0&& ...
    isa(r.expiresAt,"uint64")&&isscalar(r.expiresAt)&&r.expiresAt>r.requestedAt&& ...
    isa(r.policyVersion,"uint16")&&isscalar(r.policyVersion);
if ~valid, return, end
if r.policyVersion~=p.policyVersion, valid=false; reason=uint16(37); return, end
if c.evaluationTimestamp<r.requestedAt || c.evaluationTimestamp>r.expiresAt
    valid=false; reason=uint16(33);
end
end

function [valid,reason] = validateDecision(d,r,c,p)
reason=uint16(21); required=["requestId";"decision";"decidedBy";"decidedAt";"comments";"decisionVersion"];
valid=isstruct(d)&&isscalar(d)&&isequal(string(fieldnames(d)),required);
if ~valid, return, end
valid=isa(d.requestId,"uint32")&&isscalar(d.requestId)&& ...
    isa(d.decision,"uint8")&&isscalar(d.decision)&&d.decision<=4&& ...
    isa(d.decidedBy,"uint32")&&isscalar(d.decidedBy)&& ...
    isa(d.decidedAt,"uint64")&&isscalar(d.decidedAt)&& ...
    isa(d.comments,"uint32")&&isscalar(d.comments)&& ...
    isa(d.decisionVersion,"uint16")&&isscalar(d.decisionVersion);
if ~valid, return, end
if d.requestId~=r.requestId, valid=false; reason=uint16(32); return, end
if d.decisionVersion~=p.decisionVersion, valid=false; reason=uint16(37); return, end
if d.decision~=0 && d.decision~=4 && d.decidedBy==0
    valid=false; reason=uint16(30); return
end
if d.decision~=0 && d.decision~=4 && ~ismember(c.approverRole,p.authorizedRoles)
    valid=false; reason=uint16(31); return
end
if d.decidedBy~=0 && d.decidedBy==c.requesterId
    valid=false; reason=uint16(35); return
end
if d.decision~=0 && (d.decidedAt==0 || d.decidedAt<r.requestedAt || d.decidedAt>c.evaluationTimestamp)
    valid=false; reason=uint16(33); return
end
if c.delegationActive
    if c.delegationDepth>1
        valid=false; reason=uint16(36); return
    end
    if ~p.delegationEnabled || c.delegatorId==0 || ...
            c.originalApproverId==0 || d.decidedBy==0
        valid=false; reason=uint16(34); return
    end
    if d.decidedBy==c.originalApproverId || d.decidedBy==c.delegatorId
        valid=false; reason=uint16(35); return
    end
elseif c.delegationDepth~=0 || c.delegatorId~=0
    valid=false; reason=uint16(34);
end
end

function valid = validPolicy(p)
required=["policyVersion";"decisionVersion";"waitingTimeoutMs";"approvalValidityMs";"authorizedRoles";"delegationEnabled"];
valid=isstruct(p)&&isscalar(p)&&isequal(string(fieldnames(p)),required)&& ...
    isa(p.policyVersion,"uint16")&&isscalar(p.policyVersion)&&p.policyVersion==1&& ...
    isa(p.decisionVersion,"uint16")&&isscalar(p.decisionVersion)&&p.decisionVersion==1&& ...
    isa(p.waitingTimeoutMs,"uint64")&&isscalar(p.waitingTimeoutMs)&&p.waitingTimeoutMs==300000&& ...
    isa(p.approvalValidityMs,"uint64")&&isscalar(p.approvalValidityMs)&&p.approvalValidityMs==900000&& ...
    isa(p.authorizedRoles,"uint8")&&isequal(size(p.authorizedRoles),[3 1])&& ...
    isequal(p.authorizedRoles,uint8([1;2;3]))&&islogical(p.delegationEnabled)&&isscalar(p.delegationEnabled);
end

function valid = validContext(c)
required=["requestPresent";"decisionPresent";"recommendationId";"requesterId"; ...
    "approverRole";"evaluationTimestamp";"delegationActive";"delegationDepth"; ...
    "delegatorId";"originalApproverId";"escalationRequested"; ...
    "externalSafetyActive";"externalSafetyAuthenticated";"internalEvaluationFailure"];
valid=isstruct(c)&&isscalar(c)&&isequal(string(fieldnames(c)),required)&& ...
    islogical(c.requestPresent)&&isscalar(c.requestPresent)&& ...
    islogical(c.decisionPresent)&&isscalar(c.decisionPresent)&& ...
    isa(c.recommendationId,"uint32")&&isscalar(c.recommendationId)&& ...
    isa(c.requesterId,"uint32")&&isscalar(c.requesterId)&& ...
    isa(c.approverRole,"uint8")&&isscalar(c.approverRole)&& ...
    isa(c.evaluationTimestamp,"uint64")&&isscalar(c.evaluationTimestamp)&&c.evaluationTimestamp~=0&& ...
    islogical(c.delegationActive)&&isscalar(c.delegationActive)&& ...
    isa(c.delegationDepth,"uint8")&&isscalar(c.delegationDepth)&& ...
    isa(c.delegatorId,"uint32")&&isscalar(c.delegatorId)&& ...
    isa(c.originalApproverId,"uint32")&&isscalar(c.originalApproverId)&& ...
    islogical(c.escalationRequested)&&isscalar(c.escalationRequested)&& ...
    islogical(c.externalSafetyActive)&&isscalar(c.externalSafetyActive)&& ...
    islogical(c.externalSafetyAuthenticated)&&isscalar(c.externalSafetyAuthenticated)&& ...
    islogical(c.internalEvaluationFailure)&&isscalar(c.internalEvaluationFailure);
end

function tf=externalSafetyHasPriority(c)
tf=isstruct(c)&&isscalar(c)&&isfield(c,"externalSafetyActive")&& ...
    isfield(c,"externalSafetyAuthenticated")&&islogical(c.externalSafetyActive)&& ...
    isscalar(c.externalSafetyActive)&&islogical(c.externalSafetyAuthenticated)&& ...
    isscalar(c.externalSafetyAuthenticated)&&c.externalSafetyActive&&c.externalSafetyAuthenticated;
end

function tf=validReferences(refs,count)
tf=isa(refs,"uint32")&&isequal(size(refs),[16 1])&&isa(count,"uint8")&& ...
    isscalar(count)&&count>=1&&count<=16&&all(refs(1:double(count))~=0)&& ...
    all(refs(double(count)+1:end)==0);
end

function a=fallbackAudit(code)
a=struct("requestId",uint32(0),"recommendationId",uint32(0), ...
    "policyVersion",uint16(0),"approvalState",uint8(0),"approverId",uint32(0), ...
    "approverRole",uint8(0),"decisionTimestamp",uint64(0), ...
    "evaluationTimestamp",uint64(0),"validUntilTimestamp",uint64(0), ...
    "delegationActive",false,"delegatorId",uint32(0),"escalationRequired",false, ...
    "forwardingEligible",false,"safetyBypass",false,"humanReviewRequired",true, ...
    "rationaleCode",uint16(code),"evidenceReferences",zeros(16,1,"uint32"), ...
    "auditValid",false);
end

function a=copyAvailableAudit(a,r,d,c,p)
if isstruct(p)&&isscalar(p)&&isfield(p,"policyVersion")&&isa(p.policyVersion,"uint16")&&isscalar(p.policyVersion), a.policyVersion=p.policyVersion; end
if isstruct(c)&&isscalar(c)
    if isfield(c,"recommendationId")&&isa(c.recommendationId,"uint32")&&isscalar(c.recommendationId), a.recommendationId=c.recommendationId; end
    if isfield(c,"evaluationTimestamp")&&isa(c.evaluationTimestamp,"uint64")&&isscalar(c.evaluationTimestamp), a.evaluationTimestamp=c.evaluationTimestamp; end
end
if isstruct(r)&&isscalar(r)&&isfield(r,"requestId")&&isa(r.requestId,"uint32")&&isscalar(r.requestId), a.requestId=r.requestId; end
if isstruct(d)&&isscalar(d)&&isfield(d,"decidedBy")&&isa(d.decidedBy,"uint32")&&isscalar(d.decidedBy), a.approverId=d.decidedBy; end
end

function a=copyRequest(a,r)
a.requestId=r.requestId; a.recommendationId=r.proposedRecommendation;
a.policyVersion=r.policyVersion; a.evidenceReferences=r.evidenceRefs;
end

function a=copyDecision(a,d,c)
a.approverId=d.decidedBy; a.approverRole=c.approverRole;
a.decisionTimestamp=d.decidedAt; a.delegationActive=c.delegationActive;
a.delegatorId=c.delegatorId;
end

function tf=completeAudit(a,approval)
base=a.requestId~=0&&a.recommendationId~=0&&a.policyVersion~=0&& ...
    a.evaluationTimestamp~=0&&any(a.evidenceReferences~=0)&& ...
    all(diff(find([a.evidenceReferences==0;true],1)-1)>=0); %#ok<NBRAK>
if approval
    base=base&&a.approvalState==5&&a.approverId~=0&&ismember(a.approverRole,uint8([1 2 3]))&& ...
        a.decisionTimestamp~=0&&a.validUntilTimestamp>=a.evaluationTimestamp;
end
tf=logical(base);
end

function tf=validSafetyAudit(a)
tf=a.policyVersion~=0&&a.evaluationTimestamp~=0&&a.rationaleCode==20&&a.safetyBypass;
end

function value=addNoOverflow(a,b)
if a>intmax("uint64")-b, value=uint64(0); else, value=a+b; end
end
