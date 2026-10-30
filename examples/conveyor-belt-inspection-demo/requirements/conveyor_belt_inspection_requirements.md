# Conveyor Belt Surface Inspection Reuse Demonstration Requirements

## Status

**DRAFT — GATE 2 PROJECT OWNER APPROVAL REQUIRED.**

## Scope and terminology

This document defines project-specific requirements for a future conveyor-belt
surface-inspection reuse demonstration. It does not authorize implementation,
data acquisition, MATLAB execution, or testing. “Conveyor” and “surface” are
project terms and shall remain outside the reusable core and shared workflow.

## CONV-REQ-001 — Source provenance

The project shall record the provenance, ownership or generator, license or
project-generated status, source identifier, and timestamp for every image
input before processing.

**Verification intent:** Inspect recorded source metadata and reject or report
missing provenance with a controlled status.

## CONV-REQ-002 — Generic source-contract mapping

The project source adapter shall map a supported RGB inspection frame and
project metadata into the unchanged `InspectionData` and `InspectionMetadata`
contracts without adding conveyor-specific fields to those contracts.

**Verification intent:** Compare required fields, types, dimensions, directions,
versions, and controlled invalid-output behavior against the approved generic
contracts.

## CONV-REQ-003 — Controlled invalid source handling

Malformed, missing, nonfinite, unsupported, or unprovenanced source input shall
produce controlled invalid or empty output. It shall not create fabricated image
metadata, detection, prediction, evidence success, or command output.

**Verification intent:** Use negative source cases and verify controlled status
with zero uncontrolled failure.

## CONV-REQ-004 — Quality-gated processing

Only an accepted `DataQualityResult` status shall permit downstream inspection
processing. Rejected or invalid quality results shall stop downstream processing
with a controlled status.

**Verification intent:** Exercise pass, reject, and malformed quality cases.

## CONV-REQ-005 — Conventional detector selection

The project shall use only the accepted Phase 6 conventional detector through
the approved replaceable detector contract. The Phase 7 deep-learning detector
shall remain disabled and shall not be selected as the operational detector.

**Verification intent:** Inspect detector identity and consumer-interface
conformance.

## CONV-REQ-006 — Generic feature extraction

The project shall consume `DetectionResult` through the approved numerical
feature extractor and shall not add project-specific anomaly size, physical
dimension, degradation, or sensor measurements to the reusable feature catalog
without a separately approved interface change.

**Verification intent:** Verify catalog/schema/version validation and controlled
no-detection behavior.

## CONV-REQ-007 — Prediction-context provenance

If a future demonstration uses the accepted Phase 9B prediction configuration,
every value not obtained from the image source shall be deterministic,
individually labeled `DEMONSTRATION_CONTEXT`, and never represented as observed
camera, conveyor, or sensor data. Unavailable values shall remain unavailable.

**Verification intent:** Inspect field-level provenance and controlled behavior
when required context is unavailable.

## CONV-REQ-008 — Advisory-only risk and approval behavior

Risk assessment, HumanApprovalGate evaluation, and recommendation mapping shall
remain advisory. They shall not issue conveyor control, actuator, mission,
flight, approval-command, ReturnToHome, SafeLanding, or safety-command output.

**Verification intent:** Static endpoint inspection and controlled approval/risk
cases.

## CONV-REQ-009 — Evidence integrity and privacy

The future project shall use the approved evidence-recording boundary for
metadata, provenance, status, and references. It shall not commit raw image
payloads, credentials, personal data, or unlicensed external data.

**Verification intent:** Verify controlled evidence-chain behavior, reference
integrity, and repository-scope checks.

## CONV-REQ-010 — Reuse isolation

The future project shall use the unchanged
`skills/simulink-engineering-workflow/SKILL.md` and frozen reusable core.
Conveyor-specific source mapping, terminology, metadata, thresholds, and future
test fixtures shall remain project-local.

**Verification intent:** Compare shared-workflow and reusable-core hashes before
and after future project execution; inspect exact changed-path inventory.

## Draft acceptance direction

Gate 2 shall define an exact source-data policy, future allowlist, named roles,
test identifiers, measurable pass/fail criteria, hash procedure, and evidence
retention controls. No result may be described as real conveyor-defect
performance or production readiness unless separately supported by approved
data, evaluation, and acceptance evidence.
