# Preprocessing and Replaceable Detection

Use this reference for controlled preprocessing and for conventional or learned detection implementations behind the common detection contract.

## Preprocessing

1. Accept only data with the required quality disposition.
2. Preserve the original source record and create a new processed-data reference.
3. Record every transformation in execution order with parameters, implementation version, configuration version, and input/output references.
4. Define deterministic behavior for missing, invalid, unsupported, or non-finite values.
5. Prevent incomplete processing output from reaching detection or feature extraction.

Project-selected transformations and values belong in configuration. Reusable guidance does not prescribe enhancement sequences or thresholds.

## Detection Boundary

All conventional computer-vision and learned implementations shall conform to one replaceable boundary. A detection result identifies the analyzed item, label identifier, confidence, optional location, implementation or model version, and schema version. Project configuration owns label meanings and selected implementation.

An implementation failure, unavailable model, invalid output, or unsupported input produces an explicit failure record and no synthesized detection.

## Training and Model Controls

Do not fit, tune, calibrate, or train until the dataset governance record and project metric policy are approved. Record:

- Dataset and split versions
- Training configuration and random-state controls
- Implementation, dependency, and compute environment versions
- Input and output contracts
- Model identity, version, integrity hash, and storage reference
- Confidence semantics and calibration method
- Intended operating envelope and unsupported conditions

Changing a model artifact, preprocessing assumption, taxonomy, or decision threshold creates a new controlled version and requires impact analysis.

## Metrics

Select metrics appropriate to the task and approved risk:

- Classification: per-label precision, recall, F1, confusion matrix, support, false-positive rate, and false-negative rate.
- Detection: precision-recall measures, average precision where meaningful, localization overlap, localization error, and support.
- Segmentation: per-label overlap measures, boundary measures where meaningful, precision, recall, and support.
- Confidence: calibration error or an approved proper scoring measure, reliability by operating slice, and abstention behavior.

Report the dataset version, split, operating slices, support, threshold, uncertainty, and confidence interval where applicable. Never report an achieved value without executed evidence.

## Verification Cases

Cover normal, empty-result, ambiguous, low-confidence, corrupt-input, degraded-quality, unsupported-schema, missing-model, invalid-output, unavailable-component, and deterministic-repeat behavior. Demonstrate implementation replacement without consumer-interface changes.

Use the [model card template](../../../templates/templates/model_card_template.md) for each selected model or algorithm version.
