# Team-Scale Agentic Engineering Workflow for MATLAB and Simulink

**Shared Workflow Version:** 1.0.0

This repository demonstrates a reusable, approval-gated engineering workflow for teams using MATLAB, Simulink, and related approved products. The UAV mission supervisor is the reference project; it is not the reusable workflow itself.

## Objectives

- Make engineering behavior consistent across team members and clean agent sessions.
- Separate organization standards, team configuration, and project-specific artifacts.
- Require explicit scope, requirements, plan, verification, and acceptance gates.
- Preserve requirement-to-implementation-to-test-and-result traceability.
- Prevent developer checks from being represented as independent verification.
- Reuse the unchanged approved core workflow on a second small project.

## Three-Layer Structure

### Organization standard

Shared across teams:

- `AGENTS.md`
- `skills/simulink-engineering-workflow/SKILL.md`
- Reusable templates under `templates/templates/`
- Approval-gate and independent-verification rules
- Shared-workflow versioning and definition of done

These artifacts remain application-independent.

### Team configuration

Maintained for the team:

- `TEAM.md`
- `config/team_configuration.yaml`
- Named role assignments
- Approved products and integrations
- Team conventions and additional checks
- Pinned shared-workflow version

### Project artifacts

Maintained by each project:

- Requirements and acceptance criteria
- Architecture and interfaces
- MATLAB, Simulink, and Stateflow artifacts
- Data dictionaries and parameters
- Tests, expected results, coverage, and traceability
- Reports, assumptions, limitations, and known issues

The current UAV reference artifacts are stored directly under `requirements/`, `models/`, `data/`, `scripts/`, `tests/`, and `reports/`. The documented `projects/` hierarchy is a future repository-structure work package and does not exist in the current layout.

## Roles and Handoff

The minimum engineering chain is:

```text
System Engineer
    -> approved requirements and implementation plan
Model Developer
    -> frozen candidate and developer evidence
Independent Verification Engineer
    -> independent decision
Project Owner
    -> final acceptance or rejection
```

Canonical names, responsibilities, prohibitions, and RACI assignments are defined in `TEAM.md`. Every assisting agent must read `AGENTS.md`, load the shared workflow skill, declare its active role and authority, and stop at approval gates.

## Standard Change Workflow

```text
Gate 1: Scope/ECR Approval
    -> Gate 2: Requirements Approval
    -> Gate 3: Implementation Plan Approval
    -> Controlled Implementation
    -> Diagnostics, Tests, Traceability, and Coverage as applicable
    -> Gate 4: Implementation Evidence Complete
    -> Gate 5: Independent Verification
    -> Gate 6: Project Owner Final Acceptance
```

Silence, continuation, self-review, or a separate AI session is not approval or independent verification.

## Current Repository Layout

```text
agentic-uav-pipeline-inspection/
|-- AGENTS.md
|-- TEAM.md
|-- config/
|   `-- team_configuration.yaml
|-- skills/
|   `-- simulink-engineering-workflow/
|       `-- SKILL.md
|-- templates/
|   `-- templates/                         # Legacy nested location retained pending cleanup approval
|       |-- change_request_template.md Markdown
|       |-- implementation_plan_template.md
|       |-- test_plan_template.md
|       |-- independent_review_template.md
|       `-- change_report_template.md
|-- requirements/
|-- models/
|-- data/
|-- scripts/
|-- tests/
`-- reports/
```

The nested template path and the existing `change_request_template.md Markdown` filename are known legacy naming issues. They are intentionally retained because repository cleanup is a separate approval-controlled work package.

## Approved Tooling

The authoritative approved product and integration list is `config/team_configuration.yaml`. Do not install or use an unlisted toolbox, plugin, library, code generator, hardware package, or external service without explicit dependency and scope approval.

## Shared Workflow Adoption

A new team or project shall:

1. Adopt an approved, unchanged shared workflow version.
2. Assign its roles and Project Owner in a team configuration.
3. Select only approved products and team checks.
4. Create project-specific requirements, architecture, implementation, tests, and reports.
5. Follow all six approval gates.
6. Preserve independent verification by a named individual other than the implementer.
7. Raise a separate shared-workflow ECR instead of patching the core skill locally.

## Consistency and Reuse Evidence

After the workflow is frozen, three clean agent sessions shall receive the same bounded request and baseline. Their scope, safety decisions, gates, affected artifacts, verification strategy, traceability, and assumptions shall be compared using a controlled scorecard. A mandatory gate or safety violation is an automatic failure.

The second small project shall create its own team/project artifacts while using the same shared workflow version and hashes. UAV requirements, traceability, test results, and safety claims shall not be copied as evidence for the second project.

## Status Boundaries

- Implementation complete: developer work and evidence are complete.
- Independently verified: a different named individual has recorded a Gate 5 decision.
- Finally accepted: the Project Owner has recorded a Gate 6 decision.

These statuses are distinct and shall never be conflated.
