# Agentic UAV Pipeline Inspection: Model-Based Design Workflow

> Production-grade Model-Based Design (MBD) framework integrating Simulink, Stateflow, and MathWorks Agentic Toolkits with Machine Learning and Computer Vision. Features an autonomous UAV mission supervisor designed for traceable, safety-critical industrial infrastructure monitoring and automated verification.

---

## Overview
Modern industrial infrastructure—such as crude oil and natural gas pipelines spanning remote desert corridors—requires rigorous, automated surveillance. This repository houses an enterprise-grade **Team-Scale Agentic Engineering Starter Kit**. It bridges cutting-edge AI agent workflows (Model Context Protocol / Agentic Toolkits) with traditional, high-reliability **Model-Based Design (MBD)** principles to safely manage and verify complex cyber-physical systems.

---

##  Tech Stack & Tooling
* **Core Design:** MATLAB, Simulink, Stateflow
* **Agentic Workflows:** MathWorks Agentic Toolkits, Custom `simulink-engineering-workflow` Agent Skill
* **Verification & Validation:** Requirements Toolbox, Simulink Test, Simulink Coverage
* **Perception & Intelligence:** Computer Vision Toolbox, Statistics and Machine Learning Toolbox
* **Infrastructure & MLOps:** Git, Centralized Data Dictionaries (`.sldd`)

---

##  Repository Architecture

```text
agentic-uav-pipeline-inspection/
│
├── AGENTS.md                          # Organization-level agent governance & rules
├── config/
│   └── team_configuration.yaml        # Team roles, conventions, & approved toolboxes
│
├── templates/                         # Standardized engineering templates
│   ├── change_request_template.md
│   ├── implementation_plan_template.md
│   └── change_report_template.md
│
├── skills/
│   └── simulink-engineering-workflow/ # Reusable core agent skill (Read -> Plan -> Edit -> Test)
│       └── SKILL.md
│
└── projects/
    └── uav_pipeline_inspection/       # Reference implementation: UAV Mission Supervisor
        ├── requirements/
        ├── models/                    # Stateflow logic & Simulink harness (.slx)
        └── tests/                     # Automated test scripts & coverage reports



# MATLAB temporary and auto-save files
*.asv
*.bak
slprj/
sfprj/
codegen/
*.mex*
*.mat
*.fig

# Python cache & virtual environments
__pycache__/
*.py[cod]
*$py.class
venv/
env/
.env

# OS-specific hidden files
.DS_Store
Thumbs.db
.vscode/
.idea/
