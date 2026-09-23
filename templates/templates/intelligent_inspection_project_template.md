# Intelligent-Inspection Project Definition

**Template Version:** 1.0.0  
**Shared Workflow Version:** 1.0.0

Do not treat placeholders as approved facts or evidence.

## 1. Identification and Ownership

| Field | Entry |
|---|---|
| Project ID | [Stable ID] |
| Project name | [Name] |
| Associated ECR | [ECR ID] |
| Branch/baseline | [Branch and commit/version] |
| Project Owner | [Name] |
| Systems Engineer | [Name/TBD] |
| Implementer | [Name/TBD] |
| Dataset owner/steward | [Name/role/TBD] |
| Independent reviewer | [Different named individual/TBD] |
| Workflow version | [Version] |
| Document owner | [Name/role] |
| Document version/date | [Version / YYYY-MM-DD] |

## 2. Objective and Scope

- **Problem and intended use:** [Description]
- **Users and affected operations:** [Description]
- **In scope:** [Items]
- **Out of scope:** [Items]
- **Safety-critical authority:** [External approved mechanism]
- **Prohibited direct outputs:** [Commands/endpoints or `None`]

## 3. Requirements and Acceptance Criteria

| Requirement ID | Statement/summary | Rationale | Acceptance criterion | Owner | Status |
|---|---|---|---|---|---|
| [REQ-ID] | [Text] | [Why] | [Objective criterion] | [Name/role] | [Draft/Approved] |

## 4. Architecture and Interfaces

| Component/interface ID | Responsibility or contract | Inputs | Outputs | Failure behavior | Version/owner |
|---|---|---|---|---|---|
| [ID] | [Definition] | [Contracts] | [Contracts] | [Behavior] | [Version/name] |

- **Reusable artifacts:** [Paths/versions]
- **Project-selected configuration:** [Sources, taxonomy, units, thresholds, implementations, policies, mappings]
- **Source types:** [Real/recorded/simulated selections]
- **Replaceability constraints:** [Contract invariants]

## 5. Dataset Governance

- **Dataset-governance record:** [ID/path]
- **Dataset ID/version:** [Values]
- **Owner and approved use:** [Name/scope]
- **Provenance and license:** [References]
- **Train/validation/test split:** [Method/version]
- **Leakage assessment:** [Result/evidence]
- **Approval status:** [PENDING/APPROVED/REJECTED]

No training may start while any mandatory dataset field or approval is pending.

## 6. Model and Algorithm Configuration

| Model/implementation ID | Type | Version/hash | Dataset version | Configuration | Owner | Approval status |
|---|---|---|---|---|---|---|
| [ID] | [Conventional/learned/regression/deterministic] | [Value] | [Value/N/A] | [Reference] | [Name/role] | [Status] |

## 7. Metrics and Operating Slices

| Task | Metric | Slice | Minimum support | Pass threshold | Rationale | Approval reference |
|---|---|---|---:|---:|---|---|
| [Classification/detection/segmentation/regression/quality/approval] | [Metric] | [Slice] | [Value] | [Value] | [Why] | [Record] |

- **Confidence definition and threshold:** [Definition/reference]
- **Uncertainty method and limit:** [Definition/reference]
- **Invalid/degraded disposition:** [Review/reacquisition/non-action policy]

## 8. Approval and Operational-Change Controls

| Control | Approved value/behavior | Owner | Evidence |
|---|---|---|---|
| Approver roles and identity | [Value] | [Name/role] | [Reference] |
| Pending/rejected/deferred behavior | [Value] | [Name/role] | [Reference] |
| Timeout/expiration/delegation/escalation | [Value] | [Name/role] | [Reference] |
| Validity interval | [Value] | [Name/role] | [Reference] |
| External safety priority | [How independence is preserved] | [Name/role] | [Reference] |

## 9. Verification and Traceability

| Requirement ID | Component/procedure | Verification ID | Expected result | Evidence path | Status |
|---|---|---|---|---|---|
| [REQ-ID] | [Element] | [TST/ANL/REV-ID] | [Criterion] | [Path] | [Pending/Pass/Fail] |

Required scenarios include normal, uncertain, invalid, degraded, rejected, timeout, unavailable, and failure behavior.

## 10. Limitations, Assumptions, and Residual Risks

| ID | Type | Description | Impact | Owner | Disposition/status |
|---|---|---|---|---|---|
| [ID] | [Assumption/limitation/risk] | [Details] | [Impact] | [Name/role] | [Status] |

## 11. Evidence Index

| Evidence ID | Description | Artifact/version | Path | Integrity/hash | Owner |
|---|---|---|---|---|---|
| [ID] | [Description] | [Value] | [Path] | [Value] | [Name/role] |

## 12. Approval Decisions

| Gate/decision | Approver name | Approver role | Decision | Date | Approved scope | Conditions/deviations |
|---|---|---|---|---|---|---|
| [Gate] | [Name] | [Role] | [Decision] | [YYYY-MM-DD] | [Scope] | [Details] |

## 13. Independent Verification

| Field | Entry |
|---|---|
| Candidate version/hashes | [Values] |
| Reviewer | [Different named individual] |
| Independence declaration | [Confirmed/PENDING] |
| Evidence reviewed | [References] |
| Decision | [PENDING / PASS / PASS WITH OBSERVATIONS / FAIL / CORRECTIVE ACTION REQUIRED] |
| Findings and residual risks | [IDs/details] |

Developer checks are not independent verification or final acceptance.
