# Gate 2 Acceptance Criteria and Metric Definitions

**Associated ECR:** ECR-20260906-001

**Baseline status:** APPROVED — Gate 2 on 2026-09-06

**Clarification status:** APPROVED — Nouran Ismail, Project Owner, 2026-09-06

These criteria define how later work will be judged. They do not report executed tests or achieved model performance.

## Specification Acceptance

| ID | Criterion | Measurement |
|---|---|---|
| IIW-AC-001 | Every generic requirement has a unique stable ID, rationale, and objective acceptance criterion. | Requirement-table audit reports 100% completeness and zero duplicate IDs. |
| IIW-AC-002 | Every architecture component has defined inputs, outputs, responsibility, and failure behavior. | Component-contract matrix reports no missing mandatory field. |
| IIW-AC-003 | Every exchanged record uses one named, versioned interface contract. | Connection-to-contract review reports 100% assignment and zero unnamed exchanges. |
| IIW-AC-004 | Project semantics remain outside reusable requirements, components, and interfaces. | Terminology and configuration review reports zero project taxonomy, threshold, command, or asset-semantic definitions in reusable core artifacts. |

## Data-Quality Metrics

Projects shall select applicable measures and approve their thresholds before implementation:

- Exposure or valid dynamic-range fraction.
- Contrast or intensity-spread measure.
- Sharpness/blur measure.
- Noise estimate or signal-to-noise measure.
- Occlusion/obstruction or usable-area fraction.
- Spatial resolution or sampling sufficiency.
- Corruption, missing-data, timestamp, calibration, and metadata-completeness checks.

Acceptance requires each selected metric to define unit/domain, computation version, threshold reference, boundary behavior, and reason code. No threshold value is approved by this package.

### Approved Phase 5 Numeric-Boundary Clarification

For Phase 5 data-quality comparisons:

- A measured value satisfies a minimum boundary when `measuredValue >= minimumThreshold`.
- A measured value satisfies a maximum boundary when `measuredValue <= maximumThreshold`.
- Both the measured value and configured threshold shall be represented as MATLAB `single` values before comparison, consistent with the approved quality-score representation.
- No implicit or undocumented numeric tolerance is permitted.
- `NaN`, positive infinity, and negative infinity shall be rejected before any boundary comparison.
- When `minimumThreshold == maximumThreshold`, only a measured `single` value exactly equal to that value satisfies the range.

| Clarification field | Entry |
|---|---|
| Decision | **APPROVED** |
| Approver | Nouran Ismail — Project Owner |
| Approval date | 2026-09-07 |
| Phase 5A status | **COMPLETE; developer verification PASS — 16/16; Project Owner review ACCEPTED** |
| Phase 5B status | **AUTHORIZED — NOT STARTED** |
| Later phases | Phase 6 remains Replaceable Computer-Vision Detection and is **NOT AUTHORIZED**; Phases 7–17 remain **NOT AUTHORIZED** |

## Phase 5B Image-Preprocessing Acceptance Criteria

| ID | Criterion | Measurement |
|---|---|---|
| IIW-AC-032 | Preprocessing accepts only an input whose `DataQualityResult.status` is `PASS`. | Tests show every `REVIEW`, `REJECT`, missing, malformed, and unsupported quality disposition produces no `ProcessedData` output and an explicit failure record. |
| IIW-AC-033 | Format/channel normalization and resizing are deterministic and use only approved configuration values. | Repeated identical inputs and configuration produce identical outputs; output type, channel count, and configured dimensions match exactly. |
| IIW-AC-034 | Intensity normalization, denoising, and contrast adjustment are applied only when selected by approved configuration and in the configured order. | Operation-order tests cover enabled and disabled operations and find no unrecorded transformation or hard-coded project threshold. |
| IIW-AC-035 | Every processed output preserves source provenance and records all applied operations and parameter values. | Each `ProcessedData` record resolves its source item, transform record, implementation version, configuration version, ordered operation identifiers, and exact parameter values. |
| IIW-AC-036 | Preprocessing does not conceal, repair, or relabel rejected input as valid. | Rejected-input tests produce no processed payload or downstream-analysis eligibility, including when an image transformation could visually improve the input. |
| IIW-AC-037 | The Phase 5B implementation remains application-independent and contains no detection, segmentation, learned-model, feature, prediction, risk, approval, recommendation, or operational-control behavior. | Static scope and prohibited-terminology checks report zero prohibited implementation and zero project-specific terminology. |

Phase 5B acceptance is governed by `IIW-REQ-004`. These criteria define future verification and do not claim that preprocessing has been implemented or tested.

## Detection and Classification Metrics

- Per-label precision, recall, and F1 score.
- Confusion matrix and support count.
- False-positive and false-negative rates.
- Precision-recall area or average precision where appropriate.
- Localization overlap and localization error where locations are produced.
- Confidence calibration, including a declared calibration error or proper scoring measure.
- Performance slices for approved quality, source, and operating-condition groups.

Dataset splits, thresholds, minimum sample support, and pass values remain project decisions. No achieved value is claimed.

### Approved Phase 7 KSDD2 Acceptance Criteria

| ID | Criterion | Required result |
|---|---|---|
| IIW-AC-038 | The official KSDD2 test partition remains isolated from development decisions. | Zero official-test samples are used for training, validation, fitting, preprocessing decisions, threshold tuning, model selection, or early stopping. |
| IIW-AC-039 | Training and validation use a deterministic stratified 80/20 split of the official training partition. | Stable SHA-256 ordering and the recorded seed/configuration reproduce identical membership; exact duplicates and approved acquisition groups never cross partitions. |
| IIW-AC-040 | The optional learned detector performs binary semantic segmentation and maps results to the approved generic `DetectionResult`. | Background/anomaly segmentation remains behind `DetectorContract`; the conventional detector and generic interfaces have zero changes. |
| IIW-AC-041 | Training is reproducible and traceable. | Evidence records MATLAB/toolbox versions, hardware, seed, hyperparameters, execution time, preprocessing configuration, imbalance treatment, early stopping, and any pretrained-weight source/license. |
| IIW-AC-042 | Confidence handling is controlled. | The default pixel threshold is 0.50; tuning uses validation only and records the selected threshold; low-confidence output abstains or uses the approved controlled status. |
| IIW-AC-043 | Required performance evidence is partition-specific. | Pixel Dice, pixel IoU, image-level precision/recall/F1, negative-image false-positive rate, inference time, and confusion matrix are reported separately for validation and untouched official test data. |
| IIW-AC-044 | Minimum demonstration thresholds are fixed before official-test evaluation. | Test recall >= 0.75, precision >= 0.70, F1 >= 0.72, positive-image mean Dice >= 0.50, negative-image false-positive rate <= 0.15, zero interface-schema violations, and zero uncontrolled execution failures. |
| IIW-AC-045 | Missed thresholds are reported without post-test relaxation. | Any miss yields `FAIL` or `APPROVED WITH LIMITATIONS`; no threshold changes after official-test results are viewed. |
| IIW-AC-046 | Dataset and model license controls remain explicit. | Dataset payloads remain outside Git; the model and model card preserve attribution and CC BY-NC-SA 4.0 non-commercial/ShareAlike restrictions; no production-readiness or pipeline-domain-validation claim appears. |

These criteria were approved by Nouran Ismail, Project Owner, on 2026-09-09. They authorize Phase 7 dataset use, training, and evaluation within the existing Phase 7 allowlist. They do not claim that training or evaluation occurred and do not authorize Phases 8-17.

## Regression Metrics

- Mean absolute error and root mean squared error.
- Bias/error mean and error distribution by approved slice.
- Coefficient of determination where technically meaningful.
- Prediction-interval coverage and width where uncertainty intervals are produced.
- Residual checks and out-of-distribution behavior.

Regression acceptance additionally requires proof that inputs are numerical feature sets and not raw inspection payloads.

## Robustness and Failure-Handling Criteria

| ID | Criterion | Required result in later verification |
|---|---|---|
| IIW-AC-005 | Missing, corrupted, rejected-quality, and unsupported-schema inputs are handled explicitly. | 100% of approved failure cases produce failure/review evidence and no autonomous action. |
| IIW-AC-006 | Low-confidence and excessive-uncertainty boundaries are deterministic. | Boundary cases produce the approved reacquisition/review disposition with no unauthorized forwarding. |
| IIW-AC-007 | Component unavailability does not create synthetic success evidence. | Every injected unavailable-component case records failure and prevents dependent recommendation forwarding. |

## Approval-Gate Criteria

| ID | Criterion | Required result in later verification |
|---|---|---|
| IIW-AC-008 | Missing, pending, deferred, rejected, and expired decisions block eligible recommendation forwarding. | 100% of those cases are blocked and recorded. |
| IIW-AC-009 | Only approved, unexpired recommendations are eligible for project-adapter forwarding. | 100% decision-table conformance. |
| IIW-AC-010 | Approval waiting cannot delay an external safety response. | Priority analysis and integration scenarios show zero blocked external safety responses. |

## Reusability Acceptance Criteria

| ID | Criterion | Measurement |
|---|---|---|
| IIW-AC-011 | At least two distinct project configurations use the same reusable workflow and contracts. | Core artifact hashes are identical; differences are confined to approved configuration and adapter artifacts. |
| IIW-AC-012 | Detection implementations are replaceable. | A contract-conformance demonstration substitutes two implementations without consumer-interface changes. |
| IIW-AC-013 | Project taxonomies, thresholds, units, and action mappings are supplied only by configuration. | Cross-project diff finds no project-semantic edit to reusable core files. |

## Traceability Criteria

| ID | Criterion | Measurement |
|---|---|---|
| IIW-AC-014 | Approved requirements trace to implementation elements, tests, results, and evidence. | 100% of in-scope approved requirements have every mandatory link and zero broken links. |
| IIW-AC-015 | Dataset, processing, feature, model, risk, approval, and recommendation versions are recoverable. | Every sampled transaction resolves a complete evidence chain with no orphan identifier. |

## Future 3D Scalability Criteria

| ID | Criterion | Measurement |
|---|---|---|
| IIW-AC-016 | Simulated and real sources use the same generic inspection-source contract. | Contract comparison reports identical mandatory fields, directions, and semantics. |
| IIW-AC-017 | Environment-specific pose, scene, and condition information is carried as adapter metadata. | No generic downstream interface change is required when switching sources. |
| IIW-AC-018 | Inspection AI remains outside the simulation-environment boundary. | Architecture inspection finds no detection, feature, prediction, risk, or approval implementation inside that boundary. |
| IIW-AC-019 | Source substitution preserves evidence provenance. | Evidence records distinguish adapter/source versions while retaining the same generic chain structure. |

### Approved Phase 16 execution controls

**Status:** **APPROVED — PHASE 16 AUTHORIZED, NOT STARTED.** Nouran Ismail — Project Owner / Lead Systems Engineer / MBD Architect, 2026-09-17. Phase 16 is limited to the replaceable source adapter, its configuration/schema, one test file, and evidence. Phase 17 remains **NOT AUTHORIZED**.

- `IIW-TST-3D-001`: prove virtual and accepted source adapters expose equal mandatory `InspectionData` and `InspectionMetadata` fields, directions, types, dimensions, and semantics.
- `IIW-TST-3D-002`: substitute the virtual adapter without changing a downstream interface or reusable-core consumer.
- `IIW-TST-3D-003`: validate deterministic inline virtual RGB/fisheye frames and approved pose, environmental, scenario, timestamp, reference-frame, and version metadata; reject malformed input controllably.
- `IIW-TST-3D-004`: prove provenance distinguishes source, adapter, and scenario versions while retaining the generic evidence-chain structure.
- `IIW-TST-3D-005`: prove the simulation boundary contains no preprocessing, detection, prediction, risk, approval, evidence-decision, mission, or command implementation; verify unchanged protected hashes and exact five-file isolation.

Acceptance is locked to `IIW-AC-016` through `IIW-AC-019`, 5/5 test groups passing, zero failed or incomplete tests, zero downstream-interface changes, zero AI inside the environment boundary, zero prohibited endpoints, unchanged reusable-core/Phase 13/Phase 14/Phase 15/real-source/MissionSupervisor hashes, and exactly five Phase 16 artifacts changed. The external MathWorks example remains read-only and outside Git. Any external fixture, example copy/change, new dependency or path, environment artifact, MissionSupervisor connection, or core change fails preflight and requires separate authorization.

**Final Phase 16 disposition (2026-09-17): COMPLETE, VERIFIED AND ACCEPTED.** Developer verification passed 5/5. Yahya Helmy — Independent Verification & Validation Engineer — reviewed saved evidence without independently rerunning MATLAB and recorded **PASS**. Nouran Ismail — Project Owner — recorded **APPROVED**. `IIW-AC-016` through `IIW-AC-019` are accepted as satisfied; all future-adapter and demonstration-only limitations remain, and Phase 17 remains **NOT AUTHORIZED**.

### Approved Phase 16B live external-project demonstration acceptance

**Status:** **APPROVED — PHASE 16B AUTHORIZED, NOT STARTED.** Nouran Ismail — Project Owner, 2026-09-17. Phase 17 remains **NOT AUTHORIZED**.

- `IIW-TST-EXT-001`: prove external-model identity, unchanged hash, actual runtime camera-frame acquisition, exact acquisition method, and close-without-save behavior.
- `IIW-TST-EXT-002`: prove the accepted Phase 16 adapter accepts the acquired frame/context and emits unchanged generic contracts.
- `IIW-TST-EXT-003`: record valid outputs/statuses for quality, preprocessing, conventional detection, numerical features, health prediction where supported, risk, approval-gate behavior, advisory recommendation, and evidence chain.
- `IIW-TST-EXT-004`: prove every value is classified as external simulation output or deterministic demonstration context, with zero misrepresented UAV observations.
- `IIW-TST-EXT-005`: prove the Phase 6 conventional detector is selected and the Phase 7 deep-learning detector remains disabled.
- `IIW-TST-EXT-006`: prove advisory-only behavior and zero flight, MissionSupervisor, actuator, ReturnToHome, SafeLanding, approval, or safety-command endpoints.
- `IIW-TST-EXT-007`: prove evidence-chain completeness, version/provenance retention, controlled failure, and deterministic repetition.
- `IIW-TST-EXT-008`: prove unchanged protected hashes, exact four-file isolation, no committed external payload, and presence of the mandatory disclaimer.

Locked acceptance is 8/8 groups passing with zero failed/incomplete, schema violations, uncontrolled failures, prohibited endpoints, fabricated external outputs, or protected-hash changes. At least one actual runtime camera frame must be obtained from the external MathWorks project. Every external and configured value requires explicit provenance. All workflow-stage results must be recorded. All Phase 9B inputs not produced by the project must be deterministic, separately governed `DEMONSTRATION_CONTEXT`. Exact four-file isolation is mandatory. No screenshot artifact is approved.

## Approved Phase 4 Interface-Schema Acceptance Criteria

| ID | Criterion | Measurement |
|---|---|---|
| IIW-AC-020 | Exactly the twelve approved interface names exist once each in the authorized interface dictionary. | Dictionary inspection reports 12 expected interfaces, zero missing, zero duplicate, and zero unexpected interfaces. |
| IIW-AC-021 | Every approved logical element is retained or has an explicitly approved runtime realization recorded in the clarification. | Baseline-to-runtime matrix reports 100% disposition and zero silent rename or removal. |
| IIW-AC-022 | Every runtime element has a type, fixed dimension, unit, range or encoding, validity rule, and default. | Automated schema comparison reports 100% match to the approved detailed tables. |
| IIW-AC-023 | Optional numeric scalars use an explicit Boolean validity element and use zero, not NaN-only, when invalid. | Schema inspection and default-value checks report full conformance. |
| IIW-AC-024 | Feature and reference arrays use capacities 32 and 16 respectively, with bounded counts and zero-filled unused entries. | Dimensions, count ranges, and defaults match the approved representation rules. |
| IIW-AC-025 | Runtime identifiers and categories are numeric; human-readable names remain in configuration or evidence documentation. | Interface inspection finds no runtime string/text element. |
| IIW-AC-026 | The architecture has exactly the three approved typed inputs and three approved typed outputs. | Boundary-port inventory matches `interface_contracts.md` exactly. |
| IIW-AC-027 | Exactly ten approved top-level components remain and all approved logical and evidence flows remain connected. | Component and connector comparison reports no missing, duplicate, or unexpected component and no broken approved flow. |
| IIW-AC-028 | Every evidence-observation output uses its approved interface and `EvidenceRecorder` has no control or approval authority. | Port-to-interface matrix matches all ten assignments and finds no evidence-to-decision connector. |
| IIW-AC-029 | `HumanApprovalGate` emits `ApprovalRequest`, receives external `ApprovalDecision`, cannot self-approve, and has no safety-critical command interface. | Static architecture inspection confirms direction, external boundary, and absence of a self-decision or safety-command path. |
| IIW-AC-030 | Every required architecture exchange is typed and the model and dictionary open, update, save, close, and reopen without unresolved architecture errors. | Phase 4 test reports zero untyped required ports and all lifecycle checks pass. |
| IIW-AC-031 | Interface, element, component, port, and connector names remain application-independent. | Automated prohibited-terminology scan reports zero occurrence in runtime names. |

These criteria are approved for Phase 4 implementation and verification. This approval does not constitute Phase 4 implementation, verification, or acceptance.

## Approved Phase 8 Feature-Catalog Acceptance Criteria

**Status:** **APPROVED — Nouran Ismail, Project Owner, 2026-09-10**

| ID | Criterion | Required result |
|---|---|---|
| IIW-AC-047 | Catalog content is limited to approved `DetectionResult` information. | Exactly six features use IDs 1–6; no raw-image, mask, region size/shape/count, or uncalibrated physical measurement exists. |
| IIW-AC-048 | Ordering and representation are deterministic. | Active IDs are unique and ascending; capacity remains 32; repeated identical inputs/configuration produce identical output. |
| IIW-AC-049 | No-detection output is exact. | Six entries; presence and location availability are valid zero; coordinates are zero and invalid; confidence follows `confidenceValid`; unused entries are zero/false. |
| IIW-AC-050 | Malformed/nonfinite inputs fail controllably. | Exact all-zero empty output, false validity, zero counts, no partial output, and no uncontrolled error. |
| IIW-AC-051 | Units and versions conform. | Codes `1=dimensionless`, `2=metre`; nonempty output has supported nonzero schema/extractor versions; mismatches are rejected. |
| IIW-AC-052 | Source trace and array alignment are preserved. | `sourceRefs(1)=resultId`, `referenceCount=1`, active arrays align, and unused capacity is zero-filled. |
| IIW-AC-053 | Prediction boundary is numerical and reusable. | No raw payload, taxonomy name, project-specific term, or disabled learned-detector dependency appears in the catalog or extractor interface. |

`IIW-AC-047` through `IIW-AC-053` are approved. Acceptance does not establish predictive-maintenance sufficiency and does not authorize claims that the catalog contains anomaly geometry, degradation, vibration, temperature, current, operating time, or remaining-useful-life information.

## Approved Phase 9A and Simplified Phase 9B Acceptance Criteria

**Status:** `IIW-AC-054` through `IIW-AC-065` **APPROVED — Nouran Ismail, Project Owner, 2026-09-13**

| ID | Criterion | Required result |
|---|---|---|
| IIW-AC-054 | Phase 9A is application-independent. | Static inspection finds only generic predictor, feature-set validation, prediction, uncertainty/status, model-version, evidence, and model-card behavior; zero prohibited Phase 9B terms or thresholds. |
| IIW-AC-055 | Predictor implementations are replaceable. | Two contract-conforming predictors execute through the same entry point with no caller or schema change. |
| IIW-AC-056 | Input and output schemas conform exactly. | Valid `NumericalFeatureSet` input produces the exact approved `HealthPrediction`; malformed/nonfinite/version-invalid input produces the exact controlled invalid output. |
| IIW-AC-057 | Failure and uncertainty behavior is controlled. | Loading, execution, invalid-output, out-of-distribution, and excessive-uncertainty cases produce no fabricated valid estimate and no uncontrolled failure. |
| IIW-AC-058 | The pipeline adapter implements only approved project mappings. | IDs 101–115 occur once in ascending order with approved units, ranges, validity, zero defaults, provenance, and no raw-image predictor input; IDs 104 and 105 are excluded from the active regression predictors and are not treated as causal degradation inputs. |
| IIW-AC-059 | Synthetic data is reproducible and leakage-controlled. | Generator version 1, seed `20260910`, frozen distributions, dependencies, and dataset hash are recorded; exactly 100 groups and 600 observations reproduce a group-safe 70/15/15 split (70/15/15 groups and 420/90/90 observations); no group crosses partitions and test remains untouched until freeze. |
| IIW-AC-060 | Target and horizon are fixed before training. | Target is a synthetic `[0,100]` health score at 30 days using context ID 9001; formula and all generator parameters are frozen before fitting. |
| IIW-AC-061 | The fixed regression implementation does not inspect the test partition before freeze. | A median-target baseline is reported only as a reference; one ridge linear-regression model with `Lambda=0.1` is fitted using training data and evaluated on test only after generator, formulas, transformations, model, thresholds, and uncertainty policy are frozen. No ensemble, model comparison, hyperparameter search, Regression Learner, conformal prediction, or test-guided adjustment occurs. |
| IIW-AC-062 | Locked regression performance criteria are met. | Synthetic test MAE `<=8.0`, RMSE `<=12.0`, and R-squared `>=0.65`; validation and test values are reported separately without post-test threshold changes. |
| IIW-AC-063 | Standardization and residual-based uncertainty are deterministic and leakage-controlled. | Training-only column means and standard deviations are stored in the model; zero standard deviations are replaced by `1`; stored values are applied unchanged to validation, test, and future inputs. The model stores `validationRMSE` and records uncertainty `min(validationRMSE/100,1)` without using test data; repeated calculations are identical and invalid/OOD inputs abstain. |
| IIW-AC-064 | Interface and execution integrity hold. | Zero `NumericalFeatureSet` or `HealthPrediction` schema violations, zero uncontrolled failures, deterministic repeated inference, and complete model/dataset/configuration provenance. |
| IIW-AC-065 | Claims remain bounded. | Every dataset, model-card, and evidence artifact states: “Integration and workflow demonstration only; not evidence of real pipeline prognostic accuracy or production readiness.” |

Phase 9A acceptance remains recorded against `IIW-AC-054` through `IIW-AC-057`. Revised `IIW-AC-058` through `IIW-AC-065` and the simplified Phase 9B clarification are approved. Locked synthetic-test thresholds are MAE `<=8.0`, RMSE `<=12.0`, and R-squared `>=0.65`, with zero interface violations and zero uncontrolled failures. Acceptance additionally requires frozen/versioned formulas, coefficients, distributions, clipping, missing-data rules, and noise before generation; group assignment before data-dependent transformation; zero group overlap; test isolation until the model and thresholds are frozen; training-only standardization; inference-time availability and no future-target leakage for `priorHealthScore`; exclusion of location coordinates from causal regression predictors; `[0,100]` prediction bounding; and controlled invalid/review status for unsupported or out-of-distribution input.

### Approved Phase 9B Corrective Acceptance Control

**Status:** **APPROVED — Nouran Ismail, Project Owner, 2026-09-13**

No acceptance criterion or threshold was weakened. The corrected generator version 1.1 candidate satisfies `IIW-AC-058`, `IIW-AC-059`, and `IIW-AC-064`: every generated row satisfies `locationAvailable=true` only when `detectionPresent=true`, implemented as `locationAvailable = detectionPresent && locationAvailableCandidate`; invariant violations, interface-schema violations, and uncontrolled failures are zero. The existing 14 tests remain present and unsuppressed and passed 14/14. The original test exposure and interface failure remain in evidence history. The one additional final test-partition evaluation was consumed; zero further evaluations are authorized.

**Phase 9B Project Owner disposition:** **PERFORMANCE PASS; ACCEPTED — Nouran Ismail, Project Owner, 2026-09-13.** The result is classified **DEMONSTRATION ONLY — NOT PRODUCTION READY**. Independent verification remains pending and requires a different named reviewer.

## Approved Phase 10 Risk-Policy Acceptance Criteria

**Status:** APPROVED — Nouran Ismail, Project Owner, 2026-09-13.

| ID | Criterion | Required result |
|---|---|---|
| IIW-AC-066 | Risk-policy version and encodings conform. | Policy version is `1`; all five risk levels and approved rationale codes match the approved numeric tables exactly. |
| IIW-AC-067 | Evidence sufficiency is conjunctive and deterministic. | Each required condition passes in the nominal case; independently invalidating each condition produces `REVIEW_REQUIRED` and no autonomous or safety action. |
| IIW-AC-068 | Confidence and uncertainty boundaries conform. | `0.20` uncertainty and `0.80` confidence pass; values beyond those limits and all nonfinite/out-of-range values produce `REVIEW_REQUIRED`. |
| IIW-AC-069 | Health thresholds and boundaries conform. | `0` is `HIGH`, `50` is `MEDIUM`, `80` and `100` are `LOW`; adjacent in-range cases follow the approved intervals. |
| IIW-AC-070 | Decision priority is exact. | Every approved combination selects the highest-priority applicable rule; decision-table conformance is 100%. |
| IIW-AC-071 | Conservative fallback and safety boundary hold. | Unsupported status/version, missing field, invalid numeric input, and injected internal failure produce `REVIEW_REQUIRED`, required review, prohibited autonomous action, and no safety command or approval bypass. |
| IIW-AC-072 | Verification evidence is complete. | `IIW-TST-RISK-001` through `IIW-TST-RISK-007` pass; decision/condition coverage is 100% or each residual has documented structural-infeasibility justification; traceability and policy hash are recorded. |

### Phase 10 verification disposition

**Independent decision:** **PASS — Yahya Helmy, Independent Verification & Validation Engineer, 2026-09-14.** The reviewer assessed existing saved evidence and did not claim a MATLAB or test rerun. Developer verification passed 10/10; decision-table conformance and decision coverage were 100%; condition coverage was 194/196 and MC/DC was 96/98. The true outcomes of `prediction.featureSetId == 0` after successful validation and `confidence < policy.minimumConfidence` after the uncertainty short-circuit were accepted as structurally infeasible. No coverage filtering or suppression occurred, and production implementation was unchanged during corrective testing.

**Project Owner acceptance:** **APPROVED — Nouran Ismail, 2026-09-14.** Phase 10 is **COMPLETE, VERIFIED AND ACCEPTED**. Phases 11–17 remain **NOT AUTHORIZED**.

## Approved Phase 11 Human-Approval Acceptance Criteria

**Status:** APPROVED — Nouran Ismail, Project Owner, 2026-09-14.

| ID | Criterion | Required result |
|---|---|---|
| IIW-AC-073 | Approval-state encoding and forwarding conform. | All six states use their approved numeric codes; only valid, matched, authorized, unexpired `APPROVED` is eligible; state-table conformance is 100%. |
| IIW-AC-074 | Identity and role checks conform. | Zero/nonconforming identity and roles outside `1`–`3` block forwarding; valid configured identities and roles are auditable. |
| IIW-AC-075 | Pending timeout is inclusive. | Exactly 300 seconds remains waiting and blocked; any greater age produces `EXPIRED`, blocked forwarding, and review/escalation indication only. |
| IIW-AC-076 | Approval validity is inclusive. | Exactly 900 seconds after approval remains valid; any later evaluation produces `EXPIRED` and blocks forwarding. |
| IIW-AC-077 | Rejection, deferral, expiration, and missing behavior conform. | Each blocks forwarding; no state silently becomes `APPROVED`; rejected/expired require a new request and deferred remains reviewable only through timeout. |
| IIW-AC-078 | Delegation is bounded and auditable. | One enabled, valid, distinct-identity delegation may be evaluated; nested, disabled, incomplete, same-identity, or unauthorized-role delegation blocks forwarding. |
| IIW-AC-079 | References and versions conform. | Request/recommendation mismatch and unsupported policy version block forwarding with controlled rationale. |
| IIW-AC-080 | External safety priority is preserved. | Active authenticated safety indication immediately blocks forwarding and asserts `safetyBypass`; the gate neither delays nor generates/selects/modifies a safety command. |
| IIW-AC-081 | Audit and conservative fallback are complete. | Every evaluation records all approved audit fields; malformed/stale/invalid/internal-failure cases require review, block forwarding, and expose no autonomous or safety command. |
| IIW-AC-082 | Phase 11 verification is complete. | `IIW-TST-APR-001` through `IIW-TST-APR-010` pass; decision/condition coverage is 100% or each residual has independently reviewed structural-infeasibility justification. |

The approved interpretation of `IIW-AC-073`, `IIW-AC-079`, and `IIW-AC-081` includes the Phase 11 rationale and audit clarification approved on 2026-09-14: every evaluation returns exactly one highest-priority scalar `uint16` rationale code from the approved `0,20–39` table; the audit record contains exactly the 18 approved fixed-size fields and types; any missing or invalid mandatory audit field sets `auditValid=false` and blocks forwarding; and external interface schemas remain unchanged. The previous rationale/audit implementation blocker is **RESOLVED**.

### Phase 11 verification disposition

**Independent decision:** **PASS WITH ACCEPTED COVERAGE DEVIATION — Yahya Helmy, Independent Verification & Validation Engineer, 2026-09-15.** The reviewer assessed saved implementation, test, and coverage evidence and did not independently rerun MATLAB. Developer verification passed 16/16 and approval-state decision-table conformance was 100%; statement coverage was 174/180 (96.67%), function coverage 15/15 (100%), decision coverage 106/112 (94.64%), condition coverage 323/358 (90.22%), and MC/DC 144/179 (80.45%). Residual coverage was not claimed structurally infeasible. The deviation from the structural-coverage objective in `IIW-AC-082` was explicitly accepted based on complete decision-table, safety-priority and boundary-state testing, deterministic conservative fallback, and absence of autonomous or safety-command output.

**Project Owner acceptance:** **APPROVED — Nouran Ismail, 2026-09-15.** Phase 11 is **COMPLETE, VERIFIED AND ACCEPTED**. Phases 12–17 remain **NOT AUTHORIZED**.

## Approved Phase 12 Evidence-Policy Acceptance Controls

**Status:** APPROVED — Nouran Ismail, Project Owner, 2026-09-15.

- `IIW-TST-EVD-001` through `IIW-TST-EVD-006` remain required and cover chain completeness, orphan handling, immutability, version recording, controlled failure, and retention-policy behavior.
- Mandatory identifiers are present in 100% of accepted records.
- Valid chains contain zero orphan, self, duplicate-ID, or circular references and maintain consistent transaction-stage order.
- Canonical record content produces deterministic SHA-256 `uint8 [32 1]` integrity metadata; content change invalidates the previous digest.
- Role permissions match the approved four-role table; unknown, zero, malformed, or write-ineligible roles cannot create a success record.
- Retention metadata defaults to 365 days, `retentionHold=true` prevents deletion eligibility, and Phase 12 performs no deletion.
- Every injected writer-unavailable, write-failure, invalid-input/chain, integrity-failure, and access-failure case produces an explicit failure and zero synthetic-success records.
- Evidence contains no credentials, personal names, secrets, authentication tokens, or raw payload by default; the recorder remains application-independent and observational.
- The approved external `EvidenceRecord` interface remains unchanged; its `integrityMetadata` value references the implementation-local digest record.

### Phase 12 verification disposition

**Independent decision:** **PASS — Yahya Helmy, Independent Verification & Validation Engineer, 2026-09-16.** The review used saved implementation, diagnostic, test, and coverage evidence; MATLAB was not independently rerun. Developer verification passed 20/20; function coverage was 17/17 (100%) and statement coverage was 146/162 (90.12%). Decision and condition coverage were unavailable from the source-coverage provider and are recorded as a tool limitation, not as 100% coverage. Mandatory identifiers were present in 100% of accepted records; valid-chain orphan references were zero; multistage, self-reference, circular-reference, stage-order, duplicate-ID, persistence-failure, deterministic SHA-256, and no-command-authority checks passed. No test was removed, suppressed, or weakened.

**Project Owner acceptance:** **APPROVED — Nouran Ismail, 2026-09-16.** Phase 12 is **COMPLETE, VERIFIED AND ACCEPTED**. The complete corrective history remains preserved. Phases 13–17 remain **NOT AUTHORIZED**.

## Unresolved Acceptance Decisions

### Proposed Phase 13 UAV-configuration acceptance controls

**Status:** **APPROVED — PHASE 13 AUTHORIZED, NOT STARTED; SOURCE ACQUISITION/COMPATIBILITY PENDING.** Nouran Ismail — Project Owner / Lead Systems Engineer, 2026-09-16. MATLAB R2026a, Simulink, UAV Toolbox, Simulink 3D Animation, and Computer Vision Toolbox are approved. The pregenerated MathWorks example “Simulate Simple Flight Scenario and Sensor in Unreal Engine Environment” is the sole source. It must be acquired through an official MathWorks mechanism to the external MATLAB-managed Examples directory and verified read-only before implementation. Only RGB/fisheye output and simulation context metadata may be consumed. Example modification, repository copying, repackaging, redistribution, or commit fails acceptance.

- `IIW-TST-UAV-001`: every accepted simulated MathWorks UAV 3D camera frame maps to the unchanged `InspectionData` and `InspectionMetadata` schemas with resolvable numeric provenance.
- `IIW-TST-UAV-002`: 100% of required UAV project metadata fields match their fixed types, dimensions, units, ranges, and nonzero/reference rules; malformed or incomplete metadata is rejected controllably.
- `IIW-TST-UAV-003`: taxonomy is exactly `0=UNASSIGNED_OR_NO_DETECTION`, `1=SURFACE_ANOMALY_INDICATION`, and `255=INVALID`; no unsupported defect/severity claim is present.
- `IIW-TST-UAV-004`: only quality `PASS` proceeds; inclusive brightness `[0.20,0.80]`, contrast `>=0.10`, sharpness `>=0.03`, saturation fraction `<=0.25`, saturation level `0.95`, and all rejected/malformed cases conform to the existing quality contract.
- `IIW-TST-UAV-005`: valid conventional-detection confidence `>=0.50` is acceptable at the inclusive boundary; lower/unavailable/invalid/nonfinite confidence produces review/reacquisition advice and no mission request; configured units remain project-local.
- `IIW-TST-UAV-006`: every risk/evidence row deterministically maps to the approved five-code advisory table; only a valid current external approval makes a recommendation eligible at the advisory boundary.
- `IIW-TST-UAV-007`: static and behavioral inspection finds zero direct flight, mission, approval, ReturnToHome, SafeLanding, or safety-command endpoint and zero MissionSupervisor connection.
- `IIW-TST-UAV-008`: only the exact six Phase 13 files change; reusable-core and protected UAV hashes are identical; repeated inputs are deterministic; every artifact carries the demonstration-only limitation.

Acceptance requires all eight tests to pass, zero schema violations, zero uncontrolled failures, zero protected-hash changes, zero command endpoints, and the mandatory disclaimer. No real-world performance metric or readiness claim is accepted.

The exact six-file allowlist is mandatory. Example modification/copying, direct MissionSupervisor integration, and flight, mission, approval, ReturnToHome, SafeLanding, or safety-command output fail acceptance. Phases 14–17 remain not authorized.

### Phase 13 verification disposition

**Independent decision:** **PASS — Yahya Helmy, Independent Verification & Validation Engineer, 2026-09-16.** The review used saved repository implementation, developer-test, YAML-validation, hash, example-compatibility, Git-scope, and corrective-history evidence; MATLAB was not independently rerun. Developer verification passed 8/8 with zero failures and zero incomplete tests. The review confirmed deterministic generic-contract mapping; project-local semantics; exact taxonomy; PASS-only quality and inclusive `0.50` confidence gates; controlled non-command fallbacks; advisory codes 0–4; external approval enforcement; zero prohibited endpoints or MissionSupervisor connection; unchanged protected hashes; external read-only example handling; full disclosure of the initial 7/8 hash-ordering result; no performance claim; and exact six-file scope.

**Project Owner acceptance:** **APPROVED — Nouran Ismail, 2026-09-16.** Phase 13 is **COMPLETE, VERIFIED AND ACCEPTED** and retains the classification **integration/workflow demonstration only; not evidence of real-world inspection or production readiness**. Phases 14–17 remain **NOT AUTHORIZED**.

### Approved Phase 14 fixed-camera reuse acceptance controls

**Status:** **APPROVED — PHASE 14 AUTHORIZED, NOT STARTED.** Nouran Ismail — Project Owner, 2026-09-16. The approved demonstration uses deterministic synthetic RGB frames defined only inside `test_fixed_camera_configuration.m`; the fixtures are project-generated test data, and no external dataset, download, camera, credential, network, training, performance evaluation, external license, new toolbox, or hardware interface is required.

- `IIW-TST-FIX-001`: every valid stationary-camera frame and context maps deterministically to the exact unchanged `InspectionData` and `InspectionMetadata` schemas, with nonzero station, part, camera/source, payload/context, sequence, timestamp, and fixed-frame references.
- `IIW-TST-FIX-002`: missing, nonscalar, mistyped, dimensionally invalid, nonfinite, zero-required-reference, invalid timestamp, and malformed source/context cases return controlled empty/rejected results with zero uncontrolled failures.
- `IIW-TST-FIX-003`: taxonomy is exactly `0=UNASSIGNED_OR_NO_DETECTION`, `1=SURFACE_ANOMALY_INDICATION`, `255=INVALID`; finite valid confidence `>=single(0.50)` is accepted inclusively, while below-boundary, unavailable, invalid, and nonfinite confidence cannot become forwardable.
- `IIW-TST-FIX-004`: only exact quality `PASS` proceeds; `REVIEW`, `REJECT`, missing, unsupported, and malformed quality results remain blocked and cannot be repaired into acceptable evidence.
- `IIW-TST-FIX-005`: risk/evidence cases map deterministically only to advisory codes 0–4; invalid or insufficient evidence yields controlled review/reacquisition advice and no actuator or control output.
- `IIW-TST-FIX-006`: applicable nonzero recommendations require a valid current external approval; pending, rejected, expired, missing, or malformed approval blocks forwarding; static/behavioral inspection finds zero actuator, production-line, machine-control, mission, flight, self-approval, ReturnToHome, SafeLanding, or safety-command endpoint.
- `IIW-TST-FIX-007`: repeated identical inputs/configuration produce identical outputs; all deterministic fixtures reside inside the test file; reusable-core hashes match the accepted Phase 13 baseline; fixed-camera differences are confined to the exact six allowlisted files; the demonstration-only limitation is present.

Acceptance is locked at 7/7 test groups passing, zero failed or incomplete tests, zero schema violations, zero uncontrolled failures, zero prohibited endpoints, unchanged reusable-core hashes, and exact six-file isolation. Any additional fixture, path, dependency, dataset, toolbox, hardware interface, core change, or control endpoint requires execution to stop for separate authorization. No project performance or production-readiness claim is permitted. Phases 15–17 remain **NOT AUTHORIZED**.

### Phase 14 verification disposition

**Independent decision:** **PASS — Yahya Helmy, Independent Verification & Validation Engineer, 2026-09-16.** Review used saved implementation, developer-test, YAML, hash, Git-scope, and limitation evidence; MATLAB was not independently rerun. Developer verification passed 7/7 with zero failures, incomplete tests, schema violations, uncontrolled failures, or prohibited endpoints. The review confirmed all fifteen requested findings, including inline-only deterministic fixtures, exact generic-contract mapping, controlled malformed handling, exact taxonomy and boundaries, advisory/approval behavior, zero command endpoints, confined project semantics, repeatability, unchanged protected hashes, exact six-file scope, and no performance claim.

**Project Owner acceptance:** **APPROVED — Nouran Ismail, 2026-09-16.** Phase 14 is **COMPLETE, VERIFIED AND ACCEPTED**. It remains an integration/workflow demonstration only and does not establish real-world inspection, production-line, machine-control, or production readiness. Phases 15–17 remain **NOT AUTHORIZED**.

### Approved Phase 15 reusability-evaluation acceptance controls

**Status:** **COMPLETE, VERIFIED AND ACCEPTED.** Developer assessment passed 4/4. Yahya Helmy — Independent Verification & Validation Engineer — reviewed saved evidence and independently reproduced the repository-byte hashes without rerunning MATLAB, then recorded **PASS** on 2026-09-17. Nouran Ismail — Project Owner — recorded **APPROVED** on 2026-09-17. Phase 15 remained read-only evaluation except for `reusability_evaluation.md`, `reusable_core_hashes.txt`, and `test_reusability.m`; Phases 13 and 14 remain frozen accepted evidence.

- `IIW-TST-REUSE-001`: enumerate the identical 17-file reusable-core inventory using normalized repository-relative paths and ordinal bytewise sorting; prove equality of every normalized path and individual raw-byte SHA-256; reproduce canonical aggregate `cb92fed88d4818d9f55ff94b3ff25f23bdca04b37db5fc01f29995bacfda0096`. Retain `41ba04cb0ca590e2706f47fb561b57e0e0ee64ed2a3b6d31a987904480357665` as the legacy-ordering aggregate in accepted Phase 13/14 evidence without rewriting those records.
- `IIW-TST-REUSE-002`: compare the UAV and fixed-camera bindings and confirm all mandatory generic interface fields, directions, types, dimensions, and semantics match.
- `IIW-TST-REUSE-003`: confirm application terminology and semantics remain confined to their project configurations/adapters and that zero reusable-core changes are attributable to either project.
- `IIW-TST-REUSE-004`: demonstrate detector substitution requires zero consumer-interface changes and produces no unauthorized modification.

Acceptance was met: two configurations used identical reusable-core paths and individual file hashes; project-semantic core changes, mandatory interface/direction mismatches, detector-substitution consumer changes, terminology leakage, and uncontrolled failures were zero; exactly three Phase 15 artifacts changed. The canonical aggregate input remains the concatenation, in ordinal bytewise ascending normalized-path order, of UTF-8-without-BOM `<repository-relative-forward-slash-path>\n<lowercase-64-hex-file-sha256>\n` entries, including the final LF and containing no CR, spaces, extra delimiters, or blank lines. Both labeled aggregates, all normalized inventory paths and individual hashes, the exact serialization, SHA-256 algorithm, file count, branch, commit, and generation date remain preserved. The stopped preflight and ordering-convention cause remain disclosed. `IIW-AC-011` through `IIW-AC-013` are satisfied. Phases 16–17 remain **NOT AUTHORIZED**.

- Applicable data-quality measures and thresholds.
- Label taxonomies and minimum per-label support not specifically approved for the Phase 7 KSDD2 binary task.
- Detection, calibration, and regression pass thresholds other than the approved Phase 7 KSDD2 criteria.
- Required operating-condition slices and robustness scenarios.
- Approval audit-retention duration; Phase 11 state, timeout, validity, delegation, escalation, identity, and audit-content behavior is approved.
- Evidence-retention duration and integrity mechanism.

## Gate 2 Review

| Field | Entry |
|---|---|
| Decision | **APPROVED** |
| Approver | Nouran Ismail — Project Owner |
| Approval date | 2026-09-06 |
| Comments | Approved for implementation-plan preparation only under ECR-20260906-001. Project metric values, thresholds, and anomaly classes require approval before training. |

## Gate 2 Interface-Schema Clarification Review

| Field | Entry |
|---|---|
| Decision | **APPROVED** |
| Clarification status | **APPROVED** |
| Approver | Nouran Ismail — Project Owner |
| Approval date | 2026-09-06 |
| Comments | Acceptance criteria `IIW-AC-020` through `IIW-AC-031` are approved. The interface-ambiguity blocker is **RESOLVED**; Phase 4 is **AUTHORIZED AND READY TO EXECUTE** but has not started. Phases 5–17 remain **NOT AUTHORIZED**. |
