# workwise — Project Rules

<!--
Golden Test:
"Would removing this rule cause the agent to make mistakes?"
If not, cut it.
Only encode project-specific decisions and rules that override defaults.
-->

---

## Project Overview

This is a **Flutter workwise app** (`workwise`).

---

## Workflows Protocol (SOPs)
Before writing or modifying any code, the agent MUST inspect the relevant workflow in `.agents/workflows/` and adhere strictly to its execution order:
- Creating a new feature → Read & follow `.agents/rules/create-feature.md` (also available as `/create-feature`)
- Connecting mock to real API → Read & follow `.agents/workflows/connect-api.md`
- Modifying existing screen/logic → Read & follow `.agents/workflows/modify-feature.md`
- Fixing bugs or unexpected behavior → Read & follow `.agents/workflows/debug-issue.md`
- Ingesting an API collection → Read & follow `.agents/workflows/api-collection.md`

The corresponding on-demand Agent Skills are available as `/create-feature`,
`/connect-api`, `/modify-feature`, `/debug-issue`, and `/api-collection`.

Any response violating these workflows will be rejected.

# Section A — General Engineering Rules

## 1) Architecture

* Follow **Clean Architecture** with feature-based organization:
  `presentation → domain → data`.
* Never bypass layers or mix responsibilities.
* **Presentation:** UI, user interaction, and state observation only — no business logic.
* **Domain:** business rules, entities, repository contracts, and use cases.
* **Data:** APIs, databases, storage, serialization, and external services.
* Read existing code and follow established project patterns before introducing new abstractions.

## 2) Shared Code

* Check `core/` before creating shared code.
* Only place code in `core/` when it is genuinely reusable or project-wide.
* Reuse existing utilities and components instead of duplicating them.

## 3) Error Handling

* Keep error handling within the established architecture.
* Translate external exceptions into the project's error system under `core/errors/` at the Data layer.
* Never expose raw exceptions to Presentation.
* Handle loading, empty, success, and error states where applicable.

## 4) Change Discipline

* Make the smallest change that solves the problem.
* Fix root causes rather than symptoms.
* Preserve existing behavior, APIs, flows, and UX unless explicitly asked to change them.
* Do not refactor unrelated code.
* Avoid unnecessary file or architecture changes.

## 5) Dependencies

* Do not add a package when Flutter/Dart or an existing dependency already solves the problem.
* Add dependencies only when there is a clear project need.
* Prefer stable and well-maintained packages.

## 6) Security

* Never hardcode secrets, credentials, tokens, or API keys.
* Never log sensitive information.
* Validate external input where appropriate.
* Flag security issues when discovered.

## 7) Testing

* Add focused tests for important Domain and Data logic.
* Bug fixes should include a regression test when practical.
* Tests must be deterministic and behavior-focused.

---

# Section B — Flutter & Dart Rules

## 1) State Management

* Use **Cubit/Bloc** for feature and application state.
* Do not use Riverpod, Provider, GetX, ChangeNotifier, or ValueNotifier.
* Use `setState` only for simple local UI state.
* Cubits depend on **Use Cases**, never directly on Repositories or Data Sources.
* Use `BlocBuilder`/`BlocSelector` at the smallest widget scope that needs the state.
* Prefer `sealed class` for Cubit/Bloc states when it improves state safety and exhaustive handling.

## 2) Domain Purity

* Domain must have **zero Flutter imports**.
* Domain must not depend on APIs, databases, storage, or external-service implementations.

## 3) Dependency Injection

* Use **GetIt** as the only service locator.
* Register dependencies in:
  `core/services/service_locator.dart`
* Register Data Sources, Repository implementations, Use Cases, Cubits, and application services as needed.
* Prefer constructor injection.

## 4) Routing

* Use **GoRouter** under `lib/core/routing/`.
* Keep authentication redirects centralized.

## 5) Design System

* Use the centralized design system under:
  `lib/core/design_system/`
* Reuse existing design-system components before creating new generic widgets.
* Do not hardcode repeated colors, spacing, radii, or typography values.
* Feature-specific widgets belong inside their feature's `presentation/widgets/`.

## 6) Widget & Build Discipline

* Prefer `const` constructors wherever possible.
* Never create `TextEditingController`, `AnimationController`, `FocusNode`, or other lifecycle-dependent objects inside `build()`.
* Dispose controllers and focus nodes properly.
* Keep widgets and functions small and focused.
* Prefer composition over large widgets.

## 7) Performance

* Use builder-based widgets such as `ListView.builder` and `GridView.builder` for large or dynamic collections.
* Minimize unnecessary rebuilds using `const`, `BlocSelector`, and appropriate widget boundaries.
* Do not optimize prematurely without a real performance concern.

## 8) Code Generation

* `build_runner` is allowed only for the project's existing `json_serializable` / `json_annotation` setup.
* Do not introduce Freezed or other code-generation solutions.

---

# Section C — Data & External Services

## 1) Backend Agnostic

The architecture must not depend on a specific backend or external service.

External-service-specific code belongs in the **Data layer** only.

```text
UI → Cubit → Use Case → Repository Contract → Repository Impl → Data Source → External Service
```

Never access external services directly from Screens, Widgets, Cubits, or Domain.

## 2) Serialization

* Serialization and deserialization belong in the Data layer.
* Models belong under `data/models/`.
* Entities belong under `domain/entities/`.
* Follow the project's existing serialization approach.

---

# Section D — Project Structure & Conventions

## 1) Folder Structure

```text
lib/
├── core/
│   ├── design_system/
│   ├── errors/
│   ├── routing/
│   ├── services/
│   └── utils/
│
├── features/
│   └── <feature_name>/
│       ├── data/
│       │   ├── datasource/
│       │   ├── models/
│       │   └── repo/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repo/
│       │   └── usecases/
│       └── presentation/
│           ├── cubit/
│           ├── screens/
│           └── widgets/
│
└── main.dart
```

* Follow this structure for new features.
* Do not introduce alternative structures such as `common/`, `shared/`, or `helpers/` when an existing project location already fits.

## 2) Naming

* Files: `snake_case.dart`
* Classes: `PascalCase`
* Variables/functions: `camelCase`
* Private members: `_prefixed`
* Constants: `camelCase`

## 3) Code Quality

* Follow Effective Dart and `flutter_lints`.
* Use `final` for immutable fields.
* Prefer `const` where possible.
* Reuse existing code before creating new utilities.

---

# Section E — Accessibility & Localization

## 1) Accessibility

* Use `Semantics` when necessary, especially for icon-only controls.
* Maintain sufficient color contrast.
* Support larger text sizes without important content clipping or overflowing.

## 2) Localization

* Never hardcode user-facing strings.
* Use `context.l10n.keyName` throughout the project.
* Do not use `AppLocalizations.of(context)` directly inside Features.
* Before adding a new key, check the existing ARB files and reuse an existing key when applicable.
* Add every new localization key to **both Arabic and English** ARB files.
* Follow the existing localization setup and support RTL where applicable.

---

# Section F — Final Checklist

Before completing a task, verify:

* Requested functionality works and existing behavior is preserved.
* Clean Architecture boundaries are respected.
* Cubit/Bloc + GetIt are used consistently.
* Loading, empty, success, and error states are handled where applicable.
* No hardcoded user-facing strings.
* Localization uses `context.l10n` consistently.
* New localization keys exist in both Arabic and English.
* Accessibility has been considered.
* No unnecessary dependencies or unrelated file modifications.
* Code follows existing project conventions.

When multiple solutions are possible, prefer:

**consistent → simple → maintainable → testable → performant → accessible**
