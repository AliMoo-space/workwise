class NotificationEntity {
  const NotificationEntity({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.metadata,
    required this.isRead,
    required this.createdAt,
  });

  final String id;
  final String type;
  final String? title;
  final String? body;
  final Map<String, dynamic> metadata;
  final bool isRead;
  final String createdAt;
}

class NotificationPageEntity {
  const NotificationPageEntity({
    required this.notifications,
    required this.links,
    required this.meta,
  });

  final List<NotificationEntity> notifications;
  final NotificationLinksEntity links;
  final NotificationMetaEntity meta;
}

class NotificationLinksEntity {
  const NotificationLinksEntity({
    required this.first,
    required this.last,
    required this.prev,
    required this.next,
  });

  final String? first;
  final String? last;
  final String? prev;
  final String? next;
}

class NotificationMetaEntity {
  const NotificationMetaEntity({
    required this.currentPage,
    required this.from,
    required this.lastPage,
    required this.links,
    required this.perPage,
    required this.to,
    required this.total,
  });

  final int? currentPage;
  final int? from;
  final int? lastPage;
  final List<NotificationPaginationLinkEntity> links;
  final int? perPage;
  final int? to;
  final int? total;
}

class NotificationPaginationLinkEntity {
  const NotificationPaginationLinkEntity({
    required this.url,
    required this.label,
    required this.active,
  });

  final String? url;
  final String label;
  final bool active;
}
