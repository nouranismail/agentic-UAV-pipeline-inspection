# Team Roles and Responsibilities - Agentic MBD Framework

**Shared Workflow Version:** 1.0.0

All team members and assisting agents shall follow `AGENTS.md`, `skills/simulink-engineering-workflow/SKILL.md`, the team configuration, and the applicable approved project artifacts. Roles define authority; they do not override approval gates.

## Canonical Roles

### 1. Project Owner / Approval Authority

- **Responsibilities:** Owns project scope; approves ECRs, requirements, implementation plans, dependencies, deviations, and final acceptance; reviews independent-verification findings.
- **Permitted actions:** Approve, reject, return, suspend, or restrict work packages.
- **Prohibited actions:** Treat incomplete or failed verification as accepted; represent owner review as independent verification; silently override safety findings.
- **Required inputs:** ECR, approved requirements, risk assessment, implementation plan, change report, and independent-verification decision.
- **Required outputs:** Dated decisions containing approver name, role, exact scope, conditions, and deviations.
- **Approval authority:** Sole final project authority unless delegation is explicitly recorded.
- **Independence:** Final acceptance does not replace independent V&V.
- **Handoff:** Sends approved scope to the Systems Engineer and receives the independent decision from V&V.
- **Stop/escalation:** Missing reviewer, unresolved safety finding, failed verification, broken traceability, unapproved dependency, or scope expansion.

### 2. Lead Systems Engineer / MBD Architect

- **Assignment alias:** System Engineer.
- **Responsibilities:** Defines and reviews requirements, interfaces, architecture, safety priorities, acceptance criteria, hazards, and implementation-plan content.
- **Permitted actions:** Inspect artifacts; author or recommend ECRs, requirements, architecture decisions, and plans; review technical readiness.
- **Prohibited actions:** Grant final approval to its own implementation; override failed V&V; authorize release.
- **Required inputs:** Approved ECR, stakeholder needs, project baseline, constraints, and hazards.
- **Required outputs:** Requirements, architecture decisions, interface analysis, acceptance criteria, and implementation plan.
- **Approval authority:** Technical recommendation only; Project Owner records gate decisions.
- **Independence:** Cannot independently verify behavior it implemented.
- **Handoff:** Transfers approved requirements and plan to the developer; provides architecture evidence to V&V.
- **Stop/escalation:** Ambiguous requirement, undefined safety priority, incompatible interface, or uncontrolled configuration impact.

### 3. AI & Algorithm Developer

- **Assignment alias:** Model Developer.
- **Responsibilities:** Implements only the approved MATLAB, Simulink, Stateflow, algorithm, perception, or data-processing work package; maintains configuration and traceability; performs developer checks.
- **Permitted actions:** Modify only artifacts named in the approved plan; run approved diagnostics, simulations, tests, coverage, and evidence collection.
- **Prohibited actions:** Expand scope; introduce dependencies; approve its own plan or work; suppress failures; claim independent verification.
- **Required inputs:** Approved ECR, requirements, architecture, interfaces, implementation plan, and test plan.
- **Required outputs:** Controlled implementation, traceability, diagnostics, developer test results, coverage where applicable, and change-report inputs.
- **Approval authority:** Implementation authority only within approved scope.
- **Independence:** Developer verification is not independent V&V.
- **Handoff:** Transfers a frozen candidate and implementation evidence to the Systems Engineer and Independent V&V Engineer.
- **Stop/escalation:** Unexpected interface impact, safety ambiguity, failed test, unresolved warning, coverage gap, broken link, or out-of-scope artifact.

### 4. Independent Verification & Validation Engineer

- **Assignment alias:** Verification Engineer.
- **Responsibilities:** Independently inspects requirements, implementation semantics, tests, traceability, coverage, assumptions, deviations, and change evidence.
- **Permitted actions:** Conduct read-only review; reproduce verification; create approved verification evidence; record findings and a decision.
- **Prohibited actions:** Repair the implementation during the same review; conceal failures; verify work authored by the reviewer; claim final project acceptance.
- **Required inputs:** Frozen candidate and hashes, requirements, plan, implementation, configuration, tests, traceability, coverage where applicable, and change report.
- **Required outputs:** Findings and exactly one decision: `PASS`, `PASS WITH OBSERVATIONS`, or `FAIL / CORRECTIVE ACTION REQUIRED`.
- **Approval authority:** Independent technical verification decision; not final acceptance.
- **Independence:** Must be a different named individual from the implementer. A separate AI session alone is insufficient.
- **Handoff:** Sends the decision to the Project Owner or corrective findings to the responsible engineering role.
- **Stop/escalation:** Candidate changes during review, missing evidence, broken links, suppressed objectives, unrepeatable results, or conflict of interest.

### 5. Integration & Tooling Lead

- **Responsibilities:** Maintains organization governance, shared skills, templates, approved tool configuration, repository integration, shared-workflow versioning, and release preparation.
- **Permitted actions:** Assess tooling and implement governance or integration work explicitly approved by the Project Owner.
- **Prohibited actions:** Install dependencies or change governance, workflow behavior, or project engineering behavior without approval.
- **Required inputs:** Approved governance/tooling ECR, compatibility and security assessment, approved role definitions, and implementation plan.
- **Required outputs:** Consistent governance artifacts, tool inventory, validation evidence, version record, and integration report.
- **Approval authority:** Tool administration within approved scope; no functional or final approval authority.
- **Independence:** Cannot independently verify governance or tooling changes it implemented.
- **Handoff:** Sends the frozen governance/tooling candidate to independent review and then Project Owner disposition.
- **Stop/escalation:** Unapproved product, security concern, workflow conflict, or repository-wide impact outside scope.

## Minimum Engineering Handoff

```text
Lead Systems Engineer / MBD Architect
        -> approved requirements and plan
AI & Algorithm Developer
        -> frozen implementation and developer evidence
Independent Verification & Validation Engineer
        -> independent decision
Project Owner / Approval Authority
        -> final acceptance or rejection
```

## RACI Summary

| Activity | Project Owner | Systems Engineer | Developer | Independent V&V | Integration Lead |
|---|---|---|---|---|---|
| ECR scope decision | A | R | C | C | C |
| Requirements and architecture | A | R | C | C | I |
| Implementation plan | A | R | R | C | I |
| Controlled implementation | I | C | R | I | C |
| Developer verification | I | C | R | I | C |
| Independent verification | I | C | I | R/A | I |
| Final acceptance | R/A | C | I | C | I |
| Shared workflow maintenance | A | C | C | C | R |

`R` = Responsible, `A` = Accountable, `C` = Consulted, `I` = Informed.
