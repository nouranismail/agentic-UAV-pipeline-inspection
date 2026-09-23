# Temperature Control Workflow Reuse Demo

This small Simulink project demonstrates that the repository's unchanged
`skills/simulink-engineering-workflow/SKILL.md` can be reused outside the UAV
domain.

## Change demonstrated

Baseline behavior:

- `heaterRequest = true` when `temperatureC < 18`.
- `heaterRequest = false` when `temperatureC >= 18`.

Authorized change:

- Add `highTemperatureAlarm`.
- The alarm is true when `temperatureC >= 35`.
- The alarm is false when `temperatureC < 35`.
- Preserve the accepted heater behavior.

## Reuse boundary

The reusable skill remains at the repository root and is not copied or
modified. Temperature-specific requirements, configuration, implementation,
tests, and evidence remain inside this example.

## Build and test in MATLAB

From the repository root:

```matlab
demoRoot = fullfile(pwd,"examples","temperature-control-demo");
addpath(fullfile(demoRoot,"models"));
build_temperature_controller(demoRoot);

results = runtests(fullfile(demoRoot,"tests","test_temperature_controller.m"));
disp(table(results))

fprintf("TEMP_COUNTS passed=%d failed=%d incomplete=%d total=%d\n", ...
    sum([results.Passed]),sum([results.Failed]), ...
    sum([results.Incomplete]),numel(results));
```

Expected result:

```text
TEMP_COUNTS passed=8 failed=0 incomplete=0 total=8
```

After execution, record the actual result in
`reports/reusability_demo.md`. Do not claim PASS before running MATLAB.

## Demonstrated workflow

Read → Plan → Edit → Verify → Test → Review → Report
