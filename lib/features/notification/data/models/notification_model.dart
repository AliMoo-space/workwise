import 'package:workwise/core/errors/exception.dart';
import 'package:workwise/core/utils/json_helper.dart';
import 'package:workwise/features/notification/domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.type,
    required super.title,
    required super.body,
    required super.metadata,
    required super.isRead,
    required super.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: JsonHelper.required<String>(json, 'id'),
      type: JsonHelper.required<String>(json, 'type'),
      title: JsonHelper.optional<String>(json, 'title'),
      body: JsonHelper.optional<String>(json, 'body'),
      metadata: _optionalMap(json, 'metadata'),
      isRead: JsonHelper.required<bool>(json, 'is_read'),
      createdAt: JsonHelper.required<String>(json, 'created_at'),
    );
  }
}

class NotificationPageModel extends NotificationPageEntity {
  const NotificationPageModel({
    required super.notifications,
    required super.links,
    required super.meta,
  });

  factory NotificationPageModel.fromJson(Map<String, dynamic> json) {
    final notificationsJson = JsonHelper.required<List<dynamic>>(
      json,
      'notifications',
    );
    final linksJson = _optionalMap(json, 'links');
    final metaJson = _optionalMap(json, 'meta');
    final metaLinksJson = _optionalList(metaJson, 'links');

    return NotificationPageModel(
      notifications: notificationsJson
          .map(
            (item) => NotificationModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
      links: NotificationLinksModel.fromJson(linksJson),
      meta: NotificationMetaModel.fromJson(metaJson, metaLinksJson),
    );
  }
}

class NotificationLinksModel extends NotificationLinksEntity {
  const NotificationLinksModel({
    required super.first,
    required super.last,
    required super.prev,
    required super.next,
  });

  factory NotificationLinksModel.fromJson(Map<String, dynamic> json) {
    return NotificationLinksModel(
      first: JsonHelper.optional<String>(json, 'first'),
      last: JsonHelper.optional<String>(json, 'last'),
      prev: JsonHelper.optional<String>(json, 'prev'),
      next: JsonHelper.optional<String>(json, 'next'),
    );
  }
}

class NotificationMetaModel extends NotificationMetaEntity {
  const NotificationMetaModel({
    required super.currentPage,
    required super.from,
    required super.lastPage,
    required super.links,
    required super.perPage,
    required super.to,
    required super.total,
  });

  factory NotificationMetaModel.fromJson(
    Map<String, dynamic> json,
    List<dynamic> linksJson,
  ) {
    return NotificationMetaModel(
      currentPage: JsonHelper.optional<int>(json, 'current_page'),
      from: JsonHelper.optional<int>(json, 'from'),
      lastPage: JsonHelper.optional<int>(json, 'last_page'),
      links: linksJson
          .whereType<Map>()
          .map(
            (item) => NotificationPaginationLinkModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList(),
      perPage: JsonHelper.optional<int>(json, 'per_page'),
      to: JsonHelper.optional<int>(json, 'to'),
      total: JsonHelper.optional<int>(json, 'total'),
    );
  }
}

class NotificationPaginationLinkModel extends NotificationPaginationLinkEntity {
  const NotificationPaginationLinkModel({
    required super.url,
    required super.label,
    required super.active,
  });

  factory NotificationPaginationLinkModel.fromJson(Map<String, dynamic> json) {
    return NotificationPaginationLinkModel(
      url: JsonHelper.optional<String>(json, 'url'),
      label: JsonHelper.optional<String>(json, 'label') ?? '',
      active: JsonHelper.optional<bool>(json, 'active') ?? false,
    );
  }
}

Map<String, dynamic> _optionalMap(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) return const {};
  if (value is! Map) {
    throw ServerException('Invalid type for field: $key');
  }
  return Map<String, dynamic>.from(value);
}

List<dynamic> _optionalList(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) return const [];
  if (value is! List) {
    throw ServerException('Invalid type for field: $key');
  }
  return value;
}
