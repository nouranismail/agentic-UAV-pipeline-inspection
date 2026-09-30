classdef test_risk_assessment < matlab.unittest.TestCase
    methods (TestClassSetup)
        function addCorePath(t)
            folder=fileparts(mfilename("fullpath")); root=fileparts(fileparts(folder));
            t.applyFixture(matlab.unittest.fixtures.PathFixture( ...
                fullfile(root,"extensions","intelligent-inspection","core")));
        end
    end
    methods (Test)
        function IIW_TST_RISK_001_nominalLevels(t)
            t.verifyEqual(run(80,.2).riskLevel,uint8(1));
            t.verifyEqual(run(50,.2).riskLevel,uint8(2));
            t.verifyEqual(run(49.99,.2).riskLevel,uint8(3));
            t.verifyEqual(run(100,0).riskLevel,uint8(1));
            t.verifyEqual(run(0,0).riskLevel,uint8(3));
        end
        function IIW_TST_RISK_002_boundaries(t)
            a=run(80,.2); t.verifyEqual(a.confidenceStatus,uint8(1));
            t.verifyEqual(a.rationaleCodes(1),uint8(1));
            t.verifyEqual(run(79.99,.2).riskLevel,uint8(2));
            t.verifyEqual(run(50,.2).rationaleCodes(1),uint8(2));
            t.verifyEqual(run(0,.2).rationaleCodes(1),uint8(3));
        end
        function IIW_TST_RISK_003_invalidInputs(t)
            p=prediction(75,.1); p.estimate=single(NaN);
            verifyFallback(t,iiw.risk.assessRisk(p,evidence,policy),10);
            p=prediction(75,.1); p.uncertainty=single(Inf);
            verifyFallback(t,iiw.risk.assessRisk(p,evidence,policy),10);
            p=prediction(101,.1); verifyFallback(t,iiw.risk.assessRisk(p,evidence,policy),10);
            p=rmfield(prediction(75,.1),"estimate");
            verifyFallback(t,iiw.risk.assessRisk(p,evidence,policy),10);
        end
        function IIW_TST_RISK_004_evidenceSufficiency(t)
            e=evidence; e.referenceCount=uint8(0); e.evidenceRefs(:)=0;
            verifyFallback(t,iiw.risk.assessRisk(prediction(75,.1),e,policy),11);
            e=evidence; e.qualitySupplied=true; e.qualityAccepted=false;
            verifyFallback(t,iiw.risk.assessRisk(prediction(75,.1),e,policy),12);
            e=evidence; e.detectionSupplied=true; e.detectionConfidenceValid=false;
            verifyFallback(t,iiw.risk.assessRisk(prediction(75,.1),e,policy),11);
        end
        function IIW_TST_RISK_005_uncertaintyStatusAndPolicy(t)
            r=run(90,.2001); t.verifyEqual(r.riskLevel,uint8(4));
            t.verifyEqual(r.rationaleCodes(1:2),uint8([14;13]));
            p=prediction(90,.1); p.confidenceStatus=uint8(0);
            verifyFallback(t,iiw.risk.assessRisk(p,evidence,policy),15);
            q=policy; q.policyVersion=uint16(2);
            verifyFallback(t,iiw.risk.assessRisk(prediction(90,.1),evidence,q),16);
        end
        function IIW_TST_RISK_006_failureSchemaAndSafety(t)
            e=evidence; e.internalAssessmentFailure=true;
            r=iiw.risk.assessRisk(prediction(90,.1),e,policy);
            verifyFallback(t,r,17);
            expected=["assessmentId";"evidenceRefs";"riskLevel";"riskScore"; ...
                "confidenceStatus";"rationaleCodes";"policyVersion"; ...
                "referenceCount";"riskScoreValid";"rationaleCount"];
            t.verifyEqual(string(fieldnames(r)),expected);
            prohibited=["autonomousAction";"safetyCommand";"approvalDecision";"missionCommand"];
            t.verifyFalse(any(ismember(prohibited,string(fieldnames(r)))));
        end
        function IIW_TST_RISK_007_decisionTableAndDeterminism(t)
            cases=[90 .1 1; 60 .1 2; 40 .1 3; 90 .3 4];
            for k=1:size(cases,1)
                a=run(cases(k,1),cases(k,2)); b=run(cases(k,1),cases(k,2));
                t.verifyEqual(a,b); t.verifyEqual(a.riskLevel,uint8(cases(k,3)));
                t.verifyEqual(a.policyVersion,uint16(1));
                t.verifyEqual(a.evidenceRefs(1),uint32(501));
            end
            source=lower(fileread(which("iiw.risk.assessRisk")));
            forbidden=["returnto"+"home","safe"+"landing","mission"+"supervisor"];
            t.verifyFalse(any(contains(source,forbidden)));
        end
        function targetedMalformedPredictionCoverage(t)
            verifyFallback(t,iiw.risk.assessRisk([],evidence,policy),10);
            p=repmat(prediction(70,.1),1,2); verifyFallback(t,iiw.risk.assessRisk(p,evidence,policy),10);
            fields=fieldnames(prediction(70,.1));
            for k=1:numel(fields)
                p=prediction(70,.1);
                if k<=8, p.(fields{k})=double(p.(fields{k})); else, p.(fields{k})=uint8(p.(fields{k})); end
                verifyFallback(t,iiw.risk.assessRisk(p,evidence,policy),10);
            end
            scalarFields=fields;
            for k=1:numel(scalarFields)
                p=prediction(70,.1); v=p.(scalarFields{k}); p.(scalarFields{k})=repmat(v,1,2);
                verifyFallback(t,iiw.risk.assessRisk(p,evidence,policy),10);
            end
            mutations={"predictionId",uint32(0);"featureSetId",uint32(0); ...
                "modelVersion",uint16(0);"schemaVersion",uint16(2); ...
                "estimateValid",false;"contextOrHorizonValid",false; ...
                "contextOrHorizon",uint32(0);"uncertaintyValid",false; ...
                "estimate",single(-1);"estimate",single(101); ...
                "uncertainty",single(-1);"uncertainty",single(1.1)};
            for k=1:size(mutations,1)
                p=prediction(70,.1); p.(mutations{k,1})=mutations{k,2};
                verifyFallback(t,iiw.risk.assessRisk(p,evidence,policy),10);
            end
        end
        function targetedEvidenceCoverage(t)
            verifyFallback(t,iiw.risk.assessRisk(prediction(70,.1),[],policy),10);
            e=repmat(evidence,1,2); verifyFallback(t,iiw.risk.assessRisk(prediction(70,.1),e,policy),10);
            e=rmfield(evidence,"qualityAccepted"); verifyFallback(t,iiw.risk.assessRisk(prediction(70,.1),e,policy),10);
            names=fieldnames(evidence);
            for k=1:numel(names)
                e=evidence;
                if islogical(e.(names{k})), e.(names{k})=uint8(e.(names{k})); else, e.(names{k})=double(e.(names{k})); end
                verifyFallback(t,iiw.risk.assessRisk(prediction(70,.1),e,policy),10);
            end
            scalarNames=["assessmentId";"referenceCount";"qualitySupplied";"qualityAccepted"; ...
                "detectionSupplied";"detectionConfidence";"detectionConfidenceValid";"internalAssessmentFailure"];
            for k=1:numel(scalarNames)
                e=evidence; v=e.(scalarNames(k)); e.(scalarNames(k))=repmat(v,1,2);
                verifyFallback(t,iiw.risk.assessRisk(prediction(70,.1),e,policy),10);
            end
            e=evidence; e.assessmentId=uint32(0); verifyFallback(t,iiw.risk.assessRisk(prediction(70,.1),e,policy),10);
            e=evidence; e.evidenceRefs=zeros(15,1,"uint32"); verifyFallback(t,iiw.risk.assessRisk(prediction(70,.1),e,policy),10);
            e=evidence; e.referenceCount=uint8(17); verifyFallback(t,iiw.risk.assessRisk(prediction(70,.1),e,policy),10);
            e=evidence; e.evidenceRefs(1)=0; verifyFallback(t,iiw.risk.assessRisk(prediction(70,.1),e,policy),10);
            e=evidence; e.evidenceRefs(2)=1; verifyFallback(t,iiw.risk.assessRisk(prediction(70,.1),e,policy),10);
            e=evidence; e.qualitySupplied=true; e.qualityAccepted=true;
            t.verifyEqual(iiw.risk.assessRisk(prediction(70,.1),e,policy).riskLevel,uint8(2));
            for value={single(NaN),single(-.1),single(1.1),single(.5)}
                e=evidence; e.detectionSupplied=true; e.detectionConfidenceValid=true; e.detectionConfidence=value{1};
                r=iiw.risk.assessRisk(prediction(70,.1),e,policy);
                if value{1}==single(.5), t.verifyEqual(r.riskLevel,uint8(2)); else, verifyFallback(t,r,11); end
            end
        end
        function targetedPolicyCoverage(t)
            verifyFallback(t,iiw.risk.assessRisk(prediction(70,.1),evidence,[]),16);
            q=repmat(policy,1,2); verifyFallback(t,iiw.risk.assessRisk(prediction(70,.1),evidence,q),16);
            q=rmfield(policy,"lowHealthThreshold"); verifyFallback(t,iiw.risk.assessRisk(prediction(70,.1),evidence,q),16);
            q=rmfield(policy,"policyVersion"); verifyFallback(t,iiw.risk.assessRisk(prediction(70,.1),evidence,q),16);
            q=policy; q.policyVersion=uint16([1 1]); verifyFallback(t,iiw.risk.assessRisk(prediction(70,.1),evidence,q),16);
            names=fieldnames(policy);
            for k=1:numel(names)
                q=policy; q.(names{k})=double(q.(names{k}));
                verifyFallback(t,iiw.risk.assessRisk(prediction(70,.1),evidence,q),16);
            end
            q=policy; q.maximumUncertainty=single(.3); verifyFallback(t,iiw.risk.assessRisk(prediction(70,.1),evidence,q),16);
            q=policy; q.minimumConfidence=single(.7); verifyFallback(t,iiw.risk.assessRisk(prediction(70,.1),evidence,q),16);
            q=policy; q.mediumHealthThreshold=single(49); verifyFallback(t,iiw.risk.assessRisk(prediction(70,.1),evidence,q),16);
            q=policy; q.lowHealthThreshold=single(79); verifyFallback(t,iiw.risk.assessRisk(prediction(70,.1),evidence,q),16);
            q=policy; q.maximumUncertainty=single([.2 .2]); verifyFallback(t,iiw.risk.assessRisk(prediction(70,.1),evidence,q),16);
            q=policy; q.maximumUncertainty=single(.2+1i); verifyFallback(t,iiw.risk.assessRisk(prediction(70,.1),evidence,q),16);
            q=policy; q.maximumUncertainty=single(NaN); verifyFallback(t,iiw.risk.assessRisk(prediction(70,.1),evidence,q),16);
        end
    end
end

function r=run(health,uncertainty)
r=iiw.risk.assessRisk(prediction(health,uncertainty),evidence,policy);
end
function p=prediction(health,uncertainty)
p=struct("predictionId",uint32(41),"featureSetId",uint32(42), ...
    "estimate",single(health),"contextOrHorizon",uint32(7), ...
    "uncertainty",single(uncertainty),"confidenceStatus",uint8(1), ...
    "modelVersion",uint16(1),"schemaVersion",uint16(1), ...
    "estimateValid",true,"contextOrHorizonValid",true,"uncertaintyValid",true);
end
function e=evidence
refs=zeros(16,1,"uint32"); refs(1)=uint32(501);
e=struct("assessmentId",uint32(601),"evidenceRefs",refs, ...
    "referenceCount",uint8(1),"qualitySupplied",false,"qualityAccepted",false, ...
    "detectionSupplied",false,"detectionConfidence",single(0), ...
    "detectionConfidenceValid",false,"internalAssessmentFailure",false);
end
function p=policy
p=struct("policyVersion",uint16(1),"maximumUncertainty",single(.20), ...
    "minimumConfidence",single(.80),"mediumHealthThreshold",single(50), ...
    "lowHealthThreshold",single(80));
end
function verifyFallback(t,r,code)
t.verifyEqual(r.riskLevel,uint8(4));
t.verifyEqual(r.rationaleCodes(1),uint8(code));
t.verifyFalse(r.riskScoreValid); t.verifyEqual(r.riskScore,single(0));
end
