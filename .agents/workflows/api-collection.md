# /api-collection Workflow

## Trigger
Use when ingesting an API Collection (Postman / OpenAPI / Bruno) to build or update the network and data layers.

## Step 1 — Analyze & Extract (NO CODE YET)
Read the collection file from `docs/api/` and output:
- **Feature Name & Grouping:** Identify which feature each endpoint belongs to.
- **Endpoint Matrix:**
  - HTTP Method (GET, POST, PUT, DELETE)
  - Relative Path (excluding base URL)
  - Query parameters & Request Body schema
  - Expected 200/201 response schema (detect pagination or wrapper envelopes)
  - Auth required? (Yes/No)
*Wait for developer confirmation before generating any Dart code.*

## Step 2 — Code Generation Sequence (After Approval)
1. **Endpoints:**
   - Add static constants under `lib/core/network/endpoints/api_endpoints.dart`.
   - Never hardcode the base URL.
2. **Models:**
   - Create Request / Response models under `lib/features/<feature>/data/models/`.
   - Implement `fromJson`, `toJson`, and `toEntity()`.
   - Always parse mandatory fields with `JsonHelper.required` and optional with `JsonHelper.optional`.
3. **Data Source:**
   - Create or update `<feature>_remote_data_source.dart`.
   - Inject `ApiConsumer`. Call `_apiConsumer.get/post/put/delete`.
4. **Repository:**
   - Wrap remote data source calls with `try/catch` catching `AppException` and returning `Left(Failure)` / `Right(Entity)`.