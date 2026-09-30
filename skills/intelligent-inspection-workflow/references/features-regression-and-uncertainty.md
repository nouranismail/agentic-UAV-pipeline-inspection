# Numerical Features, Health Prediction, and Uncertainty

Use this reference for the numerical boundary between analysis results and prediction, and for implementation-independent health prediction.

## Numerical Feature Contract

Each feature set shall contain:

- Stable feature-set identifier and source references
- Aligned names and numeric values
- Unit or unitless declaration for every value
- Validity indicators and missing-value semantics
- Extractor and schema versions
- Configuration and transformation references

Reject or explicitly mark invalid, non-finite, misaligned, or unsupported feature sets. Raw inspection payloads shall not enter the prediction interface.

## Feature Governance

Project configuration owns the selected features, units, ranges, aggregation windows, missing-value policy, extractor choice, and acceptance thresholds. Record feature-definition changes as versioned interface or configuration changes and reassess training data, models, metrics, and consumers.

## Health Prediction Contract

Keep the interface independent of a particular library or product API. A conforming implementation consumes only a validated numerical feature set and produces:

- Prediction identifier
- Estimate and declared semantics
- Applicable context or horizon
- Uncertainty representation
- Confidence status
- Feature-set reference
- Model or implementation version
- Schema version

Conventional regression, learned regression, statistical estimation, and approved deterministic methods may be substituted when they satisfy the same contract and verification criteria.

## Training Prerequisites

Do not fit or tune a predictor until dataset authority, split membership, leakage controls, target definition, feature set, horizon, uncertainty method, operating slices, metrics, thresholds, and reproducibility controls are approved.

## Regression and Uncertainty Metrics

Use approved metrics appropriate to the target:

- Mean absolute error and root mean squared error
- Bias and error distribution
- Coefficient of determination where meaningful
- Slice-specific error and minimum support
- Prediction-interval coverage and width
- Residual behavior and out-of-distribution response
- Repeatability or tolerance for deterministic reruns

Confidence and uncertainty are not interchangeable. Define their domains, calibration evidence, thresholds, and boundary equality behavior. Low confidence, excessive uncertainty, out-of-distribution input, or invalid features shall lead to review, reacquisition, or another approved non-action disposition.

## Evidence

Record dataset and split versions, feature schema and extractor version, training configuration, model version and hash, target/horizon, metric definitions and results, operating slices, residual and uncertainty review, limitations, failures, and approval status. Never infer or fabricate performance from model availability.
