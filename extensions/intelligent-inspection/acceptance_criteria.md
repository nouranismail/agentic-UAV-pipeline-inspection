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

## Unresolved Acceptance Decisions

- Applicable data-quality measures and thresholds.
- Label taxonomy and minimum per-label support.
- Detection, calibration, and regression pass thresholds.
- Required operating-condition slices and robustness scenarios.
- Approval expiry, timeout, delegation, and audit-retention policies.
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
