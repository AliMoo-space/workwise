class AttendanceEntity {
  final String status;
  final String? checkInTime;
  final String? checkOutTime;
  final String workedTime;
  final double? distanceMeters;
  final bool isInsideRadius;
  final bool canCheckIn;
  final bool canCheckOut;
  final AttendanceWidgetsEntity? widgets;

  AttendanceEntity({
    required this.status,
    required this.checkInTime,
    required this.checkOutTime,
    required this.workedTime,
    required this.distanceMeters,
    required this.isInsideRadius,
    required this.canCheckIn,
    required this.canCheckOut,
    this.widgets,
  });

  int get workedSeconds => parseWorkedTimeToSeconds(workedTime);

  static int parseWorkedTimeToSeconds(String? timeStr) {
    if (timeStr == null || timeStr.trim().isEmpty) return 0;
    final trimmed = timeStr.trim();

    // Handles formats like "1h 20m 30s", "0h 0m 0s", "15m", "30s"
    final hmsRegex =
        RegExp(r'(?:(\d+)\s*h)?\s*(?:(\d+)\s*m)?\s*(?:(\d+)\s*s)?');
    if (trimmed.contains('h') ||
        trimmed.contains('m') ||
        trimmed.contains('s')) {
      final match = hmsRegex.firstMatch(trimmed);
      if (match != null) {
        final h = int.tryParse(match.group(1) ?? '') ?? 0;
        final m = int.tryParse(match.group(2) ?? '') ?? 0;
        final s = int.tryParse(match.group(3) ?? '') ?? 0;
        return (h * 3600) + (m * 60) + s;
      }
    }

    // Handles formats like "HH:mm:ss" or "mm:ss"
    final parts = trimmed.split(':');
    if (parts.length == 3) {
      final h = int.tryParse(parts[0]) ?? 0;
      final m = int.tryParse(parts[1]) ?? 0;
      final s = int.tryParse(parts[2]) ?? 0;
      return (h * 3600) + (m * 60) + s;
    } else if (parts.length == 2) {
      final m = int.tryParse(parts[0]) ?? 0;
      final s = int.tryParse(parts[1]) ?? 0;
      return (m * 60) + s;
    }

    return int.tryParse(trimmed) ?? 0;
  }
}

class AttendanceWidgetsEntity {
  final PendingTasksWidgetEntity? pendingTasks;
  final NextDeadlineWidgetEntity? nextDeadline;
  final LeaveBalanceWidgetEntity? leaveBalance;

  AttendanceWidgetsEntity({
    this.pendingTasks,
    this.nextDeadline,
    this.leaveBalance,
  });
}

class PendingTasksWidgetEntity {
  final int count;
  final String label;
  final String subtext;

  PendingTasksWidgetEntity({
    required this.count,
    required this.label,
    required this.subtext,
  });
}

class NextDeadlineWidgetEntity {
  final String date;
  final String taskTitle;
  final String label;

  NextDeadlineWidgetEntity({
    required this.date,
    required this.taskTitle,
    required this.label,
  });
}

class LeaveBalanceWidgetEntity {
  final int days;
  final String label;
  final String subtext;

  LeaveBalanceWidgetEntity({
    required this.days,
    required this.label,
    required this.subtext,
  });
}
