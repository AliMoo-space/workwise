# /connect-api Workflow

## Trigger
Use when connecting an existing mock feature to a real API endpoint.

## Steps
1. Add the endpoint to `lib/core/network/endpoints/api_endpoints.dart`.
2. Update `<feature_name>_remote_data_source.dart` to call `_apiConsumer.get/post(...)`.
3. Ensure Model maps raw response using `JsonHelper`.
4. In Repository Impl, wrap remote call with `try/catch` on `AppException` returning `Left(Failure)` / `Right(Entity)`.
5. In Cubit, fold the result:
   - On Failure: emit `<Feature>Failure(message: failure.message)`.
   - On Success: emit `<Feature>Success(data: result)`.
6. Verify UI handles all states (`Skeletonizer` for loading, `AppErrorState` with retry on failure).