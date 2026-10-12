import 'package:dio/dio.dart';
import 'package:workwise/core/errors/exception.dart';
import 'package:workwise/core/network/endpoints/api_endpoints.dart';
import 'package:workwise/features/tasks/data/datasources/tasks_remote_data_source_contract.dart';
import 'package:workwise/features/tasks/data/models/task_submission_model.dart';

mixin GetSubmissionDetails on TasksRemoteDataSourceBase {
  @override
  Future<TaskSubmissionResponseModel> getSubmissionDetails({
    required int submissionId,
    String? lang,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (lang != null) queryParameters['lang'] = lang;

      final response = await apiConsumer.get(
        ApiEndpoints.getSubmissionDetails(submissionId),
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return TaskSubmissionResponseModel.fromJson(data);
      } else {
        throw const ServerException('Failed to get submission details');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const UnauthorizedException('Unauthenticated');
      } else if (e.response?.statusCode == 403) {
        throw const UnauthorizedException(
          'You are not authorized to view this submission',
        );
      } else if (e.response?.statusCode == 404) {
        throw const ServerException('Submission not found');
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
