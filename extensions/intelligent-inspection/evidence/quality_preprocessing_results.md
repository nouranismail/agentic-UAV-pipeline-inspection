# Phase 5 Data-Quality Validation Evidence

**Associated ECR:** ECR-20260906-001  
**Phase:** 5 — Inspection Source and Data-Quality Validation  
**Execution date:** 2026-09-08  
**Developer:** Nouran Ismail — AI & Algorithm Developer  
**Developer evidence status:** **PASS — CORRECTIVE RERUN**

Despite this artifact's historical filename, image preprocessing was not implemented or tested. The implementation assesses input quality without transforming the supplied payload.

## Toolchain

| Product | Observed/recorded version | Evidence basis |
|---|---|---|
| MATLAB | R2026a Update 4 (`26.1.0.3312084`) | Approved Phase 1 preflight and the Phase 5 MATLAB execution environment |
| Image Processing Toolbox | `26.1` | Approved Phase 1 preflight and Phase 5 dependency record |

Image Processing Toolbox was installed, licensed, and approved specifically for Phase 5 use before execution.

## Function Interface

```matlab
result = iiw.quality.validateInspectionData( ...
    inspectionData, inspectionMetadata, payload, configuration)
```

- `inspectionData` and `inspectionMetadata` are validated against the approved runtime contracts.
- `payload` is the content resolved by the caller for `InspectionData.payloadRef`; no separate source implementation was created.
- `configuration` supplies validator version, numeric reason codes, threshold references, and quality thresholds.
- `result` uses the approved `DataQualityResult` fields and fixed dimensions.

## Quality Metrics and Formulas

The `measures` vector uses this generic ordering for an image payload:

| Index | Measure | Formula/domain |
|---:|---|---|
| 1 | Aggregate quality score | Minimum of the four bounded metric-compliance scores, `[0,1]` |
| 2 | Brightness | Mean normalized grayscale intensity, `[0,1]` |
| 3 | Contrast | `min(2 * std(normalized grayscale), 1)` |
| 4 | Sharpness | Mean absolute four-neighbour Laplacian response divided by 4 and clipped to `[0,1]` |
| 5 | Saturation/overexposure fraction | Fraction of normalized grayscale samples at or above `saturationLevel` |
| 6 | Valid fraction | `1` after payload integrity and finite-value validation |

The validator rejects structurally invalid records or payloads. Image data outside any configured brightness, contrast, sharpness, or saturation boundary receives `REJECT`. Identical inputs and configuration use no random or stateful operation.

## Threshold Sources

No application threshold is hard-coded in the reusable function. The deterministic fixture supplies the following test-only configuration:

| Threshold | Fixture value | Runtime source |
|---|---:|---|
| Minimum brightness | 0.20 | `configuration.minBrightness` |
| Maximum brightness | 0.80 | `configuration.maxBrightness` |
| Minimum contrast | 0.10 | `configuration.minContrast` |
| Minimum sharpness | 0.03 | `configuration.minSharpness` |
| Maximum saturation fraction | 0.25 | `configuration.maxSaturationFraction` |
| Saturation level | 0.95 | `configuration.saturationLevel` |

Threshold evidence references are supplied through `configuration.thresholdRefs`. Numeric reason codes are supplied through `configuration.reasonCodes`.

## Fixture Inventory

`tests/intelligent-inspection/fixtures/quality_contract_fixtures.mat` contains:

- conforming `InspectionData` and `InspectionMetadata` records;
- configurable thresholds, threshold references, reason codes, and validator version;
- nominal image and numerical-signal payloads;
- dark, bright, low-contrast, blurred, overexposed, and nonfinite images.

Fixtures are deterministic and contain no trained or project-specific data.

## Initial Test Results

Only this command target was run:

```text
tests/intelligent-inspection/test_data_quality.m
```

Observed MATLAB summary:

```text
16 total
14 passed
2 failed
0 incomplete
```

Passing coverage included nominal image and numerical-sensor inputs, missing fields, empty payload, malformed type and dimensions, nonfinite content, dark, bright, low-contrast, blurred, overexposed, deterministic repetition, and prohibited-terminology checks.

Failures:

1. `test_data_quality/exactBrightnessBoundaryPasses`: expected `PASS (1)` but received `REJECT (3)`. The exact-boundary behavior therefore remains unresolved.
2. `test_data_quality/resultMatchesApprovedSchema`: field names were semantically identical, but the test compared the character-vector cells returned by `fieldnames` with string-valued cells. The schema assertion requires correction and rerun before conformance can be claimed.

No failure was suppressed or converted into a passing result.

## Corrective Repair and Isolated Rerun

The Project Owner approved one corrective repair after clarifying that minimum and maximum quality boundaries are inclusive, both operands are represented as MATLAB `single` values before comparison, no implicit tolerance is permitted, nonfinite values are rejected first, and equal minimum and maximum thresholds require exact `single` equality.

Corrective changes:

1. `validateInspectionData.m` now represents each measured quality value and configured threshold as `single` before applying inclusive minimum and maximum comparisons. The score calculations use explicit zero-denominator branches rather than an implicit numeric tolerance.
2. `test_data_quality.m` now converts the character-vector cells returned by `fieldnames` to a string array before comparing them with the expected string array. No `DataQualityResult` field was added, removed, renamed, or reordered.
3. The fixture thresholds and fixture data were not changed.

Only the full Phase 5 test file was rerun:

```text
Running test_data_quality
.......... ......
Done test_data_quality

Totals:
   16 Passed, 0 Failed, 0 Incomplete.
   4.0844 seconds testing time.

PHASE5_CORRECTIVE_COUNTS passed=16 failed=0 incomplete=0 total=16
```

Corrective-rerun warnings and errors: none reported by the test suite. No test was suppressed, removed, weakened, or bypassed.

## Warnings and Errors

- The first sandboxed MATLAB launch failed before command execution with `Fatal Startup Error: System Error: File system inconsistency`. The same authorized fixture-generation command succeeded when MATLAB was launched using the approved elevated execution path.
- The test process exited with `Phase5:TestsNotPassing` because two tests failed.
- No incomplete test was reported.

## Scope Exclusions

The Phase 5 implementation contains no:

- separate `InspectionSource` implementation;
- preprocessing or payload transformation;
- detection or learned model;
- feature extraction;
- regression, prediction, or uncertainty logic;
- risk, approval, or recommendation behavior;
- operational or mission-control behavior.

## Protected Artifacts

Git status was clean immediately before Phase 5. After implementation and test execution, only the four Phase 5 allowlisted paths changed. The System Composer architecture, interface dictionary, verified `MissionSupervisor`, UAV requirements, tests, coverage, and evidence were not modified or executed.

## Phase 5 Disposition

**PASS — all 16 Phase 5 tests passed with zero failures and zero incomplete tests after the authorized corrective repair.**

This is developer evidence, not independent verification or Project Owner acceptance. Phases 6–17 remain unauthorized.
