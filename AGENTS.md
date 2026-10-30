# Organization-Level AI Agent Governance for MATLAB and Simulink

**Shared Workflow Version:** 1.0.0
**Applies To:** All teams, projects, engineers, and AI agents using this repository's shared engineering workflow

## 1. Core Directive

Preserve safety, determinism, verifiability, traceability, data integrity, and maintainability. Prefer explicit and reviewable engineering behavior over implicit or clever implementations. Project-specific safety behavior belongs in approved project requirements and architecture artifacts, not in this organization-level file or the reusable workflow skill.

No role or agent may change an engineering artifact outside an explicitly approved scope. A passing developer check is not independent verification, and neither is final acceptance.

## 2. Authority and Artifact Hierarchy

Apply instructions in this order:

1. Organization rules in this `AGENTS.md`.
2. The approved reusable workflow in `skills/simulink-engineering-workflow/SKILL.md`.
3. Team roles, conventions, approved products, and assignments in `TEAM.md` and `config/team_configuration.yaml`.
4. Approved project requirements, architecture, interfaces, configuration, tests, and change records.
5. The approved ECR and implementation plan for the active work package.

If two authoritative artifacts conflict, stop and obtain a recorded disposition from the Project Owner. Do not silently choose one.

## 3. Mandatory Task Declaration

Before substantive engineering work, every role and agent shall declare:

```text
Active role:
Assigned person:
Project:
Branch/baseline:
Approved ECR:
Current gate:
Authorized artifacts:
Prohibited actions:
Required workflow version:
Independence status:
```

The agent shall then read this file, the reusable workflow skill, the applicable team configuration, the approved request, and the affected project artifacts. Missing role assignment, scope, authority, or workflow version is a stop condition.

## 4. Canonical Roles

The canonical roles and their detailed authorities are defined in `TEAM.md`:

- Project Owner / Approval Authority
- Lead Systems Engineer / MBD Architect
- AI & Algorithm Developer
- Independent Verification & Validation Engineer
- Integration & Tooling Lead

The minimum engineering handoff is System Engineer -> Model Developer -> Independent Verification Engineer. Project Owner and Integration & Tooling Lead are supporting governance roles.

One person may hold multiple explicitly recorded roles, except that the implementer and Independent Verification Engineer shall be different individuals.

## 5. Approval Gates

### Gate 1 - Scope/ECR Approval

No requirements, architecture, implementation-plan, or artifact-modification work shall begin until the Project Owner records an explicit ECR scope decision identifying the objective, affected artifacts, exclusions, dependencies, and conditions.

### Gate 2 - Requirements Approval

No implementation plan shall be approved until the Project Owner accepts the applicable requirements, interfaces, safety priorities, acceptance criteria, and identified assumptions.

### Gate 3 - Implementation Plan Approval

No repository artifact shall be modified until the Project Owner approves an implementation plan identifying exact affected files, responsible roles, hazards, verification activities, traceability, coverage objectives where applicable, acceptance criteria, and rollback actions.

### Gate 4 - Implementation Evidence Complete

The implementer shall stop after producing the approved change and developer evidence. Developer checks shall not be described as independent verification or final acceptance.

### Gate 5 - Independent Verification

An Independent Verification Engineer shall inspect the frozen candidate and record exactly one decision: `PASS`, `PASS WITH OBSERVATIONS`, or `FAIL / CORRECTIVE ACTION REQUIRED`. A separate AI-agent session alone does not establish independence.

### Gate 6 - Final Acceptance

The Project Owner shall review the change report, independent-verification decision, findings, deviations, and residual risks before explicitly accepting or rejecting the change. No release or baseline claim is permitted before this decision.

For every gate, silence, task continuation, previous general permission, an agent assumption, or implementer self-approval shall not constitute approval.

## 6. Controlled Engineering Rules

### Scope and planning

- Make only changes listed in an approved implementation plan.
- Treat unexpected downstream impact or a required additional artifact as scope expansion and stop.
- Preserve unrelated user work and never use a passing result to justify an unapproved change.

### Safety and determinism

- Implement project-defined safety behavior as explicit, deterministic, testable logic with unambiguous priority.
- Preserve project-approved fail-safe handling for invalid, unavailable, stale, or contradictory inputs.
- Do not weaken or reorder safety behavior without requirements, hazard, test, and approval updates.

### Configuration and data

- Keep shared parameters, calibrations, enumerations, buses, constants, and tunable design data in the project-approved configuration source, including a Simulink Data Dictionary where applicable.
- Record units, types, ranges, defaults, and ownership.
- Do not create ad hoc configuration overrides or duplicate authoritative values in tests.

### Traceability

- Maintain the project-required evidence chain from requirement to implementation element to test and result.
- Use stable identifiers and native traceability mechanisms where available.
- Never create fake links to nonexistent or unapproved artifacts.

### Verification evidence

- Execute the verification defined in the approved plan and test plan.
- For model changes, run applicable diagnostics, simulations, regression tests, and structural coverage review.
- For documentation or tooling changes, use proportionate validation; model compilation and coverage are not required unless engineering behavior is affected.
- Report warnings, failures, assumptions, deviations, infeasible objectives, and known limitations.
- Do not suppress, filter, or mask failures merely to obtain a passing result.

### Products and dependencies

- Use only products, libraries, services, plugins, and toolboxes approved in the team configuration and active plan.
- New dependencies require a separate recorded scope and dependency approval before installation or use.

## 7. Independent Verification

- Record the implementer and verifier by name.
- Require an explicit verifier independence declaration.
- Freeze or hash the candidate before independent review.
- Any candidate change during review invalidates that review.
- The verifier may reproduce evidence but shall not repair the implementation during the same review.
- Corrective work returns to implementation and requires regression and renewed independent review.
- AI assistance shall be disclosed; a named individual owns the independent decision.
- Project Owner review does not replace independent verification.

## 8. Handoffs

Every role handoff shall record:

```text
From role:
To role:
Completed gate:
Artifacts produced or changed:
Evidence available:
Open findings:
Assumptions and deviations:
Next permitted activity:
Required approver:
```

## 9. Shared Workflow Versioning

Shared workflow artifacts use semantic versioning:

- Major: incompatible gate, role, authority, or workflow change.
- Minor: backward-compatible workflow capability or template addition.
- Patch: clarification with no workflow-behavior change.

Changes to shared governance, skills, or templates require a controlled ECR, validation, independent review, and Project Owner acceptance. Teams shall pin the workflow version in their configuration. Projects shall not locally patch the shared skill to bypass this process.

## 10. Stop Conditions

Stop and escalate when scope or authority is missing; requirements conflict or are incomplete; safety priority is ambiguous; an unapproved dependency is required; an interface or configuration change affects another component; a relevant test or coverage objective fails; traceability is broken; evidence is missing; independent review has a conflict of interest; or a change could alter an approved baseline outside the active plan.

Never represent incomplete, self-reviewed, or unapproved evidence as compliance, independent verification, release, or final acceptance.
