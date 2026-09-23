# Inspection Source, Dataset Governance, and Data Quality

Use this reference when defining an inspection source, approving a dataset, or deciding whether acquired data is suitable for analysis.

## Source Contract

Support live, recorded, and simulated sources through the same generic contract. Each item shall identify its payload reference, modality, source, sequence, timestamp, schema version, acquisition context, and applicable calibration reference. The adapter may translate transport-specific fields but shall not change mandatory downstream semantics.

For missing payloads, unsupported schemas, incomplete metadata, unavailable calibration, stale timing, or source failure, emit an explicit invalid or unavailable result and an evidence record. Do not synthesize usable input.

## Dataset Approval Before Training

Before any fitting, tuning, calibration, or training, record and approve:

- Dataset ID, owner, steward, source, acquisition method, and intended use
- License, access rights, redistribution limits, privacy constraints, and retention rules
- Immutable dataset version, manifest, integrity hashes, and storage reference
- Annotation source, policy, reviewer process, label version, and known ambiguity
- Inclusion, exclusion, deduplication, and quality rules
- Train, validation, and test assignment method and immutable membership
- Grouping rules that keep related samples in one split
- Leakage analysis covering duplicates, identities, time adjacency, preprocessing, labels, and external data
- Representativeness, known gaps, expected operating slices, imbalance, and minimum support
- Approved metrics, thresholds, confidence policy, and accountable approvers

Any unresolved legal right, ownership, split integrity, leakage, or version issue is a training stop.

## Quality Assessment

Select only measures relevant to the approved modality and operating context. Candidate measures include:

- Payload integrity and decode success
- Metadata, timestamp, context, and calibration completeness
- Exposure or valid-range fraction
- Contrast or value spread
- Sharpness or blur
- Noise or signal-to-noise estimate
- Obstruction or usable-area fraction
- Spatial or temporal sampling sufficiency

For every selected measure, record its definition, unit or domain, computation version, threshold reference, boundary behavior, and reason codes. Threshold values are project configuration, not reusable defaults.

## Required Dispositions

Each submitted item produces exactly one status:

- `PASS`: eligible for approved preprocessing.
- `REVIEW`: not eligible for autonomous downstream action; request accountable review or reacquisition.
- `REJECT`: prevent downstream action; request reacquisition or record terminal rejection according to policy.

Normal, invalid, degraded, borderline, rejected, unavailable-source, and repeated-input cases require evidence. Low-quality input shall not become an actionable recommendation.

## Evidence

Preserve item and source IDs, source and adapter versions, measured values, threshold references, status, reason codes, validator version, disposition, timestamp, and links to any reacquisition or review. Never replace a failed or rejected record with synthetic success evidence.

Use the [dataset governance template](../../../templates/templates/dataset_governance_template.md) for the approval record.
