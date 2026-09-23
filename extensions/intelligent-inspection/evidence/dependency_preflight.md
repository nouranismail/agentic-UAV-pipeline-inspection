# Phase 1 Dependency and License Preflight Evidence

**Associated ECR:** ECR-20260906-001

**Execution date:** 2026-09-06

**Responsible role:** Integration & Tooling Lead

**Phase result:** **PASS**

## 1. Scope and Result

This preflight inspected only the approved MATLAB installation, product metadata, versions, and license availability. It did not install, update, activate, remove, or use any product for model or algorithm work.

All twelve requested products are independently confirmed as installed and licensed. The latest runtime evidence records all twelve required license features in `license("inuse")`, including the correct Predictive Maintenance Toolbox feature `pred_maintenance_toolbox`. The earlier failed check used the incorrect identifier `PredMaint_Toolbox`; its Licensing Error 5 (`-5.2`) did not demonstrate that the installed product lacked a license. All twelve products are classified `INSTALLED AND LICENSE AVAILABLE`, and Phase 1 satisfies its approved acceptance criteria.

## 2. MATLAB Release and Environment Evidence

| Item | Result | Evidence/method |
|---|---|---|
| Installation root | `C:\Program Files\MATLAB\R2026a` | Existing installation directory inspected read-only |
| MATLAB release | R2026a | `VersionInfo.xml` `<release>` |
| MATLAB version | `26.1.0.3312084` | `VersionInfo.xml` `<version>` |
| Update | Update 4 | `VersionInfo.xml` `<description>` |
| Build date | 2026-06-30 | `VersionInfo.xml` date `Jun 30 2026` |
| Installed platform | Windows 64-bit | Every relevant `prodcontents.json` key ends in `win64`; installation root is a Windows path |
| MATLAB-reported operating environment | Microsoft Windows 11 Pro Version 10.0, Build 26200; `PCWIN64` | Manual transcript output from `ver` and `computer` |
| MATLAB runtime version confirmation | `26.1.0.3312084 (R2026a) Update 4`; release query returned `2026a` | Manual transcript output from `version` and `version('-release')` |

The release/update is supported by both installation metadata and the supplied manual MATLAB runtime transcript.

## 3. Product Results

| Product | Version | Installation evidence | License-check method/result | Classification |
|---|---|---|---|---|
| MATLAB | 26.1 | `prodcontents.json` and manual `ver`: MATLAB 26.1 | Feature `matlab`: checkout successful `1` and confirmed in `license("inuse")` | **INSTALLED AND LICENSE AVAILABLE** |
| Simulink | 26.1 | `prodcontents.json` and manual `ver`: Simulink 26.1 | Feature `simulink`: checkout successful `1` and confirmed in `license("inuse")` | **INSTALLED AND LICENSE AVAILABLE** |
| Stateflow | 26.1 | `prodcontents.json` and manual `ver`: Stateflow 26.1 | Feature `stateflow`: checkout successful `1` and confirmed in `license("inuse")` | **INSTALLED AND LICENSE AVAILABLE** |
| System Composer | 26.1 | `prodcontents.json`, manual `ver`, and `which systemcomposer.createModel` | Feature `system_composer`: checkout successful `1` and confirmed in `license("inuse")` | **INSTALLED AND LICENSE AVAILABLE** |
| Image Processing Toolbox | 26.1 | `prodcontents.json` and manual `ver`: Image Processing Toolbox 26.1 | Feature `image_toolbox`: checkout successful `1` and confirmed in `license("inuse")` | **INSTALLED AND LICENSE AVAILABLE** |
| Computer Vision Toolbox | 26.1 | `prodcontents.json` and manual `ver`: Computer Vision Toolbox 26.1 | Feature `video_and_image_blockset`: checkout successful `1` and confirmed in `license("inuse")` | **INSTALLED AND LICENSE AVAILABLE** |
| Deep Learning Toolbox | 26.1 | `prodcontents.json` and manual `ver`: Deep Learning Toolbox 26.1 | Feature `neural_network_toolbox`: checkout successful `1` and confirmed in `license("inuse")` | **INSTALLED AND LICENSE AVAILABLE** |
| Statistics and Machine Learning Toolbox | 26.1 | `prodcontents.json` and manual `ver`: Statistics and Machine Learning Toolbox 26.1 | Feature `statistics_toolbox`: checkout successful `1` and confirmed in `license("inuse")` | **INSTALLED AND LICENSE AVAILABLE** |
| Predictive Maintenance Toolbox | 26.1 | `prodcontents.json`, manual `ver`, and `which diagnosticFeatureDesigner` resolve version 26.1 and the installed application | Correct feature `pred_maintenance_toolbox` is present in `license("inuse")`; earlier `PredMaint_Toolbox` check used an incorrect identifier | **INSTALLED AND LICENSE AVAILABLE** |
| Requirements Toolbox | 26.1 | `prodcontents.json` and manual `ver`: Requirements Toolbox 26.1 | Feature `simulink_requirements`: checkout successful `1` and confirmed in `license("inuse")` | **INSTALLED AND LICENSE AVAILABLE** |
| Simulink Test | 26.1 | `prodcontents.json` and manual `ver`: Simulink Test 26.1 | Feature `simulink_test`: checkout successful `1` and confirmed in `license("inuse")` | **INSTALLED AND LICENSE AVAILABLE** |
| Simulink Coverage | 26.1 | `prodcontents.json` and manual `ver`: Simulink Coverage 26.1 | Feature `simulink_coverage`: checkout successful `1` and confirmed in `license("inuse")` | **INSTALLED AND LICENSE AVAILABLE** |

No product is classified `NOT INSTALLED`, `INSTALLED BUT LICENSE NOT VERIFIED`, or `CHECK BLOCKED`. Installation and licensed runtime use are confirmed for all twelve products.

## 4. Commands and APIs Used

Read-only installation inspection:

- Read `C:\Program Files\MATLAB\R2026a\VersionInfo.xml`.
- Parsed keys in `C:\Program Files\MATLAB\R2026a\appdata\prodcontents.json`.
- Confirmed the support-package inventory file exists at `C:\ProgramData\MATLAB\SupportPackages\R2026a\appdata\prodcontents.json`; support-package content was outside the requested product scope.
- Inspected the complete user-supplied transcript at `extensions/intelligent-inspection/evidence/matlab_manual_preflight.txt` without modifying it.
- Inspected the complete user-supplied checkout results at `extensions/intelligent-inspection/evidence/license_preflight_results.txt` without modifying it.
- Inspected the complete user-supplied corrected feature evidence at `extensions/intelligent-inspection/evidence/diagnostic_feature_designer_license.txt` without modifying it.

Authorized MATLAB batch probes attempted:

- `version`
- `version('-release')`
- `computer`
- `system_dependent('getos')`
- `matlabroot`
- `ver`
- `matlab.internal.product.getBaseCodeFromProductName(productName)`
- `matlab.internal.licensing.isProductLicensed(baseCode)`

The internal licensing APIs were selected to keep installation and license entitlement separate. They are unsupported internal APIs and produced no result because MATLAB startup did not complete.

Manual transcript APIs and commands reviewed:

- `version`
- `version('-release')`
- `computer`
- `ver`
- `license('inuse')`
- `which systemcomposer.createModel`
- `license('test','System_Composer')`
- `which diagnosticFeatureDesigner`

Manual license-check evidence reviewed for each product:

- License-existence result
- Actual checkout result
- Returned message or licensing error
- MATLAB feature name used for the checkout
- Complete `license("inuse")` feature list from the corrected Predictive Maintenance diagnostic transcript

## 5. Startup Failures and Limitations

1. The first sandboxed batch launch ended with `Fatal Startup Error`, `System Error: File system inconsistency`, and exit status `0x00000001`.
2. The same combined inventory/license probe was retried with approved external MATLAB execution permission. It produced no output and was terminated after repeated monitoring intervals.
3. A separate minimal version/environment probe was attempted with approved external execution permission. It also produced no output and was terminated after repeated monitoring intervals.
4. The later license-check transcript resolves the previously missing per-product checkout results for eleven products.
5. The corrected diagnostic transcript shows `pred_maintenance_toolbox` in `license("inuse")`. The earlier `PredMaint_Toolbox` failure resulted from an incorrect feature identifier, not a missing Predictive Maintenance Toolbox license.
6. No unavailable-license blocker or limitation remains for the twelve required products.
7. The checkout actions were recorded in the supplied manual evidence; this reconciliation did not initiate MATLAB, install, activate, repair, update, or remove any product.

## 6. Future-Phase Enablement

| Phase(s) | Status after preflight | Reason |
|---|---|---|
| Phase 1 | **PASS** | All twelve required products are installed and license available; completion date 2026-09-06 |
| Phase 2 | **ELIGIBLE FOR PROJECT OWNER AUTHORIZATION — NOT YET AUTHORIZED** | Phase 1 passed, but only the Project Owner may authorize Phase 2 |
| Phases 3–17 | **NOT AUTHORIZED** | Their documented prerequisites and approval hold points remain |

No future implementation phase was executed. Phase 2 is eligible to be considered for Project Owner authorization; it is not authorized by this Phase 1 result.

## 7. Phase 1 Acceptance Evaluation

| Approved criterion | Result | Finding |
|---|---|---|
| Every dependency has release evidence, governance status, and a permitted availability value | **MET** | All twelve products are `AVAILABLE` based on installation and runtime license evidence |
| Zero product-dependent phases start with `NOT VERIFIED` | **MET** | All twelve license checkout results are now resolved; no later phase was started |
| Unavailable products have approved defer/omit disposition | **NOT APPLICABLE** | No required product is unavailable |
| Product inventory reconciliation (`IIW-TST-DEP-001`) | **NOT RUN** | Test execution was prohibited. A manual read-only comparison found twelve requested products matching twelve installed metadata entries, but this is not recorded as test evidence. |

**Final Phase 1 result: PASS.** All twelve required products have confirmed installation and licensed runtime evidence. Phase 2 is eligible for Project Owner authorization but remains not authorized. Phases 3 through 17 remain not authorized.

## 8. Scope Confirmation

- Products installed, updated, activated, or removed: **None**
- Models created or modified: **None**
- AI/CV/DL/ML training performed: **None**
- Model or regression tests run: **None**
- `TST-001` through `TST-019` run: **No**
- Verified UAV artifacts modified: **None**
- Phases 2–17 executed: **No**
