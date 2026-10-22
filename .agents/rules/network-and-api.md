---
trigger: always_on
description: "Networking boundary (ApiConsumer, ApiEndpoints) and exception-to-Failure mapping rules for WorkWise API integration."
---

# Network & API Integration Rules

## 1. Networking Boundary
- Never instantiate or use `Dio` directly in DataSources or Repositories.
- Always inject `ApiConsumer` (`sl<ApiConsumer>()`).
- API routes must reside as static constants in `lib/core/network/endpoints/api_endpoints.dart`. Never hardcode URLs.

## 2. Exception & Error Mapping
- `DioConsumer` throws subtypes of `AppException` (`ServerException`, `NetworkException`, `UnauthorizedException`, `ValidationException`).
- DataSources let `AppException` propagate or parse safely.
- Repositories catch `AppException` and return functional Failures (`ServerFailure`, `NetworkFailure`, etc.) via `Either<Failure, T>`.
- Use `JsonHelper.required(json, 'key')` and `JsonHelper.optional(json, 'key')` for robust JSON parsing.