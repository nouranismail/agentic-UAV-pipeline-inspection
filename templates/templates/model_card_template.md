# Model and Algorithm Card

**Template Version:** 1.0.0  
**Shared Workflow Version:** 1.0.0

Use for conventional, learned, regression, or deterministic implementations. Do not infer performance from installation or artifact existence.

## 1. Identification and Ownership

| Field | Entry |
|---|---|
| Model/implementation ID | [Stable ID] |
| Name and type | [Name / type] |
| Version | [Immutable version] |
| Artifact path and hash | [Path / integrity value] |
| Associated project/ECR | [IDs] |
| Owner | [Name/role] |
| Developer | [Name/role] |
| Reviewer | [Name/role/TBD] |
| Creation/update date | [YYYY-MM-DD] |
| Status | [DRAFT / CANDIDATE / APPROVED / RETIRED] |

## 2. Intended Use and Requirements

- **Purpose:** [Description]
- **Intended users:** [Users]
- **Permitted operating envelope:** [Scope]
- **Out-of-scope uses:** [Scope]
- **Inputs and outputs:** [Contract IDs/versions]
- **Operational-change boundary:** [Advisory/approval behavior]
- **External safety-critical authority:** [Reference]

| Requirement ID | Requirement summary | Acceptance criterion | Owner |
|---|---|---|---|
| [REQ-ID] | [Summary] | [Criterion] | [Name/role] |

## 3. Dataset and Split Provenance

| Dataset role | Dataset ID/version | Membership/split version | License approval | Leakage result | Evidence path |
|---|---|---|---|---|---|
| Training | [Value/N/A] | [Value] | [Reference] | [Result] | [Path] |
| Validation | [Value/N/A] | [Value] | [Reference] | [Result] | [Path] |
| Test | [Value/N/A] | [Value] | [Reference] | [Result] | [Path] |

- **Dataset-governance record:** [ID/path]
- **Pretrained or external data:** [Versions, rights, overlap assessment]

## 4. Configuration and Reproducibility

| Item | Version/value | Evidence |
|---|---|---|
| Implementation source | [Commit/path/hash] | [Path] |
| Training configuration | [Version/path/Not Applicable] | [Path] |
| Random-state controls | [Values/Not Applicable] | [Path] |
| Preprocessing configuration | [Version] | [Path] |
| Feature schema/extractor | [Version] | [Path] |
| Taxonomy or target definition | [Version] | [Path] |
| Dependencies/runtime | [Versions] | [Path] |
| Compute environment | [Description] | [Path] |

## 5. Model Structure and Decision Behavior

- **Method/architecture:** [Description]
- **Parameter count or complexity:** [Value/Not Applicable]
- **Training or fitting procedure:** [Description/Not Applicable]
- **Decision thresholds:** [Values and approval references]
- **Confidence semantics:** [Definition/domain]
- **Uncertainty representation:** [Definition/domain]
- **Low-confidence or excessive-uncertainty disposition:** [Review/reacquisition/non-action]
- **Invalid or unavailable input behavior:** [Behavior]

## 6. Metrics and Operating Slices

Record only executed results.

| Task | Metric | Dataset/split | Operating slice | Support | Threshold | Observed result | Pass/fail | Evidence |
|---|---|---|---|---:|---:|---:|---|---|
| Classification | [Precision/recall/F1/etc.] | [Version] | [Slice] | [Value] | [Value] | [Value/PENDING] | [Status] | [Path] |
| Detection | [Average precision/localization/etc.] | [Version] | [Slice] | [Value] | [Value] | [Value/PENDING] | [Status] | [Path] |
| Segmentation | [Overlap/boundary/etc.] | [Version] | [Slice] | [Value] | [Value] | [Value/PENDING] | [Status] | [Path] |
| Regression | [MAE/RMSE/bias/etc.] | [Version] | [Slice] | [Value] | [Value] | [Value/PENDING] | [Status] | [Path] |
| Calibration/uncertainty | [Metric] | [Version] | [Slice] | [Value] | [Value] | [Value/PENDING] | [Status] | [Path] |

## 7. Robustness and Failure Handling

| Scenario | Expected behavior | Observed result | Evidence | Status |
|---|---|---|---|---|
| Normal | [Behavior] | [Result/PENDING] | [Path] | [Status] |
| Uncertain/low confidence | [Behavior] | [Result/PENDING] | [Path] | [Status] |
| Invalid input | [Behavior] | [Result/PENDING] | [Path] | [Status] |
| Degraded input | [Behavior] | [Result/PENDING] | [Path] | [Status] |
| Rejected input | [Behavior] | [Result/PENDING] | [Path] | [Status] |
| Component unavailable/failure | [Behavior] | [Result/PENDING] | [Path] | [Status] |
| Out-of-distribution input | [Behavior] | [Result/PENDING] | [Path] | [Status] |

## 8. Limitations and Residual Risks

| ID | Limitation/risk | Affected slice/use | Impact | Mitigation | Owner | Residual status |
|---|---|---|---|---|---|---|
| [ID] | [Details] | [Scope] | [Impact] | [Action] | [Name/role] | [Status] |

## 9. Traceability and Evidence

| Requirement ID | Implementation element | Verification ID/result | Evidence path | Status |
|---|---|---|---|---|
| [REQ-ID] | [Element] | [ID/result] | [Path] | [Status] |

## 10. Approval Decisions

| Decision | Approver name/role | Date | Scope | Conditions/deviations |
|---|---|---|---|---|
| Dataset/metric approval | [Name/role] | [YYYY-MM-DD] | [Scope] | [Details] |
| Candidate approval | [Name/role] | [YYYY-MM-DD] | [Scope] | [Details] |

## 11. Independent Verification

| Field | Entry |
|---|---|
| Frozen candidate hash/version | [Value] |
| Independent reviewer | [Different named individual/TBD] |
| Independence declaration | [Confirmed/PENDING] |
| Review evidence | [Paths] |
| Decision | [PENDING / PASS / PASS WITH OBSERVATIONS / FAIL / CORRECTIVE ACTION REQUIRED] |
| Findings | [None/IDs] |

Developer evaluation is not independent verification or final acceptance.
