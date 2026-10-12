import 'package:workwise/core/utils/json_helper.dart';
import 'package:workwise/features/attendance/domain/entities/attendance_history_entity.dart';

class AttendanceHistoryModel extends AttendanceHistoryEntity {
  const AttendanceHistoryModel({
    required super.id,
    required super.date,
    required super.dayName,
    required super.checkIn,
    required super.checkOut,
    required super.status,
    required super.workedTime,
    required super.isException,
  });

  factory AttendanceHistoryModel.fromJson(Map<String, dynamic> json) {
    return AttendanceHistoryModel(
      id: JsonHelper.required<int>(json, 'id'),
      date: JsonHelper.required<String>(json, 'date'),
      dayName: JsonHelper.required<String>(json, 'day_name'),
      checkIn: JsonHelper.optional<String>(json, 'check_in'),
      checkOut: JsonHelper.optional<String>(json, 'check_out'),
      status: JsonHelper.required<String>(json, 'status'),
      workedTime: JsonHelper.required<String>(json, 'worked_time'),
      isException: JsonHelper.required<bool>(json, 'is_exception'),
    );
  }
}

class AttendanceHistoryPageModel extends AttendanceHistoryPageEntity {
  const AttendanceHistoryPageModel({
    required super.history,
    required super.links,
    required super.meta,
  });

  factory AttendanceHistoryPageModel.fromJson(Map<String, dynamic> json) {
    final historyJson = JsonHelper.required<List<dynamic>>(json, 'history');
    final linksJson = JsonHelper.required<Map<String, dynamic>>(json, 'links');
    final metaJson = JsonHelper.required<Map<String, dynamic>>(json, 'meta');
    final metaLinksJson =
        JsonHelper.required<List<dynamic>>(metaJson, 'links');

    return AttendanceHistoryPageModel(
      history: historyJson
          .map(
            (item) => AttendanceHistoryModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
      links: AttendanceHistoryLinksModel.fromJson(linksJson),
      meta: AttendanceHistoryMetaModel.fromJson(
        metaJson,
        metaLinksJson,
      ),
    );
  }
}

class AttendanceHistoryLinksModel extends AttendanceHistoryLinksEntity {
  const AttendanceHistoryLinksModel({
    required super.first,
    required super.last,
    required super.prev,
    required super.next,
  });

  factory AttendanceHistoryLinksModel.fromJson(Map<String, dynamic> json) {
    return AttendanceHistoryLinksModel(
      first: JsonHelper.optional<String>(json, 'first'),
      last: JsonHelper.optional<String>(json, 'last'),
      prev: JsonHelper.optional<String>(json, 'prev'),
      next: JsonHelper.optional<String>(json, 'next'),
    );
  }
}

class AttendanceHistoryMetaModel extends AttendanceHistoryMetaEntity {
  const AttendanceHistoryMetaModel({
    required super.currentPage,
    required super.from,
    required super.lastPage,
    required super.links,
    required super.path,
    required super.perPage,
    required super.to,
    required super.total,
  });

  factory AttendanceHistoryMetaModel.fromJson(
    Map<String, dynamic> json,
    List<dynamic> linksJson,
  ) {
    return AttendanceHistoryMetaModel(
      currentPage: JsonHelper.required<int>(json, 'current_page'),
      from: JsonHelper.optional<int>(json, 'from'),
      lastPage: JsonHelper.required<int>(json, 'last_page'),
      links: linksJson
          .map(
            (item) => AttendanceHistoryMetaLinkModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
      path: JsonHelper.required<String>(json, 'path'),
      perPage: JsonHelper.required<int>(json, 'per_page'),
      to: JsonHelper.optional<int>(json, 'to'),
      total: JsonHelper.required<int>(json, 'total'),
    );
  }
}

class AttendanceHistoryMetaLinkModel
    extends AttendanceHistoryMetaLinkEntity {
  const AttendanceHistoryMetaLinkModel({
    required super.url,
    required super.label,
    required super.page,
    required super.active,
  });

  factory AttendanceHistoryMetaLinkModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return AttendanceHistoryMetaLinkModel(
      url: JsonHelper.optional<String>(json, 'url'),
      label: JsonHelper.required<String>(json, 'label'),
      page: JsonHelper.optional<int>(json, 'page'),
      active: JsonHelper.required<bool>(json, 'active'),
    );
  }
}
