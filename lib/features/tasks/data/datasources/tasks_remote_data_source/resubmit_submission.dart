import 'package:dio/dio.dart';
import 'package:workwise/core/errors/exception.dart';
import 'package:workwise/core/network/endpoints/api_endpoints.dart';
import 'package:workwise/features/tasks/data/datasources/tasks_remote_data_source_contract.dart';
import 'package:workwise/features/tasks/data/models/task_submission_model.dart';

mixin ResubmitSubmission on TasksRemoteDataSourceBase {
  @override
  Future<TaskSubmissionResponseModel> resubmitSubmission({
    required int submissionId,
    required String note,
    String? lang,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (lang != null) queryParameters['lang'] = lang;

      final response = await apiConsumer.post(
        ApiEndpoints.resubmitSubmission(submissionId),
        queryParameters: queryParameters,
        data: {'note': note},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>;
        return TaskSubmissionResponseModel.fromJson(data);
      } else {
        throw const ServerException('Failed to resubmit submission');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const UnauthorizedException('Unauthenticated');
      } else if (e.response?.statusCode == 403) {
        throw const UnauthorizedException(
          'You are not authorized to resubmit this submission',
        );
      } else if (e.response?.statusCode == 404) {
        throw const ServerException('Submission not found');
      } else if (e.response?.statusCode == 422) {
        final message =
            e.response?.data['message'] ??
            'Only changes requested submissions can be resubmitted';
        throw ServerException(message);
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
