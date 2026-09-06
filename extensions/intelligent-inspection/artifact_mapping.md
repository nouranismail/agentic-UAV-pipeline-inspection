# Reusable and Project-Specific Artifact Mapping

**Associated ECR:** ECR-20260906-001

**Baseline status:** APPROVED — Gate 2 on 2026-09-06

**Clarification status:** APPROVED — Nouran Ismail, Project Owner, 2026-09-06

## Boundary Rules

- Reusable artifacts define procedure, component responsibility, contracts, evidence, and governance behavior.
- Project configurations define source bindings, taxonomies, units, thresholds, operating envelopes, and recommendation mappings.
- Adapters translate external formats into generic contracts without changing those contracts.
- The verified flight-safety supervisor and its evidence remain protected; any interface change requires a separate approved ECR.

## Mapping

| Reusable concept | UAV pipeline-inspection configuration | Fixed-camera industrial-surface configuration | Future 3D simulation adapter |
|---|---|---|---|
| `InspectionSource` | UAV camera adapter plus capture metadata | Fixed-camera adapter plus station metadata | Virtual-camera adapter using the same generic source contract |
| Inspection metadata | GPS/asset identifier and acquisition context in project extension fields | Station/part identifier and acquisition context in project extension fields | Simulated pose, scene, environmental state, and scenario identifier in adapter metadata |
| Quality policy | Motion/blocked-view and capture-sufficiency interpretation | Focus, illumination, obstruction, and part-presence interpretation | Render/capture validity and simulated visibility interpretation |
| Detection taxonomy | Project classes such as pipeline crack and corrosion | Project-approved manufactured-surface classes | Scenario labels mapped to the selected project taxonomy |
| Feature configuration | Pipeline maintenance features and units | Industrial-surface condition features and units | Same selected feature configuration; source provenance identifies simulation |
| Health prediction | Project maintenance target derived from numerical features | Project condition target derived from numerical features | Prediction remains outside the 3D environment and consumes the same numerical contract |
| Risk policy | Project risk scale and inspection recommendation policy | Station-specific review and disposition policy | Same project policy unless a separately approved simulation study overrides it |
| Approval mapping | Approved recommendation maps to a UAV mission request adapter; never directly to `SafeLanding` | Approved recommendation maps to station/work-order handling | Approval behavior remains outside the environment |
| External safety boundary | Verified `MissionSupervisor` remains authoritative and unchanged | Facility or machine safety authority remains external | Simulated safety behavior remains separate from inspection AI |
| Evidence | Source, GPS/asset, model, approval, and mapping versions | Source, station/part, model, approval, and mapping versions | Scenario, adapter, environment, source, and model versions |

## Project-Specific Configuration Ownership

| Configuration category | Reusable core | Project configuration/adapter |
|---|---:|---:|
| Contract names and mandatory generic fields | Owns | Conforms |
| Source transport and external field translation | No | Owns |
| Taxonomy and labels | No | Owns |
| Units and quality/performance thresholds | No | Owns |
| Model selection and approved version | Defines record shape | Owns selection |
| Risk scale and recommendation mapping | Defines contract | Owns semantics |
| Human approver roles and timeout policy | Defines required controls | Owns assignments/values |
| Evidence-chain mandatory identifiers | Owns | Adds project context |
| External safety behavior | No | Separate authoritative subsystem |

## Planned Artifact Relationships

```text
Generic requirements
  -> generic component definitions
  -> generic interface contracts
  -> reusable workflow procedures

Project configuration
  -> source adapter + taxonomy + thresholds + mappings
  -> unchanged generic workflow contracts
  -> project verification evidence
```

## Approved Runtime Schema Ownership

| Definition | Reusable interface schema | Project configuration/evidence |
|---|---:|---:|
| Primitive type and fixed dimension | Owns | Cannot override |
| Timestamp epoch and unit | Owns | Supplies actual timestamps |
| Identifier width and zero-unassigned rule | Owns | Allocates and resolves identifiers |
| Feature/reference capacities and count rules | Owns | Populates within bounds |
| Status encoding reserved values | Owns | Cannot redefine |
| Configurable category codes `1–254` | Reserves numeric domain | Defines human-readable meanings |
| Location vector unit and validity rule | Owns | Defines `frameId` and frame transform |
| Unit-code arrays | Owns representation | Defines code-to-unit mapping |
| Scores and validity flags | Owns `[0,1]` representation | Defines approved thresholds |
| Human-readable names and comments | Excludes from runtime interfaces | Owns and records by numeric reference |

The logical names `names`, `values`, and the existing aggregate reference fields remain traceable in the approved baseline. Their numeric runtime realizations and retained field-name policy are approved in `architecture/interface_contracts.md`.

## Approved Architecture Boundary Mapping

| Boundary port | Generic interface | Ownership boundary |
|---|---|---|
| `inspectionDataIn` | `InspectionData` | External source adapter to reusable architecture |
| `inspectionMetadataIn` | `InspectionMetadata` | External source adapter to reusable architecture |
| `approvalDecisionIn` | `ApprovalDecision` | External approval authority to reusable architecture |
| `approvalRequestOut` | `ApprovalRequest` | Reusable architecture to external approval authority |
| `recommendedActionOut` | `RecommendedAction` | Reusable architecture to project adapter |
| `evidenceRecordOut` | `EvidenceRecord` | Reusable architecture to evidence store |

No boundary port grants the reusable architecture external safety authority. The interface-ambiguity blocker is **RESOLVED**, and Phase 4 is **AUTHORIZED AND READY TO EXECUTE**. Phases 5–17 remain **NOT AUTHORIZED**.
