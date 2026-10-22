# /debug-issue Workflow

## Trigger
Use when fixing a crash, UI glitch, or state issue.

## Diagnosis Matrix
- **UI_WRONG:** Inspect widget tree → check missing `ScreenUtil` (.w/.h/.sp) or hardcoded styling.
- **STATE_ISSUE:** Trace all `emit()` in Cubit → verify `buildWhen` in `BlocBuilder` / `BlocSelector`.
- **API_FAILURE:** Check `api_endpoints.dart` → verify null-safety in Model `fromJson` via `JsonHelper`.
- **CRASH:** Trace call stack → pinpoint line → apply minimum fix.

## Rule
Provide Root Cause report, change only the failing file, and add `// Fix: [short explanation]`.