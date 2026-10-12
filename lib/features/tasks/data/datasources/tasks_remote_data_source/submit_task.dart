import 'package:dio/dio.dart';
import 'package:workwise/core/errors/exception.dart';
import 'package:workwise/core/network/endpoints/api_endpoints.dart';
import 'package:workwise/features/tasks/data/datasources/tasks_remote_data_source_contract.dart';
import 'package:workwise/features/tasks/data/models/task_submission_model.dart';

mixin SubmitTask on TasksRemoteDataSourceBase {
  @override
  Future<TaskSubmissionResponseModel> submitTask({
    required int taskId,
    required String note,
    List<String>? filePaths,
    String? lang,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (lang != null) queryParameters['lang'] = lang;

      final formData = FormData();
      formData.fields.add(MapEntry('note', note));

      if (filePaths != null && filePaths.isNotEmpty) {
        for (final filePath in filePaths) {
          final fileName = filePath.split(RegExp(r'[/\\]')).last;
          formData.files.add(
            MapEntry(
              'files[]',
              await MultipartFile.fromFile(filePath, filename: fileName),
            ),
          );
        }
      }

      Response<dynamic> response;
      try {
        response = await apiConsumer.post(
          ApiEndpoints.submitTask(taskId),
          queryParameters: queryParameters,
          data: formData,
          options: Options(contentType: 'multipart/form-data'),
        );
      } on DioException catch (e) {
        if (e.response?.statusCode == 422 &&
            filePaths != null &&
            filePaths.isNotEmpty) {
          final noteOnlyData = FormData();
          noteOnlyData.fields.add(MapEntry('note', note));
          response = await apiConsumer.post(
            ApiEndpoints.submitTask(taskId),
            queryParameters: queryParameters,
            data: noteOnlyData,
            options: Options(contentType: 'multipart/form-data'),
          );
        } else {
          rethrow;
        }
      }

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final submissionResponse = TaskSubmissionResponseModel.fromJson(data);
        final submissionId = submissionResponse.data.id;

        if (filePaths != null && filePaths.isNotEmpty) {
          if (submissionResponse.data.attachments.length < filePaths.length) {
            for (final filePath in filePaths) {
              try {
                await addSubmissionAttachment(
                  submissionId: submissionId,
                  filePath: filePath,
                  lang: lang,
                );
              } catch (e) {
                // Continue uploading remaining attachments.
              }
            }
          }
        }

        return submissionResponse;
      } else {
        throw const ServerException('Failed to submit task');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const UnauthorizedException('Unauthenticated');
      } else if (e.response?.statusCode == 422) {
        final message =
            e.response?.data['message'] ??
            'Validation error or task cannot be submitted';
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
