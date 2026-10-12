import 'package:dio/dio.dart';
import 'package:workwise/core/errors/exception.dart';
import 'package:workwise/core/network/endpoints/api_endpoints.dart';
import 'package:workwise/features/tasks/data/datasources/tasks_remote_data_source_contract.dart';
import 'package:workwise/features/tasks/data/models/tasks_response_model.dart';

mixin GetTasks on TasksRemoteDataSourceBase {
  @override
  Future<TasksResponseModel> getTasks({
    String? lang,
    String? status,
    String? priority,
    String? deadlineFrom,
    String? deadlineTo,
    int? perPage,
    int? page,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};

      if (lang != null) queryParameters['lang'] = lang;
      if (status != null) queryParameters['status'] = status;
      if (priority != null) queryParameters['priority'] = priority;
      if (deadlineFrom != null) queryParameters['deadline_from'] = deadlineFrom;
      if (deadlineTo != null) queryParameters['deadline_to'] = deadlineTo;
      if (perPage != null) queryParameters['per_page'] = perPage;
      if (page != null) queryParameters['page'] = page;

      final response = await apiConsumer.get(
        ApiEndpoints.tasks,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        return TasksResponseModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw const ServerException('Failed to load tasks');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const UnauthorizedException('Unauthenticated');
      } else if (e.response?.statusCode == 422) {
        throw const ValidationException('Validation error');
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const NetworkException('Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw const NetworkException('No internet connection');
      } else {
        throw ServerException(
          e.response?.data['message'] ?? 'Something went wrong',
        );
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
