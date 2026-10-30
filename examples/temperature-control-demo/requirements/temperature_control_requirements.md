# Temperature Control Requirements

## TEMP-REQ-001 — Heater activation

The controller shall set `heaterRequest` to true when
`temperatureC < 18`.

## TEMP-REQ-002 — Heater deactivation

The controller shall set `heaterRequest` to false when
`temperatureC >= 18`.

## TEMP-REQ-003 — High-temperature alarm activation

The controller shall set `highTemperatureAlarm` to true when
`temperatureC >= 35`.

## TEMP-REQ-004 — High-temperature alarm deactivation

The controller shall set `highTemperatureAlarm` to false when
`temperatureC < 35`.

## TEMP-REQ-005 — Interface

| Signal | Direction | Type | Unit |
|---|---|---|---|
| `temperatureC` | Input | double scalar | degree Celsius |
| `heaterRequest` | Output | logical scalar | dimensionless |
| `highTemperatureAlarm` | Output | logical scalar | dimensionless |

## TEMP-REQ-006 — Reuse isolation

The temperature demonstration shall use the unchanged shared engineering
workflow. Temperature-specific logic shall not be added to the reusable skill.
