# Generic Intelligent-Inspection Requirements

**Associated ECR:** ECR-20260906-001

**Status:** APPROVED — Gate 2 on 2026-09-06

**Scope:** Application-independent inspection workflow

These requirements define observable behavior and governance constraints. They do not prescribe algorithms, datasets, trained models, or performance claims.

| ID | Requirement statement | Rationale | Objective acceptance criterion |
|---|---|---|---|
| IIW-REQ-001 | The workflow shall accept inspection data and acquisition metadata through a versioned inspection-source contract. | Allows sources to be replaced without changing downstream components. | Contract inspection confirms mandatory payload reference, modality, source identifier, timestamp, sequence identifier, and schema version fields. |
| IIW-REQ-002 | When inspection data is received, the workflow shall validate payload availability, schema conformance, metadata completeness, and configured quality measures before analysis. | Prevents unsuitable inputs from reaching analysis components. | Every submitted item produces exactly one quality result containing status, measured values, configured thresholds, and reason codes. |
| IIW-REQ-003 | If data quality is rejected, the workflow shall prevent autonomous action generation from that data and shall request reacquisition or review. | Enforces fail-controlled behavior for unsuitable evidence. | A rejected quality result produces no actionable recommendation and produces a recorded reacquisition-or-review disposition. |
| IIW-REQ-004 | Only when quality validation returns `PASS`, preprocessing shall apply the approved deterministic, configured transformations and produce a versioned processed-data reference and transformation record without altering the source record. A `REVIEW` or `REJECT` result shall not be transformed into apparently acceptable data. | Preserves provenance and reproducibility while preventing preprocessing from bypassing data-quality disposition. | Each processed output references a `PASS` source item and records every applied operation, parameter value, execution order, implementation version, and configuration version; `REVIEW` and `REJECT` inputs produce no processed-data output. |
| IIW-REQ-005 | The detection capability shall be replaceable through a common detection contract. | Supports interchangeable conventional and learned implementations. | Two conforming mock implementation descriptions can be substituted without changing the consuming interface definitions. |
| IIW-REQ-006 | Where a learned detection implementation is selected, it shall publish model identity, version, input contract, output contract, and confidence semantics. | Prevents opaque model substitution. | The model record contains all five fields and is linked by identifier from every corresponding detection result. |
| IIW-REQ-007 | Detection results shall identify the analyzed item, detected label identifiers, confidence values, and optional location information using the generic detection contract. | Makes results traceable and application-neutral. | Contract validation accepts complete results and rejects missing analyzed-item, label, confidence, or schema fields. |
| IIW-REQ-008 | Feature extraction shall convert validated analysis results into a numerical feature set with names, values, units or unitless declarations, validity indicators, and extractor version. | Establishes an auditable boundary before numerical prediction. | Every emitted feature is numeric and has a name, validity indicator, and unit declaration; the set records extractor version. |
| IIW-REQ-009 | Health prediction shall consume numerical feature sets and shall not consume raw inspection payloads. | Keeps regression interfaces deterministic and reviewable. | Static interface review finds only a numerical-feature input and no raw-payload input on the prediction contract. |
| IIW-REQ-010 | Each health prediction shall report its estimate, applicable horizon or context, uncertainty representation, feature-set reference, and model version. | Supports interpretation and reproducibility. | Schema validation rejects any prediction missing one of the required fields. |
| IIW-REQ-011 | Risk assessment shall combine valid quality, detection, feature, prediction, and uncertainty evidence according to versioned project configuration. | Separates evidence interpretation from individual algorithms. | Every risk result identifies all consumed evidence records, configuration version, risk level, score if configured, and rationale codes. |
| IIW-REQ-012 | If prediction confidence is below its approved threshold or uncertainty exceeds its approved limit, the workflow shall request reacquisition or review and shall prevent autonomous action generation. | Prevents weak predictions from driving unsupervised change. | Boundary scenarios at, above, and below configured limits produce the approved review/reacquisition disposition and no autonomous action when limits are violated. |
| IIW-REQ-013 | A recommendation capable of changing supervised operation shall require an explicit approval decision before it becomes eligible for forwarding. | Retains accountable human authority. | Pending, rejected, expired, or missing approval states prevent forwarding; only an approved, unexpired decision permits forwarding. |
| IIW-REQ-014 | The workflow shall not issue a direct safety-critical command. | Keeps safety authority outside probabilistic analysis. | Interface and action-catalog review confirms outputs are advisory recommendation records and contain no direct safety-command endpoint. |
| IIW-REQ-015 | A pending approval shall not block, delay, mask, or replace an external safety response. | Preserves independent safety priority. | Priority analysis demonstrates that every external safety-response path bypasses approval waiting and remains executable. |
| IIW-REQ-016 | Recommended actions shall identify recommendation type, parameters, evidence references, confidence status, approval status, validity interval, and configuration version. | Makes recommendations bounded and auditable. | Contract validation rejects recommendations missing any mandatory field. |
| IIW-REQ-017 | The evidence recorder shall preserve source, quality, processing, model, feature, prediction, risk, approval, recommendation, configuration, and software-version identifiers. | Enables end-to-end traceability. | For each completed workflow transaction, an evidence-chain query resolves every applicable stage identifier without an orphan reference. |
| IIW-REQ-018 | The workflow shall record failures, rejected inputs, unavailable components, and approval timeouts without fabricating replacement evidence. | Ensures transparent failure handling. | Each injected failure category produces an explicit failure record and no synthesized success record. |
| IIW-REQ-019 | Generic workflow artifacts shall remain free of first-application classes, commands, thresholds, and asset semantics. | Protects reuse across domains. | Automated terminology/configuration review finds project semantics only in project-specific configuration or adapter artifacts. |
| IIW-REQ-020 | Project configuration shall supply label taxonomies, thresholds, action mappings, units, and source-adapter bindings without modifying generic component contracts. | Separates reusable behavior from application choices. | Two project configurations bind to the same unchanged generic contracts and component definitions. |
| IIW-REQ-021 | A real source and a simulated source shall use the same inspection-source contract. | Supports later source replacement. | Contract conformance review shows identical required fields, directions, and semantics for both adapters. |
| IIW-REQ-022 | A simulation environment shall provide data and context through an adapter and shall not contain the inspection AI implementation. | Prevents coupling analysis logic to the environment. | Architecture review locates analysis components outside the environment boundary and confirms communication only through the source contract. |
| IIW-REQ-023 | The workflow shall maintain traceability from each approved requirement to component or procedure, verification case, result, and reviewed evidence. | Supports controlled acceptance. | Traceability review reports no missing mandatory link in the approved scope. |
| IIW-REQ-024 | The same reusable workflow version shall support at least two distinct inspection configurations without core-file modification. | Provides measurable reuse evidence. | Repository comparison shows both configurations use the same core artifact hashes and differ only in approved configuration/adapters. |
| IIW-REQ-025 | Product availability shall be recorded independently from product approval status. | Prevents an approval record from becoming a false installation claim. | Every dependency entry contains separate governance-status and availability-status fields, with availability limited to `AVAILABLE`, `UNAVAILABLE`, or `NOT VERIFIED`. |

## Approved Phase 8 Feature-Catalog Requirements

**Status:** **APPROVED — Nouran Ismail, Project Owner, 2026-09-10**

| ID | Requirement | Rationale | Verification criterion |
|---|---|---|---|
| IIW-REQ-026 | Feature extraction from `DetectionResult` shall emit only the approved six-feature catalog in ascending stable-ID order and shall not infer unavailable measurements. | Prevents invented geometry and hidden raw-data coupling. | Review finds only IDs 1–6 and no raw-image, mask, pixel, region-size/shape/count, or uncalibrated physical derivation. |
| IIW-REQ-027 | A conforming no-detection result shall emit the deterministic six-entry representation with explicit validity and zero defaults. | Distinguishes valid absence from malformed input. | Repeated no-detection inputs produce identical values, ordered IDs, and the approved validity pattern. |
| IIW-REQ-028 | Malformed, nonfinite, or unsupported-schema input, or unsupported extractor configuration, shall produce the exact controlled empty `NumericalFeatureSet` and no partial values. | Prevents corrupted evidence from reaching prediction. | Each invalid category produces all-zero numeric fields, false validity, zero counts, and no uncontrolled error. |
| IIW-REQ-029 | Nonempty feature sets shall preserve source identity and validate schema version, extractor version, unit codes, alignment, unused capacity, and absence of raw payloads. | Preserves deterministic traceability and conformance. | Tests confirm one source reference, supported versions, aligned fixed arrays, zero-filled unused entries, and no raw inspection data. |

`IIW-REQ-026` through `IIW-REQ-029` are approved subject to the limitation that the six-feature catalog is not sufficient by itself for predictive-maintenance training. Additional project sensor features require separately governed IDs and project configuration; unavailable anomaly geometry may not be inferred without an approved interface change.

## Approved Phase 9 Health-Prediction Requirements

**Status:** **APPROVED — Nouran Ismail, Project Owner, 2026-09-10**

| ID | Requirement | Rationale | Verification criterion |
|---|---|---|---|
| IIW-REQ-030 | The reusable health-prediction framework shall consume only a conforming `NumericalFeatureSet` and shall reject malformed, nonfinite, unsupported-schema, unsupported-catalog, or unsupported-model input without uncontrolled failure. | Preserves the approved numerical boundary. | Contract tests cover every invalid category and produce the exact controlled invalid `HealthPrediction`. |
| IIW-REQ-031 | A replaceable predictor shall be selected through a generic contract and shall emit the exact approved `HealthPrediction` without project terminology or project thresholds. | Keeps regression implementations substitutable and reusable. | Two conforming predictors can be substituted without changing the caller or output schema. |
| IIW-REQ-032 | Every valid prediction shall identify its input feature set, prediction identifier, estimate validity, configured context or horizon, uncertainty validity, confidence status, model version, and schema version. | Makes predictions reproducible and interpretable. | Schema tests report an exact field/type/dimension match and resolvable identifiers and versions. |
| IIW-REQ-033 | Predictor loading, execution failure, invalid output, excessive uncertainty, and out-of-distribution input shall produce configured controlled status and evidence and shall not fabricate a valid estimate. | Prevents silent or synthetic success. | Failure-injection tests produce `estimateValid=false`, zero invalid numeric values, explicit status, and no uncontrolled exception. |
| IIW-REQ-034 | Project adapters shall own project feature IDs, names, units, ranges, targets, horizons, datasets, models, thresholds, and metric criteria while emitting the unchanged generic contracts. | Separates reusable behavior from the first application. | Static review finds all project semantics outside Phase 9A and confirms unchanged `NumericalFeatureSet` and `HealthPrediction` schemas. |
| IIW-REQ-035 | The UAV pipeline demonstration shall use generator version 1 and seed `20260910` to create exactly 100 synthetic pipeline-section groups with six chronological inspections per group (600 observations), solely to demonstrate integration and workflow execution. The formulas, coefficients, distributions, clipping rules, missing-data rules, and noise parameters recorded in the approved plan are frozen before implementation and shall all be recorded in the dataset manifest. The deterministic split shall assign 70/15/15 whole groups to train/validation/test before any data-dependent transformation, with zero cross-partition groups and test data untouched until model freeze. The generator shall not be tuned after test inspection. | Keeps the demonstration small, reproducible, leakage-controlled, and explicit about synthetic evidence. | The dataset manifest, generator configuration, model card, and evidence reproduce 70/15/15 groups and 420/90/90 observations, prove zero group overlap, enumerate every frozen generator value, and contain the required limitation. |
| IIW-REQ-036 | The UAV pipeline adapter shall map approved CV, thermal, gas, pressure, and inspection-history inputs to the approved project feature catalog and shall not pass raw images to prediction. | Establishes a traceable project boundary. | Mapping tests cover every approved ID, unit, range, validity rule, and invalid-input disposition and find no raw-image field. |
| IIW-REQ-037 | The UAV pipeline demonstration shall use one ridge linear-regression model with fixed `Lambda=0.1` to predict a health score on `[0,100]` for the fixed 30-day horizon. Predictor columns shall use training-only means and standard deviations, with zero standard deviations replaced by `1` and stored statistics applied unchanged elsewhere. The model shall store `validationRMSE` and emit deterministic uncertainty `min(validationRMSE/100,1)`. It shall report MAE, RMSE, R-squared, schema violations, and uncontrolled failures separately for validation and untouched synthetic test data. | Creates a small, measurable, and bounded demonstration without model-selection, leakage, or calibration complexity. | Evidence reports the fixed ridge configuration, stored training statistics, deterministic residual-uncertainty calculation, split integrity, validation/test metrics, and all locked criteria without post-test changes. |

`IIW-REQ-030` through `IIW-REQ-037` and the simplified Phase 9B clarification are approved by Nouran Ismail — Project Owner on 2026-09-13. Phase 9A remains complete, developer-verified at 16/16, and accepted; independent verification remains pending and requires a different reviewer. Phase 9B corrective implementation is complete, developer verification passed 14/14, locked performance acceptance passed, and Project Owner review is accepted on 2026-09-13. Phase 9B independent verification remains pending and requires a different named reviewer. `priorHealthScore` may be used only when genuinely available at inference time and shall contain no future-target information. Project feature IDs 104 and 105 remain catalogued for compatibility but are excluded from the active regression predictor set because location coordinates are contextual and shall not be treated as causal degradation measurements. Every valid health prediction shall be bounded to `[0,100]`; unsupported feature sets and out-of-distribution inputs shall return controlled invalid/review status. The synthetic model remains demonstration-only and is not production-ready. Phases 10–17 remain not authorized.

### Approved Phase 10 elaboration of existing requirements

**Status:** APPROVED by Nouran Ismail — Project Owner on 2026-09-13. No new requirement ID is introduced; this policy elaborates `IIW-REQ-011`, `IIW-REQ-012`, `IIW-REQ-014`–`IIW-REQ-018`, `IIW-REQ-020`, and `IIW-REQ-023`.

- Policy version 1 encodes `UNKNOWN=0`, `LOW=1`, `MEDIUM=2`, `HIGH=3`, and `REVIEW_REQUIRED=4`.
- Evidence sufficiency requires a conforming successful `HealthPrediction`, valid `[0,100]` estimate, valid `[0,1]` uncertainty, valid model identity/version, nonempty valid feature/evidence references, accepted quality when supplied, and valid detection confidence when supplied.
- Confidence is `1-uncertainty`; uncertainty `<=0.20` and confidence `>=0.80` are acceptable inclusive boundaries.
- With sufficient evidence, estimate `>=80` is low risk, `>=50 && <80` is medium risk, and `<50` is high risk.
- Invalid, missing, rejected, contradictory, unsupported, nonfinite, out-of-range, or internally failed assessment is conservatively `REVIEW_REQUIRED`, requires human review, prohibits autonomous action, and emits no safety command.
- Decision priority and rationale codes are normative as recorded in `architecture/safety_and_approval_priorities.md` and `architecture/interface_contracts.md`.
- `RiskAssessment` remains advisory and cannot command or bypass an external safety authority or `HumanApprovalGate`.

### Approved Phase 11 elaboration of existing requirements

**Status:** APPROVED by Nouran Ismail — Project Owner on 2026-09-14. No new requirement ID is introduced; this policy elaborates `IIW-REQ-012`–`IIW-REQ-018`, `IIW-REQ-020`, and `IIW-REQ-023`.

- Approval policy version 1 uses states `MISSING=0`, `PENDING=1`, `DEFERRED=2`, `REJECTED=3`, `EXPIRED=4`, and `APPROVED=5`; only a valid `APPROVED` evaluation is forwarding-eligible.
- Valid approval requires nonzero identity, authorized configured role, conforming identity evidence, matched request/recommendation references, supported policy version, and valid timestamps.
- Pending/deferred age exactly 300 seconds remains waiting and blocked; greater age expires. Approval remains valid through exactly 900 seconds after decision and expires afterward.
- Only one explicitly enabled and fully audited delegation level is permitted; nested or invalid delegation blocks forwarding.
- Escalation indicates review only and cannot approve or issue an operational or safety command.
- Authenticated external safety indication has priority, immediately blocks recommendation forwarding, and is never delayed or transformed by the gate.
- Malformed, stale, mismatched, unsupported, invalidly delegated, or internally failed evaluation blocks forwarding, requires human review, and produces no autonomous or safety command.

### Approved Phase 9B Corrective Clarification

**Status:** **APPROVED — Nouran Ismail, Project Owner, 2026-09-13**

The Phase 9B version-1 developer evidence found that synthetic records may set `locationAvailable=true` while `detectionPresent=false`, violating the already-approved invariant that location availability implies detection presence. The approved generator version 1.1 shall preserve every approved feature meaning and shall compute exactly:

```matlab
locationAvailable = detectionPresent && locationAvailableCandidate;
```

This clarification does not weaken or replace `IIW-REQ-035` or `IIW-REQ-036`; it corrects generated data to conform to them. Seed `20260910`, 100 groups, six observations per group, the group-safe 70/15/15 split, and every unrelated frozen generator rule remain unchanged. Corrective execution completed within the unchanged ten-file allowlist and consumed the one authorized additional final test-partition evaluation. No additional evaluation remains authorized.

## Gate 2 Review

| Field | Entry |
|---|---|
| Decision | **APPROVED** |
| Approver | Nouran Ismail — Project Owner |
| Approval date | 2026-09-06 |
| Comments | Approved for implementation-plan preparation only under ECR-20260906-001. Model implementation, MATLAB execution, training, and testing remain unauthorized pending Gate 3. |

## Phase 5 Subphase Amendment

| Field | Entry |
|---|---|
| Decision | **APPROVED** |
| Approver | Nouran Ismail — Project Owner |
| Approval date | 2026-09-07 |
| Revised requirement IDs | `IIW-REQ-004` only |
| New requirement IDs | None |
| Disposition | Phase 5 is divided into Phase 5A — Reusable `DataQualityValidation` and Phase 5B — Reusable Image Preprocessing. Phase 5B is authorized but not started. |
| Conditions | Phase 5B accepts only `PASS` inputs, preserves immutable source evidence, records every configured transformation, and does not authorize detection or any Phase 6–17 behavior. |
