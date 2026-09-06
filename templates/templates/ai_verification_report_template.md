# AI Verification Report

**Template Version:** 1.0.0  
**Shared Workflow Version:** 1.0.0

This template separates developer evidence, independent verification, and final acceptance. Record only executed or inspected evidence.

## 1. Identification and Ownership

| Field | Entry |
|---|---|
| Verification report ID | [Stable ID] |
| Associated ECR/project | [IDs] |
| Candidate branch/baseline | [Branch and commit/version] |
| Candidate artifact hashes | [Values/path] |
| Report owner | [Name/role] |
| Implementer | [Name/role] |
| Verification executor | [Name/role] |
| Independent reviewer | [Different named individual/TBD] |
| Project Owner | [Name] |
| Execution date | [YYYY-MM-DD] |
| Report status | [DRAFT / DEVELOPER EVIDENCE COMPLETE / INDEPENDENTLY REVIEWED] |

## 2. Approved Scope and Authority

- **Approved requirements:** [Stable IDs]
- **Acceptance criteria:** [Stable IDs]
- **Implementation-plan approval:** [Gate/reference]
- **Verification-plan approval:** [Reference]
- **Artifacts in scope:** [Exact paths/versions]
- **Explicit exclusions:** [Items]
- **Dependencies and availability evidence:** [References]
- **Prohibited direct outputs and external authority:** [Boundary]

## 3. Candidate Configuration

| Item | ID/version/hash | Owner | Evidence path |
|---|---|---|---|
| Architecture/interfaces | [Value] | [Name/role] | [Path] |
| Dataset and manifest | [Value] | [Name/role] | [Path] |
| Dataset provenance and license approval | [Value] | [Name/role] | [Path] |
| Train/validation/test split | [Value] | [Name/role] | [Path] |
| Leakage assessment | [Result/version] | [Name/role] | [Path] |
| Preprocessing/features | [Value] | [Name/role] | [Path] |
| Model/implementation | [Value] | [Name/role] | [Path] |
| Risk and approval policy | [Value] | [Name/role] | [Path] |
| Runtime/dependencies | [Value] | [Name/role] | [Path] |

## 4. Requirement and Acceptance-Criterion Matrix

| Requirement ID | Acceptance criterion | Verification ID/method | Expected result | Evidence path | Result |
|---|---|---|---|---|---|
| [REQ-ID] | [Criterion] | [TST/ANL/REV-ID] | [Expected] | [Path] | [PASS/FAIL/PENDING] |

## 5. Functional, Robustness, and Failure Evidence

| Scenario ID | Category | Input/precondition | Expected behavior | Observed behavior | Evidence | Result |
|---|---|---|---|---|---|---|
| [ID] | Normal | [Details] | [Behavior] | [Observed/PENDING] | [Path] | [Status] |
| [ID] | Uncertain/low confidence | [Details] | [Behavior] | [Observed/PENDING] | [Path] | [Status] |
| [ID] | Invalid | [Details] | [Behavior] | [Observed/PENDING] | [Path] | [Status] |
| [ID] | Degraded | [Details] | [Behavior] | [Observed/PENDING] | [Path] | [Status] |
| [ID] | Rejected | [Details] | [Behavior] | [Observed/PENDING] | [Path] | [Status] |
| [ID] | Approval timeout/expiration | [Details] | [Behavior] | [Observed/PENDING] | [Path] | [Status] |
| [ID] | Component/evidence failure | [Details] | [Behavior] | [Observed/PENDING] | [Path] | [Status] |

## 6. Metrics and Operating Slices

Report only applicable, approved, executed metrics.

| Task | Metric | Dataset/split version | Slice | Support | Threshold | Observed result | Result | Evidence |
|---|---|---|---|---:|---:|---:|---|---|
| Classification | [Metric] | [Version] | [Slice] | [Value] | [Value] | [Value/PENDING] | [Status] | [Path] |
| Detection | [Metric] | [Version] | [Slice] | [Value] | [Value] | [Value/PENDING] | [Status] | [Path] |
| Segmentation | [Metric] | [Version] | [Slice] | [Value] | [Value] | [Value/PENDING] | [Status] | [Path] |
| Regression | [Metric] | [Version] | [Slice] | [Value] | [Value] | [Value/PENDING] | [Status] | [Path] |
| Confidence/uncertainty | [Metric] | [Version] | [Slice] | [Value] | [Value] | [Value/PENDING] | [Status] | [Path] |

## 7. Approval and External-Authority Verification

| Case | Required outcome | Evidence | Result |
|---|---|---|---|
| Missing approval | No forwarding | [Path] | [Status] |
| Pending/deferred approval | No forwarding | [Path] | [Status] |
| Rejected approval | No forwarding | [Path] | [Status] |
| Expired approval | No forwarding | [Path] | [Status] |
| Approved and valid | Advisory forwarding only | [Path] | [Status] |
| External safety response during approval wait | Not blocked, delayed, masked, or replaced | [Path] | [Status] |
| Attempted direct safety-critical command | Rejected | [Path] | [Status] |

## 8. Traceability and Evidence Completeness

| Chain ID | Requirement | Component/procedure | Verification/result | Dataset/model/configuration versions | Evidence path | Link status |
|---|---|---|---|---|---|---|
| [ID] | [REQ-ID] | [Element] | [ID/result] | [Versions] | [Path] | [Complete/Broken/Pending] |

- **Missing links:** [None/IDs]
- **Broken links:** [Count/IDs]
- **Evidence integrity method/result:** [Details]
- **Unfabricated-evidence check:** [Method/result]

## 9. Diagnostics, Warnings, and Deviations

| ID | Type | Description | Impact | Owner | Disposition/status | Evidence |
|---|---|---|---|---|---|---|
| [ID] | [Warning/error/deviation] | [Details] | [Impact] | [Name/role] | [Status] | [Path] |

## 10. Limitations and Residual Risks

| ID | Limitation/risk | Affected use/slice | Severity | Mitigation | Owner | Acceptance status |
|---|---|---|---|---|---|---|
| [ID] | [Details] | [Scope] | [Value] | [Action] | [Name/role] | [Status] |

## 11. Developer Evidence Declaration

| Field | Entry |
|---|---|
| Implementer name/role | [Name/role] |
| Date | [YYYY-MM-DD] |
| Approved scope completed | [Yes/No/details] |
| Developer evidence status | [COMPLETE/INCOMPLETE/FAILED] |
| Unresolved findings | [None/IDs] |
| Declaration | This evidence is not independent verification or final acceptance. |

## 12. Independent Verification

| Field | Entry |
|---|---|
| Independent reviewer | [Different named individual] |
| Reviewer role | Independent Verification & Validation Engineer |
| Independence declaration | [Confirmed/PENDING] |
| Frozen candidate verified unchanged | [Yes/No] |
| Evidence independently inspected/reproduced | [References] |
| Review date | [YYYY-MM-DD] |
| Decision | [PASS / PASS WITH OBSERVATIONS / FAIL / CORRECTIVE ACTION REQUIRED] |
| Findings | [None/IDs] |
| AI assistance disclosed | [Yes/No/details] |

The reviewer shall not repair the implementation during the same independent review.

## 13. Project Owner Disposition

| Field | Entry |
|---|---|
| Project Owner | [Name] |
| Independent decision reviewed | [Yes/No] |
| Final decision | [PENDING / ACCEPTED / REJECTED / RETURNED FOR CORRECTIVE ACTION] |
| Date | [YYYY-MM-DD] |
| Accepted scope | [Exact scope] |
| Conditions, deviations, or residual risks | [None/details] |

No release or approved-baseline claim is permitted before the recorded final decision.
