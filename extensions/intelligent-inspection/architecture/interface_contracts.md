# Generic Interface Contracts

**Associated ECR:** ECR-20260906-001

**Status:** APPROVED — Gate 2 on 2026-09-06

All contracts are logical specifications. Exact MATLAB, Simulink, or System Composer types require a later approved implementation plan.

| Contract | Producer -> consumer | Mandatory content | Validity rules |
|---|---|---|---|
| `InspectionData` | `InspectionSource` -> `DataQualityValidation` | `itemId`, `payloadRef`, `modality`, `sourceId`, `sequenceId`, `timestamp`, `schemaVersion` | Identifiers nonempty; timestamp defined; payload resolvable; supported schema. |
| `InspectionMetadata` | `InspectionSource` -> validation and processing | `itemId`, `acquisitionContext`, `calibrationRef`, `contextSchemaVersion` | References same item; context fields follow project schema; missing mandatory context is explicit. |
| `DataQualityResult` | `DataQualityValidation` -> processing, risk, evidence | `itemId`, `status`, `measures`, `thresholdRefs`, `reasonCodes`, `validatorVersion` | Status is `PASS`, `REVIEW`, or `REJECT`; every measure has definition and validity. |
| `ProcessedData` | `Preprocessing` -> detection and feature extraction | `processedItemId`, `sourceItemId`, `representationRef`, `transformRecordRef`, `configurationVersion`, `schemaVersion` | Source trace preserved; representation resolvable; transformations recorded in order. |
| `DetectionResult` | `Detection` -> feature extraction and risk | `resultId`, `processedItemId`, `labelId`, `confidence`, `location`, `modelVersion`, `schemaVersion` | Confidence domain declared; location may be explicitly not applicable; label belongs to project taxonomy. |
| `NumericalFeatureSet` | `FeatureExtraction` -> `HealthPrediction` and risk | `featureSetId`, `sourceRefs`, `names`, `values`, `unitDeclarations`, `validity`, `extractorVersion`, `schemaVersion` | Values numeric; arrays aligned; invalid values explicitly flagged; no raw payload field. |
| `HealthPrediction` | `HealthPrediction` -> risk and evidence | `predictionId`, `featureSetId`, `estimate`, `contextOrHorizon`, `uncertainty`, `confidenceStatus`, `modelVersion`, `schemaVersion` | Estimate and uncertainty semantics declared; input feature reference resolvable. |
| `RiskAssessment` | `RiskAssessment` -> approval and recommendation | `assessmentId`, `evidenceRefs`, `riskLevel`, `riskScore`, `confidenceStatus`, `rationaleCodes`, `policyVersion` | Risk level uses project-approved scale; score may be not applicable but not silently omitted. |
| `ApprovalRequest` | `HumanApprovalGate` -> approval authority | `requestId`, `assessmentId`, `proposedRecommendation`, `evidenceRefs`, `requestedAt`, `expiresAt`, `policyVersion` | Request is immutable after issue; expiry later than request time. |
| `ApprovalDecision` | approval authority -> `HumanApprovalGate` | `requestId`, `decision`, `decidedBy`, `decidedAt`, `comments`, `decisionVersion` | Decision is `APPROVED`, `REJECTED`, `DEFERRED`, or `EXPIRED`; accountable identity required except system expiry. |
| `RecommendedAction` | `RecommendedAction` -> project adapter | `recommendationId`, `actionCode`, `parameters`, `evidenceRefs`, `confidenceStatus`, `approvalStatus`, `validFrom`, `validUntil`, `configurationVersion` | Advisory only; approved action code must exist in project mapping; invalid/expired record not forwarded. |
| `EvidenceRecord` | `EvidenceRecorder` -> evidence store | `recordId`, `eventType`, `artifactRefs`, `dataVersions`, `modelVersions`, `configurationVersions`, `actorOrComponent`, `timestamp`, `outcome`, `integrityMetadata` | References resolvable; outcome explicit; immutable identity; retention governed by project policy. |

## Contract Evolution

- Use explicit schema versions and backward-compatibility assessment.
- Additive optional fields require documented defaults.
- Removing, renaming, or changing mandatory-field semantics requires a controlled interface change.
- Project adapters may translate external formats but shall emit these generic contracts unchanged.
