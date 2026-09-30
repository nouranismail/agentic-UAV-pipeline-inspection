# Implementation Plan

**Template Version:** 1.0.0
**Shared Workflow Version:** 1.0.0

## 1. Identification and Authority

| Field | Entry |
|---|---|
| Associated ECR ID | ECR-[YYYYMMDD]-[00X] |
| Project | [Project name] |
| Branch/baseline | [Branch and commit/version] |
| Plan author | [Name] |
| Author role | [Canonical role] |
| Planned implementer | [Name/TBD] |
| Independent reviewer | [Different named individual/TBD] |
| Status | [DRAFT / APPROVED / REJECTED] |

## 2. Approved Requirements and Acceptance Criteria

| Requirement ID | Requirement summary | Acceptance criterion |
|---|---|---|
| [REQ-ID] | [Summary] | [Objective criterion] |

## 3. Architecture, Interfaces, and Safety

- **Architecture impact:** [Elements and rationale]
- **Interface impact:** [Inputs, outputs, types, units, rates, or `None`]
- **Safety/hazard impact:** [Priorities, fail-safe behavior, hazard controls, or `None`]
- **Downstream impact:** [Consumers or `None`]

## 4. Exact Implementation Scope

### Modify

- [Exact path and element]

### Create

- [Exact path]

### Read-only

- [Artifact inspected but not changed]

### Explicit exclusions

- [Prohibited artifact or activity]

## 5. Configuration and Dependencies

- **Configuration/data changes:** [Dictionary, parameter, setting, or `None`]
- **Approved products/libraries:** [List]
- **New dependency:** [None, or approval reference]
- **Version compatibility:** [Details]

## 6. Controlled Modification Method

[Describe the ordered, minimal edits and the responsible role.]

## 7. Traceability Strategy

| Requirement | Implementation element | Planned test/evidence |
|---|---|---|
| [REQ-ID] | [Element] | [Test ID/evidence] |

## 8. Test and Verification Strategy

- **Test-plan reference:** [Plan ID/path]
- **Developer checks:** [Diagnostics, simulations, tests, static checks]
- **Regression scope:** [Affected suites]
- **Coverage objectives:** [Metrics or `Not Applicable` with rationale]
- **Independent-review method:** [Frozen candidate, hashes, evidence]
- **Pass/fail criteria:** [Objective criteria]

## 9. Assumptions, Deviations, and Residual Risks

- [Item, owner, and disposition]

## 10. Rollback Plan

[Provide path-specific restoration or removal steps. Do not use destructive repository-wide reset operations.]

## 11. Gate 2 - Requirements Approval

| Approval field | Entry |
|---|---|
| Approver name | [Name] |
| Approver role | Project Owner / Approval Authority |
| Decision | [APPROVED / REJECTED / RETURNED FOR REVISION] |
| Date | [YYYY-MM-DD] |
| Approved requirements/scope | [IDs and scope] |
| Conditions or deviations | [None or details] |

## 12. Gate 3 - Implementation Plan Approval

| Approval field | Entry |
|---|---|
| Approver name | [Name] |
| Approver role | Project Owner / Approval Authority |
| Decision | [APPROVED / REJECTED / RETURNED FOR REVISION] |
| Date | [YYYY-MM-DD] |
| Approved implementation scope | [Exact files/elements] |
| Conditions or deviations | [None or details] |

No repository artifact may be modified before Gate 3 approval.
