import 'package:dio/dio.dart';
import 'package:workwise/core/errors/exception.dart';
import 'package:workwise/core/network/endpoints/api_endpoints.dart';
import 'package:workwise/features/tasks/data/datasources/tasks_remote_data_source_contract.dart';
import 'package:workwise/features/tasks/data/models/task_model.dart';

mixin UpdateTaskProgress on TasksRemoteDataSourceBase {
  @override
  Future<TaskModel> updateTaskProgress({
    required int taskId,
    required int progress,
    String? lang,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (lang != null) queryParameters['lang'] = lang;

      final response = await apiConsumer.patch(
        ApiEndpoints.updateTaskProgress(taskId),
        queryParameters: queryParameters,
        data: {'progress': progress},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return TaskModel.fromJson(data['data'] as Map<String, dynamic>);
      } else {
        throw const ServerException('Failed to update task progress');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const UnauthorizedException('Unauthenticated');
      } else if (e.response?.statusCode == 403) {
        throw const UnauthorizedException(
          'You are not authorized to update this task',
        );
      } else if (e.response?.statusCode == 404) {
        throw const ServerException('Task not found');
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
