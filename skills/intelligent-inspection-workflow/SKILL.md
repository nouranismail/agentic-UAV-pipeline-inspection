---
name: intelligent-inspection-workflow
description: Extend an approved MATLAB and Simulink engineering change with governed, application-independent inspection architecture, data, AI, approval, verification, and evidence procedures.
---

# Intelligent-Inspection Workflow

Use this skill for inspection systems that combine image or sensor data, replaceable analysis implementations, numerical prediction, human approval, and traceable evidence.

## Governing Workflow

This skill extends [the Simulink engineering workflow](../simulink-engineering-workflow/SKILL.md). Read and follow that workflow first. Its role declaration, Gates 1–6, scope controls, implementation evidence, independent review, and final acceptance remain authoritative. This skill neither duplicates those controls nor grants approval.

Before work, read the approved project requirements, architecture, interfaces, configuration, ECR, implementation plan, dependency record, and relevant templates. Stop when the active gate, role assignment, dependency approval, dataset authority, or exact artifact allowlist is missing or conflicting.

## Extension Sequence

Within the authorized work package, use this sequence:

1. Read governing and project artifacts.
2. Confirm scope, role, branch, baseline, allowed files, exclusions, and current gate.
3. Assess requirements impact and preserve stable identifiers and acceptance criteria.
4. Define architecture boundaries, contracts, replaceable components, and external authorities.
5. Approve dataset provenance, license, ownership, version, split, and leakage controls.
6. Assess source-data quality before analysis.
7. Apply versioned preprocessing while preserving source provenance.
8. Execute an approved replaceable detection implementation.
9. Extract validated numerical features.
10. Produce an implementation-independent health prediction with uncertainty.
11. Assess risk using approved, versioned project policy.
12. Obtain human approval before a recommendation can cause an operational change.
13. Integrate only through approved advisory interfaces; safety-critical authority remains external to experimental AI.
14. Verify normal, uncertain, invalid, degraded, rejected, timeout, unavailable, and failure behavior.
15. Freeze the candidate and hand it to a different named independent reviewer.
16. Preserve traceability and evidence, then report only observed results.

Never fabricate a dataset, checkout, training run, test result, metric, traceability link, reviewer identity, or approval.

## Reference Routing

- For component boundaries, ports, contracts, connection rules, and architecture evolution, read [system-composer-architecture.md](references/system-composer-architecture.md).
- For real, recorded, or simulated sources, dataset governance, and quality disposition, read [inspection-source-and-data-quality.md](references/inspection-source-and-data-quality.md).
- For preprocessing and replaceable conventional or learned detection, read [vision-and-preprocessing.md](references/vision-and-preprocessing.md).
- For numerical features, health prediction, regression metrics, confidence, and uncertainty, read [features-regression-and-uncertainty.md](references/features-regression-and-uncertainty.md).
- For risk, approval, advisory integration, evidence, verification, independent review, and reporting, read [human-approval-integration-and-evidence.md](references/human-approval-integration-and-evidence.md).

Read only the references needed for the authorized task.

## Reusable and Project-Selected Boundaries

Reusable artifacts define procedures, generic contracts, required evidence, failure handling, and governance invariants. Project configuration supplies source bindings, taxonomies, units, thresholds, operating slices, selected implementations, model versions, risk policy, approver assignments, validity intervals, and recommendation mappings.

Do not move project selections into this skill. Product availability is evidence, not approval; an available product cannot be used until the active plan authorizes it.

## Templates

Use the applicable repository template without treating placeholders as evidence:

- [Intelligent-inspection project](../../templates/templates/intelligent_inspection_project_template.md)
- [Dataset governance](../../templates/templates/dataset_governance_template.md)
- [Model card](../../templates/templates/model_card_template.md)
- [AI verification report](../../templates/templates/ai_verification_report_template.md)

Incomplete fields remain `PENDING` or `NOT APPLICABLE` with a rationale. They must never be converted into inferred approvals or results.

## Mandatory Stops

Stop and escalate for an unapproved dataset or use right; split leakage; missing model or data version; undefined metric threshold; unacceptable quality; low confidence without an approved disposition; missing approval policy; attempted direct safety-critical command; broken traceability; unavailable evidence; candidate change during independent review; or any required artifact outside the approved allowlist.
