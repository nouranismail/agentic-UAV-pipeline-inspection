classdef test_evidence_recording < matlab.unittest.TestCase
    % Phase 12 requirements-based tests: IIW-TST-EVD-001 through 006.

    methods (TestClassSetup)
        function addCorePath(testCase)
            testFile = mfilename("fullpath");
            repoRoot = fileparts(fileparts(fileparts(testFile)));
            corePath = fullfile(repoRoot,"extensions","intelligent-inspection","core");
            testCase.applyFixture(matlab.unittest.fixtures.PathFixture(corePath));
        end
    end

    methods (Test)
        function validSingleRecordHasExactSchemas(testCase)
            writer = makeWriter(false);
            [result, stored] = iiw.evidence.recordEvidence(baseRecord(1,1,1),writer,uint8(1),policy());
            validation = iiw.evidence.validateEvidenceChain(stored,policy());
            testCase.verifyTrue(result.persistenceSucceeded);
            testCase.verifyTrue(validation.valid);
            testCase.verifyEqual(string(fieldnames(result.evidenceRecord)),externalFields());
            testCase.verifyEqual(string(fieldnames(result)),resultFields());
        end

        function validMultistageChainHasCompleteIdentifiers(testCase)
            writer = makeWriter(false);
            [~, firstStored] = iiw.evidence.recordEvidence(baseRecord(1,9,1),writer,uint8(2),policy());
            second = baseRecord(2,9,2);
            second.inputEvidenceRefs(1) = uint32(1);
            second.inputReferenceCount = uint8(1);
            [~, secondStored] = iiw.evidence.recordEvidence(second,writer,uint8(3),policy());
            validation = iiw.evidence.validateEvidenceChain([firstStored secondStored],policy());
            testCase.verifyTrue(validation.valid);
            testCase.verifyEqual(validation.mandatoryIdentifierFailureCount,uint16(0));
            testCase.verifyEqual(validation.orphanReferenceCount,uint16(0));
        end

        function orphanReferenceIsRejected(testCase)
            writer = makeWriter(false);
            record = baseRecord(2,1,2);
            record.inputEvidenceRefs(1) = uint32(99);
            record.inputReferenceCount = uint8(1);
            [~, stored] = iiw.evidence.recordEvidence(record,writer,uint8(1),policy());
            validation = iiw.evidence.validateEvidenceChain(stored,policy());
            testCase.verifyFalse(validation.valid);
            testCase.verifyEqual(validation.orphanReferenceCount,uint16(1));
        end

        function selfReferenceIsRejected(testCase)
            writer = makeWriter(false);
            record = baseRecord(2,1,2);
            record.inputEvidenceRefs(1) = uint32(2);
            record.inputReferenceCount = uint8(1);
            [~, stored] = iiw.evidence.recordEvidence(record,writer,uint8(1),policy());
            validation = iiw.evidence.validateEvidenceChain(stored,policy());
            testCase.verifyFalse(validation.valid);
            testCase.verifyEqual(validation.selfReferenceCount,uint16(1));
        end

        function duplicateRecordIdIsRejected(testCase)
            first = sealedRecord(baseRecord(1,1,1));
            second = sealedRecord(baseRecord(1,1,2));
            validation = iiw.evidence.validateEvidenceChain([first second],policy());
            testCase.verifyFalse(validation.valid);
            testCase.verifyEqual(validation.duplicateRecordIdCount,uint16(1));
        end

        function circularReferenceIsRejected(testCase)
            first = sealedRecord(baseRecord(1,1,1));
            second = sealedRecord(baseRecord(2,1,2));
            first.inputEvidenceRefs(1) = uint32(2);
            first.inputReferenceCount = uint8(1);
            second.inputEvidenceRefs(1) = uint32(1);
            second.inputReferenceCount = uint8(1);
            validation = iiw.evidence.validateEvidenceChain([first second],policy());
            testCase.verifyFalse(validation.valid);
            diagnostic = sprintf("failureCode=%u integrityFailures=%u orderFailures=%u", ...
                validation.failureCode,validation.integrityFailureCount, ...
                validation.incorrectStageOrderCount);
            testCase.verifyGreaterThan(validation.circularReferenceCount,uint16(0),diagnostic);
        end

        function incorrectStageOrderIsRejected(testCase)
            parent = sealedRecord(baseRecord(1,1,2));
            child = baseRecord(2,1,1);
            child.inputEvidenceRefs(1) = uint32(1);
            child.inputReferenceCount = uint8(1);
            child = sealedRecord(child);
            validation = iiw.evidence.validateEvidenceChain([parent child],policy());
            testCase.verifyFalse(validation.valid);
            testCase.verifyEqual(validation.incorrectStageOrderCount,uint16(1));
        end

        function persistedIdentifierIsImmutable(testCase)
            writer = makeWriter(false);
            [first,~] = iiw.evidence.recordEvidence(baseRecord(1,1,1),writer,uint8(1),policy());
            changed = baseRecord(1,1,2);
            [second,~] = iiw.evidence.recordEvidence(changed,writer,uint8(1),policy());
            testCase.verifyTrue(first.persistenceSucceeded);
            testCase.verifyFalse(second.persistenceSucceeded);
            testCase.verifyTrue(writer(baseRecord(8,1,1)));
        end

        function versionsAndExternalContractAreRecorded(testCase)
            writer = makeWriter(false);
            [result, stored] = iiw.evidence.recordEvidence(baseRecord(7,4,1),writer,uint8(2),policy());
            testCase.verifyEqual(stored.softwareVersion,uint16(4));
            testCase.verifyEqual(result.evidenceRecord.dataVersionCount,uint8(1));
            testCase.verifyEqual(result.evidenceRecord.modelVersionCount,uint8(1));
            testCase.verifyEqual(result.evidenceRecord.configurationVersionCount,uint8(1));
            testCase.verifyEqual(result.evidenceRecord.integrityMetadata,uint32(7));
        end

        function sha256IsDeterministic(testCase)
            [first,~] = iiw.evidence.recordEvidence(baseRecord(1,1,1),makeWriter(false),uint8(1),policy());
            [second,~] = iiw.evidence.recordEvidence(baseRecord(1,1,1),makeWriter(false),uint8(1),policy());
            testCase.verifyEqual(first.localDigest,second.localDigest);
            testCase.verifyClass(first.localDigest,"uint8");
            testCase.verifySize(first.localDigest,[32 1]);
        end

        function changedContentInvalidatesDigest(testCase)
            stored = sealedRecord(baseRecord(1,1,1));
            changed = stored;
            changed.outputArtifactRef = uint32(999);
            validation = iiw.evidence.validateEvidenceChain(changed,policy());
            testCase.verifyFalse(validation.valid);
            testCase.verifyEqual(validation.integrityFailureCount,uint16(1));
        end

        function submitRolesOneThroughThreeAreAuthorized(testCase)
            [one,~] = iiw.evidence.recordEvidence(baseRecord(1,1,1),makeWriter(false),uint8(1),policy());
            [two,~] = iiw.evidence.recordEvidence(baseRecord(2,1,1),makeWriter(false),uint8(2),policy());
            [three,~] = iiw.evidence.recordEvidence(baseRecord(3,1,1),makeWriter(false),uint8(3),policy());
            testCase.verifyTrue(one.persistenceSucceeded);
            testCase.verifyTrue(two.persistenceSucceeded);
            testCase.verifyTrue(three.persistenceSucceeded);
        end

        function readOnlyAndUnknownRolesCannotSubmit(testCase)
            [reviewer,~] = iiw.evidence.recordEvidence(baseRecord(1,1,1),makeWriter(false),uint8(4),policy());
            [unknown,~] = iiw.evidence.recordEvidence(baseRecord(2,1,1),makeWriter(false),uint8(0),policy());
            testCase.verifyFalse(reviewer.persistenceSucceeded);
            testCase.verifyFalse(unknown.persistenceSucceeded);
            testCase.verifyEqual(reviewer.failureCode,uint8(5));
            testCase.verifyEqual(unknown.failureCode,uint8(5));
        end

        function retentionDefaultAndHoldAreEnforced(testCase)
            defaulted = baseRecord(1,1,1);
            defaulted.retentionDays = uint16(0);
            [defaultResult, defaultStored] = iiw.evidence.recordEvidence(defaulted,makeWriter(false),uint8(1),policy());
            held = baseRecord(2,1,1);
            held.retentionHold = true;
            [heldResult, heldStored] = iiw.evidence.recordEvidence(held,makeWriter(false),uint8(1),policy());
            testCase.verifyEqual(defaultStored.retentionDays,uint16(365));
            testCase.verifyTrue(defaultResult.deletionEligible);
            testCase.verifyFalse(heldResult.deletionEligible);
            testCase.verifyTrue(heldStored.retentionHold);
        end

        function unavailableAndFailingWritersAreControlled(testCase)
            [unavailable,~] = iiw.evidence.recordEvidence(baseRecord(1,1,1),[],uint8(1),policy());
            [failed,~] = iiw.evidence.recordEvidence(baseRecord(2,1,1),makeWriter(true),uint8(1),policy());
            testCase.verifyEqual(unavailable.failureCode,uint8(6));
            testCase.verifyEqual(failed.failureCode,uint8(7));
            testCase.verifyFalse(unavailable.successRecorded);
            testCase.verifyFalse(failed.successRecorded);
        end

        function invalidInputCreatesNoSyntheticSuccess(testCase)
            record = baseRecord(1,1,1);
            record.recordId = uint32(0);
            [result, stored] = iiw.evidence.recordEvidence(record,makeWriter(false),uint8(1),policy());
            testCase.verifyFalse(result.persistenceSucceeded);
            testCase.verifyTrue(result.failureRecorded);
            testCase.verifyFalse(result.successRecorded);
            testCase.verifyEqual(result.evidenceRecord.recordId,uint32(0));
            testCase.verifyEqual(stored.recordId,uint32(0));
            testCase.verifyEqual(result.localDigest,zeros(32,1,"uint8"));
        end

        function prohibitedPrivateOrRawContentIsRejected(testCase)
            named = baseRecord(1,1,1);
            named.personalName = "not permitted";
            raw = baseRecord(2,1,1);
            raw.rawImage = zeros(2,2,"uint8");
            [nameResult,~] = iiw.evidence.recordEvidence(named,makeWriter(false),uint8(1),policy());
            [rawResult,~] = iiw.evidence.recordEvidence(raw,makeWriter(false),uint8(1),policy());
            testCase.verifyFalse(nameResult.persistenceSucceeded);
            testCase.verifyFalse(rawResult.persistenceSucceeded);
        end

        function repeatedExecutionIsDeterministic(testCase)
            [first, firstStored] = iiw.evidence.recordEvidence(baseRecord(1,1,1),makeWriter(false),uint8(1),policy());
            [second, secondStored] = iiw.evidence.recordEvidence(baseRecord(1,1,1),makeWriter(false),uint8(1),policy());
            testCase.verifyEqual(first,second);
            testCase.verifyEqual(firstStored,secondStored);
        end

        function malformedInputReturnsExactControlledOutput(testCase)
            [result, stored] = iiw.evidence.recordEvidence(struct(),makeWriter(false),uint8(1),policy());
            testCase.verifyEqual(string(fieldnames(result)),resultFields());
            testCase.verifyEqual(result.evidenceRecord.recordId,uint32(0));
            testCase.verifyEqual(stored.recordId,uint32(0));
            testCase.verifyTrue(result.humanReviewRequired);
        end

        function outputsContainNoCommandAuthority(testCase)
            [result,~] = iiw.evidence.recordEvidence(baseRecord(1,1,1),makeWriter(false),uint8(1),policy());
            prohibited = ["autonomousAction","missionCommand","approvalCommand", ...
                "safetyCommand","MissionSupervisor","ReturnToHome","SafeLanding"];
            testCase.verifyEmpty(intersect(string(fieldnames(result)),prohibited));
            testCase.verifyEmpty(intersect(string(fieldnames(result.evidenceRecord)),prohibited));
        end
    end
end

function p = policy()
p = struct("policyVersion",uint16(1),"schemaVersion",uint16(1), ...
    "defaultRetentionDays",uint16(365));
end

function r = baseRecord(recordId,transactionId,stageId)
r = struct("recordId",uint32(recordId),"transactionId",uint32(transactionId), ...
    "stageId",uint32(stageId),"actorOrComponent",uint32(101), ...
    "inputEvidenceRefs",zeros(16,1,"uint32"),"inputReferenceCount",uint8(0), ...
    "outputArtifactRef",uint32(501),"dataVersions",[uint16(1);zeros(15,1,"uint16")], ...
    "dataVersionCount",uint8(1),"modelVersions",[uint16(2);zeros(15,1,"uint16")], ...
    "modelVersionCount",uint8(1),"configurationVersions",[uint16(3);zeros(15,1,"uint16")], ...
    "configurationVersionCount",uint8(1),"softwareVersion",uint16(4), ...
    "timestamp",uint64(1770000000000),"outcome",uint8(1),"failureStatus",uint8(0), ...
    "policyVersion",uint16(1),"schemaVersion",uint16(1), ...
    "retentionDays",uint16(365),"retentionHold",false);
end

function stored = sealedRecord(record)
[result,stored] = iiw.evidence.recordEvidence(record,makeWriter(false),uint8(1),policy());
assert(result.persistenceSucceeded);
end

function names = externalFields()
names = ["recordId";"eventType";"artifactRefs";"dataVersions"; ...
    "modelVersions";"configurationVersions";"actorOrComponent";"timestamp"; ...
    "outcome";"integrityMetadata";"artifactReferenceCount";"dataVersionCount"; ...
    "modelVersionCount";"configurationVersionCount"];
end

function names = resultFields()
names = ["persistenceSucceeded";"failureRecorded";"successRecorded"; ...
    "humanReviewRequired";"failureCode";"evidenceRecord";"localDigest"; ...
    "deletionEligible"];
end

function writer = makeWriter(failWrites)
recordIds = zeros(1,0,"uint32");
writer = @append;
    function ok = append(record)
        if failWrites || any(recordIds == record.recordId)
            ok = false;
            return
        end
        recordIds(end+1) = record.recordId;
        ok = true;
    end
end
