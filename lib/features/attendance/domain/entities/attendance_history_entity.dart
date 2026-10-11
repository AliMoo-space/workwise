class AttendanceHistoryEntity {
  const AttendanceHistoryEntity({
    required this.id,
    required this.date,
    required this.dayName,
    required this.checkIn,
    required this.checkOut,
    required this.status,
    required this.workedTime,
    required this.isException,
  });

  final int id;
  final String date;
  final String dayName;
  final String? checkIn;
  final String? checkOut;
  final String status;
  final String workedTime;
  final bool isException;
}

class AttendanceHistoryPageEntity {
  const AttendanceHistoryPageEntity({
    required this.history,
    required this.links,
    required this.meta,
  });

  final List<AttendanceHistoryEntity> history;
  final AttendanceHistoryLinksEntity links;
  final AttendanceHistoryMetaEntity meta;
}

class AttendanceHistoryLinksEntity {
  const AttendanceHistoryLinksEntity({
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

class AttendanceHistoryMetaEntity {
  const AttendanceHistoryMetaEntity({
    required this.currentPage,
    required this.from,
    required this.lastPage,
    required this.links,
    required this.path,
    required this.perPage,
    required this.to,
    required this.total,
  });

  final int currentPage;
  final int? from;
  final int lastPage;
  final List<AttendanceHistoryMetaLinkEntity> links;
  final String path;
  final int perPage;
  final int? to;
  final int total;
}

class AttendanceHistoryMetaLinkEntity {
  const AttendanceHistoryMetaLinkEntity({
    required this.url,
    required this.label,
    required this.page,
    required this.active,
  });

  final String? url;
  final String label;
  final int? page;
  final bool active;
}
