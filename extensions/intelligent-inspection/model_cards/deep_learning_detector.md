# Model Card: Phase 7 Deep-Learning Detector

Status: **DEVELOPER ACCEPTANCE FAIL** — training and verification completed, but two locked performance thresholds were missed.

The compact U-Net implements binary `background`/`anomaly` segmentation through the replaceable `DetectorContract` and approved `DetectionResult`. Nouran Ismail (AI & Algorithm Developer) trained model version 1 on 2026-09-09.

Dataset: KSDD2, supplied by ViCoS Laboratory and Kolektor Group for approved non-commercial use under CC BY-NC-SA 4.0. Attribution and ShareAlike apply to the model and adaptations; dataset payloads remain outside Git. Archive SHA-256: `EDCDB486809B24F1D17B785E30C52FAFC5999554DD5FE18DDF77B61CEB6F36A8`.

## Training and split

- Canonical samples: 3,335; official training: 2,331; official test: 1,004.
- Deterministic official-training-only split: 1,865 training and 466 validation samples, stratified using SHA-256 ordering, configuration `KSDD2-validation-v1`, seed 7,092,026.
- Official test data was not used for fitting or tuning. It was evaluated twice because the first completed evaluation could not be persisted after a model-save path error. Configuration and threshold were unchanged; this deviation requires Project Owner disposition.
- Compact U-Net input `64 x 64 x 3`, encoder depth 2, 8 initial filters, no pretrained weights.
- Adam, learning rate 0.001, mini-batch 16, 3 epochs, class weights `[1, 8]`.
- CPU fallback because GPU was unavailable; training time 206.8864 seconds.
- Maximum epochs completed at iteration 348; final training loss 0.063078 and validation loss 0.016072.
- Validation-selected pixel threshold: 0.45.

## Results

| Metric | Validation | Untouched test | Criterion |
|---|---:|---:|---:|
| Pixel Dice | 0.5666 | 0.4203 | Report |
| Pixel IoU | 0.3952 | 0.2660 | Report |
| Image precision | 0.9459 | 0.8750 | >= 0.70 — PASS |
| Image recall | 0.7292 | 0.6364 | >= 0.75 — **FAIL** |
| Image F1 | 0.8235 | 0.7368 | >= 0.72 — PASS |
| Positive-image mean Dice | 0.4193 | 0.2959 | >= 0.50 — **FAIL** |
| Negative-image false-positive rate | 0.0048 | 0.0112 | <= 0.15 — PASS |
| Mean inference time | 0.01305 s | 0.01231 s | Report |

Test confusion matrix `[TN FP; FN TP]`: `[884 10; 40 70]`. Uncontrolled failures: 0. Developer tests: PASS — 9/9.

## Limitations and integrity

This is not production-ready or validated for another inspection domain. The narrow, imbalanced dataset and the missed recall and positive-image Dice criteria prevent operational approval. Low-confidence and malformed inputs are controlled. The detector issues no approval, mission, or safety commands.

- Execution deviation: official-test evaluation count was 2.
- Model size: 733,560 bytes.
- Model SHA-256: `5D44D817C708104A67632A0290B4C5D10A942FC9D130302F97C7E5C58A42D93B`.
- Independent verification: PENDING; different named reviewer required.
- Project Owner review: PENDING.

## Corrective-training authorization

Nouran Ismail, Project Owner, authorized corrective training on 2026-09-09. Phase 7 remains **FAIL - CORRECTIVE TRAINING AUTHORIZED**. The authorization permits no more than three training/validation-only candidates, aspect-ratio-preserving `72 x 192` input (or a documented downsampling-compatible equivalent), aligned nearest-neighbor mask resizing, up to 10 epochs, validation early stopping with documented patience, deterministic training-only augmentation, continued imbalance handling, and validation-only threshold selection from a grid fixed before execution.

Architecture, weights, preprocessing, and threshold must be frozen before exactly one additional official-test evaluation. The two earlier evaluations remain disclosed, and the corrective result cannot be described as fully blind. Performance thresholds, partitions, official-test membership, interfaces, allowlist, and licensing restrictions remain unchanged. Phases 8-17 remain not authorized.

## Corrective model version 2 result

One candidate, `corrective-01`, was trained and selected using training and validation data only. Its frozen configuration uses a centered aspect-ratio-preserving `192 x 72 x 3` letterbox, nearest-neighbor mask resizing, encoder depth 2, 8 initial filters, class weights `[1, 8]`, deterministic seed 7,092,026, and threshold grid `[0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75]`. The portrait-equivalent size is divisible by the U-Net downsampling factor and avoids the failed baseline's square distortion.

Training stopped through validation patience 4 at iteration 650 in epoch 6; the frozen best-validation network was iteration 450. Training took 689.446329 seconds. The validation rule selected threshold 0.45 with recall 0.877551 and positive-image mean Dice 0.533960.

| Metric | Corrective validation | Official-test exposure 3 | Locked criterion |
|---|---:|---:|---:|
| Pixel Dice | 0.579176 | 0.500998 | Report |
| Pixel IoU | 0.407634 | 0.334221 | Report |
| Image precision | 0.364407 | 0.369231 | >= 0.70 - **FAIL** |
| Image recall | 0.877551 | 0.872727 | >= 0.75 - PASS |
| Image F1 | 0.514970 | 0.518919 | >= 0.72 - **FAIL** |
| Positive-image mean Dice | 0.533960 | 0.480120 | >= 0.50 - **FAIL** |
| Negative-image false-positive rate | 0.179856 | 0.183445 | <= 0.15 - **FAIL** |
| Mean inference time | 0.013525 s | 0.013745 s | Report |

Exposure-3 confusion matrix `[TN FP; FN TP]`: `[730 164; 14 96]`. Schema violations and uncontrolled failures: 0. Frozen-model developer tests: PASS - 10/10.

Corrective model size: 773,126 bytes. SHA-256: `2F5557B291B7220DD8E59A7B93ABDA7B54963B4E3C3E334577F214BB7976A0B6`.

This third exposure is not fully blind because the two earlier official-test results were observed. Phase 7 remains **FAIL** and awaits Project Owner review; no further official-test evaluation is authorized.

## Project Owner disposition

Reviewed by Nouran Ismail — Project Owner on 2026-09-09 using the saved evidence only.

- Phase 7 implementation activity: **COMPLETE**.
- Developer unit verification: **PASS — 10/10**.
- Locked performance acceptance: **FAIL**.
- Decision: **NOT ACCEPTED FOR DEPLOYMENT**.
- Artifact disposition: **RETAINED AS AN EXPERIMENTAL PROTOTYPE WITH LIMITATIONS**.
- Default status: **DISABLED**; the approved operational detector remains the Phase 6 conventional detector.
- Failed locked criteria: precision 0.369231 versus 0.70; F1 0.518919 versus 0.72; positive-image mean Dice 0.480120 versus 0.50; negative-image false-positive rate 0.183445 versus maximum 0.15.
- Recall passed at 0.872727; interface conformance and controlled execution passed.
- Three official-test exposures occurred, so the final evaluation is not fully blind.
- Independent verification is **NOT REQUESTED** until performance is accepted. No further official KSDD2 test evaluation is authorized.

The failed results and thresholds remain unchanged. This model is not production-ready and must not be selected by default.
