# AI Agent Governance - Agentic UAV Pipeline Inspection

## Core Directive

Treat this repository as a safety-critical industrial AIoT and Model-Based Design (MBD) project. All work must preserve the safety, determinism, verifiability, traceability, and maintainability of the UAV pipeline-inspection system. Prefer explicit, reviewable model behavior over clever or implicit implementations. Never trade flight safety, safe landing, emergency response, data integrity, or requirement traceability for inspection throughput, autonomy, or convenience.

The authoritative engineering artifacts are the approved requirements, Simulink/Stateflow models, centralized data dictionaries, and verified tests. Make only changes that are within the approved scope and can be traced, tested, and reported.

## Approved MathWorks Products

Use only the following MathWorks products unless a repository owner explicitly approves an exception:

- MATLAB
- Simulink
- Stateflow
- Requirements Toolbox
- Simulink Test
- Simulink Coverage
- Computer Vision Toolbox
- Statistics and Machine Learning Toolbox

Do not introduce dependencies on unapproved toolboxes, third-party blocks, code generators, hardware-support packages, or external services without written approval.

## Mandatory Operating Rules

### Plan Before Editing

- Do not make unplanned model, Stateflow chart, test, requirement, or configuration edits.
- Before any edit, create or obtain a formal Implementation Plan that identifies the affected requirements, model elements, interfaces, data, hazards, tests, acceptance criteria, and rollback approach.
- Keep changes minimal and scoped to the approved plan. If investigation reveals a need outside that scope, stop and request an updated plan.
- Never bypass model integrity checks, disable safety logic, mask test failures, or alter a baseline merely to obtain a passing result.

### Traceability

- Maintain bidirectional traceability: **Requirements -> Model Elements -> Test Cases**.
- Every changed model element must link to one or more approved requirements; every changed or added requirement must have model and test links.
- Use Requirements Toolbox links and stable identifiers where available. Do not rely solely on filenames, comments, or informal descriptions as trace evidence.
- Update trace links and the traceability report as part of the same approved change.

### Safety and State-Machine Hierarchy

- Model safety functions as explicit, deterministic, and testable logic with clear priority and transition conditions.
- Safety-critical conditions always override routine inspection behavior. In particular, a critical low-battery condition shall command the approved safe-landing or return-to-safe-state behavior and override routine inspection, waypoint tracking, imaging, and noncritical communications states.
- Emergency, collision-avoidance, geofence, propulsion, sensor-validity, and communications-loss responses must have defined priority relative to mission states; ambiguous simultaneous events are unacceptable.
- Do not weaken, reorder, or remove safety transitions, guards, temporal logic, fault responses, or fallback states without hazard analysis, requirement updates, and explicit approval.
- Preserve fail-safe defaults: when inputs are invalid, unavailable, stale, or contradictory, transition to the approved safe state rather than continuing autonomous inspection.

### Configuration and Data Management

- Store shared parameters, calibration values, enumerations, buses, constants, and tunable design data in centralized Simulink Data Dictionaries (`.sldd`).
- Do not hardcode configuration values in block dialogs, MATLAB scripts, Stateflow actions, masks, or test harnesses when the value belongs in the project configuration.
- Use explicit units, data types, ranges, defaults, and ownership for dictionary entries. Changes to a dictionary are configuration changes and require traceability and tests.
- Maintain model references, variants, solver settings, sample times, and interface definitions under controlled configuration management. Do not make ad hoc local overrides.

### Verification and Evidence

- Execute relevant Simulink Test suites after each approved change. Add or update tests before declaring behavior complete.
- Assess structural coverage with Simulink Coverage. Safety and decision logic requires decision coverage review; justify and document any uncovered decision or infeasible objective.
- Record model diagnostics, test results, coverage results, assumptions, known limitations, and deviations in the change report.
- Treat warnings affecting data types, algebraic loops, sample times, model references, solver behavior, or Stateflow semantics as engineering issues to resolve or formally disposition.

## Sequential 10-Step Change Process

Follow all steps in order for every change. Do not skip a step unless the repository owner records an approved exception.

1. **Read project instructions and establish scope.** Read this file, the repository `README.md`, model-specific instructions, requirements, architecture documents, prior baselines, and relevant issue/change-request material. Identify the safety classification, owner, affected interfaces, and success criteria.
2. **Inspect the model before editing.** Use `model_overview` to understand model structure, referenced models, libraries, data dictionaries, variants, harnesses, and existing verification assets. Record the baseline version or commit.
3. **Read the affected artifacts.** Use `model_read` to inspect the exact blocks, subsystems, Stateflow charts, signals, parameters, requirement links, tests, and configuration entries involved. Confirm existing behavior and identify downstream impacts.
4. **Create and obtain approval for the Implementation Plan.** Define requirements affected; proposed model and `.sldd` changes; safety impact and state priority; traceability updates; tests and coverage objectives; acceptance criteria; and rollback plan. Do not edit until the plan is approved.
5. **Implement controlled changes.** Use `model_edit` only for the approved scope. Make small, atomic changes; preserve interfaces and naming conventions; configure reusable data in the `.sldd`; and document any necessary implementation decisions.
6. **Update requirement links and design traceability.** Link each changed requirement to its implementing model elements, and connect those elements to the corresponding test cases. Verify both forward and backward traceability.
7. **Perform model checks and simulation.** Run applicable model diagnostics, compile/update checks, and representative simulations. Investigate unexpected warnings, assertion failures, nondeterministic behavior, invalid data, or unsafe state transitions before proceeding.
8. **Execute Simulink Test suites.** Run all affected regression, integration, requirements-based, and safety tests in Simulink Test. Add or revise tests for each changed behavior, including priority/override and fault scenarios.
9. **Check structural coverage.** Collect Simulink Coverage results and review decision coverage, especially for Stateflow transitions and safety-critical decisions. Resolve gaps where feasible; formally justify and trace any infeasible or intentionally uncovered decisions.
10. **Generate and review a traceable change report.** Produce a report containing the approved plan, baseline and changed artifacts, requirement/model/test links, `.sldd` changes, simulation evidence, test results, coverage results, safety impact, residual risks, deviations, and rollback information. Submit it for required engineering review before release or baseline update.

## Stop Conditions and Escalation

Stop work and escalate to the repository owner or designated safety authority when requirements conflict or are incomplete; a safety priority is ambiguous; a test or coverage objective fails; a model requires an unapproved dependency; an interface or dictionary change affects another component; or the planned change could alter certified, validated, or safety-baselined behavior.

Never represent an unverified simulation, incomplete coverage result, or missing trace link as evidence of compliance.
