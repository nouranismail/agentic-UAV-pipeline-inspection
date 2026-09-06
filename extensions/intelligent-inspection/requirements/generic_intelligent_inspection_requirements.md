# Generic Intelligent-Inspection Requirements

**Associated ECR:** ECR-20260906-001

**Status:** APPROVED — Gate 2 on 2026-09-06

**Scope:** Application-independent inspection workflow

These requirements define observable behavior and governance constraints. They do not prescribe algorithms, datasets, trained models, or performance claims.

| ID | Requirement statement | Rationale | Objective acceptance criterion |
|---|---|---|---|
| IIW-REQ-001 | The workflow shall accept inspection data and acquisition metadata through a versioned inspection-source contract. | Allows sources to be replaced without changing downstream components. | Contract inspection confirms mandatory payload reference, modality, source identifier, timestamp, sequence identifier, and schema version fields. |
| IIW-REQ-002 | When inspection data is received, the workflow shall validate payload availability, schema conformance, metadata completeness, and configured quality measures before analysis. | Prevents unsuitable inputs from reaching analysis components. | Every submitted item produces exactly one quality result containing status, measured values, configured thresholds, and reason codes. |
| IIW-REQ-003 | If data quality is rejected, the workflow shall prevent autonomous action generation from that data and shall request reacquisition or review. | Enforces fail-controlled behavior for unsuitable evidence. | A rejected quality result produces no actionable recommendation and produces a recorded reacquisition-or-review disposition. |
| IIW-REQ-004 | When quality validation passes, preprocessing shall produce a versioned processed-data reference and transformation record without altering the source record. | Preserves provenance and reproducibility. | Each processed output references its source item and records the ordered transformations and configuration version. |
| IIW-REQ-005 | The detection capability shall be replaceable through a common detection contract. | Supports interchangeable conventional and learned implementations. | Two conforming mock implementation descriptions can be substituted without changing the consuming interface definitions. |
| IIW-REQ-006 | Where a learned detection implementation is selected, it shall publish model identity, version, input contract, output contract, and confidence semantics. | Prevents opaque model substitution. | The model record contains all five fields and is linked by identifier from every corresponding detection result. |
| IIW-REQ-007 | Detection results shall identify the analyzed item, detected label identifiers, confidence values, and optional location information using the generic detection contract. | Makes results traceable and application-neutral. | Contract validation accepts complete results and rejects missing analyzed-item, label, confidence, or schema fields. |
| IIW-REQ-008 | Feature extraction shall convert validated analysis results into a numerical feature set with names, values, units or unitless declarations, validity indicators, and extractor version. | Establishes an auditable boundary before numerical prediction. | Every emitted feature is numeric and has a name, validity indicator, and unit declaration; the set records extractor version. |
| IIW-REQ-009 | Health prediction shall consume numerical feature sets and shall not consume raw inspection payloads. | Keeps regression interfaces deterministic and reviewable. | Static interface review finds only a numerical-feature input and no raw-payload input on the prediction contract. |
| IIW-REQ-010 | Each health prediction shall report its estimate, applicable horizon or context, uncertainty representation, feature-set reference, and model version. | Supports interpretation and reproducibility. | Schema validation rejects any prediction missing one of the required fields. |
| IIW-REQ-011 | Risk assessment shall combine valid quality, detection, feature, prediction, and uncertainty evidence according to versioned project configuration. | Separates evidence interpretation from individual algorithms. | Every risk result identifies all consumed evidence records, configuration version, risk level, score if configured, and rationale codes. |
| IIW-REQ-012 | If prediction confidence is below its approved threshold or uncertainty exceeds its approved limit, the workflow shall request reacquisition or review and shall prevent autonomous action generation. | Prevents weak predictions from driving unsupervised change. | Boundary scenarios at, above, and below configured limits produce the approved review/reacquisition disposition and no autonomous action when limits are violated. |
| IIW-REQ-013 | A recommendation capable of changing supervised operation shall require an explicit approval decision before it becomes eligible for forwarding. | Retains accountable human authority. | Pending, rejected, expired, or missing approval states prevent forwarding; only an approved, unexpired decision permits forwarding. |
| IIW-REQ-014 | The workflow shall not issue a direct safety-critical command. | Keeps safety authority outside probabilistic analysis. | Interface and action-catalog review confirms outputs are advisory recommendation records and contain no direct safety-command endpoint. |
| IIW-REQ-015 | A pending approval shall not block, delay, mask, or replace an external safety response. | Preserves independent safety priority. | Priority analysis demonstrates that every external safety-response path bypasses approval waiting and remains executable. |
| IIW-REQ-016 | Recommended actions shall identify recommendation type, parameters, evidence references, confidence status, approval status, validity interval, and configuration version. | Makes recommendations bounded and auditable. | Contract validation rejects recommendations missing any mandatory field. |
| IIW-REQ-017 | The evidence recorder shall preserve source, quality, processing, model, feature, prediction, risk, approval, recommendation, configuration, and software-version identifiers. | Enables end-to-end traceability. | For each completed workflow transaction, an evidence-chain query resolves every applicable stage identifier without an orphan reference. |
| IIW-REQ-018 | The workflow shall record failures, rejected inputs, unavailable components, and approval timeouts without fabricating replacement evidence. | Ensures transparent failure handling. | Each injected failure category produces an explicit failure record and no synthesized success record. |
| IIW-REQ-019 | Generic workflow artifacts shall remain free of first-application classes, commands, thresholds, and asset semantics. | Protects reuse across domains. | Automated terminology/configuration review finds project semantics only in project-specific configuration or adapter artifacts. |
| IIW-REQ-020 | Project configuration shall supply label taxonomies, thresholds, action mappings, units, and source-adapter bindings without modifying generic component contracts. | Separates reusable behavior from application choices. | Two project configurations bind to the same unchanged generic contracts and component definitions. |
| IIW-REQ-021 | A real source and a simulated source shall use the same inspection-source contract. | Supports later source replacement. | Contract conformance review shows identical required fields, directions, and semantics for both adapters. |
| IIW-REQ-022 | A simulation environment shall provide data and context through an adapter and shall not contain the inspection AI implementation. | Prevents coupling analysis logic to the environment. | Architecture review locates analysis components outside the environment boundary and confirms communication only through the source contract. |
| IIW-REQ-023 | The workflow shall maintain traceability from each approved requirement to component or procedure, verification case, result, and reviewed evidence. | Supports controlled acceptance. | Traceability review reports no missing mandatory link in the approved scope. |
| IIW-REQ-024 | The same reusable workflow version shall support at least two distinct inspection configurations without core-file modification. | Provides measurable reuse evidence. | Repository comparison shows both configurations use the same core artifact hashes and differ only in approved configuration/adapters. |
| IIW-REQ-025 | Product availability shall be recorded independently from product approval status. | Prevents an approval record from becoming a false installation claim. | Every dependency entry contains separate governance-status and availability-status fields, with availability limited to `AVAILABLE`, `UNAVAILABLE`, or `NOT VERIFIED`. |

## Gate 2 Review

| Field | Entry |
|---|---|
| Decision | **APPROVED** |
| Approver | Nouran Ismail — Project Owner |
| Approval date | 2026-09-06 |
| Comments | Approved for implementation-plan preparation only under ECR-20260906-001. Model implementation, MATLAB execution, training, and testing remain unauthorized pending Gate 3. |
