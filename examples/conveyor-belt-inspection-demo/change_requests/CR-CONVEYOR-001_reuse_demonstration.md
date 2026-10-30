# CR-CONVEYOR-001 — Conveyor Belt Surface Inspection Reuse Demonstration

## Status

**GATE 1 SCOPE APPROVED — REQUIREMENTS DRAFT PREPARED — GATE 2 PENDING.**

## Purpose

Demonstrate that the existing reusable intelligent-inspection workflow can be
applied to an industrial fixed-camera conveyor-belt surface-inspection project
without modifying the shared workflow or reusable intelligent-inspection core.

## Gate 1 Scope Approval

| Field | Recorded decision |
|---|---|
| Project Owner | Nouran Ismail |
| Approval date | 2026-09-30 |
| Decision | Planning-only ECR and requirements preparation authorized |
| Project | Conveyor Belt Surface Inspection Reuse Demonstration |
| Shared workflow | `skills/simulink-engineering-workflow/SKILL.md`, unchanged |
| Current gate | Gate 2 — requirements approval pending |

## Proposed objective

Define a project-specific fixed-camera source and configuration boundary that
can later supply the unchanged generic inspection contracts to the accepted
reusable workflow:

```text
project image source -> source adapter -> InspectionData / InspectionMetadata
  -> quality -> preprocessing -> accepted conventional detector
  -> DetectionResult -> numerical features -> prediction / risk / approval
  -> advisory recommendation -> evidence
```

The objective is workflow and interface reuse. It is not a claim of production
conveyor-defect detection, maintenance prognosis, or autonomous control.

## In scope for this planning authorization

- Project-local ECR and draft requirements only.
- Requirements for source provenance, generic-contract mapping, quality gating,
  conventional detection, controlled downstream behavior, advisory-only output,
  evidence, and reuse isolation.
- Identification of future decisions required before implementation.

## Explicit exclusions

- No source adapter, model, configuration, test, dataset, image fixture, report,
  or implementation plan is created by this authorization.
- No image download, data generation, model training, or MATLAB execution.
- No modification of the reusable core, shared skill, UAV artifacts,
  MissionSupervisor, Phase 6 detector, Phase 7 model, or accepted evidence.
- No actuator, conveyor control, mission, flight, approval-command,
  ReturnToHome, SafeLanding, or safety-command endpoint.

## Authorized paths for this planning task

1. `examples/conveyor-belt-inspection-demo/change_requests/CR-CONVEYOR-001_reuse_demonstration.md`
2. `examples/conveyor-belt-inspection-demo/requirements/conveyor_belt_inspection_requirements.md`

Any additional path requires a separate recorded authorization.

## Proposed component dispositions

| Component | Proposed project use |
|---|---|
| Shared engineering workflow | Required and unchanged |
| Reusable intelligent-inspection core | Read-only; must remain unchanged |
| Phase 6 conventional detector | Only proposed operational demonstration detector |
| Phase 7 deep-learning detector | Disabled; excluded because performance acceptance failed |
| Phase 9B prediction | May be used only as explicitly labeled synthetic/demonstration context after separate approval |
| Risk, approval, evidence components | Advisory and controlled-status boundaries only |

## Gate 2 decision required

Before any implementation plan or artifact creation, the Project Owner must
approve the draft requirements, source-data choice and licensing/provenance
approach, project metadata, controlled-status behavior, test intent, acceptance
criteria, roles, and exact future implementation allowlist.
