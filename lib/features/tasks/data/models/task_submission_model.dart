import 'package:workwise/features/tasks/data/models/task_model.dart';

class TaskSubmissionModel {
  final int id;
  final int taskId;
  final int userId;
  final String note;
  final String status;
  final DateTime submittedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final TaskModel? task;
  final SubmissionUser? user;
  final List<SubmissionAttachment> attachments;
  final List<dynamic> reviews;

  const TaskSubmissionModel({
    required this.id,
    required this.taskId,
    required this.userId,
    required this.note,
    required this.status,
    required this.submittedAt,
    required this.createdAt,
    required this.updatedAt,
    this.task,
    this.user,
    this.attachments = const [],
    this.reviews = const [],
  });

  factory TaskSubmissionModel.fromJson(Map<String, dynamic> json) {
    return TaskSubmissionModel(
      id: json['id'] as int,
      taskId: json['task_id'] as int,
      userId: json['user_id'] as int,
      note: json['note'] as String? ?? '',
      status: json['status'] as String,
      submittedAt: DateTime.parse(json['submitted_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      task: json['task'] != null
          ? TaskModel.fromJson(json['task'] as Map<String, dynamic>)
          : null,
      user: json['user'] != null
          ? SubmissionUser.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      attachments: json['attachments'] != null
          ? (json['attachments'] as List)
              .map((e) => SubmissionAttachment.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      reviews: json['reviews'] as List? ?? [],
    );
  }
}

class SubmissionUser {
  final int id;
  final String employeeId;
  final String name;
  final String email;
  final String? avatar;
  final String? jobTitle;

  const SubmissionUser({
    required this.id,
    required this.employeeId,
    required this.name,
    required this.email,
    this.avatar,
    this.jobTitle,
  });

  factory SubmissionUser.fromJson(Map<String, dynamic> json) {
    return SubmissionUser(
      id: json['id'] as int,
      employeeId: json['employee_id'] as String? ?? '',
      name: json['name'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String?,
      jobTitle: json['job_title'] as String?,
    );
  }
}

class SubmissionAttachment {
  final int id;
  final int submissionId;
  final int uploadedBy;
  final String fileName;
  final String filePath;
  final String mimeType;
  final int fileSize;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SubmissionAttachment({
    required this.id,
    required this.submissionId,
    required this.uploadedBy,
    required this.fileName,
    required this.filePath,
    required this.mimeType,
    required this.fileSize,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubmissionAttachment.fromJson(Map<String, dynamic> json) {
    return SubmissionAttachment(
      id: json['id'] as int,
      submissionId: json['submission_id'] as int,
      uploadedBy: json['uploaded_by'] as int,
      fileName: json['file_name'] as String,
      filePath: json['file_path'] as String,
      mimeType: json['mime_type'] as String,
      fileSize: json['file_size'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  String get fullUrl => 'https://workwise-production-3941.up.railway.app/$filePath';
}

class TaskSubmissionResponseModel {
  final bool success;
  final String message;
  final TaskSubmissionModel data;

  const TaskSubmissionResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory TaskSubmissionResponseModel.fromJson(Map<String, dynamic> json) {
    return TaskSubmissionResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: TaskSubmissionModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}
