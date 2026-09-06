# Dependency Register

**Associated ECR:** ECR-20260906-001

**Status:** APPROVED — Gate 2 on 2026-09-06

Phase 1 completed with `PASS` on 2026-09-06. Installation, version, and licensed runtime use are verified for all twelve products. The correct Predictive Maintenance Toolbox feature is `pred_maintenance_toolbox`; the earlier `PredMaint_Toolbox` failure used an incorrect identifier and did not indicate a missing license. Availability values remain restricted to `AVAILABLE`, `UNAVAILABLE`, or `NOT VERIFIED`.

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
| Image Processing Toolbox | Quality measurement and preprocessing | Proposed optional dependency | 26.1 | INSTALLED | AVAILABLE | INSTALLED AND LICENSE AVAILABLE | AVAILABLE |
| Deep Learning Toolbox | Optional learned detection implementation | Proposed optional dependency | 26.1 | INSTALLED | AVAILABLE | INSTALLED AND LICENSE AVAILABLE | AVAILABLE |
| Predictive Maintenance Toolbox | Optional condition-feature and prediction workflows | Proposed optional dependency | 26.1 | INSTALLED | AVAILABLE — feature `pred_maintenance_toolbox` confirmed in use | INSTALLED AND LICENSE AVAILABLE | AVAILABLE |

## Dependency Rules

- Approval does not imply installation or licensed availability.
- Availability does not imply approval for a work package.
- An unavailable optional product requires an approved design disposition; it shall not be silently substituted.
- Product use, versions, compatibility checks, and fallbacks belong in the Gate 3 implementation plan.
- Installation evidence does not imply license availability.
- Phase 1 is `PASS`; all twelve required products are installed and license available.
- Phase 2 is eligible for Project Owner authorization but remains not authorized. Phases 3 through 17 remain not authorized.
- Detailed evidence is in `extensions/intelligent-inspection/evidence/dependency_preflight.md`.
- Raw checkout evidence is in `extensions/intelligent-inspection/evidence/license_preflight_results.txt`.
- Corrected Predictive Maintenance Toolbox feature evidence is in `extensions/intelligent-inspection/evidence/diagnostic_feature_designer_license.txt`.
