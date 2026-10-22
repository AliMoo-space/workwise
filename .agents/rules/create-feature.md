---
trigger: model_decision
description: "Inside-out Clean Architecture workflow for creating a new Flutter feature under lib/features/<feature_name>/."
---

# /create-feature Workflow

## Trigger
Use this workflow when creating a new feature under `lib/features/<feature_name>/`.

## Execution Order (Inside-Out)
1. **Domain Layer:**
   - Define `domain/entities/<feature_name>_entity.dart` (extends Equatable).
   - Define `domain/repo/<feature_name>_repo.dart` (abstract interface).
   - Implement `domain/usecases/get_<feature_name>_usecase.dart`.
2. **Data Layer:**
   - Define `data/models/<feature_name>_model.dart` (fromJson, toJson, toEntity, copyWith).
   - Implement `data/datasource/<feature_name>_remote_data_source.dart` (injects `ApiConsumer`).
   - Implement `data/repo/<feature_name>_repo_impl.dart` (calls DataSource, maps `AppException` to `Failure`).
3. **Presentation Layer:**
   - Define `presentation/cubit/<feature_name>_state.dart` (`Initial`, `Loading`, `Success`, `Failure`).
   - Implement `presentation/cubit/<feature_name>_cubit.dart` (injects UseCase, emits states).
   - Build `presentation/screens/<feature_name>_screen.dart` and `presentation/widgets/`.
4. **Wiring & Registration:**
   - In `lib/core/services/service_locator.dart`: Register DS, Repo, UseCases (`registerLazySingleton`), Cubit (`registerFactory`).
   - In `lib/core/routing/app_routes.dart` & `router_generation_config.dart`: Register route using `slideTransitionPage`.
   - In `l10n`: Add strings to both `ar` and `en` ARB files.