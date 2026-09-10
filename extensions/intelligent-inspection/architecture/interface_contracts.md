# Generic Interface Contracts

**Associated ECR:** ECR-20260906-001

**Baseline status:** APPROVED — Gate 2 on 2026-09-06

**Clarification status:** APPROVED — Nouran Ismail, Project Owner, 2026-09-06

The original contracts below preserve the approved logical element names. The approved runtime realization, exact types, dimensions, units, ranges, validity rules, defaults, and encodings are defined by the detailed schemas in this clarification. Phase 4 will implement those schemas under its existing approved plan and exact allowlist.

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

## Approved Runtime Representation Rules

These rules refine, but do not replace, the approved logical elements above.

| Concept | Runtime representation |
|---|---|
| Boolean | `boolean`, `[1 1]`, unit `1`, range `{false,true}`, default `false` |
| Score | `single`, `[1 1]`, unit `1`, range `[0,1]`, default `0` |
| Timestamp | `uint64`, `[1 1]`, unit `ms`, milliseconds since Unix epoch in UTC, default `0` meaning unassigned |
| Identifier/reference | `uint32`, `[1 1]`, unit `1`, range `[0,4294967295]`, default `0` meaning unassigned |
| Version identifier | `uint16`, `[1 1]`, unit `1`, range `[0,65535]`, default `0` meaning unassigned |
| Status/category | `uint8`, `[1 1]`, unit `1`, default `0`; encoding defined below or supplied by approved project configuration where stated |
| Optional numeric scalar | Value plus a `boolean` validity element; invalid value is `0`, never NaN-only |
| Location | `double`, `[3 1]`, unit `m`, each coordinate in `[-realmax('double'),realmax('double')]`; `locationValid=false` requires `[0;0;0]`; `frameId` is `uint16` |
| Feature vector | Capacity 32; `featureIds` is `uint16 [32 1]`; `featureValues` is `single [32 1]`; unused entries are zero; `featureCount` is `uint8` in `[0,32]` |
| Reference vector | Capacity 16; existing logical reference-field names are retained; each reference array is `uint32 [16 1]`, unused entries are zero, the associated reference count is `uint8` in `[0,16]`, and identifier zero means unassigned. |
| Human-readable text | Not carried at runtime. Numeric codes resolve through approved configuration and evidence documentation. |

All numeric values shall be finite when valid. Unless a row says otherwise, units are `1` and arrays default to all zeros.

## Approved Phase 5 Quality-Boundary Comparison Rules

The Project Owner approved the following deterministic comparison rules for Phase 5 on 2026-09-07:

1. Minimum acceptance boundaries are inclusive: `measuredValue >= minimumThreshold`.
2. Maximum acceptance boundaries are inclusive: `measuredValue <= maximumThreshold`.
3. The measured value and configured threshold shall both be represented as MATLAB `single` values before comparison.
4. No implicit or undocumented numeric tolerance is permitted.
5. `NaN`, positive infinity, and negative infinity shall be rejected before any comparison.
6. If the minimum and maximum thresholds are equal, only a measured `single` value exactly equal to that threshold satisfies the range.

| Clarification field | Entry |
|---|---|
| Decision | **APPROVED** |
| Approver | Nouran Ismail — Project Owner |
| Approval date | 2026-09-07 |
| Corrective authority | Phase 5 corrective repair only |
| Phase 5 status | **FAIL — CORRECTIVE REPAIR AUTHORIZED** |
| Later phases | Phases 6–17 remain **NOT AUTHORIZED** |

## Status and Category Encodings

| Element | Encoding |
|---|---|
| `modality` | `0=UNASSIGNED`, `1=IMAGE`, `2=VIDEO`, `3=SIGNAL`, `4=MULTIMODAL`, `5=OTHER_CONFIGURED` |
| Data-quality `status` | `0=UNASSIGNED`, `1=PASS`, `2=REVIEW`, `3=REJECT` |
| `confidenceStatus` | `0=UNASSIGNED`, `1=ACCEPTABLE`, `2=LOW`, `3=UNAVAILABLE`, `4=INVALID` |
| Approval `decision` | `0=UNASSIGNED`, `1=APPROVED`, `2=REJECTED`, `3=DEFERRED`, `4=EXPIRED` |
| `approvalStatus` | `0=UNASSIGNED`, `1=PENDING`, `2=APPROVED`, `3=REJECTED`, `4=DEFERRED`, `5=EXPIRED`, `6=INVALID` |
| `eventType` | `0=UNASSIGNED`, `1=SOURCE`, `2=QUALITY`, `3=PROCESSING`, `4=DETECTION`, `5=FEATURE`, `6=PREDICTION`, `7=RISK`, `8=APPROVAL`, `9=RECOMMENDATION`, `10=FAILURE` |
| `outcome` | `0=UNASSIGNED`, `1=SUCCESS`, `2=REVIEW`, `3=REJECTED`, `4=FAILED`, `5=UNAVAILABLE`, `6=TIMEOUT` |
| `labelId`, `riskLevel`, `actionCode`, `reasonCodes` | `0=UNASSIGNED`; values `1–254` are defined in approved project configuration; `255=INVALID` |

## Approved Runtime Schemas

### `InspectionData`

| Element | Type | Dimension | Unit | Range/encoding | Validity and default |
|---|---|---:|---|---|---|
| `itemId` | `uint32` | `[1 1]` | `1` | Identifier | Valid when nonzero; default `0` |
| `payloadRef` | `uint32` | `[1 1]` | `1` | Identifier | Must resolve when nonzero; default `0` |
| `modality` | `uint8` | `[1 1]` | `1` | Modality encoding | Valid values `1–5`; default `0` |
| `sourceId` | `uint32` | `[1 1]` | `1` | Identifier | Valid when nonzero; default `0` |
| `sequenceId` | `uint32` | `[1 1]` | `1` | `[0,4294967295]` | `0` is unassigned; default `0` |
| `timestamp` | `uint64` | `[1 1]` | `ms` | Unix epoch UTC | Valid when nonzero; default `0` |
| `schemaVersion` | `uint16` | `[1 1]` | `1` | Version identifier | Valid when nonzero; default `0` |

### `InspectionMetadata`

| Element | Type | Dimension | Unit | Range/encoding | Validity and default |
|---|---|---:|---|---|---|
| `itemId` | `uint32` | `[1 1]` | `1` | Identifier | Must match `InspectionData.itemId`; default `0` |
| `acquisitionContext` | `uint32` | `[1 1]` | `1` | Configuration/evidence reference | Must resolve when nonzero; default `0` |
| `calibrationRef` | `uint32` | `[1 1]` | `1` | Reference | `0` explicitly means unavailable; default `0` |
| `contextSchemaVersion` | `uint16` | `[1 1]` | `1` | Version identifier | Valid when nonzero; default `0` |

### `DataQualityResult`

| Element | Type | Dimension | Unit | Range/encoding | Validity and default |
|---|---|---:|---|---|---|
| `itemId` | `uint32` | `[1 1]` | `1` | Identifier | Must reference the assessed item; default `0` |
| `status` | `uint8` | `[1 1]` | `1` | Data-quality encoding | Valid values `1–3`; default `0` |
| `measures` | `single` | `[32 1]` | `1` | Each entry `[0,1]` | First `measureCount` entries valid; unused entries `0` |
| `thresholdRefs` | `uint32` | `[32 1]` | `1` | Reference identifiers | Aligned with `measures`; unused entries `0` |
| `reasonCodes` | `uint8` | `[16 1]` | `1` | Configured code encoding | First `reasonCodeCount` entries valid; unused entries `0` |
| `validatorVersion` | `uint16` | `[1 1]` | `1` | Version identifier | Valid when nonzero; default `0` |
| `measureCount` (added) | `uint8` | `[1 1]` | `1` | `[0,32]` | Default `0` |
| `reasonCodeCount` (added) | `uint8` | `[1 1]` | `1` | `[0,16]` | Default `0` |

### `ProcessedData`

| Element | Type | Dimension | Unit | Range/encoding | Validity and default |
|---|---|---:|---|---|---|
| `processedItemId` | `uint32` | `[1 1]` | `1` | Identifier | Valid when nonzero; default `0` |
| `sourceItemId` | `uint32` | `[1 1]` | `1` | Identifier | Must resolve to the source item; default `0` |
| `representationRef` | `uint32` | `[1 1]` | `1` | Reference | Must resolve when nonzero; default `0` |
| `transformRecordRef` | `uint32` | `[1 1]` | `1` | Evidence reference | Must resolve when nonzero; default `0` |
| `configurationVersion` | `uint16` | `[1 1]` | `1` | Version identifier | Valid when nonzero; default `0` |
| `schemaVersion` | `uint16` | `[1 1]` | `1` | Version identifier | Valid when nonzero; default `0` |

### `DetectionResult`

| Element | Type | Dimension | Unit | Range/encoding | Validity and default |
|---|---|---:|---|---|---|
| `resultId` | `uint32` | `[1 1]` | `1` | Identifier | Valid when nonzero; default `0` |
| `processedItemId` | `uint32` | `[1 1]` | `1` | Identifier | Must resolve to processed data; default `0` |
| `labelId` | `uint8` | `[1 1]` | `1` | Configured category code | `0=UNASSIGNED`, `255=INVALID`; default `0` |
| `confidence` | `single` | `[1 1]` | `1` | `[0,1]` | Validity declared by `confidenceValid`; default `0` |
| `location` | `double` | `[3 1]` | `m` | Each entry `[-realmax('double'),realmax('double')]` | Validity declared by `locationValid`; invalid value `[0;0;0]` |
| `modelVersion` | `uint16` | `[1 1]` | `1` | Version identifier | `0` means no model version; default `0` |
| `schemaVersion` | `uint16` | `[1 1]` | `1` | Version identifier | Valid when nonzero; default `0` |
| `confidenceValid` (added) | `boolean` | `[1 1]` | `1` | Boolean | Default `false`; false requires `confidence=0` |
| `locationValid` (added) | `boolean` | `[1 1]` | `1` | Boolean | Default `false`; false requires zero location |
| `frameId` (added) | `uint16` | `[1 1]` | `1` | Project-frame identifier | Nonzero when location is valid; default `0` |

### `NumericalFeatureSet`

| Element | Type | Dimension | Unit | Range/encoding | Validity and default |
|---|---|---:|---|---|---|
| `featureSetId` | `uint32` | `[1 1]` | `1` | Identifier | Valid when nonzero; default `0` |
| `sourceRefs` | `uint32` | `[16 1]` | `1` | Reference vector | First `referenceCount` entries valid; unused entries `0` |
| `names` | Logical concept only | — | — | Approved runtime realization is `featureIds` below | Human-readable names resolve through version-controlled project configuration |
| `values` | Logical concept only | — | — | Approved runtime realization is `featureValues` below | The runtime interface carries only the fixed-capacity numeric vector |
| `unitDeclarations` | `uint16` | `[32 1]` | `1` | Configured unit-code identifiers | Aligned with active features; unused entries `0` |
| `validity` | `boolean` | `[32 1]` | `1` | Boolean vector | Aligned with active features; unused entries `false` |
| `extractorVersion` | `uint16` | `[1 1]` | `1` | Version identifier | Valid when nonzero; default `0` |
| `schemaVersion` | `uint16` | `[1 1]` | `1` | Version identifier | Valid when nonzero; default `0` |
| `featureIds` (approved runtime realization of `names`) | `uint16` | `[32 1]` | `1` | Numeric feature identifiers | First `featureCount` entries active; unused entries `0` |
| `featureValues` (approved runtime realization of `values`) | `single` | `[32 1]` | `1` | Each entry `[-realmax('single'),realmax('single')]` | First `featureCount` entries active; unused entries `0` |
| `featureCount` (added) | `uint8` | `[1 1]` | `1` | `[0,32]` | Default `0` |
| `referenceCount` (added) | `uint8` | `[1 1]` | `1` | `[0,16]` | Default `0` |

### `HealthPrediction`

| Element | Type | Dimension | Unit | Range/encoding | Validity and default |
|---|---|---:|---|---|---|
| `predictionId` | `uint32` | `[1 1]` | `1` | Identifier | Valid when nonzero; default `0` |
| `featureSetId` | `uint32` | `[1 1]` | `1` | Identifier | Must resolve to a feature set; default `0` |
| `estimate` | `single` | `[1 1]` | `1` | `[-realmax('single'),realmax('single')]` | Validity declared by `estimateValid`; default `0` |
| `contextOrHorizon` | `uint32` | `[1 1]` | `1` | Reference to configured context/horizon definition | Validity declared by `contextOrHorizonValid`; default `0` |
| `uncertainty` | `single` | `[1 1]` | `1` | `[0,1]` | Validity declared by `uncertaintyValid`; default `0` |
| `confidenceStatus` | `uint8` | `[1 1]` | `1` | Confidence-status encoding | Default `0` |
| `modelVersion` | `uint16` | `[1 1]` | `1` | Version identifier | Valid when nonzero; default `0` |
| `schemaVersion` | `uint16` | `[1 1]` | `1` | Version identifier | Valid when nonzero; default `0` |
| `estimateValid` (added) | `boolean` | `[1 1]` | `1` | Boolean | Default `false`; false requires `estimate=0` |
| `contextOrHorizonValid` (added) | `boolean` | `[1 1]` | `1` | Boolean | Default `false`; false requires zero reference |
| `uncertaintyValid` (added) | `boolean` | `[1 1]` | `1` | Boolean | Default `false`; false requires `uncertainty=0` |

### `RiskAssessment`

| Element | Type | Dimension | Unit | Range/encoding | Validity and default |
|---|---|---:|---|---|---|
| `assessmentId` | `uint32` | `[1 1]` | `1` | Identifier | Valid when nonzero; default `0` |
| `evidenceRefs` | `uint32` | `[16 1]` | `1` | Reference vector | First `referenceCount` entries valid; unused entries `0` |
| `riskLevel` | `uint8` | `[1 1]` | `1` | Configured category code | `0=UNASSIGNED`, `255=INVALID`; default `0` |
| `riskScore` | `single` | `[1 1]` | `1` | `[0,1]` | Validity declared by `riskScoreValid`; default `0` |
| `confidenceStatus` | `uint8` | `[1 1]` | `1` | Confidence-status encoding | Default `0` |
| `rationaleCodes` | `uint8` | `[16 1]` | `1` | Configured code encoding | First `rationaleCount` entries valid; unused entries `0` |
| `policyVersion` | `uint16` | `[1 1]` | `1` | Version identifier | Valid when nonzero; default `0` |
| `referenceCount` (added) | `uint8` | `[1 1]` | `1` | `[0,16]` | Default `0` |
| `riskScoreValid` (added) | `boolean` | `[1 1]` | `1` | Boolean | Default `false`; false requires `riskScore=0` |
| `rationaleCount` (added) | `uint8` | `[1 1]` | `1` | `[0,16]` | Default `0` |

### `ApprovalRequest`

| Element | Type | Dimension | Unit | Range/encoding | Validity and default |
|---|---|---:|---|---|---|
| `requestId` | `uint32` | `[1 1]` | `1` | Identifier | Valid when nonzero; default `0` |
| `assessmentId` | `uint32` | `[1 1]` | `1` | Identifier | Must resolve to risk assessment; default `0` |
| `proposedRecommendation` | `uint32` | `[1 1]` | `1` | Proposed-record reference | Must resolve when nonzero; default `0` |
| `evidenceRefs` | `uint32` | `[16 1]` | `1` | Reference vector | First `referenceCount` entries valid; unused entries `0` |
| `requestedAt` | `uint64` | `[1 1]` | `ms` | Unix epoch UTC | Valid when nonzero; default `0` |
| `expiresAt` | `uint64` | `[1 1]` | `ms` | Unix epoch UTC | Must exceed `requestedAt`; default `0` |
| `policyVersion` | `uint16` | `[1 1]` | `1` | Version identifier | Valid when nonzero; default `0` |
| `referenceCount` (added) | `uint8` | `[1 1]` | `1` | `[0,16]` | Default `0` |

### `ApprovalDecision`

| Element | Type | Dimension | Unit | Range/encoding | Validity and default |
|---|---|---:|---|---|---|
| `requestId` | `uint32` | `[1 1]` | `1` | Identifier | Must match a request; default `0` |
| `decision` | `uint8` | `[1 1]` | `1` | Approval-decision encoding | Valid values `1–4`; default `0` |
| `decidedBy` | `uint32` | `[1 1]` | `1` | Actor identifier | Required except system expiry; default `0` |
| `decidedAt` | `uint64` | `[1 1]` | `ms` | Unix epoch UTC | Valid when nonzero; default `0` |
| `comments` | `uint32` | `[1 1]` | `1` | Evidence-document reference | `0` explicitly means no comment; default `0` |
| `decisionVersion` | `uint16` | `[1 1]` | `1` | Version identifier | Valid when nonzero; default `0` |

### `RecommendedAction`

| Element | Type | Dimension | Unit | Range/encoding | Validity and default |
|---|---|---:|---|---|---|
| `recommendationId` | `uint32` | `[1 1]` | `1` | Identifier | Valid when nonzero; default `0` |
| `actionCode` | `uint8` | `[1 1]` | `1` | Configured category code | `0=UNASSIGNED`, `255=INVALID`; default `0` |
| `parameters` | `single` | `[16 1]` | `1` | Each entry `[-realmax('single'),realmax('single')]` | First `parameterCount` entries active; unused entries `0` |
| `evidenceRefs` | `uint32` | `[16 1]` | `1` | Reference vector | First `referenceCount` entries valid; unused entries `0` |
| `confidenceStatus` | `uint8` | `[1 1]` | `1` | Confidence-status encoding | Default `0` |
| `approvalStatus` | `uint8` | `[1 1]` | `1` | Approval-status encoding | Default `0` |
| `validFrom` | `uint64` | `[1 1]` | `ms` | Unix epoch UTC | Valid when nonzero; default `0` |
| `validUntil` | `uint64` | `[1 1]` | `ms` | Unix epoch UTC | Must exceed `validFrom`; default `0` |
| `configurationVersion` | `uint16` | `[1 1]` | `1` | Version identifier | Valid when nonzero; default `0` |
| `parameterCount` (added) | `uint8` | `[1 1]` | `1` | `[0,16]` | Default `0` |
| `referenceCount` (added) | `uint8` | `[1 1]` | `1` | `[0,16]` | Default `0` |

### `EvidenceRecord`

| Element | Type | Dimension | Unit | Range/encoding | Validity and default |
|---|---|---:|---|---|---|
| `recordId` | `uint32` | `[1 1]` | `1` | Identifier | Valid when nonzero; default `0` |
| `eventType` | `uint8` | `[1 1]` | `1` | Event-type encoding | Valid values `1–10`; default `0` |
| `artifactRefs` | `uint32` | `[16 1]` | `1` | Reference vector | First `artifactReferenceCount` entries valid; unused entries `0` |
| `dataVersions` | `uint16` | `[16 1]` | `1` | Version identifiers | First `dataVersionCount` entries valid; unused entries `0` |
| `modelVersions` | `uint16` | `[16 1]` | `1` | Version identifiers | First `modelVersionCount` entries valid; unused entries `0` |
| `configurationVersions` | `uint16` | `[16 1]` | `1` | Version identifiers | First `configurationVersionCount` entries valid; unused entries `0` |
| `actorOrComponent` | `uint32` | `[1 1]` | `1` | Actor/component identifier | Valid when nonzero; default `0` |
| `timestamp` | `uint64` | `[1 1]` | `ms` | Unix epoch UTC | Valid when nonzero; default `0` |
| `outcome` | `uint8` | `[1 1]` | `1` | Outcome encoding | Valid values `1–6`; default `0` |
| `integrityMetadata` | `uint32` | `[1 1]` | `1` | Integrity-record reference | `0` means unavailable; default `0` |
| `artifactReferenceCount` (added) | `uint8` | `[1 1]` | `1` | `[0,16]` | Default `0` |
| `dataVersionCount` (added) | `uint8` | `[1 1]` | `1` | `[0,16]` | Default `0` |
| `modelVersionCount` (added) | `uint8` | `[1 1]` | `1` | `[0,16]` | Default `0` |
| `configurationVersionCount` (added) | `uint8` | `[1 1]` | `1` | `[0,16]` | Default `0` |

## Approved Architecture Boundary

| Direction | Port | Interface |
|---|---|---|
| Input | `inspectionDataIn` | `InspectionData` |
| Input | `inspectionMetadataIn` | `InspectionMetadata` |
| Input | `approvalDecisionIn` | `ApprovalDecision` |
| Output | `approvalRequestOut` | `ApprovalRequest` |
| Output | `recommendedActionOut` | `RecommendedAction` |
| Output | `evidenceRecordOut` | `EvidenceRecord` |

`HumanApprovalGate` emits `ApprovalRequest`, receives `ApprovalDecision` from the external approval authority, and forwards only a validated decision to `RecommendedAction`. It cannot approve its own request and has no safety-critical command interface.

## Approved Evidence-Observation Interface Assignment

| Producing component | Observation interface |
|---|---|
| `InspectionSource` | `InspectionMetadata` |
| `DataQualityValidation` | `DataQualityResult` |
| `Preprocessing` | `ProcessedData` |
| `Detection` | `DetectionResult` |
| `FeatureExtraction` | `NumericalFeatureSet` |
| `HealthPrediction` | `HealthPrediction` |
| `RiskAssessment` | `RiskAssessment` |
| `HumanApprovalGate` | `ApprovalDecision` |
| `RecommendedAction` | `RecommendedAction` |
| `EvidenceRecorder` | `EvidenceRecord` |

## Approved Clarification Decisions

1. Logical `NumericalFeatureSet.names` is realized at runtime as `featureIds: uint16 [32 1]`; logical `values` is realized as `featureValues: single [32 1]`; `featureCount` is `uint8` in `[0,32]`. Human-readable feature names resolve through version-controlled project configuration.
2. Existing reference-field names (`sourceRefs`, `evidenceRefs`, and `artifactRefs`) are retained. Each uses `uint32 [16 1]`, an associated `uint8` count in `[0,16]`, zero-filled unused entries, and identifier zero meaning unassigned.
3. `contextOrHorizon` is a `uint32` reference with `contextOrHorizonValid`. Its meaning, unit, horizon, and interpretation are defined in the applicable version-controlled project configuration and evidence record.

## Clarification Approval Record

| Field | Entry |
|---|---|
| Decision | **APPROVED** |
| Approver | Nouran Ismail — Project Owner |
| Approval date | 2026-09-06 |
| Interface-ambiguity blocker | **RESOLVED** |
| Phase 4 | **AUTHORIZED AND READY TO EXECUTE** |
| Later phases | Phases 5–17 remain **NOT AUTHORIZED** |

This approval authorizes later Phase 4 execution only under its existing four-file implementation allowlist. It does not implement Phase 4.

## Approved Phase 8 Numerical Feature Catalog Clarification

**Status:** **APPROVED — Nouran Ismail, Project Owner, 2026-09-10**

The catalog is derived only from the approved ten-field `DetectionResult`. It does not infer region size, shape, count, masks, pixel measurements, or any other unavailable information. Runtime ordering is ascending `featureId`. Catalog version and proposed extractor version are both `1`.

| ID | Generic feature name | Source or exact derivation | MATLAB type | Unit/code | Range | Default | Validity rule | No-detection behavior | Malformed/nonfinite behavior | Extractor version | Rationale for health prediction |
|---:|---|---|---|---|---|---:|---|---|---|---:|---|
| 1 | `detectionPresent` | `single(labelId >= 1 && labelId <= 254)` | `single [1 1]` | dimensionless/`1` | `[0,1]` | `0` | Valid for every conforming result; `labelId=255` is malformed | `0`, valid | Controlled empty set | 1 | Distinguishes absence from measured attributes |
| 2 | `detectionConfidence` | `single(confidence)` | `single [1 1]` | dimensionless/`1` | `[0,1]` | `0` | Valid only when `confidenceValid=true` and the value is finite and in range | `0`; valid only when explicitly valid at source | Invalid asserted value produces the controlled empty set; `confidenceValid=false` gives `0`, invalid | 1 | Provides bounded evidence strength without raw data |
| 3 | `locationAvailable` | `single(locationValid)` after location/frame validation | `single [1 1]` | dimensionless/`1` | `[0,1]` | `0` | Valid for every conforming result; asserted location requires nonzero `frameId` and finite coordinates | `0`, valid | Controlled empty set | 1 | Distinguishes unavailable spatial context from zero coordinates |
| 4 | `locationCoordinate1` | `single(location(1))` | `single [1 1]` | metre/`2` | finite `single` range | `0` | Valid only for valid location/frame and finite conversion | `0`, invalid | Controlled empty set for malformed/nonfinite asserted location | 1 | Supplies calibrated generic spatial context when available |
| 5 | `locationCoordinate2` | `single(location(2))` | `single [1 1]` | metre/`2` | finite `single` range | `0` | Same as feature 4 | `0`, invalid | Same as feature 4 | 1 | Supplies calibrated generic spatial context when available |
| 6 | `locationCoordinate3` | `single(location(3))` | `single [1 1]` | metre/`2` | finite `single` range | `0` | Same as feature 4 | `0`, invalid | Same as feature 4 | 1 | Supplies calibrated generic spatial context when available |

Proposed unit codes are `0=UNASSIGNED`, `1=DIMENSIONLESS`, and `2=METRE`. Human-readable names resolve from this version-controlled catalog; runtime continues to carry numeric IDs and values only. Category and version identifiers remain configuration/provenance and are not treated as ordinal regression features.

For a conforming no-detection result (`labelId=0`), emit all six entries in ID order: `featureIds(1:6)=uint16(1:6)`, `featureCount=uint8(6)`, detection presence and location availability are valid zero, coordinates are zero and invalid, and confidence follows its explicit source validity. Set `sourceRefs(1)=resultId`, `referenceCount=1`, zero-fill all unused entries, and require configured nonzero `featureSetId`, `extractorVersion=1`, and supported `schemaVersion`.

For a malformed result, unsupported schema, required identifier/version violation, `labelId=255`, invalid asserted confidence/location, or nonfinite asserted value, return the exact controlled empty `NumericalFeatureSet`: all numeric fields and arrays zero, all validity entries false, `featureCount=0`, and `referenceCount=0`. Emit no partial set.

Schema validation requires the exact approved fields, types and dimensions; aligned IDs, values, units and validity; unique ascending active IDs; zero-filled unused capacity; supported nonzero schema/extractor versions for nonempty output; a resolvable source reference; and no raw payload. Catalog or extractor-version mismatch is rejected as controlled empty output and recorded as a failure.

### Approved limitation and reuse boundary

This catalog contains only features supported by the approved `DetectionResult`. It is not sufficient by itself to train a predictive-maintenance model and shall not be presented as containing anomaly size, degradation, vibration, temperature, current, operating time, or remaining-useful-life information.

The generic `NumericalFeatureSet` remains the predictor input. Separately governed project sensor adapters may populate additional feature IDs. Domain-specific feature names, units, and mappings belong in the applicable project configuration, not the reusable Phase 8 implementation. Adding anomaly area, width, height, or mask features requires a separately approved interface change because those values are absent from the current `DetectionResult`.

| Approval field | Entry |
|---|---|
| Decision | **APPROVED** |
| Approver | Nouran Ismail — Project Owner |
| Approval date | 2026-09-10 |
| Approved catalog | Feature IDs 1–6; ascending order; catalog version 1; extractor version 1; unit codes `0=UNASSIGNED`, `1=DIMENSIONLESS`, `2=METRE` |
| Approved behavior | Exact no-detection and malformed/invalid-input behavior defined above |
