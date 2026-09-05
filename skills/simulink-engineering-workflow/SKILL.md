---
name: simulink-engineering-workflow
version: 1.0.0
description: Reusable, approval-gated workflow for agent-assisted MATLAB and Simulink engineering.
---

# Simulink Engineering Workflow and Agentic Execution

## Purpose

Guide engineers and AI agents through a consistent read, scope, plan, edit, verify, test, independently review, and report process. The skill is application-independent and shall read project-specific requirements and configuration instead of embedding application logic.

## Required Context

Before acting, read:

1. `AGENTS.md`.
2. `TEAM.md` and `config/team_configuration.yaml`.
3. The project context, approved requirements, architecture, interfaces, and configuration.
4. The active ECR, approval records, and implementation plan.
5. The affected artifacts and existing verification evidence.

Declare the active role, assigned person, project, branch/baseline, ECR, current gate, authorized artifacts, prohibited actions, workflow version, and independence status. Stop if any required item is missing or conflicting.

## Supported Work

- Define or review requirements and acceptance criteria.
- Implement approved MATLAB, Simulink, Stateflow, algorithm, or configuration changes.
- Investigate failed diagnostics, simulation, test, traceability, or coverage results.
- Perform proportionate governance or tooling changes.
- Conduct independent verification when the assigned individual is independent.
- Produce traceable test, review, and change evidence.

This skill does not grant approval authority. Role authority comes from `TEAM.md`, the team configuration, and recorded gate decisions.

## Mandatory Approval-Gated Workflow

### 1. Read and establish scope

Read the governing instructions and project artifacts. Confirm the branch, baseline, owners, safety classification, affected interfaces, approved products, success criteria, and exclusions.

### 2. Inspect the existing artifacts

Inspect architecture and exact affected artifacts before proposing changes. For Simulink work, use available architectural/model-read capabilities; if the preferred service is unavailable, use an approved native read-only method and record the deviation.

### 3. Analyze impact and prepare the ECR

Identify affected requirements, interfaces, configuration, hazards, tests, traceability, dependencies, and downstream consumers.

**Stop at Gate 1:** Project Owner Scope/ECR Approval.

### 4. Define and approve requirements

Create or revise requirements, safety priorities, interfaces, acceptance criteria, assumptions, and verification intent within the approved scope.

**Stop at Gate 2:** Project Owner Requirements Approval.

### 5. Prepare the implementation and test plans

Use the approved templates under `templates/templates/`. Identify exact files, responsible roles, controlled edits, configuration, traceability, diagnostics, tests, coverage where applicable, independent review, acceptance criteria, and rollback.

**Stop at Gate 3:** Project Owner Implementation Plan Approval. No repository artifact may be modified before this gate.

### 6. Implement the controlled change

Modify only approved artifacts. Prefer approved model-edit capabilities for model work; use an approved native API only when necessary and record the reason. Keep changes small, explicit, and reviewable. Do not introduce unapproved dependencies or duplicate authoritative configuration.

### 7. Update traceability and inspect the result

Establish required links from requirements to implementation elements to tests and results. Reinspect changed artifacts and confirm that scope, interfaces, configuration, and safety behavior match the approved plan.

### 8. Run proportionate diagnostics and verification

For model changes, run applicable compile/update checks, simulations, requirements-based and regression tests, and structural coverage review. For non-model changes, run syntax, schema, path, consistency, security, and content checks appropriate to the artifact. Never suppress a failure to produce a passing result.

### 9. Record implementation evidence

Complete the developer portions of the change report, including changed artifacts, tool results, tests, coverage, traceability, warnings, assumptions, deviations, residual risks, and rollback information.

**Stop at Gate 4:** Implementation Evidence Complete. This is not independent verification or final acceptance.

### 10. Perform independent verification

A different named individual from the implementer shall review the frozen candidate. Record artifact hashes, independence, evidence reviewed, findings, reproducibility, and one decision: `PASS`, `PASS WITH OBSERVATIONS`, or `FAIL / CORRECTIVE ACTION REQUIRED`. A separate AI session alone does not establish independence.

**Stop at Gate 5:** Independent Verification Decision. Corrective work returns to implementation and requires regression and renewed review.

### 11. Record final acceptance

The Project Owner reviews the change report, verification decision, findings, deviations, and residual risks and records acceptance or rejection.

**Stop at Gate 6:** Project Owner Final Acceptance. Release or baseline actions require separate authorization when applicable.

### 12. Handoff and preserve evidence

Record the completed gate, artifacts, evidence, findings, assumptions, deviations, next permitted activity, and required approver. Preserve version-controlled evidence and do not claim status beyond the completed gate.

## Proportional Verification

- Safety or decision-logic changes require requirements-based tests, priority/fault scenarios, traceability, and structural coverage review where supported.
- Configuration changes require value, type, range, unit, ownership, dependency, and regression checks.
- MATLAB algorithm changes require deterministic tests and applicable numerical, boundary, and error-handling checks.
- Documentation and governance changes require syntax, path, terminology, authority, gate, and cross-artifact consistency checks.
- Inapplicable activities shall be marked `Not Applicable` with a rationale, never silently skipped.

## Shared Workflow Controls

- The shared workflow uses semantic versioning and is pinned by the team configuration.
- Projects may supply their own requirements and configuration but shall not patch the shared skill locally.
- Shared workflow changes require their own ECR, validation, independent review, and Project Owner acceptance.
- Assumptions, tool outputs, unresolved issues, and deviations shall be recorded.

## Safety and Integrity Constraints

- Project-defined safety behavior overrides routine behavior according to approved requirements.
- Safety priorities shall be explicit and deterministic.
- Shared configuration belongs in the approved project configuration source, including a data dictionary where applicable.
- Do not bypass checks, mask failures, create fake traceability, or claim independent verification without an independent named reviewer.
- Stop on ambiguity, failed acceptance criteria, broken traceability, unapproved dependencies, unexpected scope, or conflict of interest.
