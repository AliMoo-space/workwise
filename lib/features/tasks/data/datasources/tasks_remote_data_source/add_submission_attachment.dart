import 'package:dio/dio.dart';
import 'package:workwise/core/errors/exception.dart';
import 'package:workwise/core/network/endpoints/api_endpoints.dart';
import 'package:workwise/features/tasks/data/datasources/tasks_remote_data_source_contract.dart';
import 'package:workwise/features/tasks/data/models/task_submission_model.dart';

mixin AddSubmissionAttachment on TasksRemoteDataSourceBase {
  @override
  Future<SubmissionAttachment> addSubmissionAttachment({
    required int submissionId,
    required String filePath,
    String? lang,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (lang != null) queryParameters['lang'] = lang;

      final fileName = filePath.split(RegExp(r'[/\\]')).last;
      final formData = FormData();
      formData.files.add(
        MapEntry(
          'file',
          await MultipartFile.fromFile(filePath, filename: fileName),
        ),
      );

      final response = await apiConsumer.post(
        ApiEndpoints.addSubmissionAttachment(submissionId),
        queryParameters: queryParameters,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>;
        return SubmissionAttachment.fromJson(
          data['data'] as Map<String, dynamic>,
        );
      } else {
        throw const ServerException('Failed to add attachment');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const UnauthorizedException('Unauthenticated');
      } else if (e.response?.statusCode == 403) {
        throw const UnauthorizedException(
          'You are not authorized to add attachment to this submission',
        );
      } else if (e.response?.statusCode == 404) {
        throw const ServerException('Submission not found');
      } else if (e.response?.statusCode == 422) {
        throw const ValidationException('Invalid file or validation error');
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
