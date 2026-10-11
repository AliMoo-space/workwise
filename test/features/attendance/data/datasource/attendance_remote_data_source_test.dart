import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workwise/core/errors/exception.dart';
import 'package:workwise/core/network/api_consumer.dart';
import 'package:workwise/core/network/endpoints/api_endpoints.dart';
import 'package:workwise/features/attendance/data/datasource/attendance_remote_data_source.dart';

class FakeApiConsumer implements ApiConsumer {
  String? lastGetPath;
  Map<String, dynamic>? lastGetQuery;
  String? lastPostPath;
  dynamic lastPostData;
  Map<String, dynamic>? lastPostQuery;
  dynamic responseData;

  @override
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    lastGetPath = path;
    lastGetQuery = queryParameters;
    return Response(
      data: responseData,
      requestOptions: RequestOptions(path: path),
    );
  }

  @override
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    lastPostPath = path;
    lastPostData = data;
    lastPostQuery = queryParameters;
    return Response(
      data: responseData,
      requestOptions: RequestOptions(path: path),
    );
  }

  @override
  Future<Response> delete(String path, {data, Map<String, dynamic>? queryParameters, Options? options}) {
    throw UnimplementedError();
  }

  @override
  Future<Response> patch(String path, {data, Map<String, dynamic>? queryParameters, Options? options}) {
    throw UnimplementedError();
  }

  @override
  Future<Response> put(String path, {data, Map<String, dynamic>? queryParameters, Options? options}) {
    throw UnimplementedError();
  }
}

void main() {
  late FakeApiConsumer fakeApiConsumer;
  late AttendanceRemoteDataSourceImpl dataSource;

  setUp(() {
    fakeApiConsumer = FakeApiConsumer();
    dataSource = AttendanceRemoteDataSourceImpl(apiConsumer: fakeApiConsumer);
  });

  group('getTodayAttendance', () {
    test('sends latitude and longitude as query parameters and extracts data safely', () async {
      fakeApiConsumer.responseData = {
        'success': true,
        'message': 'Today attendance retrieved successfully.',
        'data': {
          'status': 'Off Shift',
          'check_in_time': null,
          'check_out_time': null,
          'worked_time': '0h 0m 0s',
          'distance_meters': 100.5,
          'is_inside_radius': false,
          'can_check_in': true,
          'can_check_out': false,
        },
      };

      final result = await dataSource.getTodayAttendance(
        latitude: 30.0444,
        longitude: 31.2357,
      );

      expect(fakeApiConsumer.lastGetPath, ApiEndpoints.todayAttendance);
      expect(fakeApiConsumer.lastGetQuery, {'latitude': 30.0444, 'longitude': 31.2357});
      expect(result.status, 'Off Shift');
      expect(result.canCheckIn, true);
    });

    test('throws ServerException when data field is missing or invalid', () async {
      fakeApiConsumer.responseData = {'success': true};

      expect(
        () => dataSource.getTodayAttendance(latitude: 30.0, longitude: 31.0),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('checkIn', () {
    test('sends latitude and longitude in body (data)', () async {
      fakeApiConsumer.responseData = {
        'success': true,
        'message': 'Checked in successfully.',
        'data': {
          'id': 10,
          'user_id': 1,
          'date': '2026-09-12',
          'check_in': '09:05 AM',
          'check_out': null,
          'status': 'Present',
          'worked_time': null,
          'is_exception': false,
        },
      };

      final result = await dataSource.checkIn(
        latitude: 30.0444,
        longitude: 31.2357,
      );

      expect(fakeApiConsumer.lastPostPath, ApiEndpoints.checkIn);
      expect(fakeApiConsumer.lastPostData, {'latitude': 30.0444, 'longitude': 31.2357});
      expect(result.id, 10);
      expect(result.status, 'Present');
    });
  });

  group('checkOut', () {
    test('sends POST request without body', () async {
      fakeApiConsumer.responseData = {
        'success': true,
        'message': 'Checked out successfully.',
        'data': {
          'id': 3,
          'user_id': 6,
          'date': '2026-09-24',
          'check_in': '06:52 PM',
          'check_out': '06:52 PM',
          'status': 'Late',
          'worked_time': '00:00:05',
          'is_exception': true,
        },
      };

      final result = await dataSource.checkOut(
        latitude: 30.0444,
        longitude: 31.2357,
      );

      expect(fakeApiConsumer.lastPostPath, ApiEndpoints.checkOut);
      expect(fakeApiConsumer.lastPostData, isNull);
      expect(result.id, 3);
      expect(result.workedTime, '00:00:05');
    });
  });
}
