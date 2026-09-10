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
