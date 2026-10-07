import 'package:dio/dio.dart';
import 'package:workwise/core/errors/exception.dart';
import 'package:workwise/core/network/api_consumer.dart';
import 'package:workwise/core/network/endpoints/api_endpoints.dart';
import 'package:workwise/features/tasks/data/models/task_model.dart';
import 'package:workwise/features/tasks/data/models/task_submission_model.dart';
import 'package:workwise/features/tasks/data/models/tasks_response_model.dart';

abstract class TasksRemoteDataSource {
  Future<TasksResponseModel> getTasks({
    String? lang,
    String? status,
    String? priority,
    String? deadlineFrom,
    String? deadlineTo,
    int? perPage,
    int? page,
  });

  Future<TaskModel> updateTaskProgress({
    required int taskId,
    required int progress,
    String? lang,
  });

  Future<TaskModel> updateTaskStatus({
    required int taskId,
    required String status,
    String? lang,
  });

  Future<TaskSubmissionResponseModel> submitTask({
    required int taskId,
    required String note,
    List<String>? filePaths,
    String? lang,
  });

  Future<TaskSubmissionResponseModel> getSubmissionDetails({
    required int submissionId,
    String? lang,
  });

  Future<SubmissionAttachment> addSubmissionAttachment({
    required int submissionId,
    required String filePath,
    String? lang,
  });

  Future<TaskSubmissionResponseModel> resubmitSubmission({
    required int submissionId,
    required String note,
    String? lang,
  });
}

class TasksRemoteDataSourceImpl implements TasksRemoteDataSource {
  final ApiConsumer apiConsumer;

  TasksRemoteDataSourceImpl({required this.apiConsumer});

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

  @override
  Future<TaskModel> updateTaskStatus({
    required int taskId,
    required String status,
    String? lang,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (lang != null) queryParameters['lang'] = lang;

      final response = await apiConsumer.patch(
        ApiEndpoints.updateTaskStatus(taskId),
        queryParameters: queryParameters,
        data: {'status': status},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return TaskModel.fromJson(data['data'] as Map<String, dynamic>);
      } else {
        throw const ServerException('Failed to update task status');
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
        final message =
            e.response?.data['message'] ?? 'Invalid status transition';
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
            MapEntry('files[]', await MultipartFile.fromFile(filePath, filename: fileName)),
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
        // Fallback: if sending files[] in initial POST failed with 422, send note alone and upload files via addSubmissionAttachment
        if (e.response?.statusCode == 422 && filePaths != null && filePaths.isNotEmpty) {
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

        // Ensure attachments are uploaded to the submission
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
                // Log and continue uploading remaining attachments
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
          await MultipartFile.fromFile(
            filePath,
            filename: fileName,
          ),
        ),
      );

      final response = await apiConsumer.post(
        ApiEndpoints.addSubmissionAttachment(submissionId),
        queryParameters: queryParameters,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
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
        final message = e.response?.data['message'] ?? 'Only changes requested submissions can be resubmitted';
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
