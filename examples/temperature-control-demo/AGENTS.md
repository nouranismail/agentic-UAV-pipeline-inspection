# Temperature Control Demo Instructions

This directory inherits the repository-level `AGENTS.md`.

## Mandatory skill

Use the unchanged shared skill:

`../../skills/simulink-engineering-workflow/SKILL.md`

## Required sequence

1. Read
2. Plan
3. Edit
4. Verify
5. Test
6. Review
7. Report

## Project rules

- Keep all temperature-specific semantics inside this directory.
- Do not modify the reusable skill for this demonstration.
- Preserve the 18-degree heater threshold.
- Implement the high-temperature alarm at an inclusive 35-degree boundary.
- Run regression and new-requirement tests.
- Do not report PASS without executed test evidence.
- A different named reviewer must perform independent verification.
- Do not modify UAV, MissionSupervisor, or intelligent-inspection artifacts.
