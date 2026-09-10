# Phase 7 Deep-Learning Detection Results

## Status

- Implementer: Nouran Ismail — AI & Algorithm Developer
- Execution date: 2026-09-09
- Implementation/training: COMPLETE
- Developer verification: **PASS — 9 passed, 0 failed, 0 incomplete**
- Locked performance acceptance: **FAIL**
- Independent verification and Project Owner review: PENDING

No Phase 8–17 behavior was implemented. The detector issues no approval, mission, or safety command.

## Environment and data

MATLAB R2026a Update 4 (`26.1.0.3312084`) and Deep Learning Toolbox 26.1 were used. A controlled CPU fallback was used because a GPU was unavailable.

KSDD2 archive SHA-256: `EDCDB486809B24F1D17B785E30C52FAFC5999554DD5FE18DDF77B61CEB6F36A8`. The 3,335 canonical pairs comprise official training 2,331 (246 positive, 2,085 negative) and official test 1,004 (110 positive, 894 negative). Two documented copy files were excluded, and no exact source-image duplicate crossed official partitions.

Only the official training partition was split: 1,865 training and 466 validation samples using stratified SHA-256 ordering, `KSDD2-validation-v1`, and seed 7,092,026. Official test data was excluded from all tuning. It was evaluated twice because the first completed evaluation could not be persisted after a repository-root model-save path error. The deterministic rerun used unchanged configuration and threshold. This deviates from the authorized single evaluation and requires Project Owner disposition.

## Training

- Compact U-Net; `64 x 64 x 3`; encoder depth 2; 8 initial filters; no pretrained weights.
- Adam; learning rate 0.001; mini-batch 16; class weights `[1, 8]`; 3 epochs.
- Maximum epochs completed at iteration 348; duration 206.8864 seconds.
- Last training losses: 0.003025, 0.016467, 0.063078.
- Last validation losses: 0.022133, 0.022795, 0.016072.
- Validation-selected threshold: 0.45.

## Metrics

| Metric | Validation | Untouched test | Criterion / result |
|---|---:|---:|---:|
| Pixel Dice | 0.566556 | 0.420262 | Report |
| Pixel IoU | 0.395242 | 0.266033 | Report |
| Image precision | 0.945946 | 0.875000 | >= 0.70 — PASS |
| Image recall | 0.729167 | 0.636364 | >= 0.75 — **FAIL** |
| Image F1 | 0.823529 | 0.736842 | >= 0.72 — PASS |
| Positive-image mean Dice | 0.419286 | 0.295946 | >= 0.50 — **FAIL** |
| Negative-image false-positive rate | 0.004785 | 0.011186 | <= 0.15 — PASS |
| Mean inference time | 0.013046 s | 0.012309 s | Report |

Official-test confusion matrix `[TN FP; FN TP]`: `[884 10; 40 70]`. Uncontrolled failures: 0. No threshold changed after test evaluation.

## Test and artifact evidence

Only `tests/intelligent-inspection/test_deep_learning_detector.m` ran. Nine tests covered loading, contract compatibility, exact schema, anomaly, no-detection, malformed input, low confidence, determinism, and provenance/version. Result: 9 passed, 0 failed, 0 incomplete.

- Model size: 733,560 bytes.
- Model SHA-256: `5D44D817C708104A67632A0290B4C5D10A942FC9D130302F97C7E5C58A42D93B`.
- Warning: GPU unavailable; CPU fallback used.
- Errors in completed run: none.

Phase 7 is **FAIL** because test recall and positive-image mean Dice missed locked minima. Results were neither suppressed nor retuned against the test partition.

## Corrective-training execution

Corrective training was authorized after the preceding failure. The earlier metrics and two official-test exposures above remain the preserved baseline.

### Candidate and selection evidence

Exactly one candidate was evaluated, within the maximum of three:

| Candidate | Input and architecture | Training configuration | Selected validation result |
|---|---|---|---|
| `corrective-01` | Centered letterbox `192 x 72 x 3`; compact U-Net; encoder depth 2; 8 initial filters | Adam 0.001; batch 16; maximum 10 epochs; class weights `[1, 8]`; seed 7,092,026; patience 4; deterministic reflection, +/-4-pixel translation and +/-0.05 image-only intensity variation | Threshold 0.45; recall 0.877551; positive-image mean Dice 0.533960; F1 0.514970; FPR 0.179856 |

The input is the documented portrait-oriented equivalent to preferred `72 x 192`; it preserves source aspect ratio through centered letterboxing and is divisible by the network downsampling factor. Masks use nearest-neighbor interpolation. Translation and reflection remain aligned; intensity variation applies only to images.

The threshold grid was locked before execution as `[0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75]`. Candidate and threshold selection used only training and validation data. Since validation recall exceeded 0.75, the approved rule selected by positive-image mean Dice, then F1 and lower FPR. With one candidate, `corrective-01` was frozen.

### Training history

- Training: 1,865 samples, including 197 positive.
- Validation: 466 samples, including 49 positive.
- Official test: 1,004 samples, including 110 positive; membership unchanged.
- Training stopped by the validation criterion in epoch 6 at iteration 650.
- Frozen best-validation network: iteration 450.
- Training duration: 689.446329 seconds on CPU.
- Last training losses at iterations 648-650: 0.0049748, 0.011950, 0.100990.
- Last validation losses at iterations 550, 600 and 650: 0.023290, 0.015491, 0.024509.

### Frozen result and official-test exposure 3

Architecture, weights, preprocessing, threshold 0.45 and configuration were frozen before the single additionally authorized evaluation. This third exposure is not described as fully blind.

| Metric | Corrective validation | Official test exposure 3 | Locked criterion / result |
|---|---:|---:|---:|
| Pixel Dice | 0.579176 | 0.500998 | Report |
| Pixel IoU | 0.407634 | 0.334221 | Report |
| Image precision | 0.364407 | 0.369231 | >= 0.70 - **FAIL** |
| Image recall | 0.877551 | 0.872727 | >= 0.75 - PASS |
| Image F1 | 0.514970 | 0.518919 | >= 0.72 - **FAIL** |
| Positive-image mean Dice | 0.533960 | 0.480120 | >= 0.50 - **FAIL** |
| Negative-image false-positive rate | 0.179856 | 0.183445 | <= 0.15 - **FAIL** |
| Mean inference time | 0.013525 s | 0.013745 s | Report |

Exposure-3 confusion matrix `[TN FP; FN TP]`: `[730 164; 14 96]`. Schema violations: 0. Uncontrolled failures: 0.

### Developer verification and artifact

Only `tests/intelligent-inspection/test_deep_learning_detector.m` ran after freezing: 10 passed, 0 failed, 0 incomplete. Coverage included loading, contract compatibility, exact schema, anomaly, no detection, malformed input, low confidence, deterministic inference, provenance/version, and the frozen corrective configuration.

- Model version: 2.
- Model size: 773,126 bytes.
- Model SHA-256: `2F5557B291B7220DD8E59A7B93ABDA7B54963B4E3C3E334577F214BB7976A0B6`.
- Warning: GPU unavailable; controlled CPU execution used.
- Controlled pre-training issue: logical-mask translation initially rejected a logical fill value; it was corrected to numeric zero before training began and caused no official-test exposure.
- No further official-test evaluation is authorized.

Final Phase 7 developer status: **FAIL**. Recall, schema conformance and controlled execution passed, but precision, F1, positive-image mean Dice and negative-image false-positive rate missed locked criteria. No threshold was lowered or tuned from official-test results.

## Project Owner review — 2026-09-09

Nouran Ismail — Project Owner reviewed the existing saved evidence without retraining, reevaluation, threshold changes, or MATLAB execution.

| Disposition item | Result |
|---|---|
| Phase 7 implementation activity | **COMPLETE** |
| Developer unit verification | **PASS — 10/10** |
| Locked performance acceptance | **FAIL** |
| Project Owner decision | **NOT ACCEPTED FOR DEPLOYMENT** |
| Artifact disposition | **RETAINED AS AN EXPERIMENTAL PROTOTYPE WITH LIMITATIONS** |
| Deep-learning detector default | **DISABLED** |
| Approved operational detector | Phase 6 conventional detector |
| Independent verification | **NOT REQUESTED** until performance is accepted |
| Further official KSDD2 test evaluation | **NOT AUTHORIZED** |

Failed locked criteria remain: precision 0.369231 versus required 0.70; F1 0.518919 versus required 0.72; positive-image mean Dice 0.480120 versus required 0.50; and negative-image false-positive rate 0.183445 versus maximum 0.15. Recall passed at 0.872727. Interface conformance and controlled execution passed. Three official-test exposures occurred, and the final evaluation is not fully blind.

The failed results and approved thresholds remain unchanged. The model is not production-ready and shall not be selected by default.
