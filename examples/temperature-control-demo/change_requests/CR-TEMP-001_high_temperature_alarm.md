# CR-TEMP-001 — Add High-Temperature Alarm

## Status

IMPLEMENTATION PREPARED — MATLAB VERIFICATION PENDING

## Purpose

Demonstrate reuse of the same agentic MATLAB/Simulink engineering workflow in
a second engineering domain.

## Requested change

Add a logical scalar output named `highTemperatureAlarm`.

- True when `temperatureC >= 35`.
- False when `temperatureC < 35`.
- Preserve the existing heater behavior at the 18-degree boundary.

## In scope

- Temperature-specific requirements
- Reproducible Simulink model builder
- Regression and boundary tests
- Reusability evidence

## Out of scope

- Changes to the shared skill
- UAV or MissionSupervisor changes
- Intelligent-inspection changes
- AI, computer vision, or predictive maintenance
- Hardware deployment

## Authorized paths

Only paths under:

`examples/temperature-control-demo/`

## Acceptance

- Eight tests pass.
- Zero failed or incomplete tests.
- Heater behavior is unchanged.
- Alarm boundary is inclusive at 35 degrees.
- Shared skill and UAV artifacts remain unchanged.
- Independent review is recorded after executed evidence exists.
