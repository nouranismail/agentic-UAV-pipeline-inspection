# Team Roles & Responsibilities (Agentic MBD Framework)

To ensure smooth multi-disciplinary collaboration, this repository follows a structured Model-Based Design (MBD) RACI-style role breakdown:

1. **Lead Systems Engineer / MBD Architect**
   * **Responsibilities:** Defines high-level system requirements, manages system architecture, oversees the centralized Simulink Data Dictionary (`.sldd`), and approves all Engineering Change Requests (ECRs).
2. **AI & Algorithm Developer**
   * **Responsibilities:** Implements computer vision pipelines, machine learning models, and autonomous navigation logic (e.g., Stateflow supervisory logic, path planning).
3. **Verification & Validation (V&V) Engineer**
   * **Responsibilities:** Builds test harnesses using Simulink Test, executes regression suites, tracks decision and condition coverage via Simulink Coverage, and audits Change Reports.
4. **Integration & Tooling Lead**
   * **Responsibilities:** Manages the MATLAB Agentic Toolkits, MCP protocol configurations, GitHub workflows, and repository governance (`AGENTS.md` and agent skills).