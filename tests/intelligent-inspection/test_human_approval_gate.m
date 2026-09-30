classdef test_human_approval_gate < matlab.unittest.TestCase
    methods (TestClassSetup)
        function addCorePath(t)
            folder=fileparts(mfilename("fullpath")); root=fileparts(fileparts(folder));
            t.applyFixture(matlab.unittest.fixtures.PathFixture(fullfile(root,"extensions","intelligent-inspection","core")));
        end
    end
    methods (Test)
        function IIW_TST_APR_001_states(t)
            t.verifyState(runCase(uint8(0),1000),1,24,false);
            t.verifyState(runCase(uint8(3),1000),2,25,false);
            t.verifyState(runCase(uint8(2),1000),3,26,false);
            t.verifyState(runCase(uint8(4),1000),4,28,false);
            t.verifyState(runCase(uint8(1),1000),5,29,true);
            c=context; c.requestPresent=false; t.verifyState(call(request,decision(1),c),0,22,false);
        end
        function IIW_TST_APR_002_missingAndReferences(t)
            c=context; c.decisionPresent=false; t.verifyState(call(request,decision(1),c),0,23,false);
            d=decision(1); d.requestId=uint32(99); t.verifyEqual(call(request,d,context).rationaleCode,uint16(32));
            c=context; c.recommendationId=uint32(99); t.verifyEqual(call(request,decision(1),c).rationaleCode,uint16(32));
        end
        function IIW_TST_APR_003_identityAndRoles(t)
            d=decision(1); d.decidedBy=uint32(0); t.verifyEqual(call(request,d,context).rationaleCode,uint16(30));
            c=context; c.approverRole=uint8(4); t.verifyEqual(call(request,decision(1),c).rationaleCode,uint16(31));
            c=context; d=decision(1); d.decidedBy=c.requesterId; t.verifyEqual(call(request,d,c).rationaleCode,uint16(35));
        end
        function IIW_TST_APR_004_waitingBoundary(t)
            t.verifyState(runCase(uint8(0),300000),1,24,false);
            t.verifyState(runCase(uint8(0),300001),4,27,false);
            t.verifyState(runCase(uint8(3),300000),2,25,false);
            t.verifyState(runCase(uint8(3),300001),4,27,false);
        end
        function IIW_TST_APR_005_approvalBoundary(t)
            t.verifyState(runCase(uint8(1),900000),5,29,true);
            t.verifyState(runCase(uint8(1),900001),4,28,false);
        end
        function IIW_TST_APR_006_delegation(t)
            c=context; c.delegationActive=true; c.delegationDepth=uint8(1); c.delegatorId=uint32(70); c.originalApproverId=uint32(70);
            a=call(request,decision(1),c); t.verifyTrue(a.forwardingEligible); t.verifyTrue(a.delegationActive);
            c.delegationDepth=uint8(2); t.verifyEqual(call(request,decision(1),c).rationaleCode,uint16(36));
            c=context; c.delegationActive=true; c.delegationDepth=uint8(1); c.delegatorId=uint32(80); c.originalApproverId=uint32(80);
            d=decision(1); d.decidedBy=uint32(80); t.verifyEqual(call(request,d,c).rationaleCode,uint16(35));
        end
        function IIW_TST_APR_007_escalation(t)
            c=context; c.escalationRequested=true; a=call(request,decision(0),c);
            t.verifyEqual(a.rationaleCode,uint16(39)); t.verifyTrue(a.escalationRequired); t.verifyFalse(a.forwardingEligible);
        end
        function IIW_TST_APR_008_externalSafety(t)
            c=context; c.externalSafetyActive=true; c.externalSafetyAuthenticated=true;
            a=call([],[],c); t.verifyEqual(a.rationaleCode,uint16(20)); t.verifyTrue(a.safetyBypass);
            t.verifyFalse(a.forwardingEligible); t.verifyTrue(a.humanReviewRequired);
        end
        function IIW_TST_APR_009_invalidAuditAndDeterminism(t)
            q=policy; q.policyVersion=uint16(2); t.verifyEqual(call(request,decision(1),context,q).rationaleCode,uint16(37));
            a=call([],decision(1),context); t.verifyEqual(a.rationaleCode,uint16(21)); t.verifyFalse(a.auditValid);
            c=context; c.internalEvaluationFailure=true; t.verifyEqual(call(request,decision(1),c).rationaleCode,uint16(38));
            a=call(request,decision(1),context); b=call(request,decision(1),context); t.verifyEqual(a,b);
        end
        function IIW_TST_APR_010_schemaModelAndTerminology(t)
            a=call(request,decision(1),context);
            expected=["requestId";"recommendationId";"policyVersion";"approvalState";"approverId";"approverRole"; ...
                "decisionTimestamp";"evaluationTimestamp";"validUntilTimestamp";"delegationActive";"delegatorId"; ...
                "escalationRequired";"forwardingEligible";"safetyBypass";"humanReviewRequired";"rationaleCode"; ...
                "evidenceReferences";"auditValid"];
            t.verifyEqual(string(fieldnames(a)),expected); t.verifyClass(a.rationaleCode,"uint16"); t.verifyTrue(a.auditValid);
            model=fullfile(projectRoot,"extensions","intelligent-inspection","models","human_approval_gate.slx");
            open_system(model); set_param("human_approval_gate","SimulationCommand","update"); save_system("human_approval_gate"); close_system("human_approval_gate",0);
            source=lower(fileread(which("iiw.approval.evaluateApproval")));
            forbidden=["returnto"+"home","safe"+"landing","mission"+"supervisor","safetycommand","missioncommand"];
            t.verifyFalse(any(contains(source,forbidden)));
        end
        function targetedRequestValidationCoverage(t)
            verifyControlled(t,call([],decision(1),context),21);
            verifyControlled(t,call(repmat(request,1,2),decision(1),context),21);
            verifyControlled(t,call(rmfield(request,"assessmentId"),decision(1),context),21);
            fields=fieldnames(request);
            for k=1:numel(fields)
                r=request; r.(fields{k})=wrongType(r.(fields{k}));
                verifyControlled(t,call(r,decision(1),context),21);
                r=request; r.(fields{k})=repeatValue(r.(fields{k}));
                verifyControlled(t,call(r,decision(1),context),21);
            end
            for name=["requestId","assessmentId","proposedRecommendation"]
                r=request; r.(name)=uint32(0); verifyControlled(t,call(r,decision(1),context),21);
            end
            r=request; r.referenceCount=uint8(0); verifyControlled(t,call(r,decision(1),context),21);
            r=request; r.referenceCount=uint8(17); verifyControlled(t,call(r,decision(1),context),21);
            r=request; r.evidenceRefs=zeros(15,1,"uint32"); verifyControlled(t,call(r,decision(1),context),21);
            r=request; r.evidenceRefs(1)=uint32(0); verifyControlled(t,call(r,decision(1),context),21);
            r=request; r.evidenceRefs(2)=uint32(9); verifyControlled(t,call(r,decision(1),context),21);
            r=request; r.requestedAt=uint64(0); verifyControlled(t,call(r,decision(1),context),21);
            r=request; r.expiresAt=r.requestedAt; verifyControlled(t,call(r,decision(1),context),21);
            r=request; r.policyVersion=uint16(2); verifyControlled(t,call(r,decision(1),context),37);
            r=request; c=context; c.evaluationTimestamp=r.requestedAt-uint64(1);
            verifyControlled(t,call(request,decision(1),c),33);
            r=request; c=context; c.evaluationTimestamp=r.expiresAt+uint64(1);
            verifyControlled(t,call(request,decision(1),c),33);
            r=request; c=context; c.evaluationTimestamp=r.requestedAt;
            r=request; d=decision(1); d.decidedAt=r.requestedAt;
            t.verifyEqual(call(request,d,c).rationaleCode,uint16(29));
        end
        function targetedDecisionValidationCoverage(t)
            verifyControlled(t,call(request,[],context),21);
            verifyControlled(t,call(request,repmat(decision(1),1,2),context),21);
            verifyControlled(t,call(request,rmfield(decision(1),"comments"),context),21);
            fields=fieldnames(decision(1));
            for k=1:numel(fields)
                d=decision(1); d.(fields{k})=wrongType(d.(fields{k}));
                verifyControlled(t,call(request,d,context),21);
                d=decision(1); d.(fields{k})=repeatValue(d.(fields{k}));
                verifyControlled(t,call(request,d,context),21);
            end
            d=decision(1); d.decision=uint8(5); verifyControlled(t,call(request,d,context),21);
            d=decision(1); d.requestId=uint32(0); verifyControlled(t,call(request,d,context),32);
            d=decision(1); d.decisionVersion=uint16(2); verifyControlled(t,call(request,d,context),37);
            d=decision(1); d.decidedAt=uint64(0); verifyControlled(t,call(request,d,context),33);
            r=request; d=decision(1); d.decidedAt=r.requestedAt-uint64(1); verifyControlled(t,call(r,d,context),33);
            c=context; d=decision(1); d.decidedAt=c.evaluationTimestamp+uint64(1); verifyControlled(t,call(request,d,c),33);
            for role=uint8(1:3)
                c=context; c.approverRole=role;
                t.verifyEqual(call(request,decision(1),c).rationaleCode,uint16(29));
            end
            for role=uint8([0 4 255])
                c=context; c.approverRole=role; verifyControlled(t,call(request,decision(1),c),31);
            end
            d=decision(4);
            t.verifyEqual(call(request,d,context).rationaleCode,uint16(28));
        end
        function targetedContextValidationCoverage(t)
            verifyControlled(t,call(request,decision(1),[]),21);
            verifyControlled(t,call(request,decision(1),repmat(context,1,2)),21);
            verifyControlled(t,call(request,decision(1),rmfield(context,"approverRole")),21);
            fields=fieldnames(context);
            for k=1:numel(fields)
                c=context; c.(fields{k})=wrongType(c.(fields{k}));
                verifyControlled(t,call(request,decision(1),c),21);
                c=context; c.(fields{k})=repeatValue(c.(fields{k}));
                verifyControlled(t,call(request,decision(1),c),21);
            end
            c=context; c.evaluationTimestamp=uint64(0); verifyControlled(t,call(request,decision(1),c),21);
            c=context; c.externalSafetyActive=true; c.externalSafetyAuthenticated=false;
            verifyControlled(t,call(request,decision(1),c),21);
            c=context; c.externalSafetyActive=false; c.externalSafetyAuthenticated=true;
            t.verifyEqual(call(request,decision(1),c).rationaleCode,uint16(29));
            c=context; c.externalSafetyActive=true; c.externalSafetyAuthenticated=true;
            c.internalEvaluationFailure=true; t.verifyEqual(call([],[],c).rationaleCode,uint16(20));
            c=context; c.internalEvaluationFailure=true; verifyControlled(t,call(request,decision(1),c),38);
        end
        function targetedPolicyValidationCoverage(t)
            verifyControlled(t,call(request,decision(1),context,[]),37);
            verifyControlled(t,call(request,decision(1),context,repmat(policy,1,2)),37);
            verifyControlled(t,call(request,decision(1),context,rmfield(policy,"decisionVersion")),37);
            fields=fieldnames(policy);
            for k=1:numel(fields)
                q=policy; q.(fields{k})=wrongType(q.(fields{k}));
                verifyControlled(t,call(request,decision(1),context,q),37);
                if ~isequal(size(q.(fields{k})),[3 1])
                    q=policy; q.(fields{k})=repeatValue(q.(fields{k}));
                    verifyControlled(t,call(request,decision(1),context,q),37);
                end
            end
            q=policy; q.decisionVersion=uint16(2); verifyControlled(t,call(request,decision(1),context,q),37);
            q=policy; q.waitingTimeoutMs=uint64(299999); verifyControlled(t,call(request,decision(1),context,q),37);
            q=policy; q.approvalValidityMs=uint64(899999); verifyControlled(t,call(request,decision(1),context,q),37);
            q=policy; q.authorizedRoles=uint8([1;2;4]); verifyControlled(t,call(request,decision(1),context,q),37);
        end
        function targetedDelegationCoverage(t)
            c=delegatedContext; q=policy; q.delegationEnabled=false;
            verifyControlled(t,call(request,decision(1),c,q),34);
            c=delegatedContext; c.delegatorId=uint32(0); verifyControlled(t,call(request,decision(1),c),34);
            c=delegatedContext; c.originalApproverId=uint32(0); verifyControlled(t,call(request,decision(1),c),34);
            c=delegatedContext; d=decision(1); d.decidedBy=uint32(0); verifyControlled(t,call(request,d,c),30);
            c=delegatedContext; c.delegationDepth=uint8(2); verifyControlled(t,call(request,decision(1),c),36);
            c=delegatedContext; d=decision(1); d.decidedBy=c.originalApproverId; verifyControlled(t,call(request,d,c),35);
            c=delegatedContext; d=decision(1); d.decidedBy=c.delegatorId; verifyControlled(t,call(request,d,c),35);
            c=context; c.delegationDepth=uint8(1); verifyControlled(t,call(request,decision(1),c),34);
            c=context; c.delegatorId=uint32(70); verifyControlled(t,call(request,decision(1),c),34);
        end
        function targetedAuditOverflowAndRationaleCoverage(t)
            a=call(request,decision(1),context); t.verifyTrue(a.auditValid);
            t.verifyEqual(a.evidenceReferences(1),uint32(501));
            c=context; c.decisionPresent=false; a=call(request,decision(1),c);
            t.verifyTrue(a.auditValid); t.verifyFalse(a.forwardingEligible);
            r=request; r.requestedAt=intmax("uint64")-uint64(100); r.expiresAt=intmax("uint64");
            c=context; c.evaluationTimestamp=intmax("uint64"); d=decision(0);
            a=call(r,d,c); t.verifyState(a,4,27,false);
            r=request; r.requestedAt=intmax("uint64")-uint64(200); r.expiresAt=intmax("uint64");
            d=decision(1); d.decidedAt=intmax("uint64")-uint64(100);
            c=context; c.evaluationTimestamp=intmax("uint64");
            a=call(r,d,c); t.verifyState(a,4,28,false);
            expected=uint16(20:39); observed=zeros(size(expected),"uint16");
            c=safetyContext; observed(1)=call([],[],c).rationaleCode;
            observed(2)=call([],decision(1),context).rationaleCode;
            c=context;c.requestPresent=false;observed(3)=call(request,decision(1),c).rationaleCode;
            c=context;c.decisionPresent=false;observed(4)=call(request,decision(1),c).rationaleCode;
            observed(5)=runCase(uint8(0),1).rationaleCode; observed(6)=runCase(uint8(3),1).rationaleCode;
            observed(7)=runCase(uint8(2),1).rationaleCode; observed(8)=runCase(uint8(0),300001).rationaleCode;
            observed(9)=runCase(uint8(1),900001).rationaleCode; observed(10)=runCase(uint8(1),1).rationaleCode;
            d=decision(1);d.decidedBy=uint32(0);observed(11)=call(request,d,context).rationaleCode;
            c=context;c.approverRole=uint8(4);observed(12)=call(request,decision(1),c).rationaleCode;
            d=decision(1);d.requestId=uint32(99);observed(13)=call(request,d,context).rationaleCode;
            d=decision(1);d.decidedAt=uint64(0);observed(14)=call(request,d,context).rationaleCode;
            c=context;c.delegatorId=uint32(1);observed(15)=call(request,decision(1),c).rationaleCode;
            c=context;d=decision(1);d.decidedBy=c.requesterId;observed(16)=call(request,d,c).rationaleCode;
            c=delegatedContext;c.delegationDepth=uint8(2);observed(17)=call(request,decision(1),c).rationaleCode;
            q=policy;q.policyVersion=uint16(2);observed(18)=call(request,decision(1),context,q).rationaleCode;
            c=context;c.internalEvaluationFailure=true;observed(19)=call(request,decision(1),c).rationaleCode;
            c=context;c.escalationRequested=true;observed(20)=call(request,decision(0),c).rationaleCode;
            t.verifyEqual(observed,expected);
            first=call(request,decision(1),context);
            for k=1:5, t.verifyEqual(call(request,decision(1),context),first); end
        end
    end
    methods
        function verifyState(t,a,state,reason,forward)
            t.verifyEqual(a.approvalState,uint8(state)); t.verifyEqual(a.rationaleCode,uint16(reason));
            t.verifyEqual(a.forwardingEligible,forward);
        end
    end
end

function a=runCase(code,age)
r=request; d=decision(code); c=context;
if code==0
    c.evaluationTimestamp=r.requestedAt+uint64(age);
    d.decidedAt=uint64(0);
elseif code==3
    c.evaluationTimestamp=r.requestedAt+uint64(age);
    d.decidedAt=r.requestedAt;
else
    c.evaluationTimestamp=d.decidedAt+uint64(age);
end
a=call(r,d,c);
end
function a=call(r,d,c,p)
if nargin<4, p=policy; end
a=iiw.approval.evaluateApproval(r,d,c,p);
end
function r=request
refs=zeros(16,1,"uint32"); refs(1)=uint32(501);
r=struct("requestId",uint32(10),"assessmentId",uint32(11),"proposedRecommendation",uint32(12), ...
    "evidenceRefs",refs,"requestedAt",uint64(1000000),"expiresAt",uint64(4000000), ...
    "policyVersion",uint16(1),"referenceCount",uint8(1));
end
function d=decision(code)
d=struct("requestId",uint32(10),"decision",uint8(code),"decidedBy",uint32(80), ...
    "decidedAt",uint64(1100000),"comments",uint32(0),"decisionVersion",uint16(1));
if code==0, d.decidedBy=uint32(0); d.decidedAt=uint64(0); end
end
function c=context
c=struct("requestPresent",true,"decisionPresent",true,"recommendationId",uint32(12), ...
    "requesterId",uint32(60),"approverRole",uint8(1),"evaluationTimestamp",uint64(1200000), ...
    "delegationActive",false,"delegationDepth",uint8(0),"delegatorId",uint32(0), ...
    "originalApproverId",uint32(0),"escalationRequested",false,"externalSafetyActive",false, ...
    "externalSafetyAuthenticated",false,"internalEvaluationFailure",false);
end
function p=policy
p=struct("policyVersion",uint16(1),"decisionVersion",uint16(1),"waitingTimeoutMs",uint64(300000), ...
    "approvalValidityMs",uint64(900000),"authorizedRoles",uint8([1;2;3]),"delegationEnabled",true);
end
function c=delegatedContext
c=context; c.delegationActive=true; c.delegationDepth=uint8(1);
c.delegatorId=uint32(70); c.originalApproverId=uint32(70);
end
function c=safetyContext
c=context; c.externalSafetyActive=true; c.externalSafetyAuthenticated=true;
end
function value=wrongType(value)
if islogical(value), value=uint8(value); else, value=double(value); end
end
function value=repeatValue(value)
value=repmat(value,1,2);
end
function verifyControlled(t,a,code)
t.verifyEqual(a.rationaleCode,uint16(code));
t.verifyFalse(a.forwardingEligible); t.verifyTrue(a.humanReviewRequired);
end
function root=projectRoot
folder=fileparts(mfilename("fullpath")); root=fileparts(fileparts(folder));
end
