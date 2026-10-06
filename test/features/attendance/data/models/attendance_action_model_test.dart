import 'package:flutter_test/flutter_test.dart';
import 'package:workwise/core/errors/exception.dart';
import 'package:workwise/features/attendance/data/models/attendance_action_model.dart';

void main() {
  group('AttendanceActionModel', () {
    test('should parse 201 check-in response correctly', () {
      final json = <String, dynamic>{
        'id': 10,
        'user_id': 1,
        'date': '2026-09-12',
        'check_in': '09:05 AM',
        'check_out': null,
        'status': 'Present',
        'worked_time': null,
        'is_exception': false,
      };

      final model = AttendanceActionModel.fromJson(json);

      expect(model.id, 10);
      expect(model.userId, 1);
      expect(model.date, '2026-09-12');
      expect(model.checkIn, '09:05 AM');
      expect(model.checkOut, isNull);
      expect(model.status, 'Present');
      expect(model.workedTime, isNull);
      expect(model.workedSeconds, isNull);
      expect(model.isException, false);
    });

    test('should parse 200 check-out response correctly', () {
      final json = <String, dynamic>{
        'id': 3,
        'user_id': 6,
        'date': '2026-09-24',
        'check_in': '06:52 PM',
        'check_out': '06:52 PM',
        'status': 'Late',
        'worked_time': '00:00:05',
        'is_exception': true,
      };

      final model = AttendanceActionModel.fromJson(json);

      expect(model.id, 3);
      expect(model.userId, 6);
      expect(model.date, '2026-09-24');
      expect(model.checkIn, '06:52 PM');
      expect(model.checkOut, '06:52 PM');
      expect(model.status, 'Late');
      expect(model.workedTime, '00:00:05');
      expect(model.workedSeconds, 5);
      expect(model.isException, true);
    });

    test('should throw ServerException when required field is missing', () {
      final json = <String, dynamic>{
        'user_id': 6,
        'date': '2026-09-24',
      };

      expect(() => AttendanceActionModel.fromJson(json), throwsA(isA<ServerException>()));
    });
  });
}
