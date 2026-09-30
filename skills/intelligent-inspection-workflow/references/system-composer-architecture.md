# Logical Architecture Guidance

Use this reference only after the governing workflow authorizes architecture work. The approved component and interface specifications remain authoritative; this document describes a reusable procedure for realizing and reviewing them.

## Inputs

- Approved requirements and acceptance criteria
- Approved component definitions and logical interface contracts
- Current ECR and implementation-plan allowlist
- Product approval and availability evidence
- Project-selected configuration boundaries

Stop if a component, interface, dependency, or generated companion artifact falls outside the approved scope.

## Logical Component Set

Keep these responsibilities separate unless an approved architecture decision says otherwise:

1. `InspectionSource`
2. `DataQualityValidation`
3. `Preprocessing`
4. `Detection`
5. `FeatureExtraction`
6. `HealthPrediction`
7. `RiskAssessment`
8. `HumanApprovalGate`
9. `RecommendedAction`
10. `EvidenceRecorder`

The logical architecture defines responsibilities, ports, interfaces, and connections. Behavioral algorithms and project policy values belong to later authorized work.

## Architecture Procedure

1. Create a requirement-to-component allocation draft using stable identifiers.
2. Define each component’s responsibility, required inputs, outputs, and explicit failure output.
3. Assign one named, versioned contract to every exchange; do not use unnamed connections.
4. Connect the analysis path from source through recommendation while keeping evidence observation independent of decision authority.
5. Verify that `HealthPrediction` accepts numerical features and no raw payload.
6. Verify that `HumanApprovalGate` controls recommendation eligibility but not external safety execution.
7. Verify that `RecommendedAction` emits advisory records only.
8. Bind project taxonomies, thresholds, units, implementations, policies, and action mappings through configuration or adapters.
9. Record tool release, architecture version, contract versions, and artifact hash.

## Source Replacement

Real, recorded, and simulated sources shall expose the same mandatory `InspectionData` and `InspectionMetadata` contracts. Environment-specific or transport-specific fields belong in adapter metadata. Replacing a source must not change downstream component ports or mandatory field semantics.

## Contract Evolution

- Give every contract an explicit schema version.
- Treat new optional fields as backward-compatible only when defaults and absence behavior are documented.
- Treat renamed, removed, or semantically changed mandatory fields as controlled interface changes.
- Reassess all producers, consumers, adapters, verification cases, and evidence readers after a contract change.

## Review Evidence

Record the component inventory, port-to-contract matrix, connection matrix, requirement allocations, configuration boundary, unresolved interface decisions, diagnostics permitted by the active plan, and artifact hashes. Never claim architecture execution or validation that was not performed.

Authoritative specifications:

- [Component definitions](../../../extensions/intelligent-inspection/architecture/component_definitions.md)
- [Interface contracts](../../../extensions/intelligent-inspection/architecture/interface_contracts.md)
- [Acceptance criteria](../../../extensions/intelligent-inspection/acceptance_criteria.md)
