# Gate 2 Acceptance Criteria and Metric Definitions

**Associated ECR:** ECR-20260906-001

**Status:** APPROVED — Gate 2 on 2026-09-06

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
