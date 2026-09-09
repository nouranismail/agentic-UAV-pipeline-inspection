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
| Planned implementers | Phase 5A, Phase 5B, Phase 6, and Phase 7 AI & Algorithm Developer: Nouran Ismail; other phase assignments remain **TBD** |
| Independent reviewer | **TBD:** a different named individual from every implementation author; Nouran Ismail is ineligible to independently verify her own Phase 5A, Phase 5B, Phase 6, or Phase 7 implementation |
| Status | **PHASES 1-6 COMPLETE AND ACCEPTED; PHASE 7 FAIL - CORRECTIVE TRAINING AUTHORIZED; PHASES 8-17 NOT AUTHORIZED** |

Gate 3 was approved by the Project Owner on 2026-09-06, initially with execution authority limited to Phase 1. Phases 1 through 4 were subsequently completed and accepted through their controlled hold points. On 2026-09-07, the Project Owner accepted Phase 4 developer evidence and authorized the narrowed data-quality scope. After an approved corrective repair, Phase 5A developer verification passed 16 of 16 tests and the Project Owner accepted Phase 5A. The Project Owner divided Phase 5 into Phase 5A — Reusable `DataQualityValidation` and Phase 5B — Reusable Image Preprocessing without renumbering Phases 6–17. On 2026-09-08, the Project Owner accepted Phase 5B and then Phase 6 developer evidence, recording 16/16 for each. Phase 6 is complete and accepted, with independent verification pending. Phase 7 training completed but failed two fixed performance criteria. On 2026-09-09, the Project Owner authorized controlled corrective training within the unchanged seven-file implementation allowlist. Phases 8–17 remain unauthorized. Phase hold points are controls within the Gate 3 work package; they do not replace or renumber repository Gates 1–6.

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

### Phase 9 — Predictive-Maintenance Regression

- **Approved requirement IDs:** `IIW-REQ-009`–`IIW-REQ-012`, `IIW-REQ-017`–`IIW-REQ-020`, `IIW-REQ-023`, `IIW-REQ-025`.
- **Prerequisites:** Phase 8 accepted; Statistics and Machine Learning Toolbox and any used Predictive Maintenance Toolbox capability verified and approved; dataset governance, feature set, target definition, split, metrics, uncertainty method, and pass thresholds approved.
- **Exact allowed files:** `extensions/intelligent-inspection/core/+iiw/+prediction/predictHealth.m`; `extensions/intelligent-inspection/training/train_health_regression.m`; `extensions/intelligent-inspection/models/health_regression.mat`; `extensions/intelligent-inspection/model_cards/health_regression.md`; `extensions/intelligent-inspection/datasets/regression_dataset_manifest.yaml`; `tests/intelligent-inspection/test_health_prediction.m`; `extensions/intelligent-inspection/evidence/health_prediction_results.md`.
- **Protected files:** Section 4 and all raw payload interfaces.
- **Responsible engineering role:** AI & Algorithm Developer.
- **Implementation actions:** Train only from approved numerical features; record estimate, context/horizon, uncertainty, feature reference, and model version; implement invalid/out-of-distribution disposition.
- **Measurable acceptance criteria:** Static inspection finds no raw-data input; split integrity passes; every prediction has required provenance/uncertainty; all approved regression metrics and slice thresholds are evaluated with no fabricated value.
- **Tests and metrics:** `IIW-TST-REG-001` through `IIW-TST-REG-007`; numeric-input, schema, split leakage, repeatability, invalid input, uncertainty, and out-of-distribution tests; MAE, RMSE, bias, applicable R-squared, interval coverage/width, and approved slices.
- **Evidence produced:** Dataset manifest, training log/configuration, model hash/card, regression metrics, residual/uncertainty review, and limitations.
- **Approval gate:** Gate 3 plus explicit dataset/target/metric/product approval; any missing approval stops training while preserving earlier phases.
- **Rollback approach:** Remove only the listed regression artifacts and restore the previous approved prediction selection; retain immutable evidence according to the approved retention policy.

### Phase 10 — Risk Assessment

- **Approved requirement IDs:** `IIW-REQ-011`, `IIW-REQ-012`, `IIW-REQ-014`–`IIW-REQ-018`, `IIW-REQ-020`, `IIW-REQ-023`.
- **Prerequisites:** Required upstream contracts accepted; project risk scale, evidence sufficiency, confidence/uncertainty thresholds, rationale codes, and conservative fallback approved.
- **Exact allowed files:** `extensions/intelligent-inspection/core/+iiw/+risk/assessRisk.m`; `extensions/intelligent-inspection/core/+iiw/+risk/validateRiskPolicy.m`; `extensions/intelligent-inspection/config/risk_policy_schema.yaml`; `tests/intelligent-inspection/test_risk_assessment.m`; `extensions/intelligent-inspection/evidence/risk_assessment_results.md`.
- **Protected files:** Section 4 and project policy values outside separately approved configuration phases.
- **Responsible engineering role:** AI & Algorithm Developer with Lead Systems Engineer review.
- **Implementation actions:** Implement deterministic evidence validation and versioned policy interpretation; emit risk level/score/rationale/evidence references; force review or reacquisition when mandatory evidence is missing or uncertainty limits fail.
- **Measurable acceptance criteria:** Every output identifies inputs and policy version; boundary behavior is deterministic; rejected/low-confidence cases produce no autonomous action; no direct safety command exists.
- **Tests and metrics:** `IIW-TST-RISK-001` through `IIW-TST-RISK-007`; nominal, missing evidence, rejected quality, low confidence, excessive uncertainty, boundary, and repeatability cases; 100% approved decision-table conformance and structural decision/condition coverage or justified infeasible objectives.
- **Evidence produced:** Decision table, test results, coverage review, rationale-code matrix, and policy hash.
- **Approval gate:** Gate 3 plus Project Owner approval of project policy values before configuration use; safety ambiguity is a stop condition.
- **Rollback approach:** Remove only the listed risk implementation/schema/tests/evidence and restore the prior selected policy version.

### Phase 11 — HumanApprovalGate

- **Approved requirement IDs:** `IIW-REQ-012`–`IIW-REQ-018`, `IIW-REQ-020`, `IIW-REQ-023`.
- **Prerequisites:** Phase 10 accepted; authenticated approver roles, timeout, rejection, expiration, delegation, escalation, identity, audit, and external-safety bypass policies explicitly approved.
- **Exact allowed files:** `extensions/intelligent-inspection/core/+iiw/+approval/evaluateApproval.m`; `extensions/intelligent-inspection/models/human_approval_gate.slx`; `extensions/intelligent-inspection/config/approval_policy_schema.yaml`; `tests/intelligent-inspection/test_human_approval_gate.m`; `extensions/intelligent-inspection/evidence/human_approval_gate_results.md`.
- **Protected files:** Section 4, especially the verified `MissionSupervisor`; no connector to a safety-critical command is allowed.
- **Responsible engineering role:** AI & Algorithm Developer with Lead Systems Engineer safety review.
- **Implementation actions:** Implement deterministic missing, pending, deferred, rejected, expired, and approved states; validate accountable identity and validity interval; prevent forwarding except for approved/unexpired recommendations; provide an independent external-safety bypass path.
- **Measurable acceptance criteria:** 100% approval-state table conformance; unauthorized states forward zero recommendations; external safety response is never blocked or delayed; audit fields are complete; no direct safety-command endpoint exists.
- **Tests and metrics:** `IIW-TST-APR-001` through `IIW-TST-APR-010`; all states, timeout boundaries, invalid identity, delegation, escalation, stale decision, deterministic repetition, and external-safety priority; decision/condition coverage target 100% or reviewed structural infeasibility.
- **Evidence produced:** Approved policy record, state/decision table, compile/update result, tests, coverage, audit samples, and safety-priority analysis.
- **Approval gate:** Gate 3 plus a distinct Project Owner policy-approval hold point. Missing policy prevents Phase 11 implementation.
- **Rollback approach:** Remove only the listed approval implementation/model/schema/tests/evidence and restore the prior architecture component to unimplemented status; do not touch the external safety subsystem.

### Phase 12 — Evidence Recording

- **Approved requirement IDs:** `IIW-REQ-006`, `IIW-REQ-010`, `IIW-REQ-011`, `IIW-REQ-016`–`IIW-REQ-018`, `IIW-REQ-023`, `IIW-REQ-025`.
- **Prerequisites:** Evidence store, immutable identifier, integrity, access, retention, failure, and privacy policies approved; contracts from Phase 4 accepted.
- **Exact allowed files:** `extensions/intelligent-inspection/core/+iiw/+evidence/recordEvidence.m`; `extensions/intelligent-inspection/core/+iiw/+evidence/validateEvidenceChain.m`; `extensions/intelligent-inspection/config/evidence_policy_schema.yaml`; `tests/intelligent-inspection/test_evidence_recording.m`; `extensions/intelligent-inspection/evidence/evidence_recorder_results.md`.
- **Protected files:** Section 4 and external evidence stores not explicitly approved.
- **Responsible engineering role:** Integration & Tooling Lead with AI & Algorithm Developer input.
- **Implementation actions:** Record stage IDs, artifacts, data/model/configuration/software versions, actor/component, timestamp, outcome, and integrity metadata; expose chain validation; record persistence failure without fabricating success.
- **Measurable acceptance criteria:** Every applicable transaction resolves a complete chain; orphan references equal zero; injected persistence failures create explicit failures and zero synthetic success records.
- **Tests and metrics:** `IIW-TST-EVD-001` through `IIW-TST-EVD-006`; chain completeness, orphan, immutability, version, failure, and retention-policy tests; 100% mandatory identifiers present.
- **Evidence produced:** Schema-validation results, sampled chains, failure logs, integrity observations, and traceability inventory.
- **Approval gate:** Gate 3 plus evidence-policy approval hold point before persistence implementation.
- **Rollback approach:** Disable and remove only the listed recorder code/schema/tests/report; preserve already generated audit evidence according to retention rules.

### Phase 13 — UAV Pipeline Configuration

- **Approved requirement IDs:** `IIW-REQ-001`–`IIW-REQ-003`, `IIW-REQ-007`–`IIW-REQ-021`, `IIW-REQ-023`, `IIW-REQ-024`.
- **Prerequisites:** Required reusable phases accepted; UAV data source, licensing, asset metadata, taxonomy, anomaly classes, quality/performance thresholds, risk scale, action mapping, and approver policy approved. Any MissionSupervisor interface proposal requires a separate ECR before proceeding beyond the advisory boundary.
- **Exact allowed files:** `extensions/intelligent-inspection/configurations/uav-pipeline/configuration.yaml`; `extensions/intelligent-inspection/configurations/uav-pipeline/source_adapter.m`; `extensions/intelligent-inspection/configurations/uav-pipeline/recommendation_adapter.m`; `extensions/intelligent-inspection/configurations/uav-pipeline/dataset_manifest.yaml`; `tests/intelligent-inspection/test_uav_pipeline_configuration.m`; `extensions/intelligent-inspection/evidence/uav_pipeline_configuration_results.md`.
- **Protected files:** Section 4 and every existing UAV supervisor interface/model/test/evidence artifact.
- **Responsible engineering role:** AI & Algorithm Developer with Lead Systems Engineer interface review.
- **Implementation actions:** Bind camera and contextual metadata, project taxonomy and maintenance features, policies, and advisory recommendation mapping to generic contracts; stop the adapter at a mission-request boundary; do not connect to or alter the protected supervisor without a separate ECR.
- **Measurable acceptance criteria:** Configuration validates; all project semantics remain in this configuration/adapter; invalid quality or confidence forwards no mission-changing request; approved recommendations remain advisory; protected artifact hashes are unchanged.
- **Tests and metrics:** `IIW-TST-UAV-001` through `IIW-TST-UAV-008`; source mapping, context, taxonomy, blocked-view quality interpretation, feature units, approval requirement, safety-command prohibition, and protected-hash checks. Project performance metrics run only with approved data and thresholds.
- **Evidence produced:** Configuration validation, contract mapping, advisory-boundary analysis, test results, project metric evidence if authorized, and protected hashes.
- **Approval gate:** Gate 3 plus project-configuration/dataset/metric approval; any required supervisor interface change stops under a separate ECR gate sequence.
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
| Different named Independent Verification Engineer | Phase 17 independent review | Project Owner | **PENDING** |
| MATLAB/product release and availability evidence | Any product-dependent phase | Integration & Tooling Lead; Project Owner disposition | **PASS — all twelve required products installed and license available** |
| Image Processing Toolbox approval | Phase 5A and Phase 5B use | Project Owner | **APPROVED FOR PHASE 5 — Nouran Ismail, Project Owner, 2026-09-07** |
| Deep Learning Toolbox approval | Phase 7 use | Project Owner | **APPROVED FOR PHASE 7 — Nouran Ismail, Project Owner, 2026-09-08** |
| Approval for each other proposed optional product | Use of that product | Project Owner | **PENDING where configuration says PROPOSED** |
| Requirements migration/native traceability mechanism | Native link creation | Lead Systems Engineer; Project Owner | **PENDING** |
| Dataset source, license, ownership, permitted use, split, leakage control, version | Any training/tuning | Dataset owner and Project Owner | **PENDING** |
| Taxonomy, anomaly classes, metric thresholds, support, operating slices | CV/DL/project evaluation | Lead Systems Engineer and Project Owner | **PENDING** |
| Regression target, horizon, feature set, uncertainty method, metric thresholds | Phase 9 training | Lead Systems Engineer and Project Owner | **PENDING** |
| Risk scale, thresholds, rationale codes, conservative fallback | Phase 10 project policy | Project Owner | **PENDING** |
| Approval roles, identity, timeout, rejection, expiry, delegation, escalation, audit | Phase 11 | Project Owner | **PENDING** |
| Evidence store, integrity, privacy, access, and retention policy | Phase 12 persistence | Project Owner | **PENDING** |
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
