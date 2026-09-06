# Dependency Register

**Associated ECR:** ECR-20260906-001

**Status:** APPROVED — Gate 2 on 2026-09-06

Availability values are restricted to `AVAILABLE`, `UNAVAILABLE`, or `NOT VERIFIED`. No product availability check was authorized or performed in this phase.

| Product | Intended use | Governance status | Availability | Verification required before use |
|---|---|---|---|---|
| MATLAB | Configuration, algorithm, and evidence automation | Existing core toolchain | NOT VERIFIED | Record release and licensed availability. |
| Simulink | Later integration reference models | Existing core toolchain | NOT VERIFIED | Record release and licensed availability. |
| Stateflow | Later deterministic approval/integration behavior if approved | Existing core toolchain | NOT VERIFIED | Record release and licensed availability. |
| Requirements Toolbox | Native requirements and traceability if selected | Existing approved toolbox | NOT VERIFIED | Probe native API and record release. |
| Simulink Test | Later requirements-based and integration testing | Existing approved toolbox | NOT VERIFIED | Probe native API and record release. |
| Simulink Coverage | Later structural coverage where applicable | Existing approved toolbox | NOT VERIFIED | Probe native API and record release. |
| Computer Vision Toolbox | Replaceable vision implementation | Existing approved toolbox; optional for extension | NOT VERIFIED | Inspect product availability before planning use. |
| Statistics and Machine Learning Toolbox | Regression and statistical evaluation | Existing approved toolbox; optional for extension | NOT VERIFIED | Inspect product availability before planning use. |
| System Composer | Architecture models and interface definitions | Proposed optional dependency | NOT VERIFIED | Requires recorded dependency approval and availability inspection. |
| Image Processing Toolbox | Quality measurement and preprocessing | Proposed optional dependency | NOT VERIFIED | Requires recorded dependency approval and availability inspection. |
| Deep Learning Toolbox | Optional learned detection implementation | Proposed optional dependency | NOT VERIFIED | Requires recorded dependency approval and availability inspection. |
| Predictive Maintenance Toolbox | Optional condition-feature and prediction workflows | Proposed optional dependency | NOT VERIFIED | Requires recorded dependency approval and availability inspection. |

## Dependency Rules

- Approval does not imply installation or licensed availability.
- Availability does not imply approval for a work package.
- An unavailable optional product requires an approved design disposition; it shall not be silently substituted.
- Product use, versions, compatibility checks, and fallbacks belong in the Gate 3 implementation plan.
