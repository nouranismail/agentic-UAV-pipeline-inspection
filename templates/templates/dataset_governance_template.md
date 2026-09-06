# Dataset Governance Record

**Template Version:** 1.0.0  
**Shared Workflow Version:** 1.0.0

No fitting, tuning, calibration, or training is permitted until required approvals are recorded.

## 1. Identification and Ownership

| Field | Entry |
|---|---|
| Dataset ID | [Stable ID] |
| Dataset name | [Name] |
| Dataset version | [Immutable version] |
| Associated project/ECR | [IDs] |
| Dataset owner | [Name/organization] |
| Dataset steward | [Name/role] |
| Technical custodian | [Name/role] |
| Approval authority | [Name/role] |
| Record owner/version/date | [Name/role / version / YYYY-MM-DD] |

## 2. Provenance and Permitted Use

| Field | Entry |
|---|---|
| Original source | [Source/reference] |
| Acquisition method and dates | [Description/range] |
| Contributors/providers | [Names/agreements] |
| License and version | [License/reference] |
| Permitted uses | [Scope] |
| Prohibited uses | [Scope] |
| Redistribution constraints | [Details] |
| Privacy/confidentiality classification | [Classification] |
| Consent or legal basis | [Reference/Not Applicable with rationale] |
| Retention/deletion policy | [Policy/reference] |

Unresolved ownership, license, privacy, consent, or permitted-use questions are stop conditions.

## 3. Manifest, Versioning, and Integrity

| Artifact | Version | Location | Item count | Integrity/hash | Access owner |
|---|---|---|---:|---|---|
| [Manifest/data/annotation] | [Value] | [Path/system] | [Value] | [Value] | [Name/role] |

- **Immutable membership definition:** [Method]
- **Change/version policy:** [Method]
- **Removal/correction record:** [Reference]
- **Backup and recovery:** [Method]

## 4. Acquisition and Annotation

| Area | Definition/version | Owner | Quality control | Evidence |
|---|---|---|---|---|
| Acquisition protocol | [Value] | [Name/role] | [Checks] | [Path] |
| Taxonomy/target definition | [Value] | [Name/role] | [Checks] | [Path] |
| Annotation procedure | [Value] | [Name/role] | [Review/adjudication] | [Path] |
| Exclusion/deduplication policy | [Value] | [Name/role] | [Checks] | [Path] |

## 5. Train, Validation, and Test Split

| Split | Membership version/path | Count | Percentage | Grouping/stratification rule | Frozen? |
|---|---|---:|---:|---|---|
| Train | [Reference] | [Value] | [Value] | [Rule] | [Yes/No] |
| Validation | [Reference] | [Value] | [Value] | [Rule] | [Yes/No] |
| Test | [Reference] | [Value] | [Value] | [Rule] | [Yes/No] |

- **Split seed or deterministic assignment:** [Value/method]
- **Related-item grouping:** [Identity, sequence, source, time, or other rule]
- **External evaluation data:** [Reference/None]
- **Test-set access controls:** [Controls]

## 6. Leakage Assessment

| Leakage mechanism | Check method | Result | Evidence | Required action |
|---|---|---|---|---|
| Exact/near duplicates across splits | [Method] | [PASS/FAIL/PENDING] | [Path] | [Action] |
| Related identity or sequence across splits | [Method] | [Result] | [Path] | [Action] |
| Temporal or source adjacency | [Method] | [Result] | [Path] | [Action] |
| Target-derived input or preprocessing leakage | [Method] | [Result] | [Path] | [Action] |
| Annotation or human-process leakage | [Method] | [Result] | [Path] | [Action] |
| External/pretrained-data overlap | [Method] | [Result] | [Path] | [Action] |

Any unresolved material leakage blocks training and performance claims.

## 7. Representativeness and Operating Slices

| Slice ID | Definition | Count by split | Known gap/bias | Minimum support | Disposition |
|---|---|---|---|---:|---|
| [ID] | [Definition] | [Values] | [Details] | [Value] | [Action/status] |

- **Class/target distribution:** [Evidence]
- **Missing or degraded conditions:** [Evidence]
- **Known distribution shift:** [Evidence]
- **Out-of-scope populations/conditions:** [List]

## 8. Processing and Feature Provenance

| Stage | Implementation/configuration version | Fit on which split? | Output reference | Leakage control |
|---|---|---|---|---|
| [Quality/preprocessing/feature extraction] | [Value] | [Split/Not fitted] | [Path] | [Control] |

## 9. Metrics and Acceptance Criteria

| Requirement ID | Task | Metric | Slice | Threshold | Rationale | Approver |
|---|---|---|---|---:|---|---|
| [REQ-ID] | [Task] | [Metric] | [Slice] | [Value] | [Why] | [Name/role] |

## 10. Traceability and Evidence

| Requirement/decision ID | Dataset artifact | Check/result ID | Evidence path | Status |
|---|---|---|---|---|
| [ID] | [Version/path] | [ID] | [Path] | [Status] |

## 11. Limitations and Residual Risks

| ID | Limitation/risk | Impact | Owner | Mitigation | Residual status |
|---|---|---|---|---|---|
| [ID] | [Details] | [Impact] | [Name/role] | [Action] | [Status] |

## 12. Approval Decision

| Field | Entry |
|---|---|
| Approver name | [Name] |
| Approver role | [Project Owner / delegated recorded authority] |
| Decision | [APPROVED / REJECTED / RETURNED FOR REVISION] |
| Date | [YYYY-MM-DD] |
| Approved dataset version and use | [Exact scope] |
| Approved split/version | [Exact references] |
| Conditions or deviations | [None/details] |

## 13. Independent Verification

| Field | Entry |
|---|---|
| Reviewer | [Different named individual/TBD] |
| Independence declaration | [Confirmed/PENDING] |
| Manifest and split integrity reviewed | [Yes/No/PENDING] |
| License/provenance reviewed | [Yes/No/PENDING] |
| Leakage evidence reviewed | [Yes/No/PENDING] |
| Decision/findings | [Decision and IDs] |

Dataset approval, implementation completion, independent verification, and final acceptance are separate decisions.
