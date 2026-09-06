# Risk, Human Approval, Integration, and Evidence

Use this reference when recommendations can affect supervised operation, or when planning verification, independent review, and reporting.

## Risk Assessment

Risk assessment consumes only valid, versioned upstream evidence and an approved project policy. Record the consumed evidence, policy version, risk level, optional score, confidence status, and rationale codes. Missing mandatory evidence, rejected quality, low confidence, excessive uncertainty, or unavailable components shall select the approved conservative disposition and prevent autonomous action.

## Human Approval Policy

Before implementing an approval gate, the Project Owner shall approve:

- Authorized roles and authenticated identity requirements
- Request ownership and delegation rules
- Approval, rejection, deferral, withdrawal, and expiration semantics
- Timeout duration and boundary behavior
- Escalation and unavailable-approver behavior
- Validity interval and stale-decision handling
- Comments, rationale, audit, retention, and evidence requirements

Only an approved, unexpired decision may make an advisory recommendation eligible for forwarding. Missing, pending, deferred, rejected, expired, invalid-identity, and timeout states shall block forwarding and be recorded.

## External Authority Boundary

Experimental AI shall not issue a direct safety-critical command. Safety-critical authority remains in an independent, approved deterministic mechanism. Approval waiting, analysis delay, unavailable evidence, or workflow failure shall not block, delay, mask, or replace an external safety response.

## Integration

- Integrate through versioned generic contracts and project-owned adapters.
- Keep recommendation types and mappings in approved project configuration.
- Validate approval status, validity interval, evidence references, confidence status, and configuration version before forwarding.
- Reject stale, incomplete, unauthorized, or unmapped recommendations.
- Treat any new endpoint, interface, dependency, or generated artifact outside the implementation plan as scope expansion.

## Verification Evidence

Plan evidence for:

- Normal and boundary behavior
- Low confidence and excessive uncertainty
- Invalid, incomplete, degraded, and rejected input
- Missing or unavailable components
- Approval pending, deferred, rejected, expired, invalid, and timeout behavior
- Evidence-store and integration failure
- External safety priority
- Deterministic repetition where applicable
- Replaceable source, detector, and predictor conformance

Record test or analysis ID, requirement and acceptance-criterion IDs, candidate version, dataset and split versions, model versions, configuration, environment, stimulus, expected result, observed result, disposition, logs, and evidence paths. Do not hide failed criteria or create placeholder traceability links to nonexistent artifacts.

## Independent Review and Reporting

After developer evidence is complete, freeze and hash the candidate. A different named individual shall declare independence, inspect the native evidence, reproduce approved checks where permitted, record findings, and issue exactly one allowed independent decision. A separate AI session does not establish independence, and the implementer cannot self-approve.

Report developer completion, independent verification, and final acceptance as separate statuses. Record assumptions, deviations, limitations, residual risks, failures, missing evidence, and corrective-action ownership. Never label generated or developer-reviewed evidence as independently verified.

Use the [AI verification report template](../../../templates/templates/ai_verification_report_template.md) and the repository’s existing independent-review and change-report templates.
