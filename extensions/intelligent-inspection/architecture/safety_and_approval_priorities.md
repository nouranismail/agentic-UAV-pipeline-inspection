# Safety and Approval Priorities

**Associated ECR:** ECR-20260906-001

**Baseline status:** APPROVED — Gate 2 on 2026-09-06

**Clarification status:** APPROVED — Nouran Ismail, Project Owner, 2026-09-06

## Priority Order

1. An external safety response has unconditional priority over inspection analysis, recommendations, and approval waiting.
2. Invalid or rejected-quality data prevents autonomous action and requires reacquisition or review.
3. Low-confidence or excessive-uncertainty output prevents autonomous action and requires reacquisition or review.
4. A mission-changing recommendation requires an explicit, valid approval decision.
5. Only an approved, unexpired recommendation may be forwarded to a project adapter.
6. AI output remains advisory and shall not directly command a safety-critical action.
7. Evidence recording captures the disposition without delaying higher-priority safety behavior.

## Approval-State Behavior

| State | Forward recommendation? | Required disposition |
|---|---:|---|
| Missing request | No | Record configuration/process failure. |
| Pending | No | Continue waiting or expire according to policy; do not block external safety. |
| Deferred | No | Request additional evidence or later review. |
| Rejected | No | Record rejection and rationale. |
| Expired | No | Require a new assessment and request. |
| Approved and valid | Yes, advisory only | Forward through the project-specific mapping and preserve approval evidence. |

## First-Application Boundary

For the first project configuration, the verified `MissionSupervisor` remains unchanged and authoritative for flight-safety behavior. Intelligent recommendations cannot directly command `SafeLanding`; any future interface change to that supervisor requires a separate approved ECR. Approval delay or inspection-workflow failure cannot delay an existing supervisor safety response.

## Approved Approval-Authority Boundary Clarification

1. `HumanApprovalGate.approvalRequestOut` produces `ApprovalRequest` and connects to architecture output `approvalRequestOut`.
2. Architecture input `approvalDecisionIn` carries `ApprovalDecision` from an external accountable approval authority to `HumanApprovalGate.approvalDecisionIn`.
3. `HumanApprovalGate` shall not create, infer, or self-issue an approval decision.
4. The gate may expose the externally received decision to `RecommendedAction` and `EvidenceRecorder`, but behavioral validation remains outside this clarification phase.
5. Architecture output `recommendedActionOut` carries advisory `RecommendedAction` only.
6. No approval, recommendation, or evidence port is a safety-critical command interface.
7. Approval waiting and evidence persistence remain outside the external safety-response path.

The representation of decisions, status, validity, identifiers, and timestamps is defined in `interface_contracts.md`. The interface-ambiguity blocker is **RESOLVED**, and Phase 4 is **AUTHORIZED AND READY TO EXECUTE**. Phases 5–17 remain **NOT AUTHORIZED**.
