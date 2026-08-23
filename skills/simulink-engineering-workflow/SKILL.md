# Skill: Simulink Engineering Workflow & Agentic Execution

## Purpose
This skill instructs autonomous AI agents on how to safely and methodically execute engineering changes, model modifications, and verification tasks for MATLAB, Simulink, and Stateflow projects. 

## Scope & Applicability
This skill applies to any Model-Based Design (MBD) project managed under strict governance (`AGENTS.md`), centralized data dictionaries (`.sldd`), and formal traceability standards.

## Supported Agent Requests
The agent equipped with this skill is authorized to process the following request types:
1. Implement a new system requirement into an existing model.
2. Add, modify, or reconfigure an operating mode or Stateflow transition.
3. Update controller gains, thresholds, or calibration parameters via centralized data dictionaries.
4. Execute test suites and verify model behavior against acceptance criteria.
5. Generate fully traceable Engineering Change Reports.

## Mandatory Execution Protocol (The 10-Step Loop)
When presented with a change task, the agent must execute these steps sequentially and never skip verification:

1. **Read & Scoping:** Read repository instructions (`AGENTS.md`), project `README.md`, active requirements, and the incoming change request.
2. **Model Overview:** Inspect model architecture, referenced models, libraries, and `.sldd` files using architectural inspection tools.
3. **Artifact Read:** Inspect exact subsystems, blocks, Stateflow charts, signals, and parameter links involved in the task.
4. **Implementation Plan:** Draft and obtain approval for an implementation plan (`templates/implementation_plan_template.md`) *before* editing models.
5. **Controlled Modification:** Execute model edits safely using approved toolkits, ensuring all design parameters link to the centralized `.sldd`.
6. **Traceability Update:** Establish bidirectional links: Requirements -> Model Elements -> Test Cases.
7. **Diagnostics & Compilation:** Run model diagnostics and compilation checks to resolve warnings, data type mismatches, or algebraic loops.
8. **Simulink Test Execution:** Run regression and requirements-based test suites using Simulink Test. Add new tests if behavior is expanded.
9. **Coverage Analysis:** Collect Simulink Coverage data, verifying decision coverage for safety-critical logic.
10. **Change Report Generation:** Produce a completed Engineering Change Report (`templates/change_report_template.md`) summarizing test results, coverage, and residual risks.

## Safety Constraints
* Never hardcode configuration parameters inside block dialogs or Stateflow charts.
* Safety-critical overrides (e.g., low-battery return-to-home states) must take absolute priority over operational states.
* Never bypass model checks or mask test failures.