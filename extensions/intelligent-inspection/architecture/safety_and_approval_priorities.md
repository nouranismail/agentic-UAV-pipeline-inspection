# Safety and Approval Priorities

**Associated ECR:** ECR-20260906-001

**Status:** APPROVED — Gate 2 on 2026-09-06

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
