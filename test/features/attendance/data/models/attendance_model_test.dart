import 'package:flutter_test/flutter_test.dart';
import 'package:workwise/core/errors/exception.dart';
import 'package:workwise/features/attendance/data/models/attendance_model.dart';
import 'package:workwise/features/attendance/domain/entities/attendance_entity.dart';

void main() {
  group('AttendanceModel', () {
    final validJson = <String, dynamic>{
      'status': 'Off Shift',
      'check_in_time': null,
      'check_out_time': null,
      'worked_time': '0h 0m 0s',
      'distance_meters': 442992.42,
      'is_inside_radius': false,
      'can_check_in': false,
      'can_check_out': false,
      'widgets': {
        'pending_tasks': {
          'count': 2,
          'label': 'PENDING TASKS',
          'subtext': '1 high priority',
        },
        'next_deadline': {
          'date': 'Oct 05',
          'task_title': 'Implement Employee Attendance API',
          'label': 'NEXT DEADLINE',
        },
        'leave_balance': {
          'days': 40,
          'label': 'LEAVE BALANCE',
          'subtext': 'Annual + Casual',
        },
      },
    };

    test('should parse correctly from valid JSON', () {
      final model = AttendanceModel.fromJson(validJson);

      expect(model.status, 'Off Shift');
      expect(model.checkInTime, isNull);
      expect(model.checkOutTime, isNull);
      expect(model.workedTime, '0h 0m 0s');
      expect(model.workedSeconds, 0);
      expect(model.distanceMeters, 442992.42);
      expect(model.isInsideRadius, false);
      expect(model.canCheckIn, false);
      expect(model.canCheckOut, false);
      expect(model.widgets, isNotNull);
      expect(model.widgets!.pendingTasks!.count, 2);
      expect(model.widgets!.nextDeadline!.date, 'Oct 05');
      expect(model.widgets!.leaveBalance!.days, 40);
    });

    test('should parse correctly when widgets is null', () {
      final jsonWithoutWidgets = Map<String, dynamic>.from(validJson)..remove('widgets');
      final model = AttendanceModel.fromJson(jsonWithoutWidgets);

      expect(model.widgets, isNull);
    });

    test('should throw ServerException when required field is missing', () {
      final invalidJson = Map<String, dynamic>.from(validJson)..remove('status');

      expect(() => AttendanceModel.fromJson(invalidJson), throwsA(isA<ServerException>()));
    });
  });

  group('parseWorkedTimeToSeconds', () {
    test('parses "1h 20m 30s" correctly', () {
      expect(AttendanceEntity.parseWorkedTimeToSeconds('1h 20m 30s'), 4830);
    });

    test('parses "00:00:05" correctly', () {
      expect(AttendanceEntity.parseWorkedTimeToSeconds('00:00:05'), 5);
    });

    test('parses "01:30:00" correctly', () {
      expect(AttendanceEntity.parseWorkedTimeToSeconds('01:30:00'), 5400);
    });

    test('handles empty or null string safely', () {
      expect(AttendanceEntity.parseWorkedTimeToSeconds(''), 0);
      expect(AttendanceEntity.parseWorkedTimeToSeconds(null), 0);
    });
  });
}
