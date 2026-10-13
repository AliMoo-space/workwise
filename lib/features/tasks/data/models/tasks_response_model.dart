import 'package:workwise/features/tasks/data/models/task_model.dart';

class TasksResponseModel {
  final bool success;
  final String message;
  final PaginationData data;

  const TasksResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory TasksResponseModel.fromJson(Map<String, dynamic> json) {
    return TasksResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: PaginationData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class PaginationData {
  final int currentPage;
  final List<TaskModel> tasks;
  final String? firstPageUrl;
  final int? from;
  final int lastPage;
  final String? lastPageUrl;
  final List<PaginationLink> links;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int? to;
  final int total;

  const PaginationData({
    required this.currentPage,
    required this.tasks,
    this.firstPageUrl,
    this.from,
    required this.lastPage,
    this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    this.to,
    required this.total,
  });

  factory PaginationData.fromJson(Map<String, dynamic> json) {
    return PaginationData(
      currentPage: json['current_page'] as int,
      tasks: (json['data'] as List<dynamic>)
          .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      firstPageUrl: json['first_page_url'] as String?,
      from: json['from'] as int?,
      lastPage: json['last_page'] as int,
      lastPageUrl: json['last_page_url'] as String?,
      links: (json['links'] as List<dynamic>)
          .map((e) => PaginationLink.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextPageUrl: json['next_page_url'] as String?,
      path: json['path'] as String,
      perPage: json['per_page'] as int,
      prevPageUrl: json['prev_page_url'] as String?,
      to: json['to'] as int?,
      total: json['total'] as int,
    );
  }
}

class PaginationLink {
  final String? url;
  final String label;
  final int? page;
  final bool active;

  const PaginationLink({
    this.url,
    required this.label,
    this.page,
    required this.active,
  });

  factory PaginationLink.fromJson(Map<String, dynamic> json) {
    return PaginationLink(
      url: json['url'] as String?,
      label: json['label'] as String,
      page: json['page'] as int?,
      active: json['active'] as bool,
    );
  }
}
