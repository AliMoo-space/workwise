import 'package:dio/dio.dart';
import 'package:workwise/core/network/api_consumer.dart';
import 'package:workwise/core/network/endpoints/api_endpoints.dart';
import 'package:workwise/core/network/error_message.dart';
import 'package:workwise/features/performance/data/performance/models/performance_model.dart';

abstract interface class PerformanceRemoteDataSource {
  Future<PerformanceModel> getPerformance();
}

class PerformanceRemoteDataSourceImpl implements PerformanceRemoteDataSource {
  const PerformanceRemoteDataSourceImpl({required this.apiConsumer});

  final ApiConsumer apiConsumer;

  @override
  Future<PerformanceModel> getPerformance() async {
    try {
      final response = await apiConsumer.get(ApiEndpoints.performance);

      final data = response.data['data'];

      if (data is! Map<String, dynamic>) {
        throw const FormatException('Invalid performance response format');
      }

      return PerformanceModel.fromJson(data);
    } on DioException catch (e) {
      throw Exception(ErrorMessage.fromDioException(e));
    } catch (e) {
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }
}
