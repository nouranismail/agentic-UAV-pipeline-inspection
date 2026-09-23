# Phase 6 Conventional Detection Developer Evidence

## Identification

| Field | Value |
|---|---|
| ECR | `ECR-20260906-001` |
| Phase | Phase 6 — Replaceable Computer-Vision Detection |
| Implementer | Nouran Ismail — AI & Algorithm Developer |
| Evidence status | **DEVELOPER VERIFICATION PASS — 16/16** |
| Independent verification | **PENDING — different named reviewer required** |

## Approved Scope

The Phase 6 implementation is limited to the common detector contract, detector dispatch, one deterministic conventional reference detector, contract/replacement tests, deterministic generic fixtures, and this evidence record. It consumes the approved `ProcessedData` schema and emits the approved `DetectionResult` schema.

Segmentation, learned detection, training, fitting, tuning, feature extraction, prediction, risk assessment, approval, recommendation, operational control, and project-specific behavior are not implemented.

## Toolchain

| Product | Version | Evidence |
|---|---|---|
| MATLAB | R2026a Update 4 (`26.1.0.3312084`) | Fixture generation and isolated Phase 6 test execution |
| Image Processing Toolbox | 26.1 | Approved dependency preflight and executed conventional operations |
| Computer Vision Toolbox | 26.1 | Installed, licensed, and approved dependency record |

## Detector Contract

`DetectorContract` defines the replaceable detector descriptor and validates the approved `ProcessedData` and `DetectionResult` schemas. A descriptor contains a function handle, numeric implementation identifier, and implementation version. `runDetector` accepts any conforming descriptor without depending on a concrete detector name.

The exact `DetectionResult` fields are:

```text
resultId           uint32 [1 1]
processedItemId    uint32 [1 1]
labelId            uint8  [1 1]
confidence         single [1 1]
location           double [3 1]
modelVersion       uint16 [1 1]
schemaVersion      uint16 [1 1]
confidenceValid    logical [1 1]
locationValid      logical [1 1]
frameId            uint16 [1 1]
```

The processed-item, result, implementation-version, schema-version, confidence, and optional configured-frame location values preserve the provenance and evidence references available in the approved interface. Human-readable labels remain outside the runtime contract.

## Configuration and Conventional Operations

The deterministic reference detector converts the resolved image payload to `single`, normalizes color input to grayscale, optionally smooths it, applies a configured bright- or dark-region threshold, removes regions below the configured minimum area, and selects the largest remaining connected region. It derives bounded confidence from intensity separation and optionally maps the centroid into a configured Cartesian frame.

Configuration owns all identifiers, schema/version values, thresholds, smoothing, minimum area, confidence disposition, and location mapping. No fitting, tuning, learned model, taxonomy name, or project threshold is embedded.

## Fixture Inventory

The fixture contains one conforming ProcessedData record, three deterministic 32-by-32 generic images (nominal, background-only, and low-confidence), and one fixed numeric detector configuration.

## Test Results

Only these Phase 6 tests are authorized for execution:

- `tests/intelligent-inspection/test_detection_contract.m`
- `tests/intelligent-inspection/test_detector_replacement.m`

The first complete run produced 15 passed, 1 failed, and 0 incomplete. The failed test expected no detection when the configured intensity threshold equaled the brightest input. The implementation correctly applied the inclusive threshold and returned low confidence. The test was corrected to vary minimum area instead; production logic was unchanged.

The corrected complete rerun produced 16 passed, 0 failed, and 0 incomplete. The tests cover schema conformance, nominal/no-detection/low-confidence behavior, malformed and nonfinite input, confidence and location constraints, provenance, determinism, configurable thresholds, prohibited terminology, replacement, invalid output, execution failure, and malformed detector descriptors.

No achieved precision, recall, F1, localization, or calibration metric is claimed because dataset fitting, tuning, and performance evaluation are outside Phase 6.

## Warnings and Errors

- The initial sandboxed fixture-generation launch failed before command execution with a MATLAB file-system inconsistency; the approved local R2026a execution path succeeded.
- The MATLAB connector could not attach, so analysis and tests used the local R2026a batch path.
- Code Analyzer reported one test-helper output potentially unset. The helper now assigns a default before injecting the expected error; production behavior was unchanged.
- The final test execution reported no warning or error.

## Protected Artifacts

The verified supervisor, existing architecture and dictionary, Phase 5 artifacts, and all Phase 7–17 artifacts are protected from modification.

## Phase 6 Disposition

**DEVELOPER VERIFICATION PASS — 16/16**

This is developer evidence, not independent verification or final acceptance. A different named Independent Verification Engineer remains required.
