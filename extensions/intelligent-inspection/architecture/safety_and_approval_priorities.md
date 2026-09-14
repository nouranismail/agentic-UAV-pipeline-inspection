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

The representation of decisions, status, validity, identifiers, and timestamps is defined in `interface_contracts.md`. The Phase 4 interface-ambiguity blocker was resolved by its recorded clarification; subsequent phase dispositions are controlled by the ECR and implementation plan.

## Approved Phase 10 Risk-Assessment Priority

**Decision:** APPROVED by Nouran Ismail — Project Owner on 2026-09-13. **Risk policy version:** `1`.

Evidence is sufficient only when the input `HealthPrediction` conforms to its approved schema; prediction status is valid and successful; its estimate (`healthValue`) is valid and within `[0,100]`; uncertainty is valid and within `[0,1]`; model identity and version are valid; required feature/evidence references are valid and nonempty; upstream quality is accepted when supplied; and upstream detection confidence is valid when detection is supplied. Missing, malformed, rejected, or contradictory evidence is insufficient.

| Priority | Condition | Risk level | Required rationale |
|---:|---|---|---|
| 1 | Invalid or malformed input | `REVIEW_REQUIRED` | `INVALID_INPUT`, or the applicable unsupported-status/version/internal-failure code |
| 2 | Missing or rejected evidence | `REVIEW_REQUIRED` | `MISSING_EVIDENCE` or `QUALITY_REJECTED` |
| 3 | Uncertainty `>0.20` or confidence `<0.80` | `REVIEW_REQUIRED` | `EXCESSIVE_UNCERTAINTY` or `LOW_CONFIDENCE` |
| 4 | Valid `healthValue < 50` | `HIGH` | `HEALTH_HIGH_RISK` |
| 5 | Valid `healthValue >= 50 && healthValue < 80` | `MEDIUM` | `HEALTH_MEDIUM_RISK` |
| 6 | Valid `healthValue >= 80` | `LOW` | `HEALTH_LOW_RISK` |

No lower-priority rule may override a higher-priority rule. Boundaries `uncertainty=0.20`, confidence `0.80`, and `healthValue=0`, `50`, `80`, and `100` are accepted as specified. Unsupported status/policy, missing fields, nonfinite/out-of-range values, or internal assessment failure conservatively produces `REVIEW_REQUIRED`, prohibits autonomous action, requires human review, and issues no safety command.

`RiskAssessment` is advisory only. It cannot command `MissionSupervisor`, `ReturnToHome`, or `SafeLanding`; approve its own recommendation; bypass `HumanApprovalGate`; or produce an autonomous mission-changing action. External safety response retains unconditional priority.

## Approved Phase 11 Human-Approval Priority

**Decision:** APPROVED by Nouran Ismail — Project Owner on 2026-09-14. **Policy version:** `1`.

| Priority | Condition | Forwarding | Disposition |
|---:|---|---:|---|
| 1 | Authenticated external safety indication active | No | Assert `safetyBypass`; do not delay, generate, select, or modify the external safety response |
| 2 | Malformed input, invalid identity/role/reference/version/timestamp/delegation, or internal failure | No | Controlled invalid result; human review required |
| 3 | Missing approval | No | `MISSING` |
| 4 | Pending/deferred beyond 300 seconds | No | `EXPIRED`; escalation/review indication only |
| 5 | `PENDING`, `DEFERRED`, `REJECTED`, or `EXPIRED` | No | Preserve the supplied/derived nonapproving state |
| 6 | `APPROVED` but outside its 900-second validity | No | `EXPIRED` |
| 7 | Valid, matched, authorized, unexpired `APPROVED` | Yes | Advisory forwarding eligibility only |

No state may self-convert to `APPROVED`. Rejection and expiration require a new request; deferral remains reviewable only until timeout. One delegation level is permitted only when enabled, both identities are nonzero and different, the delegated role is authorized, and reference/audit fields are complete. Nested or invalid delegation blocks forwarding.

External safety authority remains outside the intelligent workflow and with the verified `MissionSupervisor`. `safetyBypass` blocks recommendation forwarding but does not carry, generate, select, modify, or delay a safety command.
