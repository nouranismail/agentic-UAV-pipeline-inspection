# Verification Test Plan

**Template Version:** 1.0.0
**Shared Workflow Version:** 1.0.0

## 1. Identification

| Field | Entry |
|---|---|
| Test-plan ID | TPL-[PROJECT]-[YYYYMMDD]-[00X] |
| Associated ECR | ECR-[YYYYMMDD]-[00X] |
| Project | [Project name] |
| Candidate branch/baseline | [Branch and commit/version] |
| Test-plan author | [Name] |
| Test owner | [Name/role] |
| Planned independent reviewer | [Different named individual/TBD] |
| Date | [YYYY-MM-DD] |

## 2. Verification Scope

- **Requirements in scope:** [Stable IDs]
- **Implementation elements in scope:** [Paths/elements]
- **Regression scope:** [Suites/components]
- **Out of scope:** [Explicit exclusions]

## 3. Environment and Dependencies

| Item | Required configuration |
|---|---|
| Tool/release | [Version] |
| Approved products/libraries | [List] |
| Platform | [Environment] |
| Project configuration | [Reference] |
| Harness/fixture | [Reference or `Not Applicable`] |

## 4. Preconditions and Isolation

- **Initial state/reset:** [Method]
- **Required data/configuration:** [References]
- **Candidate freeze/hash method:** [Method]
- **Test independence:** [How cases avoid hidden shared state]

## 5. Requirements-to-Test Matrix

| Requirement ID | Test ID | Verification method | Expected evidence |
|---|---|---|---|
| [REQ-ID] | [TST-ID] | [Test/analysis/inspection] | [Result/evidence] |

## 6. Test Cases

| Test ID | Precondition | Inputs/stimulus | Expected result | Pass/fail criterion |
|---|---|---|---|---|
| [TST-ID] | [Condition] | [Inputs] | [Output/behavior] | [Objective criterion] |

## 7. Boundary, Fault, and Priority Scenarios

- [Boundary values]
- [Invalid or unavailable inputs]
- [Simultaneous/priority conditions]
- [Terminal, recovery, or persistence behavior]
- [Error handling]

Mark an item `Not Applicable` only with a rationale.

## 8. Coverage and Completeness Objectives

- **Required metrics:** [Decision/condition/state/code coverage or `Not Applicable`]
- **Target:** [Value and rationale]
- **Infeasible-objective process:** [Analysis, evidence, reviewer disposition]
- **Filtering/exclusion policy:** [Prohibited unless explicitly approved and documented]

## 9. Evidence and Reporting

- **Result artifact:** [Path/system]
- **Logs/tool outputs:** [Path/system]
- **Traceability evidence:** [Path/system]
- **Change-report reference:** [Path/system]

## 10. Test Risks, Assumptions, and Deviations

| Item | Impact | Owner | Required disposition |
|---|---|---|---|
| [Item] | [Impact] | [Name/role] | [Disposition] |

## 11. Test-Plan Approval

| Approval field | Entry |
|---|---|
| Approver name | [Name] |
| Approver role | Project Owner / Approval Authority |
| Decision | [APPROVED / REJECTED / RETURNED FOR REVISION] |
| Date | [YYYY-MM-DD] |
| Approved scope | [Tests/requirements] |
| Conditions or deviations | [None or details] |

Approval of this plan authorizes only the recorded verification scope; it does not record test execution, independent verification, or final acceptance.
