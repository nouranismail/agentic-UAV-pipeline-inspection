# Engineering Change Request

**Template Version:** 1.0.0  

**Shared Workflow Version:** 1.0.0

## 1. Identification

| Field | Entry |

|---|---|

| ECR ID | ECR-20260906-001 |

| Project | Reusable Intelligent-Inspection Workflow Extension |

| Branch/baseline | `feature/intelligent-inspection-extension` / `138d8e399f9b42d1c5defdee7b65c29abd9eca45` |

| Requested by | Nouran Ismail |

| Requestor role | Project Owner / Approval Authority |

| Project Owner | Nouran Ismail |

| Request date | 2026-09-06 |

| Target artifacts | Proposed artifacts listed in Section 3; this pre-Gate-1 activity creates only this ECR |

## 2. Problem, Motivation, and Objective

The repository has a reusable approval-gated MATLAB and Simulink workflow but no optional workflow for image- and sensor-based inspection engineering. The proposed change will add a modular, application-independent intelligent-inspection workflow that preserves the existing governance gates while defining repeatable architecture, data, model, approval, verification, and evidence procedures.

The extension is intended to reduce duplicated project setup, make AI evidence reviewable, and demonstrate reuse through separate UAV-pipeline and fixed-camera configurations. A future 3D adapter will remain replaceable and outside the AI implementation.

## 3. Scope

### In scope after Gate 1 approval

- Define generic requirements and interfaces for inspection-source abstraction, data-quality validation, preprocessing, computer vision, deep learning, numerical feature extraction, predictive-maintenance regression, confidence and uncertainty handling, human approval, evidence reporting, and AI verification.

- Add the modular reusable skill `skills/intelligent-inspection-workflow/` without modifying `skills/simulink-engineering-workflow/SKILL.md` during the initial extension.

- Define a System Composer reference architecture and reusable project templates.

- Define distinct configurations for a UAV pipeline application, a fixed-camera reuse demonstration, and a future 3D UAV adapter.

- Update team configuration only after approval to recognize the extension branch and the approved dependency set.

- Prepare requirements first, stop at Gate 2, and prepare implementation and test plans only after requirements approval.

### Out of scope

- Implementing or training CV, ML, DL, or regression models.

- Creating or modifying Simulink, Stateflow, System Composer, or 3D simulation models before the applicable approved plan.

- Fabricating datasets, annotations, performance results, tests, coverage, traceability, or verification evidence.

- Modifying the verified UAV MissionSupervisor, its dictionary, requirements, TST-001 through TST-019, coverage, or verification evidence.

- Modifying the existing reusable Simulink workflow skill during this initial extension.

- Hardware deployment, flight testing, or autonomous safety-command generation by AI.

### Proposed repository structure and affected artifacts

| Artifact | Expected impact | Owner |

|---|---|---|

| `change_requests/ECR-20260906-001_intelligent_inspection_workflow.md` | Create now; Gate 1 proposal | Lead Systems Engineer / MBD Architect |

| `extensions/intelligent-inspection/requirements/generic_intelligent_inspection_requirements.md` | Create after Gate 1; generic draft requirements and Gate 2 review record | Lead Systems Engineer / MBD Architect |

| `extensions/intelligent-inspection/architecture/component_definitions.md` | Create after Gate 1; generic component specification | Lead Systems Engineer / MBD Architect |

| `extensions/intelligent-inspection/architecture/interface_contracts.md` | Create after Gate 1; generic logical interface specification | Lead Systems Engineer / MBD Architect |

| `extensions/intelligent-inspection/architecture/safety_and_approval_priorities.md` | Create after Gate 1; safety and approval priority specification | Lead Systems Engineer / MBD Architect |

| `extensions/intelligent-inspection/acceptance_criteria.md` | Create after Gate 1; measurable, reuse, traceability, and scalability criteria | Lead Systems Engineer / MBD Architect |

| `extensions/intelligent-inspection/assumptions_and_limitations.md` | Create after Gate 1; assumptions, limitations, and unresolved decisions | Lead Systems Engineer / MBD Architect |

| `extensions/intelligent-inspection/artifact_mapping.md` | Create after Gate 1; reusable-to-project mapping | Lead Systems Engineer / MBD Architect |

| `extensions/intelligent-inspection/dependency_register.md` | Create after Gate 1; governance and availability status | Lead Systems Engineer / MBD Architect |

| `extensions/intelligent-inspection/implementation_plan.md` | Create only after Gate 2 approval | Lead Systems Engineer / MBD Architect |

| `skills/intelligent-inspection-workflow/SKILL.md` | Create only after Gate 3 approval | Integration & Tooling Lead |

| `skills/intelligent-inspection-workflow/references/system-composer-architecture.md` | Create only after Gate 3 approval | Integration & Tooling Lead |

| `skills/intelligent-inspection-workflow/references/inspection-source-and-data-quality.md` | Create only after Gate 3 approval | Integration & Tooling Lead |

| `skills/intelligent-inspection-workflow/references/vision-and-preprocessing.md` | Create only after Gate 3 approval | Integration & Tooling Lead |

| `skills/intelligent-inspection-workflow/references/features-regression-and-uncertainty.md` | Create only after Gate 3 approval | Integration & Tooling Lead |

| `skills/intelligent-inspection-workflow/references/human-approval-integration-and-evidence.md` | Create only after Gate 3 approval | Integration & Tooling Lead |

| `templates/templates/intelligent_inspection_project_template.md` | Create only after Gate 3 approval | Integration & Tooling Lead |

| `templates/templates/dataset_governance_template.md` | Create only after Gate 3 approval | Integration & Tooling Lead |

| `templates/templates/model_card_template.md` | Create only after Gate 3 approval | Integration & Tooling Lead |

| `templates/templates/ai_verification_report_template.md` | Create only after Gate 3 approval | Integration & Tooling Lead |

| `extensions/intelligent-inspection/configurations/uav-pipeline/` | Project-specific configuration; later approved phase | AI & Algorithm Developer |

| `extensions/intelligent-inspection/configurations/fixed-camera/` | Independent reuse configuration; later approved phase | AI & Algorithm Developer |

| `extensions/intelligent-inspection/adapters/uav-3d/` | Replaceable future adapter specification; later approved phase | Lead Systems Engineer / MBD Architect |

| `config/team_configuration.yaml` | Modify after approval for branch and approved dependencies | Integration & Tooling Lead |

| `skills/simulink-engineering-workflow/SKILL.md` | Read-only; no initial-extension change | Integration & Tooling Lead |

| Existing UAV supervisor and evidence artifacts | Protected and read-only | Project Owner / Approval Authority |

The Project Owner's Gate 2 work authorization clarified the specification format and split the previously proposed native requirement/architecture documents into the eight Markdown artifacts above because MATLAB execution is prohibited in this phase. This clarification does not change the approved Gate 1 objective, safety boundary, exclusions, or Gate 1 decision.

## 4. Requirements, Interfaces, and Safety Impact

- **Affected requirements:** No existing UAV requirement is changed. New generic requirement IDs will be proposed after Gate 1 and remain draft until Gate 2 approval.

- **Affected interfaces:** New generic inspection-source, quality-status, processed-data, detection-result, numerical-feature, prediction, risk, approval-decision, recommended-action, and evidence-record interfaces are proposed. Project adapters will map these interfaces without placing application-specific terminology in the reusable core.

- **Safety/hazard impact:** AI shall not directly command `SafeLanding`; the verified MissionSupervisor remains the UAV flight-safety authority. Low-quality or uncertain results shall not autonomously change a mission. Mission-changing intelligent recommendations require human approval, and pending approval shall never delay an existing flight-safety response.

- **Configuration impact:** Reusable configuration remains separate from the UAV pipeline, fixed-camera, and future 3D adapter configurations. The simulated and real inspection sources shall conform to the same generic source interface.

- **Verification impact:** Later plans shall include requirements-based tests, interface-contract checks, data-quality and uncertainty failure cases, approval-gate tests, traceability, reuse verification in two configurations, and independent review. No verification result is claimed by this ECR.

## 5. Expected Benefits

- Reusable engineering procedures across image- and sensor-based inspection projects.

- Explicit separation of generic workflow behavior from application configuration.

- Traceable dataset, model-version, approval, recommendation, and evidence records.

- Replaceable real and simulated inspection sources.

- Controlled integration of AI recommendations without transferring safety authority to AI.

- A repeatable reuse proof using a non-UAV fixed-camera inspection configuration.

## 6. Dependencies and Tools

### Already listed as approved in team configuration

- MATLAB

- Simulink

- Stateflow

- Requirements Toolbox

- Simulink Test

- Simulink Coverage

- Computer Vision Toolbox

- Statistics and Machine Learning Toolbox

### Proposed dependencies requiring recorded approval before use

- System Composer

- Image Processing Toolbox

- Deep Learning Toolbox

- Predictive Maintenance Toolbox

No installation or product-availability claim is made. Availability shall be checked only in an approved later step before the relevant product is used.

## 7. Proposed Role Assignments

| Responsibility | Assigned name | Canonical role |

|---|---|---|

| Requirements and architecture | TBD | Lead Systems Engineer / MBD Architect |

| Reusable skill and template implementation | TBD | Integration & Tooling Lead |

| Application configuration implementation | TBD | AI & Algorithm Developer |

| Independent verification | Different named individual, TBD | Independent Verification & Validation Engineer |

| Final approval | Nouran Ismail | Project Owner / Approval Authority |

The implementer and Independent Verification Engineer shall be different named individuals. A separate AI-agent session alone shall not establish independence.

## 8. Assumptions, Constraints, and Risks

### Assumptions and constraints

- Shared workflow version 1.0.0 remains authoritative.

- The intelligent-inspection skill extends rather than replaces the existing Simulink workflow.

- Generic reusable artifacts contain no UAV-, pipeline-, flight-mode-, defect-class-, or other first-application logic.

- Regression consumes validated numerical features rather than raw images.

- Dataset selection, labels, splits, performance thresholds, confidence thresholds, and approval mechanisms require later requirements decisions.

### Risks

- Leakage of application-specific logic into reusable artifacts could prevent reuse.

- Dataset bias, label quality, distribution shift, or leakage could invalidate model evidence.

- Uncalibrated confidence could cause unsafe or misleading recommendations.

- Missing human-approval audit records could break traceability.

- Tool-release or toolbox availability differences could reduce portability.

- Tight coupling to a simulated source could prevent later real-source substitution.

- Ambiguous recommendation mapping could unintentionally bypass application safety authority.

## 9. Rollback Approach

Rollback shall be path-specific. Newly created extension, skill, requirement, and template artifacts may be removed only under approved corrective scope. Changes to `config/team_configuration.yaml` shall be reverted by restoring only the approved extension entries. Existing UAV artifacts and unrelated work shall be preserved; repository-wide destructive reset operations are prohibited.

## 10. Proposed Phases and Approval Stops

1. **Gate 1:** Approve this ECR scope, exclusions, dependencies, roles, and conditions.

2. **Requirements and architecture specification:** Define generic requirements, interfaces, architecture, safety boundaries, verification intent, and the three application/adapter separations; stop at Gate 2.

3. **Gate 2:** Project Owner approves requirements, interfaces, safety priorities, acceptance criteria, and assumptions.

4. **Implementation and test planning:** Prepare exact implementation, verification, traceability, reuse, and rollback plans; stop at Gate 3.

5. **Controlled reusable-core implementation:** Create the approved skill, references, and templates; collect developer evidence and stop at Gate 4.

6. **Application configurations:** Implement UAV-pipeline and fixed-camera configurations in separately approved work packages. Treat the 3D adapter as a later scalable interface work package.

7. **Independent verification and acceptance:** Freeze candidates, complete Gate 5 through a different named reviewer, then obtain Gate 6 Project Owner disposition.

## 11. Gate 1 Acceptance Criteria

Gate 1 may be approved only when the Project Owner explicitly accepts:

- ECR identifier, objective, branch, and baseline.

- Exact proposed artifact boundaries and protected UAV artifacts.

- Separation of reusable core, UAV pipeline application, fixed-camera reuse proof, and future 3D adapter.

- Safety constraints and preservation of MissionSupervisor authority.

- Proposed dependencies and the requirement to verify availability before use.

- Role assignments or explicit `TBD` ownership to be resolved before implementation planning.

- Phase order and mandatory stops at Gates 2 and 3.

- Prohibition on fabricated datasets, results, tests, traceability, or verification evidence.

## 12. Gate 1 - Scope/ECR Approval

| Approval field | Entry |

|---|---|

| Approver name | Nouran Ismail |

| Approver role | Project Owner / Approval Authority |

| Decision | **APPROVED** |

| Date | 2026-09-06 |

| Approved scope | Gate 2 requirements and acceptance-criteria development; generic interface specification; safety-priority definition; assumptions and dependency documentation; and updating team configuration to recognize `feature/intelligent-inspection-extension` and proposed optional MATLAB products. |

| Conditions or deviations | This approval does not authorize System Composer, Simulink, or Stateflow model implementation; AI/CV/DL training; MATLAB execution; modification of the verified MissionSupervisor; or rerunning its existing tests. Proposed product availability must not be claimed until checked in an authorized later step. |

Approval applies only to the scope recorded above. Silence or task continuation is not approval.

## 13. Gate 2 - Requirements Approval

| Approval field | Entry |
|---|---|
| Approver name | Nouran Ismail |
| Approver role | Project Owner / Approval Authority |
| Decision | **APPROVED** |
| Date | 2026-09-06 |
| Approved scope | The Gate 2 specification package: generic requirements, component definitions, interface contracts, safety and approval priorities, acceptance criteria, assumptions and limitations, artifact mapping, and dependency register. |
| Authorized next activity | Creation of the implementation plan only. |
| Approved decisions | The first System Composer implementation shall be a logical architecture containing components, ports, interfaces, and connections. Optional MATLAB product availability remains `NOT VERIFIED` until an authorized preflight check. Dataset source, licensing, splitting, and versioning shall be approved before training. Project metrics, thresholds, and anomaly classes shall be approved before training. Approval timeout and escalation policies shall be defined before implementing `HumanApprovalGate`. The verified `MissionSupervisor` remains unchanged; any future interface modification requires a separate ECR. A named independent verifier shall be assigned before verification. |
| Conditions or deviations | This approval does not authorize model implementation, MATLAB execution, AI/CV/DL/ML training, or test execution. It does not approve an implementation plan or authorize modification of the verified `MissionSupervisor`. |

Gate 2 approval authorized implementation-plan preparation only and did not itself authorize implementation. The subsequent Gate 3 decision is recorded in Section 14.

## 14. Gate 3 - Implementation Plan Approval

| Approval field | Entry |
|---|---|
| Approver name | Nouran Ismail |
| Approver role | Project Owner / Approval Authority |
| Decision | **APPROVED** |
| Date | 2026-09-06 |
| Approved implementation scope | Phase 1 only: MATLAB-product and license preflight as defined by `extensions/intelligent-inspection/implementation_plan.md`. |
| Authorized next activity | Execute Phase 1 in a subsequent controlled task after its role and scope declaration. |
| Conditions or deviations | Do not execute Phases 2–17. All later phases remain subject to their documented prerequisites and approval hold points. The verified `MissionSupervisor` remains protected; any proposed interface modification requires a separate ECR. This approval does not authorize product installation, model creation or modification, training, or implementation tests. |

Phase 1 was not executed while this approval was recorded. Product availability remains `NOT VERIFIED` pending that preflight.

## 15. Controlled Phase Continuation Decision

| Decision field | Entry |
|---|---|
| Project Owner | Nouran Ismail — Project Owner |
| Decision date | 2026-09-06 |
| Phase 3 implementation | **COMPLETE** |
| Phase 3 verification | **PASS — 7/7 tests passed** |
| Phase 3 review | **ACCEPTED** |
| Phase 3 reviewer | Nouran Ismail — Project Owner |
| Phase 3 evidence | `extensions/intelligent-inspection/evidence/reference_architecture_validation.md` |
| Phase 4 decision | **AUTHORIZED AND READY TO EXECUTE** |
| Phase 4 authorized scope | Implement only the detailed generic interface schemas defined by the approved requirements and interface contracts. |
| Phase 4 exact allowlist | `extensions/intelligent-inspection/architecture/models/intelligent_inspection_reference_architecture.slx`; `extensions/intelligent-inspection/architecture/data/intelligent_inspection_interfaces.sldd`; `tests/intelligent-inspection/test_architecture_interfaces.m`; `extensions/intelligent-inspection/evidence/interface_conformance.md` |
| Phase 4 implementation status | **NOT STARTED** |
| Later phases | Phases 5–17 remain **NOT AUTHORIZED** |
| Conditions | This decision records authorization only. It does not implement Phase 4, authorize work outside its allowlist, modify the verified `MissionSupervisor`, or authorize any later phase. |

The Phase 3 review is a Project Owner phase-exit acceptance decision. It is not an independent-verification decision or final acceptance of ECR-20260906-001.

## 16. Targeted Gate 2 Interface-Schema Clarification

| Clarification field | Entry |
|---|---|
| Status | **APPROVED** |
| Prepared under authority of | Nouran Ismail — Project Owner |
| Preparation date | 2026-09-06 |
| Purpose | Resolve Phase 4 implementation-critical types, dimensions, units, ranges, defaults, encodings, null handling, boundary ports, approval-authority direction, and evidence-port assignments. |
| Authoritative detailed schema | `extensions/intelligent-inspection/architecture/interface_contracts.md` |
| Supporting clarifications | `extensions/intelligent-inspection/architecture/component_definitions.md`; `extensions/intelligent-inspection/architecture/safety_and_approval_priorities.md`; `extensions/intelligent-inspection/acceptance_criteria.md`; `extensions/intelligent-inspection/artifact_mapping.md` |
| Project Owner decisions | **APPROVED:** logical `names`/`values` are realized at runtime as `featureIds`/`featureValues` with `featureCount`; existing evidence-reference field names are retained with the approved fixed-capacity representation; `contextOrHorizon` is a `uint32` project-configuration reference with an explicit Boolean validity field; the six boundary ports, external approval-authority direction, evidence-observation assignments, and `IIW-AC-020` through `IIW-AC-031` are approved. |
| Interface-ambiguity blocker | **RESOLVED** |
| Phase 4 current status | **AUTHORIZED AND READY TO EXECUTE — NOT STARTED** |
| Later phases | Phases 5–17 remain **NOT AUTHORIZED** |
| Model and implementation impact | None in this clarification task. No model, dictionary, test, algorithm, or evidence artifact may be created or modified. |

### Clarification Review

| Approval field | Entry |
|---|---|
| Decision | **APPROVED** |
| Approver | Nouran Ismail — Project Owner |
| Approval date | 2026-09-06 |
| Conditions or deviations | Approval authorizes Phase 4 execution only under its exact four-file allowlist. It does not implement Phase 4 or authorize Phases 5–17. The verified `MissionSupervisor` remains protected. |

## 17. Phase 4 Acceptance and Phase 5 Authorization

| Decision field | Entry |
|---|---|
| Project Owner | Nouran Ismail — Project Owner |
| Decision date | 2026-09-07 |
| Phase 4 implementation | **COMPLETE** |
| Phase 4 developer verification | **PASS — 7/7 tests** |
| Phase 4 review decision | **ACCEPTED** |
| Reviewer | Nouran Ismail — Project Owner |
| Review date | 2026-09-07 |
| Phase 4 acceptance criteria | `IIW-AC-020` through `IIW-AC-031`: **ACCEPTED** |
| Phase 4 evidence | `extensions/intelligent-inspection/evidence/interface_conformance.md` |
| Phase 5 decision | **AUTHORIZED — NOT STARTED** |
| Phase 5 assigned developer | Nouran Ismail — AI & Algorithm Developer |
| Phase assignment | Phase 5 implementation |
| Developer assignment authority and date | Nouran Ismail — Project Owner; 2026-09-07 |
| Phase 5 dependency approval | Image Processing Toolbox — **APPROVED FOR PHASE 5 USE** |
| Dependency approval authority and date | Nouran Ismail — Project Owner; 2026-09-07 |
| Independence restriction | The developer assignment does not provide independent verification. Nouran Ismail shall not be recorded as the Independent Verification Engineer for her own Phase 5 implementation; independent verification remains a separate future gate. |
| Phase 5 scope | Reusable `InspectionSource` contract-boundary ingestion and `DataQualityValidation` implementation only |
| Phase 5 exact allowlist | `extensions/intelligent-inspection/core/+iiw/+quality/validateInspectionData.m`; `tests/intelligent-inspection/test_data_quality.m`; `tests/intelligent-inspection/fixtures/quality_contract_fixtures.mat`; `extensions/intelligent-inspection/evidence/quality_preprocessing_results.md` |
| Allowlist disposition | The four paths are the non-preprocessing subset of the approved Phase 5 plan allowlist. The legacy evidence filename does not authorize preprocessing. No separate `InspectionSource` implementation path is approved; adding one requires a Project Owner-approved plan amendment. |
| Phase 5 exclusions | Preprocessing, detection, deep learning, feature extraction, regression, risk assessment, recommendations, mission changes, project-specific logic, verified `MissionSupervisor` changes, and existing UAV regression execution |
| Later phases | Phases 6–17 remain **NOT AUTHORIZED** |
| Conditions | Phase 5 execution must stop for an unapproved optional product, undefined deterministic quality rule, or required artifact outside the exact allowlist. This decision is not independent verification or final ECR acceptance. |

## 18. Phase 5 Numeric-Boundary Clarification and Corrective Authorization

| Decision field | Entry |
|---|---|
| Clarification decision | **APPROVED** |
| Approver | Nouran Ismail — Project Owner |
| Approval date | 2026-09-07 |
| Minimum comparison | Inclusive: `measuredValue >= minimumThreshold` |
| Maximum comparison | Inclusive: `measuredValue <= maximumThreshold` |
| Numeric representation | Convert both the measured value and configured threshold to MATLAB `single` before comparison |
| Tolerance | No implicit or undocumented tolerance is permitted |
| Nonfinite handling | Reject `NaN`, positive infinity, and negative infinity before comparison |
| Equal thresholds | When minimum equals maximum, only an exactly equal measured `single` value satisfies the range |
| Phase 5 corrective repair | **AUTHORIZED** within the existing four-file Phase 5 allowlist |
| Phase 5 status | **FAIL — CORRECTIVE REPAIR AUTHORIZED** |
| Corrective limit | Correct only `exactBrightnessBoundaryPasses` and the field-name representation comparison in `resultMatchesApprovedSchema`; rerun only `tests/intelligent-inspection/test_data_quality.m` |
| Later phases | Phases 6–17 remain **NOT AUTHORIZED** |
| Conditions | This clarification does not modify or accept the Phase 5 implementation, authorize preprocessing, authorize a later phase, or constitute independent verification or final acceptance. |

## 19. Phase 5A Acceptance and Phase 5B Authorization Amendment

| Decision field | Entry |
|---|---|
| Project Owner | Nouran Ismail — Project Owner |
| Decision date | 2026-09-07 |
| Phase numbering disposition | Phase 5 is divided into controlled subphases 5A and 5B; Phases 6–17 are not renumbered |
| Phase 5A implementation | **COMPLETE** |
| Phase 5A developer verification | **PASS — 16/16** |
| Phase 5A review decision | **ACCEPTED** |
| Phase 5A reviewer | Nouran Ismail — Project Owner |
| Phase 5A review date | 2026-09-07 |
| Phase 5A independent verification | **PENDING** — it must be performed by a different named reviewer |
| Phase 5B decision | **AUTHORIZED — NOT STARTED** |
| Phase 5B implementer | Nouran Ismail |
| Implementer role | AI & Algorithm Developer |
| Assigned by | Nouran Ismail — Project Owner |
| Assignment date | 2026-09-07 |
| Independence restriction | The implementer may perform developer verification but may not independently verify her own Phase 5B work; independent verification must use a different named person |
| Phase 5B scope | Reusable deterministic image preprocessing only after `DataQualityValidation` returns `PASS` |
| Phase 5B requirement | Revised `IIW-REQ-004`; no new requirement ID |
| Phase 5B acceptance criteria | `IIW-AC-032` through `IIW-AC-037` |
| Phase 5B exact allowlist | `extensions/intelligent-inspection/core/+iiw/+preprocessing/preprocessInspectionData.m`; `extensions/intelligent-inspection/core/+iiw/+preprocessing/recordTransform.m`; `tests/intelligent-inspection/test_preprocessing.m`; `extensions/intelligent-inspection/evidence/quality_preprocessing_results.md` |
| Allowlist provenance | The four paths are recovered from the originally approved Phase 5 implementation plan at commit `c52d7f59b382463f8a531f23f2fc25ff3f2838a6`. The completed Phase 5A fixture remains protected and is not part of the Phase 5B modifiable allowlist. |
| Phase 5B permitted behavior | Configured deterministic format/channel normalization, resizing, intensity normalization, denoising, contrast adjustment, and complete ordered transformation/parameter recording |
| Phase 5B restrictions | Do not process `REVIEW` or `REJECT` inputs into processed output; do not hide or repair rejected input; do not implement detection, segmentation, learned models, feature extraction, regression, risk, approval, recommendations, operational commands, project-specific behavior, or MissionSupervisor changes |
| Phase 6 | Replaceable Computer-Vision Detection — **NOT AUTHORIZED** |
| Later phases | Phases 7–17 remain **NOT AUTHORIZED** |
| Conditions | This amendment authorizes Phase 5B only within its exact allowlist. It does not constitute Phase 5B implementation, developer verification, independent verification, or final ECR acceptance. |

## 20. Phase 5B Acceptance and Phase 6 Authorization

| Decision field | Entry |
|---|---|
| Project Owner | Nouran Ismail — Project Owner |
| Decision date | 2026-09-08 |
| Phase 5B implementation | **COMPLETE** |
| Phase 5B developer verification | **PASS — 16/16** |
| Phase 5B review decision | **ACCEPTED** |
| Phase 5B reviewer | Nouran Ismail — Project Owner |
| Phase 5B review date | 2026-09-08 |
| Phase 5B independent verification | **PENDING** — it must be performed by a different named reviewer |
| Overall Phase 5 implementation | **COMPLETE** |
| Phase 6 decision | **AUTHORIZED — NOT STARTED** |
| Phase 6 scope | Reusable, replaceable conventional computer-vision Detection consuming the approved `ProcessedData` and producing the approved `DetectionResult` |
| Phase 6 required behavior | Use configurable thresholds; remain application-independent; provide controlled low-confidence and no-detection results; never issue operational or safety commands |
| Phase 6 segmentation disposition | **NOT AUTHORIZED** — segmentation is not included in the approved Phase 6 implementation actions |
| Phase 6 exact allowlist | `extensions/intelligent-inspection/core/+iiw/+detection/DetectorContract.m`; `extensions/intelligent-inspection/core/+iiw/+detection/runDetector.m`; `extensions/intelligent-inspection/core/+iiw/+detection/conventionalDetector.m`; `tests/intelligent-inspection/test_detection_contract.m`; `tests/intelligent-inspection/test_detector_replacement.m`; `tests/intelligent-inspection/fixtures/detection_contract_fixtures.mat`; `extensions/intelligent-inspection/evidence/conventional_detection_results.md` |
| Phase 6 implementer | Nouran Ismail — AI & Algorithm Developer |
| Phase 6 assigned by | Nouran Ismail — Project Owner |
| Phase 6 assignment date | 2026-09-08 |
| Phase 6 independence | Developer verification does not establish independent verification; a different named person must perform independent verification |
| Later phases | Phases 7–17 remain **NOT AUTHORIZED** |
| Independence and acceptance | Project Owner acceptance of developer evidence is not independent verification or final ECR acceptance; the verified `MissionSupervisor` remains protected |

## 21. Phase 6 Acceptance and Phase 7 Authorization

| Decision field | Entry |
|---|---|
| Project Owner/date | Nouran Ismail — Project Owner; 2026-09-08 |
| Phase 6 implementation | **COMPLETE** |
| Phase 6 developer verification | **PASS — 16/16** |
| Phase 6 review | **ACCEPTED** |
| Phase 6 independent verification | **PENDING — different named reviewer required** |
| Phase 7 | Optional Deep-Learning Detection — **AUTHORIZED — NOT STARTED; EXECUTION BLOCKED PENDING PREREQUISITES** |
| Phase 7 implementer | Nouran Ismail — AI & Algorithm Developer |
| Assigned by/date | Nouran Ismail — Project Owner; 2026-09-08 |
| Phase 7 independence | Developer verification does not establish independent verification; a different named person must perform independent verification |
| Deep Learning Toolbox | **APPROVED FOR PHASE 7** |
| Phase 7 exact allowlist | `extensions/intelligent-inspection/core/+iiw/+detection/deepLearningDetector.m`; `extensions/intelligent-inspection/training/train_deep_learning_detector.m`; `extensions/intelligent-inspection/models/deep_learning_detector.mat`; `extensions/intelligent-inspection/model_cards/deep_learning_detector.md`; `extensions/intelligent-inspection/datasets/deep_learning_dataset_manifest.yaml`; `extensions/intelligent-inspection/datasets/dataset_selection_proposal.md`; `tests/intelligent-inspection/test_deep_learning_detector.m`; `extensions/intelligent-inspection/evidence/deep_learning_detection_results.md` |
| Preconditions before execution | Approve dataset source, license, ownership, immutable version, annotations, split, leakage controls, classes, metrics, thresholds, and compute constraints |
| Later phases | Phases 8–17 remain **NOT AUTHORIZED** |

### Phase 7 Dataset-Planning Amendment

| Decision field | Entry |
|---|---|
| Decision | **APPROVED** |
| Approved by/date | Nouran Ismail — Project Owner; 2026-09-08 |
| Added allowlist artifact | `extensions/intelligent-inspection/datasets/dataset_selection_proposal.md` |
| Purpose | Research and compare candidate public datasets before any dataset selection, download, annotation modification, training, or performance evaluation |
| Dataset research and proposal creation | **AUTHORIZED** |
| Dataset selection | **NOT YET APPROVED** |
| Dataset download | **NOT AUTHORIZED** |
| Annotation modification | **NOT AUTHORIZED** |
| Model training | **NOT AUTHORIZED** |
| Performance evaluation | **NOT AUTHORIZED** |
| Other Phase 7 artifacts | The other seven allowlisted implementation artifacts remain unimplemented |
| Later phases | Phases 8–17 remain **NOT AUTHORIZED** |

### Phase 7 Conditional Dataset Selection and Acquisition Authorization

| Decision field | Entry |
|---|---|
| Decision authority/date | Nouran Ismail — Project Owner; 2026-09-08 |
| Selected dataset | Kolektor Surface-Defect Dataset 2 (KolektorSDD2 / KSDD2) |
| Official source | `https://www.vicos.si/resources/kolektorsdd2/` |
| Owner/provider | ViCoS Laboratory and Kolektor Group |
| Permitted project use | Non-commercial internship research and demonstration |
| License | CC BY-NC-SA 4.0 |
| Obligations | Attribution and ShareAlike are mandatory; commercial-use claims are prohibited |
| Selection condition | Source, license, archive, annotation, and split-metadata verification must succeed before dataset use |
| Authorized acquisition | Download from the official source to approved external storage; extract; compute integrity hashes; record provenance, archive structure, image/mask encodings, annotations, counts, and split metadata |
| Authorized repository artifact | Create `extensions/intelligent-inspection/datasets/deep_learning_dataset_manifest.yaml` using verified evidence only |
| External storage | `IIW_DATASET_ROOT/KSDD2/source/` and `IIW_DATASET_ROOT/KSDD2/extracted/`, where `IIW_DATASET_ROOT` resolves outside the Git repository |
| Repository redistribution | Raw archive, extracted images, masks, and derived dataset payloads are prohibited from this Git repository |
| Utility / `.gitignore` disposition | No repository download utility and no `.gitignore` modification are required for the approved external-storage approach |
| Still prohibited | Annotation modification, model adapter implementation, training, tuning, calibration, model creation, testing, performance evaluation, and performance claims |
| Remaining training blockers | Project Owner approval of metrics, thresholds, numeric class mapping, immutable leakage-safe split membership, leakage controls, annotation interpretation, and compute constraints |
| Other artifacts | Phase 7 model/training/model-card/test/result artifacts remain unimplemented; Phases 8–17 remain **NOT AUTHORIZED** |

### Phase 7 KSDD2 Manifest Review and Training Authorization

| Decision field | Entry |
|---|---|
| Dataset manifest review | **ACCEPTED** |
| Project Owner / date | Nouran Ismail — Project Owner; 2026-09-09 |
| Verified integrity | SHA-256 `EDCDB486809B24F1D17B785E30C52FAFC5999554DD5FE18DDF77B61CEB6F36A8`; 3,335 canonical images and masks; 356 positive and 2,979 negative samples |
| Duplicate disposition | The two publisher-supplied `(copy)` files are excluded from split membership without modifying the source archive |
| Split approval | Deterministic stratified 80% training / 20% validation split from official training only; stable SHA-256 ordering with recorded seed/configuration; exact duplicates and approved acquisition groups remain together |
| Official test isolation | Official test data shall not be used for fitting, preprocessing decisions, threshold tuning, model selection, early stopping, training, or validation |
| Learning task | Binary semantic segmentation, background versus anomaly, mapped to generic `DetectionResult` regions behind `DetectorContract` |
| Training and confidence | Compact U-Net-style network; approved resizing; imbalance-aware loss; deterministic seed; validation early stopping; controlled GPU/CPU execution; default pixel threshold 0.50 with validation-only tuning and controlled abstention |
| Required metrics | Pixel Dice and IoU; image-level precision, recall, and F1; negative-image false-positive rate; inference time; confusion matrix; validation and official-test results reported separately |
| Fixed thresholds | Test recall >= 0.75; precision >= 0.70; F1 >= 0.72; positive-image mean Dice >= 0.50; negative-image false-positive rate <= 0.15; zero interface violations; zero uncontrolled failures |
| Failure disposition | A missed threshold shall be reported as `FAIL` or `APPROVED WITH LIMITATIONS`; thresholds shall not change after official-test results are viewed |
| Licensing and claims | CC BY-NC-SA 4.0 non-commercial use; no dataset payload in Git; model/model-card attribution and non-commercial/ShareAlike notice required; no production-readiness or pipeline-domain-validation claim |
| Phase 7 dataset use and model training | **AUTHORIZED — NOT STARTED** |
| Annotation modification | **NOT AUTHORIZED** |
| Later phases | Phases 8–17 remain **NOT AUTHORIZED** |

### Phase 7 Corrective-Training Authorization

| Decision field | Entry |
|---|---|
| Decision | **CORRECTIVE TRAINING AUTHORIZED** |
| Current Phase 7 status | **FAIL - CORRECTIVE TRAINING AUTHORIZED** |
| Implementer | Nouran Ismail - AI & Algorithm Developer |
| Project Owner / authorization date | Nouran Ismail - Project Owner; 2026-09-09 |
| Observed failures | Official-test recall 0.636364 versus required >= 0.75; positive-image mean Dice 0.295946 versus required >= 0.50 |
| Threshold disposition | Approved acceptance thresholds remain unchanged and shall not be lowered |
| Input representation | Use aspect-ratio-preserving `72x192`, or a documented equivalent divisible by the network downsampling factor if MATLAB/network constraints require it |
| Alignment | Preserve image-mask alignment; segmentation masks use nearest-neighbor interpolation |
| Training | Maximum 10 epochs; validation-based early stopping with documented patience |
| Training-only augmentation | Deterministic horizontal reflection where valid, small translations, and small image-only intensity variation; no image-mask misalignment |
| Imbalance handling | Continue approved class weighting or another approved imbalance-aware loss |
| Threshold selection | Validation-only selection from a predefined grid recorded before execution |
| Candidate limit | No more than three corrective candidates, compared using training and validation data only |
| Freeze rule | Freeze architecture, weights, preprocessing, and threshold before official-test evaluation |
| Additional official-test authority | Exactly one additional evaluation after freeze; disclose the earlier two evaluations and do not describe the final result as fully blind |
| Unchanged controls | Thresholds, dataset partitions and test membership, `DetectorContract`, `DetectionResult`, and non-commercial licensing restrictions |
| Exact seven-file corrective allowlist | `extensions/intelligent-inspection/core/+iiw/+detection/deepLearningDetector.m`; `extensions/intelligent-inspection/training/train_deep_learning_detector.m`; `extensions/intelligent-inspection/models/deep_learning_detector.mat`; `extensions/intelligent-inspection/model_cards/deep_learning_detector.md`; `extensions/intelligent-inspection/datasets/deep_learning_dataset_manifest.yaml`; `tests/intelligent-inspection/test_deep_learning_detector.m`; `extensions/intelligent-inspection/evidence/deep_learning_detection_results.md` |
| Prohibited use | Official test data shall not influence training, augmentation, early stopping, threshold selection, or candidate selection |
| Later phases | Phases 8-17 remain **NOT AUTHORIZED** |

## 22. Phase 7 Project Owner Disposition and Phase 8 Authorization

| Decision field | Entry |
|---|---|
| Reviewer / date | Nouran Ismail — Project Owner; 2026-09-09 |
| Phase 7 implementation activity | **COMPLETE** |
| Developer unit verification | **PASS — 10/10** |
| Locked performance acceptance | **FAIL** |
| Project Owner decision | **NOT ACCEPTED FOR DEPLOYMENT** |
| Artifact disposition | **RETAINED AS AN EXPERIMENTAL PROTOTYPE WITH LIMITATIONS** |
| Deep-learning detector default status | **DISABLED** |
| Approved operational detector | Phase 6 conventional detector |
| Failed criteria | Precision 0.369231 versus required 0.70; F1 0.518919 versus required 0.72; positive-image mean Dice 0.480120 versus required 0.50; negative-image false-positive rate 0.183445 versus maximum 0.15 |
| Passed criteria | Recall 0.872727; interface conformance passed; controlled execution passed |
| Test exposure limitation | Three official-test exposures occurred; the final evaluation is not fully blind |
| Independent verification | **NOT REQUESTED** until performance is accepted |
| Further official KSDD2 test evaluation | **NOT AUTHORIZED** |
| Result preservation | Failed results and locked thresholds remain unchanged; the model is not production-ready and shall not be selected by default |
| Actual next phase | Phase 8 — Numerical Feature Extraction |
| Phase 8 dependency basis | May consume the approved `DetectionResult` from the accepted Phase 6 conventional detector without Phase 7 performance acceptance |
| Phase 8 status | **AUTHORIZED — NOT STARTED** |
| Phase 8 implementer | Nouran Ismail — AI & Algorithm Developer |
| Phase 8 exact allowlist | `extensions/intelligent-inspection/core/+iiw/+features/extractNumericalFeatures.m`; `extensions/intelligent-inspection/core/+iiw/+features/validateFeatureSet.m`; `tests/intelligent-inspection/test_feature_extraction.m`; `tests/intelligent-inspection/fixtures/feature_contract_fixtures.mat`; `extensions/intelligent-inspection/evidence/feature_extraction_results.md` |
| Phase 8 execution prerequisite | Project-specific feature names, units, validity rules, and extraction versions must be approved before implementation |
| Subsequent phases | Phases 9–17 remain **NOT AUTHORIZED** |

### Phase 8 Feature-Catalog Clarification Approval

| Decision field | Entry |
|---|---|
| Feature catalog | **APPROVED** |
| Approver / date | Nouran Ismail — Project Owner; 2026-09-10 |
| Source boundary | Accepted Phase 6 conventional-detector `DetectionResult`; disabled Phase 7 detector excluded from the operational path |
| Catalog | Six ordered features: detection presence, confidence, location availability, and three location coordinates |
| Runtime representation | Stable `uint16` IDs 1–6, `single` values, unchanged capacity/count representation |
| Excluded derivations | Raw images, masks, region size/shape/count, uncalibrated physical dimensions, taxonomy semantics, and version identifiers as predictors |
| Approved requirement IDs | `IIW-REQ-026` through `IIW-REQ-029` |
| Approved acceptance IDs | `IIW-AC-047` through `IIW-AC-053` |
| Versions and units | Catalog version 1; extractor version 1; `0=UNASSIGNED`, `1=DIMENSIONLESS`, `2=METRE` |
| Approved behavior | Exact no-detection and malformed/invalid-input behavior in `interface_contracts.md` |
| Limitation | The catalog contains only approved `DetectionResult` information and is not sufficient alone for predictive-maintenance training; it contains no anomaly size, degradation, vibration, temperature, current, operating time, or remaining-useful-life information |
| Reuse boundary | Generic `NumericalFeatureSet` remains the predictor input; separately governed project sensor adapters may add IDs; domain-specific names, units, and mappings remain in project configuration |
| Interface-change control | Adding anomaly area, width, height, or mask features requires separate interface-change approval |
| Phase 8 | **AUTHORIZED — NOT STARTED** |
| Phase 8 implementer | Nouran Ismail — AI & Algorithm Developer |
| Operational source | Accepted Phase 6 `DetectionResult`; Phase 7 deep-learning detector remains disabled |
| Phases 9–17 | **NOT AUTHORIZED** |
| Required approver | Nouran Ismail — Project Owner |

## 23. Phase 8 Project Owner Review and Phase 9 Planning Authorization

| Decision field | Entry |
|---|---|
| Reviewer / date | Nouran Ismail — Project Owner; 2026-09-10 |
| Phase 8 implementation | **COMPLETE** |
| Developer verification | **PASS — 14/14** |
| Project Owner review | **ACCEPTED** |
| Independent verification | **PENDING — a different named reviewer is required** |
| Phase 8 evidence basis | Approved feature IDs 1–6 occur exactly once in deterministic ascending order; catalog, extractor, and schema versions are 1; approved unit, validity, no-detection, and empty-invalid-output rules are implemented; no raw images or invented physical/degradation measurements are used |
| Phase 8 change scope | Exactly the five approved Phase 8 artifacts; no protected or later-phase artifact changed |
| Actual Phase 9 | **Predictive-Maintenance Regression** |
| Phase 9 authorization | **PLANNING/SPECIFICATION AUTHORIZED — IMPLEMENTATION AND TRAINING NOT AUTHORIZED** |
| Reusable planning boundary | Predictor contract; `NumericalFeatureSet` validation; `HealthPrediction` output; model loading and execution; uncertainty/status handling; evidence and model-card rules |
| UAV pipeline planning boundary | Separately governed pipeline feature IDs/names, units/ranges, governed synthetic dataset, health-score target, trained regression model, thresholds, and acceptance metrics |
| Current dataset status | **NOT SELECTED / NOT APPROVED**; the approved plan requires dataset governance, target, split, metrics, uncertainty method, and pass thresholds before implementation or training |
| Phase 9 implementation allowlist | `extensions/intelligent-inspection/core/+iiw/+prediction/predictHealth.m`; `extensions/intelligent-inspection/training/train_health_regression.m`; `extensions/intelligent-inspection/models/health_regression.mat`; `extensions/intelligent-inspection/model_cards/health_regression.md`; `extensions/intelligent-inspection/datasets/regression_dataset_manifest.yaml`; `tests/intelligent-inspection/test_health_prediction.m`; `extensions/intelligent-inspection/evidence/health_prediction_results.md` — all **NOT AUTHORIZED** for implementation |
| Phase 9 planning/specification allowlist | Existing generic requirements, interface contracts, acceptance criteria, implementation plan, this ECR, and team configuration only; no new file |
| Phase 9 planning assignment | **SUPERSEDED by the approved Phase 9A/9B amendment in Section 24** |
| Later phases | Phases 10–17 remain **NOT AUTHORIZED** |

## 24. Approved Phase 9A/9B Planning Amendment

| Decision field | Entry |
|---|---|
| Amendment status | **APPROVED** |
| Approver / date | Nouran Ismail — Project Owner; 2026-09-10 |
| Primary demonstration | UAV pipeline inspection; no motor, pump, or bearing project is introduced |
| Phase 9A | Reusable Health-Prediction Framework; generic predictor contract, feature-set validation, replaceable execution, exact `HealthPrediction`, context/horizon, uncertainty/status, model identity/version, generic tests and evidence |
| Phase 9B | UAV Pipeline Predictive-Maintenance Demonstration; `PipelineFeatureAdapter`, IDs 101–115, governed synthetic data, 30-day `[0,100]` health target, regression comparison, project model card/tests/evidence |
| Synthetic-data limitation | “Integration and workflow demonstration only; not evidence of real pipeline prognostic accuracy or production readiness.” |
| Proposed requirements | `IIW-REQ-030` through `IIW-REQ-037` |
| Proposed acceptance criteria | `IIW-AC-054` through `IIW-AC-065` |
| Phase 9A implementation | **AUTHORIZED — NOT STARTED**; implementer Nouran Ismail — AI & Algorithm Developer; exact six-file allowlist in the approved plan |
| Phase 9B disposition | **APPROVED IN PRINCIPLE BUT NOT AUTHORIZED FOR IMPLEMENTATION**; synthetic-data generation, training, and evaluation remain prohibited until Phase 9A passes and is accepted |
| Mandatory controls | Freeze/version generator equations and noise before generation; allocate groups before data-dependent transformation; zero cross-partition groups; isolate test from selection/tuning/calibration; keep calibration separate from selection; prohibit future-target leakage through prior health; treat location as non-causal context; bound predictions to `[0,100]`; controlled invalid/review status for unsupported/OOD input; disclaimer in every Phase 9B dataset/model-card/evidence artifact |
| Phases 10–17 | **NOT AUTHORIZED** |
| Required next decision | Project Owner Phase 9A implementation-evidence review after authorized implementation and developer verification; Phase 9B remains blocked |

## 25. Phase 9A Review and Approved Simplified Phase 9B Clarification

| Decision field | Entry |
|---|---|
| Reviewer / date | Nouran Ismail — Project Owner; 2026-09-13 |
| Phase 9A implementation | **COMPLETE** |
| Phase 9A developer verification | **PASS — 16/16** |
| Phase 9A Project Owner review | **ACCEPTED** |
| Phase 9A independent verification | **PENDING — a different named reviewer is required** |
| Phase 9A evidence basis | Exactly six authorized artifacts changed; `PredictorContract` is replaceable; `NumericalFeatureSet` and the eleven-field `HealthPrediction` are validated; controlled invalid, execution-failure, and out-of-distribution behavior exists; no project model or dataset was introduced; protected artifacts remained unchanged |
| Phase 9B simplified-plan decision | **APPROVED** by Nouran Ismail — Project Owner on 2026-09-13 |
| Phase 9B implementation | **AUTHORIZED — NOT STARTED** |
| Implementer | Nouran Ismail — AI & Algorithm Developer |
| Dataset | Generator version 1; seed `20260910`; 100 synthetic pipeline-section groups; six chronological observations per group; 600 observations; deterministic group-safe 70/15/15 split yielding 70/15/15 groups and 420/90/90 observations; test untouched until freeze |
| Generator freeze | All version-1 formulas, coefficients, distributions, clipping rules, missing-data rules, and noise parameters recorded in the approved plan are frozen by this approval, shall be recorded in the dataset manifest, and shall not be tuned after viewing test results |
| Target | Synthetic health score bounded to `[0,100]` at a 30-day horizon |
| Active predictors | Feature IDs 101–103 and 106–115; IDs 104–105 remain catalogued but are excluded from causal regression input |
| Model | Ridge linear regression with fixed `Lambda=0.1`; median-target baseline is reference-only; no ensemble, model comparison, hyperparameter search, Regression Learner, or conformal prediction |
| Predictor preprocessing | Training-only column means and standard deviations; zero standard deviation replaced by `1`; values stored in the model and applied unchanged to validation, test, and future inputs |
| Metrics and uncertainty | MAE, RMSE, R-squared, `uncertainty=min(validationRMSE/100,1)`, zero interface violations, and zero uncontrolled failures; `validationRMSE` stored in the model and test excluded from uncertainty calculation |
| Dependencies | Statistics and Machine Learning Toolbox and Predictive Maintenance Toolbox are installed, license-available, and approved for the authorized Phase 9B scope |
| Exact Phase 9B allowlist | `extensions/intelligent-inspection/configurations/uav-pipeline/PipelineFeatureAdapter.m`; `extensions/intelligent-inspection/configurations/uav-pipeline/pipeline_feature_catalog.yaml`; `extensions/intelligent-inspection/training/generate_pipeline_degradation_dataset.m`; `extensions/intelligent-inspection/datasets/pipeline_degradation_dataset_manifest.yaml`; `extensions/intelligent-inspection/datasets/generated/pipeline_degradation_synthetic.mat`; `extensions/intelligent-inspection/training/train_pipeline_health_regression.m`; `extensions/intelligent-inspection/models/pipeline_health_regression.mat`; `extensions/intelligent-inspection/model_cards/pipeline_health_regression.md`; `tests/intelligent-inspection/test_pipeline_health_prediction.m`; `extensions/intelligent-inspection/evidence/pipeline_health_prediction_results.md` |
| Mandatory limitation | “Integration and workflow demonstration only; not evidence of real pipeline prognostic accuracy or production readiness.” |
| Later phases | Phases 10–17 remain **NOT AUTHORIZED** |
| Remaining review assignment | A different named independent verifier must be assigned before independent verification |

## 26. Approved Phase 9B Corrective Repair

| Decision field | Approved entry |
|---|---|
| Approver / date | Nouran Ismail — Project Owner; 2026-09-13 |
| Phase 9B | **FAIL — CORRECTIVE REPAIR APPROVED**; Phase 9B remains failed until corrective execution passes |
| Root cause | Synthetic generator invariant violation: version 1 may emit `locationAvailable=true` while `detectionPresent=false`, contrary to the approved implication `locationAvailable=true` only when `detectionPresent=true`. |
| Approved rule | Generator version 1.1 shall compute `locationAvailable = detectionPresent && locationAvailableCandidate;`. |
| Corrective implementation | **AUTHORIZED — NOT STARTED** |
| Additional permitted test exposure | **Exactly 1** after the corrected generator, regenerated dataset, retrained model, preprocessing, and thresholds are frozen |
| Execution boundary | Regenerate the dataset and retrain because input data changes; then freeze the corrected candidate before the one additional final test-partition evaluation. |
| Exact future allowlist | Unchanged ten Phase 9B artifact paths recorded in Section 25; no file is added. |
| Preserved controls | Feature meanings; interface contracts; all existing tests; seed `20260910`; 100 groups; six observations per group; group-safe 70/15/15 split; ridge `Lambda=0.1`; training-only standardization; approved uncertainty formula; locked performance thresholds; mandatory disclaimer. |
| Evidence history | Original test exposure and its failed interface result remain recorded; deletion, concealment, suppression, or reclassification is prohibited. |
| Tuning restriction | Previous test metrics shall not influence generator, model, feature, preprocessing, uncertainty, or threshold choices. |
| Protected scope | Phase 9A and verified UAV artifacts remain unchanged. Phases 10–17 remain **NOT AUTHORIZED**. |
| Decision | **APPROVED**; corrective execution is limited to the existing ten Phase 9B paths |

## 27. Phase 9B Corrective Project Owner Review

| Review field | Decision |
|---|---|
| Reviewer / date | Nouran Ismail — Project Owner; 2026-09-13 |
| Evidence basis | Existing saved generator, manifest, model card, model artifact hashes, test definition, corrective developer report, and Git scope inspection; MATLAB, generation, training, and tests were not rerun for this review |
| Phase 9B implementation | **COMPLETE** |
| Corrective developer verification | **PASS — 14/14** |
| Performance acceptance | **PASS** — MAE 0.677789, RMSE 0.833918, R-squared 0.995110, zero interface-schema violations, and zero uncontrolled failures |
| Project Owner review | **ACCEPTED** |
| Generator and data | Version 1.1; seed `20260910`; 100 groups; six observations each; 600 rows; group-safe 70/15/15 split; zero cross-partition groups; zero location/detection invariant violations |
| Model controls | Ridge `Lambda=0.1`; training-only standardization; predictions bounded to `[0,100]`; `uncertainty=min(validationRMSE/100,1)` |
| Exposure history | Original failed exposure and corrective exposure both disclosed; additional test-partition evaluations remaining: **0** |
| Test integrity | No test was weakened, removed, suppressed, or bypassed |
| Artifact scope | Exactly the ten approved Phase 9B artifacts changed; Phase 9A and verified UAV artifacts remained unchanged |
| Independent verification | **PENDING — different named reviewer required** |
| Model classification | **DEMONSTRATION ONLY — NOT PRODUCTION READY** |
| Later phases | Phases 10–17 remain **NOT AUTHORIZED**; this review authorizes no subsequent phase |

## 28. Independent Reviewer Assignment and Phase 10 Readiness

### Independent reviewer assignment

| Assignment field | Recorded decision |
|---|---|
| Project Owner / date | Nouran Ismail; 2026-09-13 |
| Reviewer | Yahya Helmy |
| Role | Independent Verification & Validation Engineer |
| Assignment status | **ASSIGNED** |
| Scope | Independent verification of the intelligent-inspection extension |
| Independence | Yahya Helmy did not implement the intelligent-extension artifacts |
| Verification decision | **PENDING** until Yahya Helmy reviews the evidence and executes the approved verification procedure |
| Decision restriction | No independent `PASS`, Project Owner final acceptance, or baseline decision is recorded by this assignment |

### Phase 10 readiness

| Readiness field | Result |
|---|---|
| Phase | Phase 10 — Risk Assessment |
| Status | **SUPERSEDED BY THE APPROVAL AND AUTHORIZATION IN SECTION 29** |
| Satisfied prerequisite | Required upstream contracts are accepted |
| Unresolved decisions | **RESOLVED** by the Project Owner decision dated 2026-09-13 in Section 29 |
| Existing exact allowlist | `extensions/intelligent-inspection/core/+iiw/+risk/assessRisk.m`; `extensions/intelligent-inspection/core/+iiw/+risk/validateRiskPolicy.m`; `extensions/intelligent-inspection/config/risk_policy_schema.yaml`; `tests/intelligent-inspection/test_risk_assessment.m`; `extensions/intelligent-inspection/evidence/risk_assessment_results.md` |
| Required next decision | Superseded; Phase 10 is authorized in Section 29 |
| Later phases | Phases 11–17 remain **NOT AUTHORIZED** |

## 29. Approved Phase 10 Risk Policy and Authorization

| Decision field | Approved record |
|---|---|
| Project Owner / decision date | Nouran Ismail; 2026-09-13 |
| Policy clarification | **APPROVED** — risk policy version 1 |
| Phase 10 | **AUTHORIZED — NOT STARTED** |
| Implementer | Nouran Ismail — AI & Algorithm Developer |
| Policy owner/reviewer | Nouran Ismail — Project Owner / Lead Systems Engineer |
| Independent verifier | Yahya Helmy — Independent Verification & Validation Engineer; decision **PENDING** |
| Risk levels | `0=UNKNOWN`; `1=LOW`; `2=MEDIUM`; `3=HIGH`; `4=REVIEW_REQUIRED` |
| Evidence sufficiency | Conforming successful `HealthPrediction`; valid health estimate and uncertainty; valid model identity/version; nonempty valid feature/evidence references; accepted quality when supplied; valid detection confidence when supplied |
| Confidence policy | `predictionConfidence=1-uncertainty`; uncertainty `<=0.20` and confidence `>=0.80` accepted inclusively; invalid values require review |
| Health policy | With sufficient evidence: `<50=HIGH`; `>=50 && <80=MEDIUM`; `>=80=LOW` |
| Priority | Invalid/malformed; missing/rejected evidence; excessive uncertainty/low confidence; high; medium; low — first applicable rule wins |
| Conservative fallback | `REVIEW_REQUIRED`; autonomous action prohibited; human review required; safety command none |
| Rationale codes | `0=NONE`; `1=HEALTH_LOW_RISK`; `2=HEALTH_MEDIUM_RISK`; `3=HEALTH_HIGH_RISK`; `10=INVALID_INPUT`; `11=MISSING_EVIDENCE`; `12=QUALITY_REJECTED`; `13=LOW_CONFIDENCE`; `14=EXCESSIVE_UNCERTAINTY`; `15=UNSUPPORTED_STATUS`; `16=UNSUPPORTED_POLICY_VERSION`; `17=INTERNAL_ASSESSMENT_FAILURE` |
| Safety boundary | Advisory only; cannot command `MissionSupervisor`, `ReturnToHome`, or `SafeLanding`, self-approve, bypass `HumanApprovalGate`, or create an autonomous mission-changing action |
| Exact Phase 10 allowlist | `extensions/intelligent-inspection/core/+iiw/+risk/assessRisk.m`; `extensions/intelligent-inspection/core/+iiw/+risk/validateRiskPolicy.m`; `extensions/intelligent-inspection/config/risk_policy_schema.yaml`; `tests/intelligent-inspection/test_risk_assessment.m`; `extensions/intelligent-inspection/evidence/risk_assessment_results.md` |
| Required tests/targets | `IIW-TST-RISK-001` through `IIW-TST-RISK-007`; 100% decision-table conformance; decision/condition coverage 100% or documented structural infeasibility |
| Later phases | Phases 11–17 remain **NOT AUTHORIZED** |
| Implementation status | No Phase 10 implementation artifact was created or modified by this authorization record |

## 30. Phase 10 Independent Verification and Project Owner Acceptance

| Review field | Recorded decision |
|---|---|
| Independent reviewer | Yahya Helmy — Independent Verification & Validation Engineer |
| Review date | 2026-09-14 |
| Review method | Review of the existing Phase 10 implementation, saved developer test evidence, coverage results, and source-level structural-infeasibility arguments; no MATLAB or test rerun is claimed |
| Phase 10 implementation | **COMPLETE** |
| Developer verification | **PASS — 10/10** |
| Decision-table conformance | **PASS — 100%** |
| Decision coverage | **40/40 = 100%** |
| Condition coverage | **194/196 = 98.98%** |
| MC/DC | **96/98 = 97.96%** |
| Corrective production scope | Production implementation unchanged during corrective testing; no coverage filtering or suppression |
| Residual 1 | **ACCEPTED AS STRUCTURALLY INFEASIBLE:** `prediction.featureSetId == 0` cannot be true after `validatePrediction` succeeds because that validation requires `featureSetId ~= 0` |
| Residual 2 | **ACCEPTED AS STRUCTURALLY INFEASIBLE:** `confidence < policy.minimumConfidence` cannot be true when evaluated because the right operand is reached only for uncertainty `<=0.20`, and `confidence=1-uncertainty` therefore guarantees confidence `>=0.80` |
| Coverage assessment | **ACCEPTED WITH TWO STRUCTURALLY INFEASIBLE OUTCOMES** |
| Independent verification decision | **PASS** |
| Project Owner acceptance | **APPROVED** — Nouran Ismail, Project Owner, 2026-09-14 |
| Phase 10 final status | **COMPLETE, VERIFIED AND ACCEPTED** |
| Later phases | Phase 11 and Phases 12–17 remain **NOT AUTHORIZED** |

## 31. Approved Phase 11 HumanApprovalGate Policy and Authorization

| Decision field | Approved record |
|---|---|
| Project Owner / date | Nouran Ismail; 2026-09-14 |
| Phase 11 policy | **APPROVED** — version 1 |
| Phase 11 | **AUTHORIZED — NOT STARTED** |
| Implementer | Nouran Ismail — AI & Algorithm Developer |
| Policy owner / safety reviewer | Nouran Ismail — Project Owner / Lead Systems Engineer |
| Independent verifier | Yahya Helmy — Independent Verification & Validation Engineer; decision **PENDING** |
| States | `0=MISSING`; `1=PENDING`; `2=DEFERRED`; `3=REJECTED`; `4=EXPIRED`; `5=APPROVED`; only valid `APPROVED` is forwarding-eligible |
| Authorized roles | `1=INSPECTION_OPERATOR`; `2=MAINTENANCE_ENGINEER`; `3=SAFETY_REVIEWER` |
| Timing | Pending/deferred exactly 300 seconds remains waiting; greater expires. Approval is valid through exactly 900 seconds after decision; greater expires. |
| Delegation | One level only when enabled, identities are nonzero/distinct, role authorized, and reference/audit evidence complete; nested or invalid delegation blocks forwarding |
| Escalation | Review indication only; cannot approve or issue an operational/safety command |
| External safety | Authenticated external indication has priority, asserts `safetyBypass`, immediately blocks recommendation forwarding, and is not generated, selected, modified, or delayed by the gate |
| Conservative fallback | Forwarding blocked; human review required; no autonomous action; no safety command |
| Audit | Request/recommendation IDs, policy/state, identity/role, decision/evaluation/valid-until times, delegation/delegator, escalation, eligibility, rationale, and safety-bypass disposition |
| Exact allowlist | `extensions/intelligent-inspection/core/+iiw/+approval/evaluateApproval.m`; `extensions/intelligent-inspection/models/human_approval_gate.slx`; `extensions/intelligent-inspection/config/approval_policy_schema.yaml`; `tests/intelligent-inspection/test_human_approval_gate.m`; `extensions/intelligent-inspection/evidence/human_approval_gate_results.md` |
| Tests/targets | `IIW-TST-APR-001` through `IIW-TST-APR-010`; approval-state conformance 100%; decision/condition coverage 100% or independently reviewed structural infeasibility |
| Exclusion | No external authentication infrastructure; supplied identity and role evidence is validated only |
| Later phases | Phases 12–17 remain **NOT AUTHORIZED** |

| Implementation status | No Phase 11 implementation artifact was created or modified by this authorization record |

## 32. Phase 11 Rationale-Code and Audit-Schema Clarification

| Decision field | Approved record |
|---|---|
| Project Owner / date | Nouran Ismail; 2026-09-14 |
| Rationale-code clarification | **APPROVED** — one real, finite scalar `uint16` code; highest-priority applicable code only; approved codes `0`, `20` through `39` as defined in `architecture/interface_contracts.md` |
| Audit-schema clarification | **APPROVED** — exactly 18 fixed-size implementation-local fields with approved identifier, version, timestamp, state, role, evidence-reference, and logical representations |
| External safety rationale | `20=EXTERNAL_SAFETY_ACTIVE`; unconditional highest priority |
| Internal failure rationale | `38=INTERNAL_EVALUATION_FAILURE` |
| Successful approval rationale | `29=APPROVAL_VALID_AND_CURRENT` |
| Audit fallback | Missing or invalid mandatory audit content sets `auditValid=false`, blocks forwarding, requires review, and cannot approve or issue/delay safety behavior |
| External interface impact | **NONE** — all approved architecture interface schemas remain unchanged |
| Previous implementation blocker | **RESOLVED** |
| Phase 11 | **AUTHORIZED AND READY TO EXECUTE — NOT STARTED** |
| Exact allowlist | Unchanged five paths recorded in Section 31 and the approved implementation plan |
| Later phases | Phases 12–17 remain **NOT AUTHORIZED** |
| Execution status | No Phase 11 implementation artifact was created or modified; MATLAB and tests were not run |

## 33. Phase 11 Independent Verification and Final Acceptance

| Decision field | Recorded result |
|---|---|
| Independent reviewer | Yahya Helmy — Independent Verification & Validation Engineer |
| Review date and method | 2026-09-15; reviewed saved implementation, test, and coverage evidence; MATLAB tests were not independently rerun |
| Developer verification | **PASS — 16/16** |
| Approval-state decision-table conformance | **100%** |
| Structural coverage | Statements 174/180 = 96.67%; functions 15/15 = 100%; decisions 106/112 = 94.64%; conditions 323/358 = 90.22%; MC/DC 144/179 = 80.45% |
| Evidence integrity | No test removed, suppressed, or weakened; complete failure and corrective history retained |
| Safety and forwarding review | External safety remains highest priority; only valid current `APPROVED` decisions permit forwarding; no direct MissionSupervisor or safety-command endpoint |
| Schema review | Exact implementation-local audit schema and rationale codes preserved |
| Residual coverage | Not claimed structurally infeasible |
| Coverage-deviation basis | Accepted based on 100% approval-state decision-table conformance, complete safety-priority and boundary-state testing, deterministic conservative fallback, and no autonomous or safety-command output |
| Coverage deviation | **ACCEPTED** |
| Independent verification decision | **PASS WITH ACCEPTED COVERAGE DEVIATION** |
| Phase 11 implementation | **COMPLETE** |
| Project Owner acceptance | **APPROVED — Nouran Ismail, 2026-09-15** |
| Phase 11 final status | **COMPLETE, VERIFIED AND ACCEPTED** |
| Later phases | Phases 12–17 remain **NOT AUTHORIZED** |

## 34. Approved Phase 12 Evidence Policy and Authorization

| Decision field | Approved record |
|---|---|
| Project Owner / date | Nouran Ismail; 2026-09-15 |
| Phase 12 evidence policy | **APPROVED** |
| Phase 12 | **COMPLETE, VERIFIED AND ACCEPTED** |
| Implementer | Nouran Ismail — Integration & Tooling Lead, with AI & Algorithm Developer responsibility |
| Independent verifier | Yahya Helmy — Independent Verification & Validation Engineer; decision **PASS**, 2026-09-16; saved-evidence review, MATLAB not independently rerun |
| Store boundary | Generic injected append-only writer; deterministic in-memory test double; no database, cloud service, filesystem location, or project-specific store in the reusable core |
| Identifiers/references | Nonzero immutable `uint32` record and transaction IDs; fixed `uint32 [16 1]` zero-padded references; duplicate/orphan/self/circular references invalidate the chain |
| Chain completeness | Mandatory stage/component, actor/component, reference, version, timestamp, outcome/failure, integrity, and policy/schema metadata with consistent transaction-stage order |
| Integrity | Deterministic SHA-256 over canonical content excluding the digest; implementation-local digest `uint8 [32 1]`, referenced by unchanged external `integrityMetadata` |
| Access | Roles 1–2 submit; role 3 submit/review; role 4 read/review; invalid roles rejected; supplied role evidence only |
| Retention | Default 365 days; `retentionHold=true` prevents deletion eligibility; Phase 12 records eligibility and deletes nothing |
| Failure | Persistence failure recorded explicitly; success not recorded; no fabricated ID, timestamp, digest, or outcome; no autonomous, mission, or safety command |
| Privacy | No credentials, personal names, secrets, tokens, or raw payload by default; project raw-data retention requires separate approval |
| Safety boundary | Observational only; cannot change upstream decisions, command MissionSupervisor, modify a safety command, or turn failure into success |
| Exact allowlist | `extensions/intelligent-inspection/core/+iiw/+evidence/recordEvidence.m`; `extensions/intelligent-inspection/core/+iiw/+evidence/validateEvidenceChain.m`; `extensions/intelligent-inspection/config/evidence_policy_schema.yaml`; `tests/intelligent-inspection/test_evidence_recording.m`; `extensions/intelligent-inspection/evidence/evidence_recorder_results.md` |
| Tests/targets | `IIW-TST-EVD-001` through `IIW-TST-EVD-006`; mandatory identifiers 100%; orphan references zero; synthetic-success records under failure zero |
| External interface impact | **NONE** — approved `EvidenceRecord` schema unchanged |
| Developer verification | **PASS — 20/20**; function coverage 17/17 (100%); statement coverage 146/162 (90.12%); decision/condition coverage unavailable as a tool limitation, not claimed as 100% |
| Corrective history | Preserved: initial 16/20; first `hasCycle` indexing defect; transitive-closure repair; second shared-workspace loop-variable collision; unique loop-variable repair; final 20/20 |
| Project Owner acceptance | **APPROVED — Nouran Ismail, 2026-09-16** |
| Later phases | Phases 13–17 remain **NOT AUTHORIZED** |
| Execution status | Phase 12 implementation **COMPLETE**; independently verified **PASS** and Project Owner accepted |
