# Intelligent-Inspection Workflow Implementation Plan

**Template Version:** 1.0.0

**Shared Workflow Version:** 1.0.0

## 1. Identification and Authority

| Field | Entry |
|---|---|
| Associated ECR ID | ECR-20260906-001 |
| Project | Reusable Intelligent-Inspection Workflow Extension |
| Branch | `feature/intelligent-inspection-extension` |
| Original ECR baseline | `138d8e399f9b42d1c5defdee7b65c29abd9eca45` |
| Gate 2 planning baseline | `6a7d6d9e3445b3aa6878dc345f9fda411b8b0177` |
| Plan author | Codex, assisting Nouran Ismail |
| Author role | Lead Systems Engineer / MBD Architect |
| Planned implementers | Phase 5A, Phase 5B, Phase 6, Phase 7, Phase 8, Phase 9A, and Phase 9B AI & Algorithm Developer: Nouran Ismail; later implementation assignments remain **TBD** |
| Independent reviewer | **TBD:** a different named individual from every implementation author; Nouran Ismail is ineligible to independently verify her own Phase 5A, Phase 5B, Phase 6, Phase 7, Phase 8, Phase 9A, or Phase 9B implementation |
| Status | **PHASES 1-6 COMPLETE AND ACCEPTED; PHASE 7 COMPLETE, PERFORMANCE FAIL, NOT ACCEPTED FOR DEPLOYMENT; PHASE 8 COMPLETE AND ACCEPTED; PHASE 9A COMPLETE AND ACCEPTED; PHASE 9B COMPLETE, CORRECTIVE DEVELOPER VERIFICATION PASS 14/14, PERFORMANCE PASS, PROJECT OWNER ACCEPTED; PHASES 10-17 NOT AUTHORIZED** |

Gate 3 was approved by the Project Owner on 2026-09-06, initially with execution authority limited to Phase 1. Phases 1 through 4 were subsequently completed and accepted through their controlled hold points. On 2026-09-07, the Project Owner accepted Phase 4 developer evidence and authorized the narrowed data-quality scope. After an approved corrective repair, Phase 5A developer verification passed 16 of 16 tests and the Project Owner accepted Phase 5A. The Project Owner divided Phase 5 into Phase 5A — Reusable `DataQualityValidation` and Phase 5B — Reusable Image Preprocessing without renumbering Phases 6–17. On 2026-09-08, the Project Owner accepted Phase 5B and then Phase 6 developer evidence, recording 16/16 for each. Phase 6 is complete and accepted, with independent verification pending. Phase 7 implementation and developer verification completed, but locked performance acceptance failed after three disclosed official-test exposures. On 2026-09-09, the Project Owner retained the deep-learning artifact only as a disabled experimental prototype and did not request independent verification. On 2026-09-10, the Project Owner accepted Phase 8 after developer verification passed 14 of 14 tests; independent verification remains pending and requires a different reviewer. On 2026-09-13, the Project Owner accepted Phase 9A with 16/16 developer verification. Phase 9B initially failed 10/14 because of the generator invariant violation. After the approved correction, generator version 1.1 passed 14/14, all locked performance criteria passed, and the Project Owner accepted Phase 9B on 2026-09-13. Both test exposures remain disclosed, zero additional evaluations are authorized, and independent verification remains pending with a different named reviewer required. The model remains demonstration-only and is not production-ready. Phases 10–17 remain unauthorized.

## 2. Approved Basis

The plan implements the approved Gate 2 package:

- `requirements/generic_intelligent_inspection_requirements.md`
- `architecture/component_definitions.md`
- `architecture/interface_contracts.md`
- `architecture/safety_and_approval_priorities.md`
- `acceptance_criteria.md`
- `assumptions_and_limitations.md`
- `artifact_mapping.md`
- `dependency_register.md`

The approved requirements are `IIW-REQ-001` through `IIW-REQ-025`. The approved acceptance criteria are `IIW-AC-001` through `IIW-AC-031`; the Project Owner accepted the Phase 4 results for `IIW-AC-020` through `IIW-AC-031` on 2026-09-07.

## 3. Global Sequencing and Stop Controls

1. Phase 1 shall finish before any product-dependent phase. No product shall be used while its availability is `NOT VERIFIED` or `UNAVAILABLE`.
2. Product availability does not grant dependency approval. Proposed products require recorded Project Owner approval before use or installation.
3. No dataset-dependent development, tuning, or training shall begin until the dataset source, licensing, ownership, permitted use, split policy, leakage controls, and immutable version are approved.
4. No CV, DL, or regression training shall begin until applicable taxonomies, anomaly classes, metrics, operating slices, thresholds, and pass criteria are approved.
5. Phase 11 shall not begin until approval timeout, rejection, expiration, delegation, escalation, identity, and audit policies are approved.
6. Phase 16 shall not begin until Phase 15 demonstrates reuse with unchanged reusable-core hashes.
7. The verified `MissionSupervisor` and its interface remain unchanged. A proposed interface change is a stop condition requiring a separate approved ECR.
8. AI outputs remain advisory. They shall not directly command a safety-critical action, and approval waiting shall not block an external safety response.
9. The implementer shall not claim independent verification. A named independent reviewer, different from the implementation authors, must review the frozen candidate at Gate 5.
10. Unexpected companion artifacts, new dependencies, new interfaces, or changes outside a phase allowlist are scope expansion and require a stop and Project Owner disposition.

## 4. Globally Protected Artifacts

Every phase protects the following unless a separate ECR explicitly authorizes a change:

- `models/uav_mission_supervisor.slx`
- `models/uav_mission_supervisor.sldd`
- `models/uav_mission_supervisor~mdl.slmx`
- `models/uav_mission_supervisor_harnessInfo.xml`
- `requirements/uav_mission_supervisor_requirements.slreqx`
- `tests/uav_mission_supervisor_harness.slx`
- `tests/uav_mission_supervisor_tests.mldatx`
- `tests/uav_mission_supervisor_tests~mldatx.slmx`
- `tests/test_data/`
- `reports/uav_mission_supervisor_coverage.cvt`
- `reports/uav_mission_supervisor_coverage_report.html`
- `reports/uav_mission_supervisor_change_report.md`
- `reports/uav_mission_supervisor_independent_review.md`
- `data/system_mode_definitions.m`
- `scripts/initialize_mission_supervisor.m`
- `skills/simulink-engineering-workflow/SKILL.md`
- All approved Gate 2 specification files listed in Section 2
- Existing `TST-001` through `TST-019` definitions and expected results

## 5. Controlled Implementation Phases

### Phase 1 — Dependency and MATLAB-Product Preflight

| Execution field | Result |
|---|---|
| Attempt date | 2026-09-06 |
| Completion date | 2026-09-06 |
| Status | **PASS** |
| Evidence | `extensions/intelligent-inspection/evidence/dependency_preflight.md`; raw results in `extensions/intelligent-inspection/evidence/license_preflight_results.txt` and `extensions/intelligent-inspection/evidence/diagnostic_feature_designer_license.txt` |
| Finding | All twelve products are installed at version 26.1 and license available. The correct Predictive Maintenance Toolbox feature is `pred_maintenance_toolbox`; the prior failed check used the incorrect identifier `PredMaint_Toolbox`. |
| Enabled phases | Phase 2 is eligible for Project Owner authorization but is not yet authorized. Phases 3–17 remain not authorized. |

- **Approved requirement IDs:** `IIW-REQ-025`.
- **Prerequisites:** Gate 3 approval; named Integration & Tooling Lead; MATLAB launch explicitly authorized for this phase; no installation authorization is inferred.
- **Exact allowed files:** `config/team_configuration.yaml`; `extensions/intelligent-inspection/dependency_register.md`; `extensions/intelligent-inspection/evidence/dependency_preflight.md`; `extensions/intelligent-inspection/tools/run_dependency_preflight.m`.
- **Protected files:** Section 4 plus every file not listed above.
- **Responsible engineering role:** Integration & Tooling Lead.
- **Implementation actions:** Query MATLAB release, license, and product availability; record `AVAILABLE` or `UNAVAILABLE` with evidence; preserve approval status separately; perform compatibility review; do not install products or substitute unavailable products.
- **Measurable acceptance criteria:** Every dependency has release evidence, governance status, and one permitted availability value; zero product-dependent phases start with `NOT VERIFIED`; unavailable products have an approved defer/omit disposition.
- **Tests and metrics:** Static schema/YAML validation; product inventory reconciliation; `IIW-TST-DEP-001`; 100% dependency rows complete and zero approval/availability conflations.
- **Evidence produced:** Dependency-preflight report, command transcript, release/license observations, configuration diff, and unresolved-product dispositions.
- **Approval gate:** Gate 3 must be approved before execution; Project Owner dependency disposition is a phase-entry hold point for each proposed product; phase exit requires Lead Systems Engineer review.
- **Rollback approach:** Remove only the new preflight script/report and restore only the extension dependency fields to their pre-phase values; do not uninstall or modify MATLAB products.

### Phase 2 — Reusable Intelligent-Inspection Skill and Templates

| Authorization field | Decision |
|---|---|
| Phase 1 prerequisite | **PASS** |
| Phase 2 status | **AUTHORIZED** |
| Approver | Nouran Ismail — Project Owner |
| Authorization date | 2026-09-06 |
| Implementation status | **COMPLETE** |
| Review result | **ACCEPTED** |
| Reviewer | Nouran Ismail — Project Owner |
| Review date | 2026-09-06 |
| Authorized scope | Create only the reusable intelligent-inspection skill, five reusable reference-guidance files, and four generic templates listed below |
| Exclusions | No Phase 2 implementation in the authorization-recording task; no test artifact, model, training, test execution, existing Simulink workflow change, or verified UAV artifact change |
| Later phases | Phase 3 is **COMPLETE AND ACCEPTED**; Phase 4 is **AUTHORIZED AND READY TO EXECUTE** but not started; Phases 5–17 remain **NOT AUTHORIZED** |
| Review meaning | Project Owner acceptance of Phase 2 implementation; not independent verification or final acceptance of ECR-20260906-001 |

- **Approved requirement IDs:** `IIW-REQ-019`, `IIW-REQ-020`, `IIW-REQ-023`, `IIW-REQ-024`, `IIW-REQ-025`.
- **Prerequisites:** Phase 1 complete for any tool used; named Integration & Tooling Lead; shared-workflow version remains 1.0.0.
- **Exact allowed files:** `skills/intelligent-inspection-workflow/SKILL.md`; `skills/intelligent-inspection-workflow/references/system-composer-architecture.md`; `skills/intelligent-inspection-workflow/references/inspection-source-and-data-quality.md`; `skills/intelligent-inspection-workflow/references/vision-and-preprocessing.md`; `skills/intelligent-inspection-workflow/references/features-regression-and-uncertainty.md`; `skills/intelligent-inspection-workflow/references/human-approval-integration-and-evidence.md`; `templates/templates/intelligent_inspection_project_template.md`; `templates/templates/dataset_governance_template.md`; `templates/templates/model_card_template.md`; `templates/templates/ai_verification_report_template.md`.
- **Protected files:** Section 4, especially the existing Simulink workflow skill and governance templates not listed above.
- **Responsible engineering role:** Integration & Tooling Lead.
- **Implementation actions:** Create the optional modular skill, reusable procedures, and four templates; require role declaration, inherited Gates 1–6, dataset/model governance, independent verification, and application-neutral terminology.
- **Measurable acceptance criteria:** All referenced paths resolve; mandatory template fields are present; the skill explicitly extends workflow 1.0.0; prohibited application terminology occurs zero times in reusable content; no existing workflow file changes.
- **Tests and metrics:** Markdown/path checks, terminology scan, required-section test, workflow-version consistency test; `IIW-TST-GOV-001` through `IIW-TST-GOV-004`.
- **Evidence produced:** Static-validation log, terminology report, path inventory, and template-field matrix.
- **Approval gate:** Gate 3 approval plus Phase 1 tool disposition; phase exit is a controlled review hold point before architecture implementation.
- **Rollback approach:** Remove only the newly created skill, reference, template, and phase-test files after confirming their resolved paths are under the listed directories.

### Phase 3 — Logical System Composer Reference Architecture

| Authorization field | Decision |
|---|---|
| Phase 2 prerequisite | **COMPLETE AND ACCEPTED** |
| Phase 3 authorization | **AUTHORIZED** |
| Approver | Nouran Ismail — Project Owner |
| Authorization date | 2026-09-06 |
| Implementation status | **COMPLETE** |
| Verification result | **PASS — 7/7 tests passed** |
| Review result | **ACCEPTED** |
| Reviewer | Nouran Ismail — Project Owner |
| Review date | 2026-09-06 |
| Authorized scope | Create the logical reference architecture, generic components, ports, connectors, structure, Phase 3 test definition, and architecture evidence strictly within the existing Phase 3 allowlist |
| Architecture-generation script | **NOT AUTHORIZED** — no script path is present in the approved Phase 3 allowlist |
| Evidence | `extensions/intelligent-inspection/evidence/reference_architecture_validation.md` |
| Review meaning | Project Owner acceptance of Phase 3 implementation evidence; not independent verification or final acceptance of ECR-20260906-001 |
| Later phases | Phase 4 is **AUTHORIZED AND READY TO EXECUTE** but not started; Phases 5–17 remain **NOT AUTHORIZED** |

- **Approved requirement IDs:** `IIW-REQ-001`, `IIW-REQ-002`, `IIW-REQ-004`, `IIW-REQ-005`, `IIW-REQ-008`–`IIW-REQ-018`, `IIW-REQ-020`–`IIW-REQ-024`.
- **Prerequisites:** System Composer and required MATLAB/Simulink products verified `AVAILABLE` and approved; Phase 2 architecture procedure complete; logical architecture depth approved at Gate 2.
- **Exact allowed files:** `extensions/intelligent-inspection/architecture/models/intelligent_inspection_reference_architecture.slx`; `tests/intelligent-inspection/test_reference_architecture.m`; `extensions/intelligent-inspection/evidence/reference_architecture_validation.md`.
- **Protected files:** Section 4 and the interface dictionary reserved for Phase 4.
- **Responsible engineering role:** Lead Systems Engineer / MBD Architect.
- **Implementation actions:** Create one logical architecture containing exactly the ten approved components, required ports, and intended connections; keep component implementations empty; record model metadata and workflow version.
- **Measurable acceptance criteria:** Exactly ten named components exist; every intended exchange has a connected port; no behavioral algorithm or first-application semantic appears; model opens and updates without architecture errors.
- **Tests and metrics:** `IIW-TST-ARCH-001` component inventory, `IIW-TST-ARCH-002` connectivity, `IIW-TST-ARCH-003` application-neutrality; 100% expected components and connections present.
- **Evidence produced:** Architecture inventory, connection matrix, screenshots/report, update diagnostics, and artifact hash.
- **Approval gate:** Gate 3 plus successful Phase 1 System Composer disposition; phase exit requires Lead Systems Engineer architecture review before Phase 4.
- **Rollback approach:** Remove the new architecture model, its phase test, and validation report only; stop before removing unexpected generated companions.

### Phase 4 — Generic Interface Definitions in the Architecture

| Authorization field | Decision |
|---|---|
| Phase 3 prerequisite | **COMPLETE AND ACCEPTED** |
| Phase 4 status | **AUTHORIZED AND READY TO EXECUTE** |
| Approver | Nouran Ismail — Project Owner |
| Authorization date | 2026-09-06 |
| Implementation status | **NOT STARTED** |
| Clarification status | **APPROVED — Nouran Ismail, Project Owner, 2026-09-06** |
| Exact authorized allowlist | `extensions/intelligent-inspection/architecture/models/intelligent_inspection_reference_architecture.slx`; `extensions/intelligent-inspection/architecture/data/intelligent_inspection_interfaces.sldd`; `tests/intelligent-inspection/test_architecture_interfaces.m`; `extensions/intelligent-inspection/evidence/interface_conformance.md` |
| Authorized scope | Implement only the detailed generic interface schemas defined by the approved requirements and interface contracts, assign them within the logical architecture, create the Phase 4 interface test, and record conformance evidence |
| Exclusions | No behavioral algorithm, project-specific configuration, trained model, protected baseline change, existing regression execution, or file outside the exact Phase 4 allowlist |
| Later phases | Phases 5–17 remain **NOT AUTHORIZED** |

- **Approved requirement IDs:** `IIW-REQ-001`, `IIW-REQ-002`, `IIW-REQ-004`, `IIW-REQ-005`–`IIW-REQ-013`, `IIW-REQ-016`–`IIW-REQ-018`, `IIW-REQ-020`–`IIW-REQ-023`, `IIW-REQ-025`.
- **Prerequisites:** Phase 3 accepted; exact System Composer interface mechanism confirmed by Phase 1 compatibility evidence; targeted Gate 2 interface-schema clarification approved, including the three decisions recorded in `architecture/interface_contracts.md`.
- **Exact allowed files:** `extensions/intelligent-inspection/architecture/models/intelligent_inspection_reference_architecture.slx`; `extensions/intelligent-inspection/architecture/data/intelligent_inspection_interfaces.sldd`; `tests/intelligent-inspection/test_architecture_interfaces.m`; `extensions/intelligent-inspection/evidence/interface_conformance.md`.
- **Protected files:** Section 4 and all behavioral implementation files.
- **Responsible engineering role:** Lead Systems Engineer / MBD Architect.
- **Implementation actions:** Define the twelve approved logical contracts as architecture interfaces/value types; assign directions and interfaces to all ports; encode version identifiers, required fields, and declared units/domains without project-specific values.
- **Measurable acceptance criteria:** `IIW-AC-020` through `IIW-AC-031`; all twelve contracts exist once; 100% required ports use named contracts; every approved logical field is retained or has an explicitly approved runtime realization; mandatory fields match the approved detailed schema; `NumericalFeatureSet` has no raw-payload field; architecture update succeeds.
- **Tests and metrics:** `IIW-TST-IF-001` schema inventory, `IIW-TST-IF-002` port assignment, `IIW-TST-IF-003` forbidden-field check, `IIW-TST-IF-004` schema-version check; zero unnamed exchanges.
- **Evidence produced:** Interface dictionary report, port-to-contract matrix, diagnostics, and hashes.
- **Approval gate:** Gate 3 and Phase 3 exit hold point; interface mismatch or unexpected generated metadata is a stop condition.
- **Rollback approach:** Restore the Phase 3 model hash and remove only the new interface dictionary, interface test, and evidence report.

### Phase 5A — Reusable DataQualityValidation

| Authorization field | Decision |
|---|---|
| Phase 4 prerequisite | **COMPLETE; developer verification PASS — 7/7 tests; Project Owner review ACCEPTED** |
| Phase 4 acceptance criteria | `IIW-AC-020` through `IIW-AC-031`: **ACCEPTED** |
| Phase 5A implementation | **COMPLETE** |
| Phase 5A developer verification | **PASS — 16/16** |
| Phase 5A review decision | **ACCEPTED** |
| Phase 5A review date | 2026-09-07 |
| Approver | Nouran Ismail — Project Owner |
| Authorization date | 2026-09-07 |
| Assigned developer | Nouran Ismail — AI & Algorithm Developer |
| Developer assignment date | 2026-09-07 |
| Approved dependency | Image Processing Toolbox — **APPROVED FOR PHASE 5 USE** by Nouran Ismail — Project Owner on 2026-09-07 |
| Independence | **PENDING** — developer verification is not independent verification; a different named reviewer is required |
| Boundary clarification | **APPROVED** — inclusive minimum and maximum comparisons using `single` measured values and thresholds, with no tolerance; nonfinite values rejected before comparison |
| Clarification approver/date | Nouran Ismail — Project Owner; 2026-09-07 |
| Corrective result | The complete corrective suite passed 16/16 with zero failed and zero incomplete tests |
| Authorized scope | Reusable `InspectionSource` contract-boundary ingestion and `DataQualityValidation` only |
| Next subphase | Phase 5B is **AUTHORIZED — NOT STARTED** |
| Later phases | Phase 6 remains Replaceable Computer-Vision Detection and is **NOT AUTHORIZED**; Phases 7–17 remain **NOT AUTHORIZED** |

- **Approved requirement IDs:** `IIW-REQ-001` through `IIW-REQ-003`, `IIW-REQ-017`, `IIW-REQ-018`, `IIW-REQ-020`, `IIW-REQ-021`, `IIW-REQ-023`.
- **Prerequisites:** Phase 4 contracts accepted; MATLAB availability remains verified; any optional-product use requires its recorded dependency approval; quality algorithms, score aggregation, configurable boundaries, and invalid-input dispositions must be deterministic and documented before developer verification.
- **Exact authorized allowlist:** `extensions/intelligent-inspection/core/+iiw/+quality/validateInspectionData.m`; `tests/intelligent-inspection/test_data_quality.m`; `tests/intelligent-inspection/fixtures/quality_contract_fixtures.mat`; `extensions/intelligent-inspection/evidence/quality_preprocessing_results.md`.
- **Allowlist derivation:** This is the non-preprocessing subset of the previously approved Phase 5 allowlist. The existing evidence filename is retained for plan compatibility but does not authorize preprocessing content. No separate `InspectionSource` implementation path exists in the approved plan; generic image/sensor ingestion is therefore limited to contract-boundary acceptance and validation within `validateInspectionData.m`. A separate source implementation artifact requires a Project Owner-approved plan amendment before creation.
- **Protected files:** Section 4; Phase 4 interfaces and architecture; all preprocessing, detection, deep-learning, feature-extraction, regression, risk, approval, recommendation, and mission-control implementations.
- **Responsible engineering role:** AI & Algorithm Developer.
- **Implementation actions:** Accept generic image or numerical sensor payloads through the approved inspection contracts; validate required metadata and detect missing, malformed, unsupported, or invalid input; calculate configurable brightness, contrast, blur, and saturation/overexposure measures for applicable image payloads; produce a generic quality score, validity/status, and reason codes; deterministically reject or route unacceptable data to review/reacquisition without producing an operational change; preserve the same contract for later recorded, real, and simulated source adapters.
- **Measurable acceptance criteria:** Every input produces exactly one typed quality result; missing or malformed payload/metadata and unacceptable quality deterministically produce `REVIEW` or `REJECT` with reason codes and no autonomous operational output; applicable image measures and the aggregate quality score are finite and bounded in `[0,1]`; numerical sensor inputs are accepted without image-only metrics being falsely marked valid; repeated identical inputs/configuration produce identical results; source replacement requires no generic contract change.
- **Tests and metrics:** `IIW-TST-QUAL-001` through `IIW-TST-QUAL-006`; valid image, valid numerical sensor, missing payload, malformed metadata, unsupported schema, brightness boundaries, contrast boundaries, blur boundaries, saturation/overexposure boundaries, deterministic repeat, rejected-input fail-safe, and source-contract compatibility cases. Tests shall use deterministic synthetic fixtures and shall not claim project performance.
- **Evidence produced:** `quality_preprocessing_results.md`, limited in this authorization to source-ingestion and data-quality results, selected metric definitions, boundary cases, diagnostics, test results, and deterministic-branch coverage where applicable.
- **Approval gate:** Developer evidence is complete and the Project Owner accepted Phase 5A. Independent verification remains pending and must use a different named reviewer.
- **Rollback approach:** Remove only the three newly authorized implementation/test/fixture artifacts and the Phase 5 evidence file, or restore them to their pre-phase hashes if they already exist; do not alter Phase 4 or protected artifacts.

### Phase 5B — Reusable Image Preprocessing

| Authorization field | Decision |
|---|---|
| Phase 5A prerequisite | **COMPLETE; developer verification PASS — 16/16; Project Owner review ACCEPTED** |
| Phase 5B status | **COMPLETE AND ACCEPTED** |
| Approver | Nouran Ismail — Project Owner |
| Authorization date | 2026-09-07 |
| Assigned implementer | Nouran Ismail — AI & Algorithm Developer |
| Assigned by/date | Nouran Ismail — Project Owner; 2026-09-07 |
| Independence | Developer assignment does not establish independent verification; independent verification must use a different named person |
| Approved requirement | `IIW-REQ-004` |
| Approved acceptance criteria | `IIW-AC-032` through `IIW-AC-037` |
| Phase 5B developer verification | **PASS — 16/16** |
| Phase 5B review | **ACCEPTED** by Nouran Ismail — Project Owner on 2026-09-08 |
| Phase 5B independent verification | **PENDING** — a different named reviewer is required |
| Overall Phase 5 | **COMPLETE** |
| Phase 6 status | Replaceable Computer-Vision Detection — **AUTHORIZED — NOT STARTED** |
| Later phases | Phases 7–17 remain **NOT AUTHORIZED** |

- **Prerequisites:** Phase 5A accepted; Image Processing Toolbox remains verified and approved for the Phase 5 work package; the input has an approved `DataQualityResult.status` of `PASS`; preprocessing operation selection, order, dimensions, parameters, implementation version, and configuration version are explicitly configured. A `REVIEW`, `REJECT`, missing, malformed, or unsupported quality result is a controlled no-output condition.
- **Exact authorized allowlist:** `extensions/intelligent-inspection/core/+iiw/+preprocessing/preprocessInspectionData.m`; `extensions/intelligent-inspection/core/+iiw/+preprocessing/recordTransform.m`; `tests/intelligent-inspection/test_preprocessing.m`; `extensions/intelligent-inspection/evidence/quality_preprocessing_results.md`.
- **Allowlist derivation:** All four paths are recovered from the originally approved Phase 5 allowlist at commit `c52d7f59b382463f8a531f23f2fc25ff3f2838a6`. The completed Phase 5A fixture `tests/intelligent-inspection/fixtures/quality_contract_fixtures.mat` is protected and may be read but not modified. Deterministic preprocessing fixtures shall be defined within `test_preprocessing.m`; if a separate fixture artifact is required, implementation stops for a Project Owner-approved allowlist amendment.
- **Protected files:** Section 4; all completed Phase 5A implementation, test, and fixture artifacts; Phase 4 interfaces and architecture; every detection, segmentation, deep-learning, feature-extraction, regression, risk, approval, recommendation, and operational-control implementation. The shared evidence file may receive only a clearly separated Phase 5B section while its Phase 5A evidence remains unchanged.
- **Responsible engineering role:** Nouran Ismail — AI & Algorithm Developer, assigned by Nouran Ismail — Project Owner on 2026-09-07. Developer verification is not independent verification.
- **Implementation actions:** Accept only quality-approved image data; deterministically normalize approved image formats or channels; resize to configured dimensions; apply configured intensity normalization, denoising, and contrast adjustment in the approved order; preserve the source record; emit the approved `ProcessedData` contract; and record every applied operation, exact parameter value, input/output reference, implementation version, and configuration version.
- **Measurable acceptance criteria:** `IIW-AC-032` through `IIW-AC-037` pass. Identical inputs and configuration produce identical output and transform records; `REVIEW` and `REJECT` inputs produce no processed output; no operation is applied unless enabled by configuration; no transformation hides or changes the original quality disposition; every processed output resolves its immutable source and complete ordered transform record.
- **Tests and metrics:** `IIW-TST-PRE-001` through `IIW-TST-PRE-006`; quality-gate rejection, format/channel normalization, configured resize, enabled/disabled deterministic transforms, ordered parameter provenance, deterministic repeat, invalid configuration, schema conformance, scope, and prohibited-terminology tests. Run only the Phase 5B test during implementation; no achieved result is claimed by this amendment.
- **Evidence produced:** A distinct Phase 5B section in `quality_preprocessing_results.md` containing configuration, operations, parameters, versions, test output, warnings, errors, changed-file inventory, protected-artifact hashes, and actual PASS/FAIL/BLOCKED disposition.
- **Approval gate:** Phase 5B implementation and 16/16 developer verification are complete and were accepted by the Project Owner on 2026-09-08. This is not independent verification; a different named individual remains required at Gate 5.
- **Rollback approach:** Remove only the two new preprocessing functions and preprocessing test, and restore only the Phase 5B addition to the shared evidence file. Do not alter Phase 5A evidence or any protected artifact.

### Phase 6 — Replaceable Computer-Vision Detection

| Authorization field | Decision |
|---|---|
| Status | **COMPLETE AND ACCEPTED** |
| Approver/date | Nouran Ismail — Project Owner; 2026-09-08 |
| Implementer | Nouran Ismail — AI & Algorithm Developer |
| Assigned by/date | Nouran Ismail — Project Owner; 2026-09-08 |
| Independence | Developer verification is not independent verification; a different named person must perform independent verification |
| Scope | Reusable, replaceable conventional computer-vision Detection only |
| Input/output | Consume approved `ProcessedData`; emit approved `DetectionResult` |
| Required behavior | Configurable thresholds; application-independent implementation; controlled low-confidence and no-detection results; no operational or safety command output |
| Segmentation | **NOT AUTHORIZED** — it is not an implementation action in the approved Phase 6 plan |
| Training/tuning | **NOT AUTHORIZED** without the separately approved dataset and metric record |
| Developer verification | **PASS — 16/16** |
| Review | **ACCEPTED** by Nouran Ismail — Project Owner on 2026-09-08 |
| Independent verification | **PENDING** — a different named reviewer is required |

- **Approved requirement IDs:** `IIW-REQ-005`–`IIW-REQ-007`, `IIW-REQ-017`–`IIW-REQ-020`, `IIW-REQ-023`, `IIW-REQ-024`.
- **Prerequisites:** Computer Vision Toolbox verified and approved; Phase 5A and Phase 5B accepted. Contract-only and deterministic fixture work may proceed without training; dataset-dependent fitting or tuning requires the complete approved dataset and metric record.
- **Exact allowed files:** `extensions/intelligent-inspection/core/+iiw/+detection/DetectorContract.m`; `extensions/intelligent-inspection/core/+iiw/+detection/runDetector.m`; `extensions/intelligent-inspection/core/+iiw/+detection/conventionalDetector.m`; `tests/intelligent-inspection/test_detection_contract.m`; `tests/intelligent-inspection/test_detector_replacement.m`; `tests/intelligent-inspection/fixtures/detection_contract_fixtures.mat`; `extensions/intelligent-inspection/evidence/conventional_detection_results.md`.
- **Protected files:** Section 4, DL files reserved for Phase 7, and project datasets/models not explicitly approved.
- **Responsible engineering role:** AI & Algorithm Developer.
- **Implementation actions:** Implement a common detector boundary and one replaceable conventional reference implementation consuming `ProcessedData`; emit the approved `DetectionResult`, including label, confidence, optional location, schema, and model/implementation version; apply configurable thresholds; return controlled low-confidence or no-detection results; never synthesize success on failure or issue an operational or safety command.
- **Measurable acceptance criteria:** Two test doubles or implementations substitute without consumer changes; complete outputs pass schema validation; incomplete outputs fail explicitly; project taxonomy remains external.
- **Tests and metrics:** `IIW-TST-DET-001` through `IIW-TST-DET-006`; contract, replacement, invalid-output, deterministic-repeat, confidence-domain, and provenance tests. Precision/recall/F1 or localization metrics are reported only after an approved dataset and pass criteria exist.
- **Evidence produced:** Contract-conformance results, replacement demonstration, failure logs, version records, and any approved dataset-based metric report.
- **Approval gate:** Gate 3, product availability, and dataset/metric hold point before any data-dependent tuning; unavailable product causes defer/omit disposition.
- **Rollback approach:** Remove only the listed detector code, tests, fixtures, and evidence; do not alter consumers or substitute another library silently.

### Phase 7 — Optional Deep-Learning Detection

| Authorization field | Decision |
|---|---|
| Status | **FAIL - CORRECTIVE TRAINING AUTHORIZED** |
| Approver/date | Nouran Ismail — Project Owner; 2026-09-08 |
| Deep Learning Toolbox | **APPROVED FOR PHASE 7** |
| Implementer | Nouran Ismail — AI & Algorithm Developer; assigned by Nouran Ismail — Project Owner on 2026-09-08 |
| Independence | Developer verification does not establish independent verification; a different named person must perform independent verification |
| Dataset planning amendment | **APPROVED** by Nouran Ismail — Project Owner on 2026-09-08 |
| Dataset research and proposal | **AUTHORIZED** only in `extensions/intelligent-inspection/datasets/dataset_selection_proposal.md` |
| Dataset selection | **KSDD2 MANIFEST ACCEPTED** by Nouran Ismail — Project Owner on 2026-09-09 |
| Dataset acquisition | **COMPLETE**; official archive preserved under approved external storage and verified by manifest evidence |
| Dataset use, model training, model creation, and performance evaluation | **AUTHORIZED — NOT STARTED**, within the existing Phase 7 allowlist and approved controls |
| Annotation modification | **NOT AUTHORIZED** |
| Storage boundary | Resolve `IIW_DATASET_ROOT` to a location outside this Git repository; use `IIW_DATASET_ROOT/KSDD2/source/` for the source archive and `IIW_DATASET_ROOT/KSDD2/extracted/` for extracted content |
| Repository boundary | Raw archives, extracted images, and derived dataset payloads shall not be stored or redistributed in this repository; no `.gitignore` amendment is required for the approved external-storage approach |
| Download utility | No repository utility is required; acquisition shall use the publisher-controlled official source and record the final resolved URL, timestamp, archive name, byte size, and cryptographic hash in the manifest |
| Execution hold | Resolved for Phase 7 by the Project Owner decision dated 2026-09-09; actual training and evaluation remain not started and must follow the fixed approved controls |
| Later phases | Phases 8–17 remain **NOT AUTHORIZED** |

- **Approved requirement IDs:** `IIW-REQ-005`–`IIW-REQ-007`, `IIW-REQ-012`, `IIW-REQ-017`–`IIW-REQ-020`, `IIW-REQ-023`.
- **Prerequisites:** Phase 6 contract accepted; Deep Learning Toolbox verified and approved; KSDD2 manifest accepted for non-commercial internship use; deterministic split, leakage controls, binary class mapping, metrics, fixed thresholds, confidence policy, and compute approach approved. Initial training failed two fixed criteria; corrective training was authorized by the Project Owner on 2026-09-09.
- **Exact allowed files:** `extensions/intelligent-inspection/core/+iiw/+detection/deepLearningDetector.m`; `extensions/intelligent-inspection/training/train_deep_learning_detector.m`; `extensions/intelligent-inspection/models/deep_learning_detector.mat`; `extensions/intelligent-inspection/model_cards/deep_learning_detector.md`; `extensions/intelligent-inspection/datasets/deep_learning_dataset_manifest.yaml`; `tests/intelligent-inspection/test_deep_learning_detector.m`; `extensions/intelligent-inspection/evidence/deep_learning_detection_results.md`. The completed dataset-selection proposal is a planning record, not a corrective implementation artifact.
- **Protected files:** Section 4, raw datasets outside the approved manifest, and the conventional detector contract.
- **Responsible engineering role:** AI & Algorithm Developer.
- **Implementation actions:** Implement the optional replaceable learned detector and controlled training pipeline using the accepted KSDD2 manifest and approved split, task, training, confidence, metric, threshold, and licensing controls. Preserve dataset payloads outside Git, record complete execution provenance, map segmentation output to generic `DetectionResult`, and issue no mission or safety command.
- **Measurable acceptance criteria:** Adapter conforms without consumer changes; model identity/version and confidence semantics accompany every result; approved validation/test split remains isolated; every approved metric is reported against its pass threshold.
- **Tests and metrics:** `IIW-TST-DL-001` through `IIW-TST-DL-006`; schema, model-version, split-integrity, reproducibility, failure, performance-slice, and calibration checks; metrics only as approved in the dataset/metric record.
- **Evidence produced:** Dataset manifest, training configuration/log, model hash, model card, test results, confusion/performance/calibration evidence, and limitations.
- **Approval gate:** Gate 3 plus explicit dataset, metric, class, product, and compute approval hold point; failure of any prerequisite defers Phase 7 without blocking non-DL phases.
- **Rollback approach:** Quarantine then remove only the listed optional model, training, adapter, manifest, tests, card, and evidence under approved corrective scope; restore the common detector selection to its prior approved version.

#### Phase 7 KSDD2 Manifest Review and Training Hold-Point Decision

| Decision field | Approved value |
|---|---|
| Dataset manifest review | **ACCEPTED** |
| Project Owner / date | Nouran Ismail — Project Owner; 2026-09-09 |
| Phase 7 dataset use and model training | **AUTHORIZED — NOT STARTED** |
| Learning task | Binary semantic segmentation: background versus anomaly; convert results to generic `DetectionResult` regions behind `DetectorContract` |
| Split | Deterministic stratified 80% training / 20% validation from official training only, using stable SHA-256 ordering and recorded seed/configuration |
| Official test | Untouched and prohibited from fitting, preprocessing decisions, threshold tuning, model selection, early stopping, training, and validation |
| Training configuration | Compact U-Net-style network; approved configurable resizing; class weighting or approved imbalance-aware loss; deterministic seeds; validation early stopping; controlled GPU with CPU fallback |
| Confidence | Default pixel threshold 0.50; validation-only tuning; record final threshold; controlled abstention for low confidence |
| Evidence | Record MATLAB/toolbox versions, hardware, seed, hyperparameters, execution time, threshold, metrics, and partition-specific results |
| Acceptance criteria | `IIW-AC-038` through `IIW-AC-046` |
| Licensing | CC BY-NC-SA 4.0 non-commercial use; dataset outside Git; attribution and ShareAlike notice in model and model card |
| Failure disposition | Missed thresholds require `FAIL` or `APPROVED WITH LIMITATIONS`; thresholds cannot change after official-test results are viewed |
| Later phases | Phases 8–17 remain **NOT AUTHORIZED** |

This decision supersedes the earlier Phase 7 acquisition-only execution hold. It authorizes only the already planned Phase 7 artifacts and actions; it does not record implementation, training, evaluation, developer verification, independent verification, or acceptance results.

#### Phase 7 Corrective-Training Control

| Control | Approved value |
|---|---|
| Authorization | **CORRECTIVE TRAINING AUTHORIZED** by Nouran Ismail - Project Owner on 2026-09-09 |
| Current status | **FAIL - CORRECTIVE TRAINING AUTHORIZED** |
| Implementer | Nouran Ismail - AI & Algorithm Developer |
| Failed criteria | Official-test recall 0.636364 < 0.75; positive-image mean Dice 0.295946 < 0.50 |
| Thresholds | Unchanged; lowering is prohibited |
| Candidate budget | Maximum three candidates selected using training and validation data only |
| Input | Aspect-ratio-preserving `72x192`, unless a documented downsampling-compatible equivalent is required |
| Mask handling | Preserve alignment and use nearest-neighbor mask interpolation |
| Training | Maximum 10 epochs; deterministic seeds; approved imbalance handling; validation-based early stopping with documented patience |
| Augmentation | Training-only deterministic horizontal reflection where valid, small translations, and small image-only intensity variation; never misalign images and masks |
| Threshold grid | Predefine and record before execution; select using validation only |
| Freeze | Freeze architecture, weights, preprocessing, and threshold before final evaluation |
| Official test | Exactly one additional evaluation is authorized after freeze; prior two evaluations remain disclosed, and the result is not fully blind |
| Prohibited influence | Official test data cannot affect training, augmentation, early stopping, threshold selection, or candidate selection |
| Exact allowlist | Unchanged seven-file Phase 7 implementation allowlist; `dataset_selection_proposal.md` remains a completed planning artifact and is not part of corrective implementation |
| Protected controls | Dataset partitions, official-test membership, `DetectorContract`, `DetectionResult`, acceptance thresholds, and CC BY-NC-SA 4.0 restrictions |
| Later phases | Phases 8-17 remain **NOT AUTHORIZED** |

### Phase 8 — Numerical Feature Extraction

**Project Owner authorization (2026-09-10):** **AUTHORIZED — NOT STARTED**. Implementer: Nouran Ismail — AI & Algorithm Developer. The Project Owner approved feature IDs 1–6, deterministic ascending order, catalog/extractor version 1, unit codes, exact no-detection and invalid-input behavior, `IIW-REQ-026`–`IIW-REQ-029`, and `IIW-AC-047`–`IIW-AC-053`. Operational input is the accepted Phase 6 `DetectionResult`; the Phase 7 detector remains disabled. The catalog is not predictive-maintenance-sufficient by itself. Project-specific sensor features require separately governed IDs/configuration, and anomaly area, width, height, or mask features require a separately approved interface change. Phases 9–17 remain **NOT AUTHORIZED**.

- **Approved requirement IDs:** `IIW-REQ-008`, `IIW-REQ-009`, `IIW-REQ-017`–`IIW-REQ-020`, `IIW-REQ-023`.
- **Prerequisites:** Phase 4 contract accepted and applicable Phase 5B/6 output available; feature names, units, validity rules, and extraction versions approved for each configuration.
- **Exact allowed files:** `extensions/intelligent-inspection/core/+iiw/+features/extractNumericalFeatures.m`; `extensions/intelligent-inspection/core/+iiw/+features/validateFeatureSet.m`; `tests/intelligent-inspection/test_feature_extraction.m`; `tests/intelligent-inspection/fixtures/feature_contract_fixtures.mat`; `extensions/intelligent-inspection/evidence/feature_extraction_results.md`.
- **Protected files:** Section 4, prediction implementations, and raw project data.
- **Responsible engineering role:** AI & Algorithm Developer.
- **Implementation actions:** Produce named numerical values with unit/unitless declarations, validity indicators, source references, schema version, and extractor version; reject invalid/non-finite feature sets as configured.
- **Measurable acceptance criteria:** 100% emitted values are numeric; names/values/units/validity arrays align; source references resolve; invalid sets cannot enter prediction; raw payloads are absent.
- **Tests and metrics:** `IIW-TST-FEAT-001` through `IIW-TST-FEAT-005`; schema, numeric-only, alignment, invalid-value, provenance, and repeatability checks.
- **Evidence produced:** Unit-test results, feature dictionary, sample provenance chain, diagnostics, and deterministic coverage where applicable.
- **Approval gate:** Gate 3 and Phase 4 exit hold point; project-specific extraction waits for approved configuration.
- **Rollback approach:** Remove only the listed feature code, tests, fixtures, and evidence; leave upstream source records intact.

### Phase 9 — Approved Predictive-Maintenance Split

**Amendment status:** **APPROVED — Nouran Ismail, Project Owner, 2026-09-13**. Phase 9A is complete and accepted with developer verification 16/16. Phase 9B corrective implementation is **COMPLETE**, developer verification is **PASS — 14/14**, locked performance acceptance is **PASS**, and Project Owner review is **ACCEPTED**. Independent verification remains pending and requires a different named reviewer. The model is **DEMONSTRATION ONLY — NOT PRODUCTION READY**. Phases 10–17 remain **NOT AUTHORIZED**.

#### Phase 9A — Reusable Health-Prediction Framework

- **Objective:** Provide an application-independent, replaceable predictor boundary that consumes only validated `NumericalFeatureSet` and emits the exact approved `HealthPrediction` with horizon/context, uncertainty, model identity/version, controlled invalid input, and controlled execution failure.
- **Proposed requirement IDs:** Existing `IIW-REQ-009`, `IIW-REQ-010`, `IIW-REQ-012`, `IIW-REQ-017`–`IIW-REQ-020`, `IIW-REQ-023`, `IIW-REQ-025`; proposed `IIW-REQ-030`–`IIW-REQ-034`.
- **Prerequisites:** This amendment and `IIW-AC-054`–`IIW-AC-057` are approved; Phase 8 is accepted; Nouran Ismail is assigned as AI & Algorithm Developer; applicable product availability and approval shall be reconfirmed before execution.
- **Approved exact allowlist:** `extensions/intelligent-inspection/core/+iiw/+prediction/PredictorContract.m`; `extensions/intelligent-inspection/core/+iiw/+prediction/predictHealth.m`; `extensions/intelligent-inspection/core/+iiw/+prediction/validateHealthPrediction.m`; `tests/intelligent-inspection/test_health_prediction_framework.m`; `tests/intelligent-inspection/fixtures/health_prediction_contract_fixtures.mat`; `extensions/intelligent-inspection/evidence/health_prediction_framework_results.md`.
- **Protected:** Completed Phase 8 artifacts; all detector, preprocessing, architecture, dictionary, UAV supervisor, and raw-payload artifacts.
- **Role:** AI & Algorithm Developer; independent verification later requires a different named person.
- **Tests:** Schema, valid prediction, invalid/nonfinite/version-mismatch feature set, replaceability, model-load failure, execution failure, invalid model output, uncertainty boundary, out-of-distribution status, deterministic repetition, prohibited terminology, and protected-artifact checks.
- **Evidence:** Test counts, contract inventory, failure behavior, model-interface/version rules, uncertainty/status rules, hashes, limitations, and protected-artifact confirmation.
- **Completion and review:** **IMPLEMENTATION COMPLETE; DEVELOPER VERIFICATION PASS — 16/16; PROJECT OWNER REVIEW ACCEPTED** by Nouran Ismail — Project Owner on 2026-09-13. Independent verification is **PENDING** and shall use a different named reviewer. The six Phase 9A artifacts are frozen pending that review.
- **Rollback:** Remove only the six Phase 9A artifacts and restore the component to its unimplemented structural state.

#### Phase 9B — UAV Pipeline Predictive-Maintenance Demonstration

- **Objective:** Implement a small UAV-pipeline predictive-maintenance demonstration by mapping governed CV, sensor, and inspection-history information into `NumericalFeatureSet`, generating a governed synthetic dataset, and training one regularized linear-regression model for a synthetic 30-day health score through the unchanged Phase 9A interface.
- **Required limitation:** Every synthetic dataset, model-card, and results artifact shall state exactly: **“Integration and workflow demonstration only; not evidence of real pipeline prognostic accuracy or production readiness.”**
- **Proposed requirement IDs:** Existing `IIW-REQ-010`–`IIW-REQ-012`, `IIW-REQ-017`–`IIW-REQ-020`, `IIW-REQ-023`, `IIW-REQ-025`; proposed `IIW-REQ-034`–`IIW-REQ-037`.
- **Prerequisites:** Phase 9A is complete and accepted; the catalog, unit-code mapping, frozen generator/target/noise definition, horizon, dataset governance, split/leakage controls, fixed model configuration, metrics, locked thresholds, residual-uncertainty method, Statistics and Machine Learning Toolbox, Predictive Maintenance Toolbox, and implementer are approved. Generator equations and noise distributions must be frozen and versioned before generation.
- **Proposed exact allowlist:** `extensions/intelligent-inspection/configurations/uav-pipeline/PipelineFeatureAdapter.m`; `extensions/intelligent-inspection/configurations/uav-pipeline/pipeline_feature_catalog.yaml`; `extensions/intelligent-inspection/training/generate_pipeline_degradation_dataset.m`; `extensions/intelligent-inspection/datasets/pipeline_degradation_dataset_manifest.yaml`; `extensions/intelligent-inspection/datasets/generated/pipeline_degradation_synthetic.mat`; `extensions/intelligent-inspection/training/train_pipeline_health_regression.m`; `extensions/intelligent-inspection/models/pipeline_health_regression.mat`; `extensions/intelligent-inspection/model_cards/pipeline_health_regression.md`; `tests/intelligent-inspection/test_pipeline_health_prediction.m`; `extensions/intelligent-inspection/evidence/pipeline_health_prediction_results.md`.
- **Feature catalog:** Preserve IDs 101–115 from `architecture/interface_contracts.md` in ascending deterministic order. The active model inputs are IDs 101–103 and 106–115: detection presence, detection confidence, location availability, surface temperature, ambient temperature, temperature difference, gas concentration, internal pressure, pressure-change rate, inspection age, prior finding count, prior health score, and time since maintenance. IDs 104–105 remain catalogued but are excluded from the regression predictor matrix; coordinates are context, not causal degradation measurements. Invalid entries are zero and invalid; there is no raw-image predictor input or inferred anomaly geometry.
- **Synthetic-generation assumptions:** Generator version 1 and seed `20260910`; exactly 100 synthetic pipeline-section groups with six chronological observations at days `[0,30,60,90,120,150]` (600 rows). This approval freezes the version-1 latent-burden, finding, sensor, history, maintenance, target, and noise equations below, including every formula, coefficient, distribution, clipping rule, missing-data rule, and noise parameter. The dataset manifest shall record every value before generation, and the generator shall not be tuned after test results are viewed. Controlled missing and out-of-distribution records are generated in a separately labelled verification slice and excluded from fitting. These distributions are synthetic assumptions, not measured asset behavior.
- **Target:** Horizon is 30 days through context ID `9001`. Define normalized factors `f1=presence*confidence`, `f2=clip(max(temperatureDifference,0)/100,0,1)`, `f3=clip(gasConcentration/100000,0,1)`, `f4=clip(abs(internalPressure-5000)/5000,0,1)`, `f5=clip(abs(pressureChangeRate)/1000,0,1)`, `f6=clip(inspectionAge/3650,0,1)`, `f7=clip(priorFindingCount/20,0,1)`, `f8=clip((100-priorHealthScore)/100,0,1)`, and `f9=clip(timeSinceMaintenance/3650,0,1)`. Then `B=0.20*f1+0.12*f2+0.12*f3+0.12*f4+0.10*f5+0.06*f6+0.08*f7+0.12*f8+0.08*f9`, and `healthScore30Day=clip(100*(1-B)-30*(0.02+0.18*B)+epsilon,0,100)`, with seeded `epsilon=clip(N(0,1),-2,2)`. This approval freezes these equations, distributions, constants, weights, clipping, and seed as generator version 1. `priorHealthScore` may be used only when genuinely available at inference time and shall never contain the future target. Every emitted valid health value is explicitly bounded to `[0,100]`.
- **Split/leakage control:** Allocate all 100 groups before generating or fitting any data-dependent transformation. Use deterministic group-safe 70% train / 15% validation / 15% test allocation by stable SHA-256 ordering of synthetic group ID plus seed/configuration. All six observations for one group remain in exactly one partition, yielding 70/15/15 groups and 420/90/90 observations. Test shall not influence feature selection, model selection, model configuration, thresholds, preprocessing decisions, or uncertainty and remains untouched until generator, transformations, model, and uncertainty policy are frozen.
- **Model and predictor preprocessing:** Report a median-target baseline only as a reference. Train exactly one ridge linear-regression model with fixed `Lambda=0.1`. Standardize predictor columns using training-partition mean and standard deviation only; replace zero standard deviation with `1`; store these values in the model artifact and apply them unchanged to validation, test, and future inputs. Validation or test statistics shall never define standardization. Model comparison, ensembles, hyperparameter search, Regression Learner, and test-guided adjustment are prohibited.
- **Uncertainty:** Store `validationRMSE` in the model artifact and use deterministic residual-based uncertainty `min(validationRMSE/100,1)` for in-distribution predictions. Test data shall not calculate or tune uncertainty. This is not conformal or complex calibrated uncertainty. Invalid or out-of-distribution input abstains with controlled invalid/review status.
- **Locked criteria:** Synthetic test MAE `<=8.0`; RMSE `<=12.0`; R-squared `>=0.65`; zero schema violations; zero uncontrolled failures. Report MAE, RMSE, and R-squared separately for training, validation, and the frozen model on test, plus the deterministic residual-based uncertainty. Thresholds shall not change after test inspection.
- **Human-review limitation:** Predictions remain advisory evidence for later risk/approval phases; low confidence, unsupported features, invalid/OOD input, or excessive uncertainty requires controlled review/abstention and cannot cause an operational or safety command. Location coordinates are contextual only and shall not be treated as causal degradation measurements.
- **Hold point:** Version-1 implementation failed 10/14. Generator version 1.1 corrective execution completed and passed 14/14 with all locked performance criteria satisfied. **PROJECT OWNER REVIEW ACCEPTED** by Nouran Ismail — Project Owner on 2026-09-13. Independent verification remains pending; the exact disclaimer remains required and Phases 10–17 remain unauthorized.
- **Remaining review assignment:** A different named independent verifier remains to be assigned before independent verification. This statement does not authorize the proposed corrective implementation.
- **Rollback:** Remove only Phase 9B allowlisted artifacts, retain immutable failed evidence if execution occurred, and restore Phase 6/8 plus accepted Phase 9A as the prior state.

##### Approved Phase 9B Corrective Repair Control

| Control | Approved value |
|---|---|
| Status | **COMPLETE — CORRECTIVE DEVELOPER VERIFICATION PASS 14/14 — PERFORMANCE PASS — PROJECT OWNER ACCEPTED** |
| Approver / date | Nouran Ismail — Project Owner; 2026-09-13 |
| Root cause | Synthetic generator version 1 may emit `locationAvailable=true` while `detectionPresent=false`, violating the approved invariant. |
| Exact correction | Generator version 1.1 computes `locationAvailable = detectionPresent && locationAvailableCandidate;`. |
| Corrective execution | **COMPLETE** |
| Project Owner review | **ACCEPTED** by Nouran Ismail — Project Owner on 2026-09-13 |
| Independent verification | **PENDING — different named reviewer required** |
| Additional permitted test exposure | **0**; the one authorized corrective exposure was consumed and both total exposures are disclosed |
| Exact corrective allowlist | The same ten paths listed in Phase 9B; no additional file is permitted. |
| Required execution after approval | Freeze version 1.1, regenerate the 600-row dataset, retrain the fixed ridge model, freeze the resulting candidate, then perform exactly one additional final test-partition evaluation. |
| Preserved dataset controls | Seed `20260910`; 100 groups; six chronological observations each; 70/15/15 group-safe split; no cross-partition group. |
| Preserved model controls | Ridge linear regression; `Lambda=0.1`; training-only standardization; zero standard deviation replaced by `1`; `uncertainty=min(validationRMSE/100,1)`. |
| Preserved acceptance controls | MAE `<=8.0`; RMSE `<=12.0`; R-squared `>=0.65`; zero interface violations; zero uncontrolled failures. |
| Evidence preservation | Retain the original test exposure, 10/14 result, interface failure, metrics, hashes, and mandatory disclaimer. |
| Prohibited influence | Previous test metrics shall not be used for tuning; contracts and tests shall not be weakened, removed, bypassed, or suppressed. |
| Protected scope | Phase 9A and all verified UAV artifacts remain unchanged; Phases 10–17 remain **NOT AUTHORIZED**. |

### Phase 10 — Risk Assessment

**Authorization decision (2026-09-13):** **AUTHORIZED — NOT STARTED.** Nouran Ismail — Project Owner approved risk policy version 1 and resolved the prior policy blockers. Nouran Ismail — AI & Algorithm Developer is the implementer; Nouran Ismail — Project Owner / Lead Systems Engineer is policy owner/reviewer; Yahya Helmy — Independent Verification & Validation Engineer remains assigned with independent verification **PENDING**.

**Completion decision (2026-09-14):** **COMPLETE, VERIFIED AND ACCEPTED.** Developer verification passed 10/10 with 100% decision-table conformance and 40/40 decision coverage. Yahya Helmy — Independent Verification & Validation Engineer reviewed the existing evidence without rerunning MATLAB, accepted the two residual condition outcomes as structurally infeasible, and recorded **PASS**. Nouran Ismail — Project Owner recorded final acceptance as **APPROVED**. Phase 11 and Phases 12–17 remain **NOT AUTHORIZED**.

- **Approved requirement IDs:** `IIW-REQ-011`, `IIW-REQ-012`, `IIW-REQ-014`–`IIW-REQ-018`, `IIW-REQ-020`, `IIW-REQ-023`.
- **Prerequisites:** **SATISFIED for start.** Required upstream contracts are accepted; risk scale, evidence sufficiency, thresholds and inclusive boundaries, rationale codes, exact priority, conservative fallback, safety boundary, implementer, and policy reviewer were approved on 2026-09-13.
- **Exact allowed files:** `extensions/intelligent-inspection/core/+iiw/+risk/assessRisk.m`; `extensions/intelligent-inspection/core/+iiw/+risk/validateRiskPolicy.m`; `extensions/intelligent-inspection/config/risk_policy_schema.yaml`; `tests/intelligent-inspection/test_risk_assessment.m`; `extensions/intelligent-inspection/evidence/risk_assessment_results.md`.
- **Protected files:** Section 4 and project policy values outside separately approved configuration phases.
- **Responsible engineering role:** Nouran Ismail — AI & Algorithm Developer; policy owner/reviewer Nouran Ismail — Project Owner / Lead Systems Engineer; independent verifier Yahya Helmy — Independent Verification & Validation Engineer, decision pending.
- **Implementation actions:** Implement deterministic evidence validation and versioned policy interpretation; emit risk level/score/rationale/evidence references; force review or reacquisition when mandatory evidence is missing or uncertainty limits fail.
- **Measurable acceptance criteria:** `IIW-AC-066` through `IIW-AC-072`; every output identifies inputs and policy version; boundary and priority behavior is deterministic; rejected/low-confidence cases produce no autonomous action; no direct safety command exists.
- **Tests and metrics:** `IIW-TST-RISK-001` through `IIW-TST-RISK-007`; nominal, missing evidence, rejected quality, low confidence, excessive uncertainty, boundary, and repeatability cases; 100% approved decision-table conformance and structural decision/condition coverage or justified infeasible objectives.
- **Evidence produced:** Decision table, test results, coverage review, rationale-code matrix, and policy hash.
- **Approval gate:** Phase 10 implementation is authorized but must stop after developer evidence for Project Owner review and later independent verification. Phases 11–17 remain **NOT AUTHORIZED**.
- **Rollback approach:** Remove only the listed risk implementation/schema/tests/evidence and restore the prior selected policy version.

### Phase 11 — HumanApprovalGate

**Authorization decision (2026-09-14):** **AUTHORIZED AND READY TO EXECUTE — NOT STARTED.** Nouran Ismail — Project Owner approved policy version 1 and resolved the Phase 11 approval-state, role, identity, timing, rejection, deferral, expiration, delegation, escalation, audit, rationale-code, conservative-fallback, and external-safety-bypass prerequisites. Nouran Ismail — AI & Algorithm Developer is implementer; Nouran Ismail — Project Owner / Lead Systems Engineer is policy owner and safety reviewer; Yahya Helmy — Independent Verification & Validation Engineer remains assigned with decision **PENDING**.

**Completion decision (2026-09-15):** **COMPLETE, VERIFIED AND ACCEPTED.** Developer verification passed 16/16 and approval-state decision-table conformance was 100%. Yahya Helmy — Independent Verification & Validation Engineer reviewed the saved evidence without independently rerunning MATLAB and recorded **PASS WITH ACCEPTED COVERAGE DEVIATION**. Residual coverage was not claimed structurally infeasible. Nouran Ismail — Project Owner recorded final acceptance as **APPROVED**. Phases 12–17 remain **NOT AUTHORIZED**.

- **Approved requirement IDs:** `IIW-REQ-012`–`IIW-REQ-018`, `IIW-REQ-020`, `IIW-REQ-023`.
- **Prerequisites:** **SATISFIED for start; previous implementation blocker RESOLVED.** Phase 10 is accepted, and all listed policy decisions plus the scalar `uint16` rationale table and fixed 18-field implementation-local audit schema were explicitly approved on 2026-09-14. External authentication infrastructure is excluded; implementation validates supplied identity and role evidence only.
- **Exact allowed files:** `extensions/intelligent-inspection/core/+iiw/+approval/evaluateApproval.m`; `extensions/intelligent-inspection/models/human_approval_gate.slx`; `extensions/intelligent-inspection/config/approval_policy_schema.yaml`; `tests/intelligent-inspection/test_human_approval_gate.m`; `extensions/intelligent-inspection/evidence/human_approval_gate_results.md`.
- **Protected files:** Section 4, especially the verified `MissionSupervisor`; no connector to a safety-critical command is allowed.
- **Responsible engineering role:** Nouran Ismail — AI & Algorithm Developer; policy owner/safety reviewer Nouran Ismail — Project Owner / Lead Systems Engineer; independent verifier Yahya Helmy — Independent Verification & Validation Engineer, decision pending.
- **Implementation actions:** Implement deterministic missing, pending, deferred, rejected, expired, and approved states; validate accountable identity and validity interval; prevent forwarding except for approved/unexpired recommendations; provide an independent external-safety bypass path.
- **Measurable acceptance criteria:** `IIW-AC-073` through `IIW-AC-082`; 100% approval-state table conformance; unauthorized states forward zero recommendations; external safety response is never blocked or delayed; audit fields are complete; no direct safety-command endpoint exists.
- **Tests and metrics:** `IIW-TST-APR-001` through `IIW-TST-APR-010`; all states, timeout boundaries, invalid identity, delegation, escalation, stale decision, deterministic repetition, and external-safety priority; decision/condition coverage target 100% or reviewed structural infeasibility.
- **Evidence produced:** Approved policy record, state/decision table, compile/update result, tests, coverage, audit samples, and safety-priority analysis.
- **Approval gate:** Phase 11 implementation is authorized within the exact five-file allowlist and must stop after developer evidence for Project Owner and independent review. Phases 12–17 remain **NOT AUTHORIZED**.
- **Rollback approach:** Remove only the listed approval implementation/model/schema/tests/evidence and restore the prior architecture component to unimplemented status; do not touch the external safety subsystem.

### Phase 12 — Evidence Recording

**Final disposition (2026-09-16):** **COMPLETE, VERIFIED AND ACCEPTED.** Developer verification passed 20/20. Yahya Helmy — Independent Verification & Validation Engineer — reviewed the saved implementation, diagnostic, test, and coverage evidence without independently rerunning MATLAB and recorded **PASS**. Nouran Ismail — Project Owner — recorded final acceptance as **APPROVED**. Function coverage was 17/17 (100%) and statement coverage was 146/162 (90.12%); unavailable decision/condition metrics remain recorded as a tool limitation and are not represented as 100%. Phases 13–17 remain **NOT AUTHORIZED**.

- **Approved requirement IDs:** `IIW-REQ-006`, `IIW-REQ-010`, `IIW-REQ-011`, `IIW-REQ-016`–`IIW-REQ-018`, `IIW-REQ-023`, `IIW-REQ-025`.
- **Prerequisites:** **SATISFIED for start.** The evidence-store boundary, immutable identifier, chain, integrity, access, retention, failure, privacy, and safety policies were approved on 2026-09-15; contracts from Phase 4 are accepted.
- **Exact allowed files:** `extensions/intelligent-inspection/core/+iiw/+evidence/recordEvidence.m`; `extensions/intelligent-inspection/core/+iiw/+evidence/validateEvidenceChain.m`; `extensions/intelligent-inspection/config/evidence_policy_schema.yaml`; `tests/intelligent-inspection/test_evidence_recording.m`; `extensions/intelligent-inspection/evidence/evidence_recorder_results.md`.
- **Protected files:** Section 4 and external evidence stores not explicitly approved.
- **Responsible engineering role:** Nouran Ismail — Integration & Tooling Lead, with AI & Algorithm Developer responsibility; independent verifier Yahya Helmy, decision **PASS** on 2026-09-16.
- **Implementation actions:** Record stage IDs, artifacts, data/model/configuration/software versions, actor/component, timestamp, outcome, and integrity metadata; expose chain validation; record persistence failure without fabricating success.
- **Measurable acceptance criteria:** Every applicable transaction resolves a complete chain; orphan references equal zero; injected persistence failures create explicit failures and zero synthetic success records.
- **Tests and metrics:** `IIW-TST-EVD-001` through `IIW-TST-EVD-006`; chain completeness, orphan, immutability, version, failure, and retention-policy tests; 100% mandatory identifiers present.
- **Evidence produced:** Schema-validation results, sampled chains, failure logs, integrity observations, and traceability inventory.
- **Approval gate:** Phase 12 is **COMPLETE, VERIFIED AND ACCEPTED**. The saved evidence preserves the initial 16/20 result, both diagnosed defects and repairs, and the final 20/20 result. Phases 13–17 remain **NOT AUTHORIZED**.
- **Rollback approach:** Disable and remove only the listed recorder code/schema/tests/report; preserve already generated audit evidence according to retention rules.

### Phase 13 — UAV Pipeline Configuration

**Authorization decision (2026-09-16):** **AUTHORIZED — NOT STARTED.** Nouran Ismail — Project Owner and Lead Systems Engineer — approves the clarified smallest demonstration, its taxonomy, PASS-only quality gate, inclusive `0.50` detection-confidence threshold, advisory mapping, exact six-file allowlist, and Phase 13-scoped use of MATLAB R2026a, Simulink, UAV Toolbox, Simulink 3D Animation, and Computer Vision Toolbox. The installed pregenerated MathWorks example “Simulate Simple Flight Scenario and Sensor in Unreal Engine Environment” is the sole approved simulated camera/context source; only its RGB camera output and simulation context metadata may be consumed, and the example shall not be modified. The purpose is integration/workflow demonstration, not real-world performance. The reusable core and protected UAV/MissionSupervisor artifacts remain frozen. Direct integration and Phases 14–17 remain **NOT AUTHORIZED**.

- **Approved requirement IDs:** `IIW-REQ-001`–`IIW-REQ-003`, `IIW-REQ-007`–`IIW-REQ-021`, `IIW-REQ-023`, `IIW-REQ-024`.
- **Prerequisites:** **SATISFIED for start.** Required reusable phases are accepted; MATLAB R2026a, Simulink, UAV Toolbox, Simulink 3D Animation, and Computer Vision Toolbox are installed, licensed, and approved for Phase 13; the installed pregenerated example source, project metadata, taxonomy, quality/confidence gates, advisory mapping, approver boundary, tests, and acceptance criteria are approved. Before editing, confirm the correct branch, a clean working tree, unchanged protected hashes, product/license availability, and that the example is available without copying or modification. Any MissionSupervisor interface proposal requires a separate ECR.
- **Exact allowed files:** `extensions/intelligent-inspection/configurations/uav-pipeline/configuration.yaml`; `extensions/intelligent-inspection/configurations/uav-pipeline/source_adapter.m`; `extensions/intelligent-inspection/configurations/uav-pipeline/recommendation_adapter.m`; `extensions/intelligent-inspection/configurations/uav-pipeline/dataset_manifest.yaml`; `tests/intelligent-inspection/test_uav_pipeline_configuration.m`; `extensions/intelligent-inspection/evidence/uav_pipeline_configuration_results.md`.
- **Protected files:** Section 4 and every existing UAV supervisor interface/model/test/evidence artifact.
- **Responsible engineering role:** Nouran Ismail — AI & Algorithm Developer, with Nouran Ismail — Lead Systems Engineer interface review; independent verifier Yahya Helmy — Independent Verification & Validation Engineer.
- **Source and purpose:** Accept only simulated MathWorks UAV 3D camera image output. `source_adapter.m` maps each frame to the unchanged `InspectionData`/`InspectionMetadata` contracts. No real camera, flight controller, vehicle bus, MissionSupervisor signal, or production-performance claim is in scope. Required disclaimer: “Integration and workflow demonstration only; not evidence of real-world inspection, anomaly-detection, pipeline-condition, flight, or production readiness.”
- **Required project metadata:** nonzero `assetId`, `pipelineSectionId`, `inspectionPlanId`, `simulationRunId`, `sceneConfigurationId`, `cameraId`, `cameraCalibrationRef`, and `sequenceId` (`uint32`); nonzero `coordinateFrameId` (`uint16`); UTC Unix-epoch-millisecond `captureTimestamp` (`uint64`); positive `imageWidth`/`imageHeight` (`uint16`); `channelCount` (`uint8`, 1 or 3); finite platform position `double [3 1]` metres and unit quaternion `double [4 1]`; plus metadata/configuration version IDs. Human-readable names remain configuration/evidence-only. The adapter emits numeric `payloadRef`, `sourceId`, and `acquisitionContext` references rather than raw project strings.
- **Minimal taxonomy:** `0=UNASSIGNED_OR_NO_DETECTION`, `1=SURFACE_ANOMALY_INDICATION`, `255=INVALID`. It is a demonstration localization category only and shall not claim crack, corrosion, leak, severity, or physical-dimension classification.
- **Quality and confidence gates:** Execute downstream processing only for exact `DataQualityResult.status=1 (PASS)`. Bind the accepted deterministic image measures using inclusive single-precision thresholds: brightness `[0.20,0.80]`, contrast `>=0.10`, sharpness `>=0.03`, saturation fraction `<=0.25`, saturation level `0.95`; nonfinite/malformed data and `REVIEW`/`REJECT` remain blocked. Conventional `DetectionResult` must have supported schema, valid confidence in `[0,1]`, and `confidence >=0.50` inclusive to enter project recommendation mapping; lower, unavailable, invalid, or nonfinite confidence produces review/reacquisition advice only and no mission request.
- **Advisory recommendation mapping:** `0=NO_RECOMMENDATION`; `1=REVIEW_INSPECTION_EVIDENCE`; `2=SCHEDULE_FOLLOW_UP_INSPECTION`; `3=REQUEST_MAINTENANCE_ASSESSMENT`; `4=REQUEST_DATA_REACQUISITION`. `REVIEW_REQUIRED` or unavailable evidence maps to 1; acceptable low risk maps to 0; medium risk maps to 2; high risk maps to 3; failed quality maps to 4. Codes 1–4 are advisory proposals, require the existing external HumanApprovalGate decision before forwarding, and terminate at an unconnected advisory mission-request boundary. They are not flight, mission, approval, ReturnToHome, SafeLanding, or safety commands.
- **Implementation actions:** Bind camera/context metadata, the single project anomaly label, existing quality/detection/risk/approval policies, and the advisory mapping to unchanged generic contracts. The adapter must not alter reusable-core files and must not connect to or modify MissionSupervisor.
- **Measurable acceptance criteria:** All six allowlisted artifacts only; configuration/schema validation passes; 100% required metadata fields are type/range-valid; source mappings conform exactly; taxonomy contains exactly codes 0, 1, and 255; each quality/confidence boundary and invalid case yields the specified gate; every mapping row is deterministic; only currently approved/unexpired recommendations are eligible at the advisory boundary; zero direct command endpoints; protected core/UAV artifact hashes unchanged; no real-world performance claim.
- **Tests and metrics:** `IIW-TST-UAV-001` source-contract and simulated-frame mapping; `002` required metadata/type/range/context mapping; `003` exact taxonomy and prohibited-class check; `004` PASS/REVIEW/REJECT plus blocked/dark/bright/low-contrast/blurred/overexposed interpretation; `005` confidence `0.50` inclusive and below/invalid/unavailable cases plus configured feature units; `006` complete deterministic recommendation-table and approval requirement; `007` zero flight/mission/approval/safety-command endpoints and no MissionSupervisor connection; `008` six-file scope, frozen-core/protected-UAV hashes, disclaimer, and deterministic repetition. Project performance metrics are not authorized by this demonstration plan.
- **Evidence produced:** Configuration validation, contract mapping, advisory-boundary analysis, test results, project metric evidence if authorized, and protected hashes.
- **Approval gate:** **SATISFIED FOR THE EXACT SIX-FILE PHASE 13 ALLOWLIST — AUTHORIZED, NOT STARTED.** Stop after developer evidence for Project Owner and independent review. Any example modification, additional file, reusable-core/protected-artifact change, direct command endpoint, or supervisor interface need is a stop condition and requires separate authorization/ECR. Phases 14–17 remain **NOT AUTHORIZED**.
- **Rollback approach:** Remove only the listed UAV-configuration files and evidence; no rollback action may touch the verified supervisor.

### Phase 14 — Fixed-Camera Reuse Demonstration

- **Approved requirement IDs:** `IIW-REQ-001`–`IIW-REQ-005`, `IIW-REQ-007`–`IIW-REQ-013`, `IIW-REQ-016`–`IIW-REQ-021`, `IIW-REQ-023`, `IIW-REQ-024`.
- **Prerequisites:** Required reusable phases accepted; fixed-camera data, licensing, station/part metadata, taxonomy, thresholds, risk/action policy, and approvers approved independently of the UAV configuration.
- **Exact allowed files:** `extensions/intelligent-inspection/configurations/fixed-camera/configuration.yaml`; `extensions/intelligent-inspection/configurations/fixed-camera/source_adapter.m`; `extensions/intelligent-inspection/configurations/fixed-camera/recommendation_adapter.m`; `extensions/intelligent-inspection/configurations/fixed-camera/dataset_manifest.yaml`; `tests/intelligent-inspection/test_fixed_camera_configuration.m`; `extensions/intelligent-inspection/evidence/fixed_camera_configuration_results.md`.
- **Protected files:** Section 4, all reusable-core files, and all Phase 13 configuration files.
- **Responsible engineering role:** AI & Algorithm Developer; reuse assessment later performed independently in Phase 15.
- **Implementation actions:** Bind the second application exclusively through generic contracts and configuration; do not alter reusable core to accommodate project semantics.
- **Measurable acceptance criteria:** Configuration validates and executes approved contract cases; core hashes remain identical to their pre-configuration values; application differences are confined to listed files; approval and low-quality behavior remain conformant.
- **Tests and metrics:** `IIW-TST-FIX-001` through `IIW-TST-FIX-007`; adapter, taxonomy, quality, feature, recommendation, approval, and hash-isolation tests; project metrics only under approved dataset thresholds.
- **Evidence produced:** Configuration report, contract results, project evidence if authorized, and before/after core hashes.
- **Approval gate:** Gate 3 plus second-project dataset/configuration approval; core modification request is a stop and scope-expansion condition.
- **Rollback approach:** Remove only the listed fixed-camera configuration, tests, manifest, and evidence; preserve the reusable core and UAV configuration.

### Phase 15 — Reusability Evaluation

- **Approved requirement IDs:** `IIW-REQ-005`, `IIW-REQ-019`–`IIW-REQ-024`.
- **Prerequisites:** Phases 13 and 14 completed with accepted developer evidence; reusable core frozen and hashed.
- **Exact allowed files:** `extensions/intelligent-inspection/evidence/reusability_evaluation.md`; `extensions/intelligent-inspection/evidence/reusable_core_hashes.txt`; `tests/intelligent-inspection/test_reusability.m`.
- **Protected files:** Section 4 and all implementation/configuration artifacts; this phase is evaluation-only.
- **Responsible engineering role:** Lead Systems Engineer / MBD Architect for developer assessment; later independent review by the assigned verifier.
- **Implementation actions:** Compare configurations, adapter bindings, contracts, detector substitution, and reusable-core hashes; document deviations and whether application semantics leaked into the core.
- **Measurable acceptance criteria:** At least two configurations use identical core hashes; zero core modifications are attributable to project semantics; all interface mandatory fields/directions match; detector replacement requires zero consumer-interface changes.
- **Tests and metrics:** `IIW-TST-REUSE-001` through `IIW-TST-REUSE-004`; core-hash equality, cross-configuration contract conformance, terminology separation, and detector substitution; acceptance against `IIW-AC-011`–`IIW-AC-013`.
- **Evidence produced:** Reuse report, hash inventory, cross-project diff, conformance matrix, and deviations.
- **Approval gate:** Gate 3 phase hold point. Phase 16 is blocked until this evaluation passes and findings are dispositioned.
- **Rollback approach:** Remove only the evaluation test/report/hash inventory; evaluation findings remain recorded if retention policy requires them.

### Phase 16 — Future 3D UAV Adapter

- **Approved requirement IDs:** `IIW-REQ-001`, `IIW-REQ-017`, `IIW-REQ-019`–`IIW-REQ-024`, `IIW-REQ-025`.
- **Prerequisites:** Phase 15 reuse acceptance; source contract frozen; any new 3D/simulation product separately approved and verified available. This phase implements only a replaceable source adapter unless a separate ECR authorizes a simulation environment.
- **Exact allowed files:** `extensions/intelligent-inspection/adapters/uav-3d/adapter_configuration.yaml`; `extensions/intelligent-inspection/adapters/uav-3d/virtual_source_adapter.m`; `extensions/intelligent-inspection/adapters/uav-3d/scenario_metadata_schema.yaml`; `tests/intelligent-inspection/test_3d_source_adapter.m`; `extensions/intelligent-inspection/evidence/3d_adapter_scalability_results.md`.
- **Protected files:** Section 4, reusable AI components, real-source adapter, and any 3D environment or scenario model not separately approved.
- **Responsible engineering role:** Lead Systems Engineer / MBD Architect for interface design and AI & Algorithm Developer for the adapter.
- **Implementation actions:** Translate virtual frames, pose, environmental context, scenario ID, and source version into the unchanged generic source contracts; keep all detection, prediction, risk, and approval behavior outside the environment.
- **Measurable acceptance criteria:** Simulated and real adapters expose identical mandatory fields/directions/semantics; switching adapters changes no downstream interface; provenance distinguishes source/adapter/scenario versions; no AI implementation exists inside the environment boundary.
- **Tests and metrics:** `IIW-TST-3D-001` through `IIW-TST-3D-005`; contract equality, adapter substitution, metadata, provenance, and architecture-boundary checks; acceptance against `IIW-AC-016`–`IIW-AC-019`.
- **Evidence produced:** Adapter contract comparison, substitution results, boundary inspection, source-version chain, and scalability report.
- **Approval gate:** Gate 3 plus passed Phase 15 and separate dependency/scope approval for any new simulation product or environment artifact.
- **Rollback approach:** Remove only the listed adapter/configuration/test/evidence files; do not modify the real-source adapter, core, or external environment.

### Phase 17 — Integration and Independent Verification

- **Approved requirement IDs:** `IIW-REQ-001`–`IIW-REQ-025`.
- **Prerequisites:** All selected phases complete; deferred optional phases explicitly marked not applicable with rationale; named implementers recorded; different named Independent Verification & Validation Engineer assigned; candidate frozen and hashed; test and evidence retention policies approved.
- **Exact allowed files:** `extensions/intelligent-inspection/integration/intelligent_inspection_integration.slx`; `tests/intelligent-inspection/intelligent_inspection_tests.mldatx`; `tests/intelligent-inspection/intelligent_inspection_test_plan.md`; `requirements/intelligent_inspection_traceability.slmx`; `reports/intelligent_inspection_change_report.md`; `reports/intelligent_inspection_verification_report.md`; `reports/intelligent_inspection_independent_review.md`; `extensions/intelligent-inspection/evidence/frozen_candidate_hashes.txt`.
- **Protected files:** Section 4. Existing `TST-001` through `TST-019` may be executed after Gate 3 only as a protected regression suite; their definitions, expectations, model, harness, and evidence shall not be modified.
- **Responsible engineering role:** AI & Algorithm Developer for integration/developer evidence; Independent Verification & Validation Engineer for read-only Gate 5 review; Project Owner for Gate 6.
- **Implementation actions:** Integrate selected generic components and configurations without modifying the protected supervisor; establish requirement-to-element-to-test/result links; execute approved regression, robustness, safety-priority, traceability, and coverage activities; freeze/hash the candidate; hand off for independent review. If UAV integration would require a new supervisor interface, omit that connection and stop for a separate ECR.
- **Measurable acceptance criteria:** All in-scope requirements have implementation/test/result evidence and zero broken mandatory links; selected tests pass with no suppressed failures; approval-state and external-safety priority behavior conform; reusable-core hashes remain stable across configurations; candidate hash is frozen before review; independent reviewer records exactly one permitted Gate 5 decision.
- **Tests and metrics:** All planned `IIW-TST-*` suites; architecture/interface checks; failure/robustness cases; approved performance and calibration/regression metrics; deterministic decision/condition coverage targets or reviewed infeasible objectives; reusability and 3D criteria when selected. Run protected `TST-001` through `TST-019` only after confirming the supervisor hashes match the verified baseline, expecting the preserved 19-test regression result without changing its evidence.
- **Evidence produced:** Test plan/results, traceability report, coverage/performance reports as applicable, protected-hash comparison, change report, frozen-candidate hashes, independent-review record, findings, and residual-risk disposition.
- **Approval gate:** Stop at Gate 4 after developer evidence. Gate 5 requires the different named verifier. Gate 6 requires Project Owner final acceptance; no baseline or release claim occurs earlier.
- **Rollback approach:** Remove only the new integration/test/traceability/report artifacts or restore them to the prior phase-approved versions; corrective implementation invalidates the frozen review and requires full affected regression and renewed Gate 5 review.

## 6. Requirement-to-Phase Mapping

| Requirement | Primary implementation phase(s) | Verification focus |
|---|---|---|
| IIW-REQ-001 | 3, 4, 13, 14, 16 | Source contract and adapter substitution |
| IIW-REQ-002 | 3, 4, 5A | One explicit quality result per item |
| IIW-REQ-003 | 5A, 13, 14 | Rejected quality blocks autonomous action |
| IIW-REQ-004 | 4, 5B | Quality-gated processing provenance and immutable source |
| IIW-REQ-005 | 3, 4, 6, 7, 15 | Replaceable detector with unchanged consumers |
| IIW-REQ-006 | 4, 6, 7 | Learned-model identity/version/confidence semantics |
| IIW-REQ-007 | 4, 6, 7, 13, 14 | Detection schema validity |
| IIW-REQ-008 | 3, 4, 8 | Numeric feature contract completeness |
| IIW-REQ-009 | 4, 8, 9 | Prediction accepts no raw payload |
| IIW-REQ-010 | 4, 9 | Prediction provenance and uncertainty |
| IIW-REQ-011 | 3, 4, 9, 10 | Versioned evidence-to-risk assessment |
| IIW-REQ-012 | 4, 7, 9, 10, 11 | Low confidence/uncertainty blocks action |
| IIW-REQ-013 | 3, 4, 11 | Approval required before forwarding |
| IIW-REQ-014 | 3, 10, 11, 13 | No direct safety-critical command |
| IIW-REQ-015 | 3, 10, 11, 13 | External safety response preempts approval waiting |
| IIW-REQ-016 | 3, 4, 10, 11 | Complete bounded recommendation record |
| IIW-REQ-017 | 3–14, 16 | End-to-end evidence identifiers and versions |
| IIW-REQ-018 | 3, 5A, 5B, 6–12 | Explicit failures; no fabricated success evidence |
| IIW-REQ-019 | 2, 3, 6–16 | Application-neutral reusable core |
| IIW-REQ-020 | 2, 3–14 | Project semantics supplied by configuration |
| IIW-REQ-021 | 3, 4, 13, 14, 16 | Same real/simulated source contract |
| IIW-REQ-022 | 3, 4, 15, 16 | AI remains outside simulation environment |
| IIW-REQ-023 | 2–17 | Requirement-to-element-to-test/result traceability |
| IIW-REQ-024 | 2, 3, 13–16 | Two configurations with identical core hashes |
| IIW-REQ-025 | 1, 2, 4, 9, 16 | Availability separate from approval |

Phase 17 verifies the complete set `IIW-REQ-001` through `IIW-REQ-025` and does not replace the primary implementation ownership above.

## 7. Verification and Coverage Strategy

- **Test-plan artifact:** `tests/intelligent-inspection/intelligent_inspection_test_plan.md`, created only after Gate 3 approval during Phase 17 preparation.
- **Developer checks:** Static schemas, MATLAB unit tests, model update/compile checks, architecture inventory, interface conformance, deterministic boundary/failure cases, dataset leakage checks, model/version provenance, and project metrics only where prerequisites are approved.
- **Regression:** New `IIW-TST-*` suites by phase. Protected UAV `TST-001` through `TST-019` are not run during planning and are run later only under Phase 17 conditions.
- **Coverage:** For deterministic MATLAB, Simulink, or Stateflow decisions, target all applicable decision and condition outcomes and review any residual structural infeasibility. Architecture, contract, traceability, and reusability measures use the percentages stated in the approved acceptance criteria. Statistical performance uses only pre-approved metrics and thresholds.
- **Traceability:** Link each approved requirement to actual implementation elements, tests, results, and evidence only after those artifacts exist. Placeholder or fake native links are prohibited.
- **Independent review:** Freeze and hash the candidate. The named verifier must be different from all implementers, declare independence, inspect native evidence, and record exactly one Gate 5 decision.
- **Pass/fail:** No suppressed failure; no broken mandatory link; no unauthorized product, dataset, interface, or safety command; all applicable approved acceptance criteria pass or are explicitly deferred before implementation with Project Owner disposition.

## 8. Unresolved Prerequisites

| Prerequisite | Required before | Owner/approver | Current status |
|---|---|---|---|
| Named Integration & Tooling Lead | Its next implementation phase | Project Owner | **PENDING** |
| Named AI & Algorithm Developer for Phase 5A | Phase 5A implementation | Project Owner | **RESOLVED — Nouran Ismail assigned on 2026-09-07** |
| Named AI & Algorithm Developer for Phase 5B | Before Phase 5B implementation | Project Owner | **RESOLVED — Nouran Ismail assigned on 2026-09-07** |
| Named AI & Algorithm Developer for Phase 6 | Before Phase 6 implementation | Project Owner | **RESOLVED — Nouran Ismail assigned on 2026-09-08** |
| Named AI & Algorithm Developer for Phase 7 | Before Phase 7 implementation | Project Owner | **RESOLVED — Nouran Ismail assigned on 2026-09-08** |
| Different named Independent Verification Engineer | Phase 17 independent review | Project Owner | **RESOLVED — Yahya Helmy assigned on 2026-09-13; decision remains PENDING until review and approved verification execution** |
| MATLAB/product release and availability evidence | Any product-dependent phase | Integration & Tooling Lead; Project Owner disposition | **PASS — all twelve required products installed and license available** |
| Image Processing Toolbox approval | Phase 5A and Phase 5B use | Project Owner | **APPROVED FOR PHASE 5 — Nouran Ismail, Project Owner, 2026-09-07** |
| Deep Learning Toolbox approval | Phase 7 use | Project Owner | **APPROVED FOR PHASE 7 — Nouran Ismail, Project Owner, 2026-09-08** |
| Approval for each other proposed optional product | Use of that product | Project Owner | **PENDING where configuration says PROPOSED** |
| Requirements migration/native traceability mechanism | Native link creation | Lead Systems Engineer; Project Owner | **PENDING** |
| Dataset source, license, ownership, permitted use, split, leakage control, version | Any training/tuning | Dataset owner and Project Owner | **PENDING** |
| Taxonomy, anomaly classes, metric thresholds, support, operating slices | CV/DL/project evaluation | Lead Systems Engineer and Project Owner | **PENDING** |
| Regression target, horizon, feature set, uncertainty method, metric thresholds | Phase 9 training | Lead Systems Engineer and Project Owner | **PENDING** |
| Risk scale, thresholds, rationale codes, conservative fallback | Phase 10 project policy | Project Owner | **APPROVED — 2026-09-13** |
| Approval roles, identity, timeout, rejection, expiry, delegation, escalation, audit | Phase 11 | Project Owner | **APPROVED — 2026-09-14** |
| Evidence store, immutable ID/chain, integrity, privacy, access, retention, failure, and safety policy | Phase 12 persistence | Project Owner | **APPROVED — 2026-09-15** |
| Any new 3D/simulation dependency and environment scope | Phase 16 | Separate ECR/dependency approval | **PENDING** |
| Existing supervisor interface can accept a proposed request without change | Any direct UAV integration | Separate interface review; separate ECR if change needed | **UNRESOLVED — no change authorized** |

## 9. Risks and Required Dispositions

- Unavailable products may defer phases; they shall not be silently substituted.
- Dataset bias, leakage, licensing, or inadequate support may prevent training or invalidate performance evidence.
- Uncalibrated confidence or undefined uncertainty thresholds block autonomous forwarding.
- Approval latency or unavailability must never block an external safety response.
- Project semantics leaking into reusable artifacts fails reuse acceptance.
- Generated binary companions or interface files not named in a phase allowlist require a scope stop before creation.
- Any change to the frozen candidate invalidates independent review and requires renewed affected verification.

## 10. Overall Rollback Plan

Rollback is phase-specific and path-bounded. Restore only files named in the affected phase to their pre-phase hashes or remove newly created files under approved corrective scope. Preserve datasets, logs, audit evidence, and model versions according to approved retention policy. Never use a repository-wide reset, delete unrelated work, alter the verified MissionSupervisor, or remove unexpected artifacts without separate authorization.

## 11. Gate 2 — Requirements Approval

| Approval field | Entry |
|---|---|
| Approver name | Nouran Ismail |
| Approver role | Project Owner / Approval Authority |
| Decision | **APPROVED** |
| Date | 2026-09-06 |
| Approved requirements/scope | `IIW-REQ-001` through `IIW-REQ-025`; approved Gate 2 architecture, interfaces, safety priorities, acceptance criteria, assumptions, mapping, and dependency register |
| Conditions or deviations | Implementation-plan creation only; model implementation, MATLAB execution, training, and tests were not authorized at Gate 2. |

## 12. Gate 3 — Implementation Plan Approval

| Approval field | Entry |
|---|---|
| Approver name | Nouran Ismail |
| Approver role | Project Owner / Approval Authority |
| Decision | **APPROVED** |
| Date | 2026-09-06 |
| Approved implementation scope | Phase 1 only: dependency and MATLAB-product/license preflight using the exact Phase 1 allowlist. |
| Conditions or deviations | Do not install products. Do not execute Phases 2–17. The verified `MissionSupervisor` remains protected, and any interface modification requires a separate ECR. All later phases remain subject to their documented prerequisites and approval hold points. |

This Gate 3 decision authorizes Phase 1 preflight only. It does not authorize model creation/modification, training, implementation tests, or any activity in Phases 2–17. Phase 1 was not executed while recording this approval.

## 13. Planning Handoff

| Handoff field | Entry |
|---|---|
| From role | Lead Systems Engineer / MBD Architect |
| To role | Nouran Ismail — AI & Algorithm Developer for Phase 7 |
| Completed activity | Phase 6 implementation COMPLETE; developer verification PASS — 16/16; Project Owner review ACCEPTED on 2026-09-08 |
| Artifacts produced or changed | Phase 6 detector contract, dispatch, conventional implementation, tests, fixture, and developer evidence |
| Evidence available | `extensions/intelligent-inspection/evidence/conventional_detection_results.md` |
| Open findings | A different named Independent Verification Engineer remains required at Gate 5 |
| Assumptions and deviations | Project Owner subphase acceptance is not independent verification or final ECR acceptance; segmentation is outside the approved Phase 6 actions |
| Next permitted activity | Resolve every dataset, metric, class, and compute prerequisite before any Phase 7 execution |
| Required approver | Project Owner approval of the remaining Phase 7 prerequisites; later independent verification requires a different named reviewer |

## 14. Controlled Phase Continuation Record

| Decision field | Entry |
|---|---|
| Project Owner | Nouran Ismail — Project Owner |
| Decision date | 2026-09-06 |
| Phase 3 implementation | **COMPLETE** |
| Phase 3 verification | **PASS — 7/7 tests passed** |
| Phase 3 review | **ACCEPTED** |
| Phase 3 reviewer | Nouran Ismail — Project Owner |
| Phase 3 evidence | `extensions/intelligent-inspection/evidence/reference_architecture_validation.md` |
| Phase 4 scope authorization | **RECORDED** |
| Phase 4 exact allowlist | `extensions/intelligent-inspection/architecture/models/intelligent_inspection_reference_architecture.slx`; `extensions/intelligent-inspection/architecture/data/intelligent_inspection_interfaces.sldd`; `tests/intelligent-inspection/test_architecture_interfaces.m`; `extensions/intelligent-inspection/evidence/interface_conformance.md` |
| Interface-schema clarification | **APPROVED — Nouran Ismail, Project Owner, 2026-09-06** |
| Interface-ambiguity blocker | **RESOLVED** |
| Phase 4 implementation | **COMPLETE** |
| Phase 4 developer verification | **PASS — 7/7 tests** |
| Phase 4 review | **ACCEPTED** |
| Phase 4 reviewer | Nouran Ismail — Project Owner |
| Phase 4 review date | 2026-09-07 |
| Phase 4 acceptance criteria | `IIW-AC-020` through `IIW-AC-031`: **ACCEPTED** |
| Phase 4 evidence | `extensions/intelligent-inspection/evidence/interface_conformance.md` |
| Phase 5 disposition | Divided into controlled subphases 5A and 5B; Phases 6–17 are not renumbered |
| Phase 5A implementation | **COMPLETE** |
| Phase 5A developer verification | **PASS — 16/16** |
| Phase 5A review | **ACCEPTED** by Nouran Ismail — Project Owner on 2026-09-07 |
| Phase 5A independence | **PENDING** — a different named reviewer is required |
| Phase 5A boundary clarification | **APPROVED** by Nouran Ismail — Project Owner on 2026-09-07; inclusive `[minimum, maximum]` comparisons in `single`, no tolerance, nonfinite values rejected first, equality-only when minimum equals maximum |
| Phase 5A exact allowlist | `extensions/intelligent-inspection/core/+iiw/+quality/validateInspectionData.m`; `tests/intelligent-inspection/test_data_quality.m`; `tests/intelligent-inspection/fixtures/quality_contract_fixtures.mat`; `extensions/intelligent-inspection/evidence/quality_preprocessing_results.md` |
| Phase 5B implementation | **COMPLETE** |
| Phase 5B developer verification | **PASS — 16/16** |
| Phase 5B review | **ACCEPTED** by Nouran Ismail — Project Owner on 2026-09-08 |
| Phase 5B implementer | Nouran Ismail — AI & Algorithm Developer, assigned by Nouran Ismail — Project Owner on 2026-09-07 |
| Phase 5B independence | **PENDING** — a different named reviewer is required |
| Phase 5B requirement and criteria | `IIW-REQ-004`; `IIW-AC-032` through `IIW-AC-037` |
| Phase 5B exact allowlist | `extensions/intelligent-inspection/core/+iiw/+preprocessing/preprocessInspectionData.m`; `extensions/intelligent-inspection/core/+iiw/+preprocessing/recordTransform.m`; `tests/intelligent-inspection/test_preprocessing.m`; `extensions/intelligent-inspection/evidence/quality_preprocessing_results.md` |
| Overall Phase 5 | **COMPLETE** |
| Phase 6 implementation | **COMPLETE** |
| Phase 6 developer verification | **PASS — 16/16** |
| Phase 6 review | **ACCEPTED** by Nouran Ismail — Project Owner on 2026-09-08 |
| Phase 6 implementer | Nouran Ismail — AI & Algorithm Developer, assigned by Nouran Ismail — Project Owner on 2026-09-08 |
| Phase 6 independence | **PENDING** — a different named reviewer is required |
| Phase 6 exact allowlist | `extensions/intelligent-inspection/core/+iiw/+detection/DetectorContract.m`; `extensions/intelligent-inspection/core/+iiw/+detection/runDetector.m`; `extensions/intelligent-inspection/core/+iiw/+detection/conventionalDetector.m`; `tests/intelligent-inspection/test_detection_contract.m`; `tests/intelligent-inspection/test_detector_replacement.m`; `tests/intelligent-inspection/fixtures/detection_contract_fixtures.mat`; `extensions/intelligent-inspection/evidence/conventional_detection_results.md` |
| Phase 6 scope control | Consume `ProcessedData`, emit `DetectionResult`, retain replaceability and configurable thresholds, handle low-confidence/no-detection outcomes, and issue no operational or safety commands; segmentation is not authorized |
| Phase 7 | Optional Deep-Learning Detection — **AUTHORIZED FOR KSDD2 ACQUISITION AND GOVERNANCE ONLY; MODEL IMPLEMENTATION BLOCKED** |
| Phase 7 exact allowlist | `extensions/intelligent-inspection/core/+iiw/+detection/deepLearningDetector.m`; `extensions/intelligent-inspection/training/train_deep_learning_detector.m`; `extensions/intelligent-inspection/models/deep_learning_detector.mat`; `extensions/intelligent-inspection/model_cards/deep_learning_detector.md`; `extensions/intelligent-inspection/datasets/deep_learning_dataset_manifest.yaml`; `extensions/intelligent-inspection/datasets/dataset_selection_proposal.md`; `tests/intelligent-inspection/test_deep_learning_detector.m`; `extensions/intelligent-inspection/evidence/deep_learning_detection_results.md` |
| Later phases | Phases 8–17 remain **NOT AUTHORIZED** |
| Conditions | KSDD2 is conditionally selected. Official-source download to external storage, extraction, integrity/provenance verification, annotation inspection, and manifest creation are authorized but not executed. Dataset use, annotation modification, training, model creation, and evaluation remain blocked. Nouran Ismail may not independently verify her own Phase 7 work. The verified `MissionSupervisor` remains protected. |
