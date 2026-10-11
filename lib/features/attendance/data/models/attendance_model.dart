import 'package:workwise/core/utils/json_helper.dart';
import 'package:workwise/features/attendance/domain/entities/attendance_entity.dart';

class AttendanceModel extends AttendanceEntity {
  AttendanceModel({
    required super.status,
    required super.checkInTime,
    required super.checkOutTime,
    required super.workedTime,
    required super.distanceMeters,
    required super.isInsideRadius,
    required super.canCheckIn,
    required super.canCheckOut,
    super.widgets,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    final widgetsJson =
        JsonHelper.optional<Map<String, dynamic>>(json, 'widgets');

    return AttendanceModel(
      status: JsonHelper.required<String>(json, 'status'),
      checkInTime: JsonHelper.optional<String>(json, 'check_in_time'),
      checkOutTime: JsonHelper.optional<String>(json, 'check_out_time'),
      workedTime: JsonHelper.required<String>(json, 'worked_time'),
      distanceMeters:
          JsonHelper.optional<num>(json, 'distance_meters')?.toDouble(),
      isInsideRadius: JsonHelper.required<bool>(json, 'is_inside_radius'),
      canCheckIn: JsonHelper.required<bool>(json, 'can_check_in'),
      canCheckOut: JsonHelper.required<bool>(json, 'can_check_out'),
      widgets: widgetsJson != null
          ? AttendanceWidgetsModel.fromJson(widgetsJson)
          : null,
    );
  }
}

class AttendanceWidgetsModel extends AttendanceWidgetsEntity {
  AttendanceWidgetsModel({
    super.pendingTasks,
    super.nextDeadline,
    super.leaveBalance,
  });

  factory AttendanceWidgetsModel.fromJson(Map<String, dynamic> json) {
    final pendingTasksJson =
        JsonHelper.optional<Map<String, dynamic>>(json, 'pending_tasks');
    final nextDeadlineJson =
        JsonHelper.optional<Map<String, dynamic>>(json, 'next_deadline');
    final leaveBalanceJson =
        JsonHelper.optional<Map<String, dynamic>>(json, 'leave_balance');

    return AttendanceWidgetsModel(
      pendingTasks: pendingTasksJson != null
          ? PendingTasksWidgetModel.fromJson(pendingTasksJson)
          : null,
      nextDeadline: nextDeadlineJson != null
          ? NextDeadlineWidgetModel.fromJson(nextDeadlineJson)
          : null,
      leaveBalance: leaveBalanceJson != null
          ? LeaveBalanceWidgetModel.fromJson(leaveBalanceJson)
          : null,
    );
  }
}

class PendingTasksWidgetModel extends PendingTasksWidgetEntity {
  PendingTasksWidgetModel({
    required super.count,
    required super.label,
    required super.subtext,
  });

  factory PendingTasksWidgetModel.fromJson(Map<String, dynamic> json) {
    return PendingTasksWidgetModel(
      count: JsonHelper.required<int>(json, 'count'),
      label: JsonHelper.required<String>(json, 'label'),
      subtext: JsonHelper.required<String>(json, 'subtext'),
    );
  }
}

class NextDeadlineWidgetModel extends NextDeadlineWidgetEntity {
  NextDeadlineWidgetModel({
    required super.date,
    required super.taskTitle,
    required super.label,
  });

  factory NextDeadlineWidgetModel.fromJson(Map<String, dynamic> json) {
    return NextDeadlineWidgetModel(
      date: JsonHelper.required<String>(json, 'date'),
      taskTitle: JsonHelper.required<String>(json, 'task_title'),
      label: JsonHelper.required<String>(json, 'label'),
    );
  }
}

class LeaveBalanceWidgetModel extends LeaveBalanceWidgetEntity {
  LeaveBalanceWidgetModel({
    required super.days,
    required super.label,
    required super.subtext,
  });

  factory LeaveBalanceWidgetModel.fromJson(Map<String, dynamic> json) {
    return LeaveBalanceWidgetModel(
      days: JsonHelper.required<int>(json, 'days'),
      label: JsonHelper.required<String>(json, 'label'),
      subtext: JsonHelper.required<String>(json, 'subtext'),
    );
  }
}


