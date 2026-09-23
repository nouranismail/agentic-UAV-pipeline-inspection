# Pipeline Health Regression Model Card

> Integration and workflow demonstration only; not evidence of real pipeline prognostic accuracy or production readiness.

- Status: CORRECTIVE DEVELOPER VERIFICATION PASS — 14/14; Project Owner review pending
- Model: ridge linear regression
- Lambda: 0.1
- Dataset: governed synthetic generator version 1.1
- Seed: 20260910
- Prediction horizon: 30 days
- Output range: [0,100]
- Standardization: training-partition statistics only; zero standard deviations replaced by 1
- Model ID/version: 9001001 / 1
- Active predictor IDs: 101–103 and 106–115
- Compatibility-only IDs: 104–105
- Training/validation/test rows: 420 / 90 / 90
- Training/validation/test groups: 70 / 15 / 15
- Validation RMSE stored in corrected model: 0.991368925577
- Frozen uncertainty: 0.009913689256
- Corrective test evaluation count: 1
- Total disclosed test exposures: 2
- Model bytes: 29264
- Model SHA-256: `A9C2C2D133AD33380F96D6AA5336A291EE286A955D206CD7A100EE42C345BA57`

## Saved Metrics

| Partition | MAE | RMSE | R-squared |
|---|---:|---:|---:|
| Training | 0.793630443306 | 0.967370859883 | 0.994537089116 |
| Validation | 0.804106356623 | 0.988700326866 | 0.992629033094 |
| Test — one frozen evaluation | 0.670958692320 | 0.830275031075 | 0.995152438749 |

All three numerical test thresholds passed. These metrics do not establish acceptance because developer verification found an interface-consistency failure.

## Known Failure and Limitations

- Developer tests: 10 passed, 4 failed, 0 incomplete.
- Generated records can contain `locationAvailable=true` while `detectionPresent=false`. The accepted Phase 8 feature contract requires location availability to imply detection presence.
- This causes the project adapter to return the controlled empty feature set for the affected nominal fixture and prevents valid `HealthPrediction` execution in four tests.
- No corrective generator, adapter, model, or test change was made after the frozen test result was observed.
- No real operational or prognostic validity is claimed.

The version-1 failed candidate remains part of the evidence history and is not accepted for integration or deployment.

## Corrective Generator 1.1 Result

- Approved correction: `locationAvailable = detectionPresent && locationAvailableCandidate`
- Invariant violations after regeneration: 0
- Cross-partition groups: 0
- Corrective developer tests: 14 passed, 0 failed, 0 incomplete
- Interface-schema violations: 0
- Uncontrolled failures: 0

| Partition | MAE | RMSE | R-squared |
|---|---:|---:|---:|
| Training | 0.788003918182 | 0.960682525725 | 0.994612368340 |
| Validation | 0.811366313301 | 0.991368925577 | 0.992589189477 |
| Test — second total exposure and single corrective exposure | 0.677788775627 | 0.833918328563 | 0.995109802619 |

The corrected candidate meets all locked developer acceptance criteria. This result is not independent verification or Project Owner acceptance.
