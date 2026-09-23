# Generic Component Definitions

**Associated ECR:** ECR-20260906-001

**Baseline status:** APPROVED — Gate 2 on 2026-09-06

**Clarification status:** APPROVED — Nouran Ismail, Project Owner, 2026-09-06

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

## Approved Architecture Boundary Ports

| Direction | Port | Interface | Destination/source |
|---|---|---|---|
| Input | `inspectionDataIn` | `InspectionData` | `InspectionSource.inspectionDataIn` |
| Input | `inspectionMetadataIn` | `InspectionMetadata` | `InspectionSource.inspectionMetadataIn` |
| Input | `approvalDecisionIn` | `ApprovalDecision` | `HumanApprovalGate.approvalDecisionIn` |
| Output | `approvalRequestOut` | `ApprovalRequest` | `HumanApprovalGate.approvalRequestOut` |
| Output | `recommendedActionOut` | `RecommendedAction` | `RecommendedAction.recommendedActionOut` |
| Output | `evidenceRecordOut` | `EvidenceRecord` | `EvidenceRecorder.evidenceRecordOut` |

## Approved Component Port Assignments

| Component | Input ports and interfaces | Output ports and interfaces | Evidence observation |
|---|---|---|---|
| `InspectionSource` | `inspectionDataIn: InspectionData`; `inspectionMetadataIn: InspectionMetadata` | `inspectionData: InspectionData`; `inspectionMetadata: InspectionMetadata` | `evidenceOut: InspectionMetadata` |
| `DataQualityValidation` | `inspectionData: InspectionData`; `inspectionMetadata: InspectionMetadata` | `qualityResult: DataQualityResult` | `evidenceOut: DataQualityResult` |
| `Preprocessing` | `inspectionData: InspectionData`; `inspectionMetadata: InspectionMetadata`; `qualityResult: DataQualityResult` | `processedData: ProcessedData` | `evidenceOut: ProcessedData` |
| `Detection` | `processedData: ProcessedData` | `detectionResult: DetectionResult` | `evidenceOut: DetectionResult` |
| `FeatureExtraction` | `processedData: ProcessedData`; `detectionResult: DetectionResult` | `numericalFeatures: NumericalFeatureSet` | `evidenceOut: NumericalFeatureSet` |
| `HealthPrediction` | `numericalFeatures: NumericalFeatureSet` | `healthPrediction: HealthPrediction` | `evidenceOut: HealthPrediction` |
| `RiskAssessment` | `qualityResult: DataQualityResult`; `detectionResult: DetectionResult`; `numericalFeatures: NumericalFeatureSet`; `healthPrediction: HealthPrediction` | `riskAssessment: RiskAssessment` | `evidenceOut: RiskAssessment` |
| `HumanApprovalGate` | `riskAssessment: RiskAssessment`; `approvalDecisionIn: ApprovalDecision` | `approvalRequestOut: ApprovalRequest`; `approvalDecision: ApprovalDecision` | `evidenceOut: ApprovalDecision` |
| `RecommendedAction` | `riskAssessment: RiskAssessment`; `approvalDecision: ApprovalDecision` | `recommendedActionOut: RecommendedAction` | `evidenceOut: RecommendedAction` |
| `EvidenceRecorder` | Nine evidence-observation inputs typed as listed above | `evidenceRecordOut: EvidenceRecord` | Final evidence output only |

Configuration and policy references named in the baseline responsibility table are resolved through numeric identifiers within the approved runtime contracts; no project value or human-readable name is embedded in a reusable interface.

`HumanApprovalGate` cannot create an `ApprovalDecision`. It emits an immutable `ApprovalRequest`, receives the external `ApprovalDecision`, validates it in a later behavioral phase, and exposes the received decision to downstream consumers and evidence recording. This clarification defines structure only and does not implement validation behavior.

## Approved Connector Preservation and Additions

The existing sequential flow remains. Phase 4 may add the typed metadata, risk-evidence, approval-authority, and boundary connectors required by the port table. Evidence observation remains outside the decision path. Exactly ten top-level components shall remain; no component may be added or removed by this clarification.

The interface ambiguity is resolved. Phase 4 is **AUTHORIZED AND READY TO EXECUTE** under its existing allowlist. Phases 5–17 remain **NOT AUTHORIZED**.
