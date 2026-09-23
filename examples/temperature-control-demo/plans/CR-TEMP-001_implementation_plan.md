# CR-TEMP-001 Implementation Plan

## Read

Read the root agent instructions, the shared workflow skill, this example's
configuration, requirements, and change request.

## Plan

Create a deterministic discrete Simulink model with:

- One double input: `temperatureC`.
- A `Compare To Constant` block using `< 18`.
- One logical output: `heaterRequest`.
- A second `Compare To Constant` block using `>= 35`.
- One logical output: `highTemperatureAlarm`.

## Edit

Use `models/build_temperature_controller.m` to generate the model
reproducibly. Do not modify shared workflow or UAV artifacts.

## Verify and test

Run `tests/test_temperature_controller.m`.

Test values:

| Temperature | Heater | Alarm |
|---:|---:|---:|
| 10.0 | true | false |
| 17.0 | true | false |
| 17.9 | true | false |
| 18.0 | false | false |
| 25.0 | false | false |
| 34.9 | false | false |
| 35.0 | false | true |
| 40.0 | false | true |

## Review

A different named reviewer checks requirements, model structure, executed test
results, scope isolation, and unchanged shared artifacts.

## Report

Record actual test totals and limitations in
`reports/reusability_demo.md`. No PASS may be recorded from expected results
alone.

## Rollback

Remove this example directory. No shared artifact is changed.
