# Assumptions and Limitations

**Associated ECR:** ECR-20260906-001

**Status:** APPROVED — Gate 2 on 2026-09-06

## Assumptions

- Project owners provide lawful, licensed, representative, and access-controlled data.
- Each project approves its taxonomy, units, thresholds, confidence semantics, action mapping, and operating envelope.
- Source and context clocks can be related through project-defined synchronization or recorded uncertainty.
- Calibration and source identity are available when required by the selected quality policy.
- Human approvers are authenticated, authorized, and accountable under project policy.
- External safety mechanisms operate independently from the inspection approval path.
- Configuration and model versions are immutable for a recorded transaction.
- Product approval and product availability are managed as separate facts.

## Limitations

- No dataset, label set, trained model, metric threshold, achieved performance, or verification result is provided in this phase.
- Generic requirements cannot establish project fitness without representative project data and approved acceptance thresholds.
- Confidence values are not assumed to be calibrated until calibration evidence is reviewed.
- Distribution shift, novel conditions, adversarial inputs, and sensor degradation cannot be eliminated; they require monitoring and conservative disposition.
- Human approval introduces latency and availability constraints but cannot block an external safety response.
- The future simulation adapter establishes interface scalability only; it does not establish real-world equivalence.
- Cybersecurity, privacy, retention, and regulatory obligations require project-specific assessment.
- System Composer and algorithm implementation choices remain subject to an approved implementation plan.

## Decisions Required Before Gate 3

- Named Systems Engineer, implementer, and different named Independent Verification Engineer.
- Requirements format and later migration/traceability strategy.
- Approved optional-product set after availability inspection.
- Dataset governance owner and permitted data sources.
- Project-specific metric thresholds and confidence/uncertainty policy.
- Approval authority, timeout, expiry, escalation, and audit policy.
- Evidence store, integrity method, and retention policy.

## Gate 2 Approved Decisions

- The first System Composer implementation shall be a logical architecture containing components, ports, interfaces, and connections.
- Optional MATLAB product availability remains `NOT VERIFIED` until an authorized preflight check is performed.
- Dataset source, licensing, splitting, and versioning require approval before training.
- Project metrics, thresholds, and anomaly classes require approval before training.
- Approval timeout and escalation policies shall be defined before implementing `HumanApprovalGate`.
- The verified `MissionSupervisor` remains unchanged; any future modification to its interface requires a separate ECR.
- A named independent verifier, different from the implementer, shall be assigned before verification.
# Phase 13 planning limitation

The authorized UAV Pipeline Configuration is limited to RGB/fisheye camera output and simulation context metadata from the pregenerated MathWorks example “Simulate Simple Flight Scenario and Sensor in Unreal Engine Environment.” MATLAB R2026a, Simulink, UAV Toolbox, Simulink 3D Animation, and Computer Vision Toolbox are installed, licensed, and approved. The example was acquired through the approved official mechanism, verified available outside Git, and used read-only. It shall remain external under the MATLAB-managed Examples directory and shall not be modified, repackaged, redistributed, committed, or copied into the repository. The demonstration is not evidence of real-world inspection, anomaly-detection, pipeline-condition, flight, or production readiness and does not validate camera realism, domain transfer, environmental robustness, anomaly taxonomy completeness, flight behavior, or MissionSupervisor compatibility. No direct UAV or MissionSupervisor integration is authorized.

## Phase 16 adapter-only limitation

The Phase 16 authorization dated 2026-09-17 uses the already installed official MathWorks example and `uav_simple_flight_model.slx` only as an external read-only compatibility reference or optional read-only runtime source. It authorizes no new or modified environment, scene, vehicle, sensor, model, Unreal project, support package, external asset, copied simulation output, or MissionSupervisor connection. Deterministic representative virtual frames and metadata live only inside the authorized test file. The adapter demonstrates source-contract scalability, not simulation realism, AI performance, flight behavior, safety behavior, or production readiness.
