# Phase 12 Evidence Recording Developer Results

**ECR:** ECR-20260906-001  
**Implementer:** Nouran Ismail — Integration & Tooling Lead, with AI & Algorithm Developer responsibility  
**Independent verifier:** Yahya Helmy — decision PENDING

## Scope

Phase 12 implements only the generic injected evidence-writer boundary, evidence-record creation, chain validation, integrity, access, retention metadata, privacy checks, and controlled persistence failure behavior. It does not connect to an external database, cloud service, fixed filesystem location, MissionSupervisor, or any command authority.

## Implementation summary

- Result status: PASS — 20/20; PENDING PROJECT OWNER AND INDEPENDENT REVIEW
- Initial executable test result: 19 passed, 1 failed, 0 incomplete out of 20
- Initial coverage: functions 16/16 (100%); statements 141/157 (89.8%)
- Mandatory identifier result: 100% for the accepted valid-chain scenarios
- Orphan-reference result: zero for valid chains; the isolated orphan scenario was detected as required
- Synthetic-success-under-failure result: zero synthetic success records under injected persistence failure
- Warnings/errors and execution history:
  1. The first launch executed zero tests because a second local `classdef` was illegal in the test-file layout. The in-memory writer was replaced with a stateful function-handle test double inside the same allowlisted file.
  2. The first executable run produced 19 passed, 1 failed, 0 incomplete; `circularReferenceIsRejected` failed. Coverage was functions 16/16 (100%) and statements 141/157 (89.8%).
  3. A vectorized closure repair did not resolve the cycle count: 19/20 passed; coverage was functions 16/16 (100%) and statements 143/159 (89.93%).
  4. A directed-graph attempt was incompatible with the runtime call form and produced 16 passed, 4 failed, 0 incomplete; coverage was functions 16/16 (100%) and statements 141/154 (91.55%).
  5. Dependency-free topological traversal attempts produced 17/20 and then 16/20 passing results. The latest measured coverage was functions 17/17 (100%) and statements 155/172 (90.11%).
  6. The remaining failing scenarios are valid multistage chain, self-reference count, circular-reference count, and incorrect-stage-order count. Referenced-chain validation enters controlled internal fallback (`failureCode=8`), so mandatory-ID and zero-orphan acceptance cannot be claimed.
  7. No test was removed, suppressed, or weakened. Temporary diagnostic warning instrumentation was removed. Further execution stopped under the repository stop condition after repeated relevant failures.
- Independent verification: PENDING

## Authorized corrective-repair result — 2026-09-16

- Temporary diagnostic instrumentation exposed the hidden exception as `Index exceeds the number of array elements` at `validateEvidenceChain/hasCycle`, on the `incoming(candidate)` lookup. The maximum valid index was 2 for multirecord chains and 1 for the single-record self-reference. The exception occurred after reference extraction and before a chain result could be returned.
- The attempted smallest repair replaced only the dimension-sensitive Kahn-style degree-vector traversal in `hasCycle` with a bounded logical transitive-closure traversal. The evidence policy, external `EvidenceRecord` schema, tests, expected outcomes, reference extraction, and stage-order rules were unchanged.
- The single authorized post-repair run still produced 16 passed, 4 failed, 0 incomplete. Valid multistage, self-reference, circular-reference, and incorrect-stage-order scenarios continued to enter controlled internal fallback (`failureCode=8`). The attempted repair therefore did not resolve the full underlying defect.
- Post-repair coverage actually available: functions 17/17 (100%); statements 149/162 (91.97%). Decision and condition coverage were not produced by this MATLAB source-coverage run and are not claimed.
- The isolated orphan-reference, duplicate-identifier, injected persistence-failure, deterministic SHA-256, and no-command-authority scenarios passed. Mandatory-identifier completeness for a valid referenced chain remains unaccepted because that scenario entered fallback.
- No test was removed, suppressed, weakened, or rewritten. Temporary diagnostic instrumentation was removed before the post-repair run.
- Per the approved stop condition, no further production edit or MATLAB execution was performed after the failed post-repair run.

## Second-exception isolated diagnosis — 2026-09-16

- Isolated test: `test_evidence_recording/validMultistageChainHasCompleteIdentifiers`
- Selection count: 1; isolated result: 0 passed, 1 failed, 0 incomplete. The full suite was not run.
- Identifier: `MATLAB:badsubscript`
- Message: `Index in position 2 exceeds array bounds. Index must not exceed 2.`
- Exact failing source during the instrumented run: `validateEvidenceChain.m`, line 83, `reachable(source,target)` in `hasCycle`.
- Call path: `validateEvidenceChain.m:83` -> `validateEvidenceChain.m:37` -> `test_evidence_recording.m:31`.
- Input records: `struct [1 2]`; policy: `struct [1 1]`.
- Record 1 references: `uint32 [16 1]`; reference count: `uint8 [1 1] = 0`.
- Record 2 references: `uint32 [16 1]`; reference count: `uint8 [1 1] = 1`.
- Unexpected graph input at failure: `adjacency` was `logical [21 2]`, although two records require a `2 x 2` adjacency matrix.
- Demonstrated root cause: the parent record loop uses `k`, while nested `calculateDigest` also uses `k` for its 21 canonical fields. Because the helper is nested in the parent function's shared workspace, digest calculation leaves parent `k` at 21. The subsequent `adjacency(k,parent)=true` expands the matrix from `2 x 2` to `21 x 2`; `hasCycle` then uses 21 as its row/node count and indexes beyond column 2. This request did not repair that variable-collision/function-boundary defect.
- Controlled behavior was preserved: the catch still returned `failureCode=8` with the unchanged schema.
- Temporary `catch ME`, diagnostic printing, report capture, stack printing, and shape printing were removed after the isolated run. The production catch is restored to anonymous controlled fallback.

Full captured exception report:

```text
Index in position 2 exceeds array bounds. Index must not exceed 2.

Error in iiw.evidence.validateEvidenceChain/hasCycle (line 83)
    reachable(source,target) = reachable(source,target) || ...
Error in iiw.evidence.validateEvidenceChain (line 37)
    validation.circularReferenceCount = uint16(hasCycle(adjacency));
Error in test_evidence_recording/validMultistageChainHasCompleteIdentifiers (line 31)
    validation = iiw.evidence.validateEvidenceChain([firstStored secondStored],policy());
Error in matlab.unittest.TestRunner/evaluateMethodCore (line 864)
Error in matlab.unittest.TestRunner/evaluateMethodsOnTestContent (line 801)
Error in matlab.unittest.TestRunner/runTestMethodCore (line 980)
Error in matlab.unittest.TestRunner/runTestCore (line 952)
Error in matlab.unittest.TestRunner/repeatTest (line 396)
Error in matlab.unittest.TestRunner/runSharedTestCase (line 337)
Error in matlab.unittest.TestRunner/runTestClass (line 1252)
Error in matlab.unittest.plugins.TestRunnerPlugin/runTestClass (line 66)
Error in matlab.unittest.plugins.testrunprogress.ConciseProgressPlugin/runTestClass (line 68)
Error in matlab.unittest.plugins.TestRunnerPlugin/runTestClass (line 66)
Error in sltest.plugins.TestManagerResultsPlugin/runTestClass (line 148)
Error in matlab.unittest.TestRunner/runTestSuite (line 1176)
Error in matlab.unittest.plugins.TestRunnerPlugin/runTestSuite (line 38)
Error in matlab.unittest.plugins.DiagnosticsOutputPlugin/runTestSuite (line 73)
Error in matlab.unittest.plugins.TestRunnerPlugin/runTestSuite (line 38)
Error in matlab.unittest.plugins.DiagnosticsRecordingPlugin/runTestSuite (line 79)
Error in matlab.unittest.plugins.TestRunnerPlugin/runTestSuite (line 38)
Error in sltest.plugins.TestManagerResultsPlugin/runTestSuite (line 134)
Error in matlab.unittest.TestRunner/evaluateMethodOnPlugins (line 254)
Error in matlab.unittest.internal.SerialTestRunStrategy/runTestSuite (line 36)
Error in matlab.unittest.internal.SerialTestRunStrategy/runSession (line 16)
Error in matlab.unittest.TestRunner/runSession (line 1133)
Error in matlab.unittest.plugins.TestRunnerPlugin/runSession (line 33)
Error in matlab.unittest.plugins.DiagnosticsOutputPlugin/runSession (line 58)
Error in matlab.unittest.plugins.TestRunnerPlugin/runSession (line 33)
Error in sltest.plugins.TestManagerResultsPlugin/runSession (line 122)
Error in matlab.unittest.TestRunner/evaluateMethodOnPlugins (line 254)
Error in matlab.unittest.TestRunner/doRunWithFcn (line 242)
Error in matlab.unittest.TestRunner/run (line 138)
Error in matlab.unittest.TestSuite/run (line 147)
```

## Authorized second corrective repair — 2026-09-16

- Repair scope was identifier-only. No algorithm, interface, policy, schema, or expected test result changed.
- Parent traversal `k` was renamed to `recordIndex`; parent reference `j` was renamed to `referenceIndex`.
- Transitive-closure indices were renamed from `pivot`, `source`, and `target` to `pivotIndex`, `sourceIndex`, and `targetIndex`.
- The colliding digest loop `k` was renamed to `fieldIndex`, including both `ordered(fieldIndex)` references.
- Shared-workspace inspection found no remaining reuse of these parent traversal variables across nested helpers.
- Adjacency dimension invariant: initialization is `false(numel(records))`; `recordIndex` is bounded by `1:numel(records)` and the located parent index is bounded by the same record inventory. Therefore the repaired code keeps adjacency exactly `N x N`. The two-record valid chain completed without fallback, confirming the prior `21 x 2` expansion no longer occurred.
- Isolated verification step 1: `validMultistageChainHasCompleteIdentifiers` passed 1/1.
- Isolated verification step 2: `selfReferenceIsRejected`, `circularReferenceIsRejected`, and `incorrectStageOrderIsRejected` passed 3/3.
- Complete `test_evidence_recording.m` result: 20 passed, 0 failed, 0 incomplete.
- Final source coverage actually available: functions 17/17 (100%); statements 146/162 (90.12%). The available source-coverage provider did not produce decision or condition coverage; neither is claimed.
- Acceptance checks retained: valid multistage chain passed; self, circular, and stage-order counts passed; valid-chain orphan count was zero; mandatory identifiers were complete; injected persistence failure produced zero synthetic success records; deterministic SHA-256 tests passed; no autonomous, mission, approval, or safety-command output was present.
- Both diagnosed exceptions, all earlier failed results, and the full corrective history above remain part of this evidence.
- No test was removed, suppressed, weakened, or modified during this repair.
- Independent verification remains PENDING.

## Safety and privacy boundary

The recorder is observational. It emits no autonomous, mission, approval, or safety command. Records use numeric actor/component identifiers and metadata/references; raw inspection payloads, personal names, credentials, secrets, and authentication tokens are prohibited by the generic input validation.

## Developer status

**PASS — 20/20; PENDING PROJECT OWNER AND INDEPENDENT REVIEW.** This is developer evidence only. Independent verification has not been performed and remains PENDING.
