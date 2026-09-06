# Generic Component Definitions

**Associated ECR:** ECR-20260906-001

**Status:** APPROVED — Gate 2 on 2026-09-06

| Component | Responsibility | Required inputs | Required outputs | Failure behavior |
|---|---|---|---|---|
| `InspectionSource` | Acquire or reference inspection data and acquisition context through a replaceable adapter. | Source configuration; acquisition trigger or schedule | Inspection data; acquisition metadata | Emit an unavailable/incomplete source status and evidence record. |
| `DataQualityValidation` | Evaluate schema, completeness, integrity, and configured quality measures before analysis. | Inspection data; acquisition metadata; quality policy | Data-quality result | Reject unsuitable data and request reacquisition or review. |
| `Preprocessing` | Apply ordered, versioned transformations to quality-approved data. | Inspection data; metadata; passing quality result; preprocessing configuration | Processed data; transformation record | Emit processing failure and prevent downstream use of incomplete output. |
| `Detection` | Produce candidate labels, locations where applicable, and confidence using a replaceable implementation. | Processed data; detection configuration; model record when applicable | Detection results | Emit unavailable/failed result; do not synthesize detections. |
| `FeatureExtraction` | Produce validated numerical features from approved upstream evidence. | Processed data and/or detection results; extractor configuration | Numerical feature set | Mark invalid features and prevent invalid sets from entering prediction. |
| `HealthPrediction` | Estimate configured condition or future measure from numerical features. | Numerical feature set; prediction configuration; model record | Health prediction | Emit invalid/unavailable prediction and uncertainty status. |
| `RiskAssessment` | Interpret evidence, uncertainty, and project policy into a reviewable risk result. | Quality result; detection results; numerical features; health prediction; risk policy | Risk assessment; rationale codes | Select conservative review/reacquisition disposition when mandatory evidence is unavailable. |
| `HumanApprovalGate` | Obtain and validate accountable approval for recommendations that can change supervised operation. | Risk assessment; proposed recommendation; approval policy; evidence references | Approval request; approval decision | Pending, rejected, expired, or unavailable approval prevents forwarding. |
| `RecommendedAction` | Form an advisory action record consistent with risk and approval state. | Risk assessment; approval decision; action mapping | Recommended action | Emit no actionable recommendation when quality, confidence, or approval constraints fail. |
| `EvidenceRecorder` | Record identifiers, versions, provenance, decisions, failures, and results across the workflow. | Events and records from every component | Evidence record; evidence-chain index | Report persistence failure explicitly; never fabricate a successful record. |

## Architectural Rules

1. Components communicate only through the contracts in `interface_contracts.md`.
2. `Detection` implementations are replaceable and cannot change consumer contracts.
3. `HealthPrediction` accepts numerical features only.
4. `HumanApprovalGate` controls recommendation eligibility, not external safety execution.
5. `EvidenceRecorder` observes every stage without becoming a decision authority.
6. Project taxonomies, thresholds, and action mappings remain outside these definitions.
