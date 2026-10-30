# Independent Verification Review

**Template Version:** 1.0.0
**Shared Workflow Version:** 1.0.0

## 1. Review Identification

| Field | Entry |
|---|---|
| Review ID | IVR-[PROJECT]-[YYYYMMDD]-[00X] |
| Associated ECR | ECR-[YYYYMMDD]-[00X] |
| Project | [Project name] |
| Candidate branch/baseline | [Branch and commit/version] |
| Implementer | [Name] |
| Independent reviewer | [Different named individual] |
| Review date | [YYYY-MM-DD] |
| AI assistance | [None or disclosed details] |

## 2. Independence Declaration

The reviewer shall confirm all items:

- [ ] I am a different named individual from the implementer.
- [ ] I did not author the candidate behavior being independently verified.
- [ ] I did not author the complete expected-result set being relied upon as sole evidence.
- [ ] I have no unresolved conflict of interest affecting this decision.
- [ ] I understand that a separate AI-agent session alone does not establish independence.

If any item cannot be confirmed, stop and escalate before reviewing.

## 3. Frozen Candidate

| Artifact | Version/hash | Changed during review? |
|---|---|---|
| [Path or identifier] | [Value] | [No required] |

Any candidate change invalidates the review and requires a new frozen baseline.

## 4. Evidence Reviewed

- [ ] Approved ECR and scope
- [ ] Approved requirements and acceptance criteria
- [ ] Approved implementation and test plans
- [ ] Architecture and interfaces
- [ ] Implementation artifacts
- [ ] Configuration and dependencies
- [ ] Developer diagnostics and test results
- [ ] Traceability
- [ ] Coverage or proportionate completeness evidence
- [ ] Assumptions, deviations, residual risks, and rollback

## 5. Reproduction and Review Results

| Review area | Method/evidence | Result | Comments |
|---|---|---|---|
| Requirements | [Method] | [Pass/Fail/Observation] | [Details] |
| Implementation | [Method] | [Pass/Fail/Observation] | [Details] |
| Tests/results | [Method] | [Pass/Fail/Observation] | [Details] |
| Traceability | [Method] | [Pass/Fail/Observation] | [Details] |
| Coverage/completeness | [Method] | [Pass/Fail/Observation] | [Details] |

## 6. Findings

| Finding ID | Severity | Description | Required corrective action | Owner |
|---|---|---|---|---|
| [ID] | [Major/Minor/Observation] | [Finding] | [Action] | [Role/name] |

The reviewer shall not repair implementation findings during the same independent review.

## 7. Gate 5 - Independent Verification Decision

Select exactly one:

- [ ] PASS
- [ ] PASS WITH OBSERVATIONS
- [ ] FAIL / CORRECTIVE ACTION REQUIRED

| Decision field | Entry |
|---|---|
| Reviewer name | [Named individual] |
| Reviewer role | Independent Verification & Validation Engineer |
| Date | [YYYY-MM-DD] |
| Decision rationale | [Evidence-based rationale] |
| Open findings | [None or IDs] |
| Required re-review scope | [None or scope] |

## 8. Project Owner Disposition

| Approval field | Entry |
|---|---|
| Project Owner | [Name] |
| Independent decision reviewed | [Yes/No] |
| Disposition | [Proceed to final acceptance / Return for corrective action] |
| Date | [YYYY-MM-DD] |
| Conditions | [None or details] |

This disposition is not itself the Gate 6 final-acceptance record unless the approved change report explicitly records that decision.
