# /modify-feature Workflow

## Trigger
Use when editing an existing screen, logic, or adding fields.

## Step 1 — Impact Analysis (Mandatory before coding)
Inspect the files and state:
- **WILL CHANGE:** [List files and specific functions]
- **MIGHT BE AFFECTED:** [Routes, DI, or sibling widgets]
- **WILL NOT TOUCH:** [Out of scope files]
*(Wait for user confirmation if the change alters existing architecture).*

## Step 2 — Minimal Implementation
- Modify only the required layer.
- Never refactor unrelated methods.
- Preserve existing UX and screen parameters.