# Dependency Register

**Associated ECR:** ECR-20260906-001

**Status:** APPROVED — Gate 2 on 2026-09-06

Phase 1 completed with `PASS` on 2026-09-06. Installation, version, and licensed runtime use are verified for all twelve products. The correct Predictive Maintenance Toolbox feature is `pred_maintenance_toolbox`; the earlier `PredMaint_Toolbox` failure used an incorrect identifier and did not indicate a missing license. Availability values remain restricted to `AVAILABLE`, `UNAVAILABLE`, or `NOT VERIFIED`.

On 2026-09-07, Nouran Ismail — Project Owner approved Image Processing Toolbox specifically for Phase 5 use under ECR-20260906-001. This scoped dependency approval does not authorize any later phase.

| Product | Intended use | Governance status | Installed version | Installation status | License status | Phase 1 classification | Availability |
|---|---|---|---|---|---|---|---|
| MATLAB | Configuration, algorithm, and evidence automation | Existing core toolchain | 26.1 | INSTALLED | AVAILABLE | INSTALLED AND LICENSE AVAILABLE | AVAILABLE |
| Simulink | Later integration reference models | Existing core toolchain | 26.1 | INSTALLED | AVAILABLE | INSTALLED AND LICENSE AVAILABLE | AVAILABLE |
| Stateflow | Later deterministic approval/integration behavior if approved | Existing core toolchain | 26.1 | INSTALLED | AVAILABLE | INSTALLED AND LICENSE AVAILABLE | AVAILABLE |
| Requirements Toolbox | Native requirements and traceability if selected | Existing approved toolbox | 26.1 | INSTALLED | AVAILABLE | INSTALLED AND LICENSE AVAILABLE | AVAILABLE |
| Simulink Test | Later requirements-based and integration testing | Existing approved toolbox | 26.1 | INSTALLED | AVAILABLE | INSTALLED AND LICENSE AVAILABLE | AVAILABLE |
| Simulink Coverage | Later structural coverage where applicable | Existing approved toolbox | 26.1 | INSTALLED | AVAILABLE | INSTALLED AND LICENSE AVAILABLE | AVAILABLE |
| Computer Vision Toolbox | Replaceable vision implementation | Existing approved toolbox; optional for extension | 26.1 | INSTALLED | AVAILABLE | INSTALLED AND LICENSE AVAILABLE | AVAILABLE |
| Statistics and Machine Learning Toolbox | Regression and statistical evaluation | Existing approved toolbox; optional for extension | 26.1 | INSTALLED | AVAILABLE | INSTALLED AND LICENSE AVAILABLE | AVAILABLE |
| System Composer | Architecture models and interface definitions | Proposed optional dependency | 26.1 | INSTALLED | AVAILABLE | INSTALLED AND LICENSE AVAILABLE | AVAILABLE |
| Image Processing Toolbox | Phase 5 data-quality measurement; preprocessing remains outside the authorized Phase 5 scope | APPROVED FOR PHASE 5 — Nouran Ismail, Project Owner, 2026-09-07 | 26.1 | INSTALLED | AVAILABLE | INSTALLED AND LICENSE AVAILABLE | AVAILABLE |
| Deep Learning Toolbox | Optional learned detection implementation | APPROVED FOR PHASE 7 — Nouran Ismail, Project Owner, 2026-09-08 | 26.1 | INSTALLED | AVAILABLE | INSTALLED AND LICENSE AVAILABLE | AVAILABLE |
| Predictive Maintenance Toolbox | Optional condition-feature and prediction workflows | Proposed optional dependency | 26.1 | INSTALLED | AVAILABLE — feature `pred_maintenance_toolbox` confirmed in use | INSTALLED AND LICENSE AVAILABLE | AVAILABLE |

## Dependency Rules

## Phase 13 Scoped Dependency Approval — 2026-09-16

The Phase 13 preflight reported MATLAB release `2026a` and confirmed installed product plus available license (`installed=1`, `license=1`) for MATLAB, Simulink, UAV Toolbox, Simulink 3D Animation, and Computer Vision Toolbox. Nouran Ismail — Project Owner — approves these five products for Phase 13 UAV Pipeline Configuration only.

The pregenerated MathWorks example **“Simulate Simple Flight Scenario and Sensor in Unreal Engine Environment”** is approved as the simulated source but is not yet installed in the local MATLAB example catalog (`matlab.internal.examples.isInstalled=0`; MATLAB-managed target root `C:\Users\Nouran Ismail\Documents\MATLAB\Examples\R2026a`). Nouran Ismail — Project Owner — authorizes acquisition of only this example through the MATLAB Help Center **Open in MATLAB/Open Live Script** workflow or another official MathWorks example mechanism. The example shall remain outside Git under the MATLAB-managed Examples directory. Opening and running the official example solely to verify source availability and R2026a compatibility is authorized after acquisition. Its files and model are read-only inputs: modification, repackaging, redistribution, commit, or copying into the repository is prohibited.

After successful acquisition, Phase 13 may consume only the example's RGB/fisheye camera output and simulation context metadata. This approval authorizes no other example content, real camera, flight-control interface, or simulation-environment development. Acquisition and compatibility results must be reported before Phase 13 implementation starts.

Availability and approval are scoped to integration/workflow demonstration. They do not establish real-world inspection performance, production readiness, or authorization to connect to MissionSupervisor. Any future MissionSupervisor connection requires a separate ECR.

- Approval does not imply installation or licensed availability.
- Availability does not imply approval for a work package.
- An unavailable optional product requires an approved design disposition; it shall not be silently substituted.
- Product use, versions, compatibility checks, and fallbacks belong in the Gate 3 implementation plan.
- Installation evidence does not imply license availability.
- Phase 1 is `PASS`; all twelve required products are installed and license available.
- Phase 5 is `AUTHORIZED — NOT STARTED`; its Image Processing Toolbox use is approved. Phases 6 through 17 remain not authorized.
- Detailed evidence is in `extensions/intelligent-inspection/evidence/dependency_preflight.md`.
- Raw checkout evidence is in `extensions/intelligent-inspection/evidence/license_preflight_results.txt`.
- Corrected Predictive Maintenance Toolbox feature evidence is in `extensions/intelligent-inspection/evidence/diagnostic_feature_designer_license.txt`.
