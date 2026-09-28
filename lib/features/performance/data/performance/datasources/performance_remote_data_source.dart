import 'package:dio/dio.dart';

import 'package:workwise/core/network/api_constants.dart';
import 'package:workwise/features/performance/data/performance/models/performance_model.dart';

abstract class PerformanceRemoteDataSource {
  Future<PerformanceModel> getPerformance();
}

class PerformanceRemoteDataSourceImpl implements PerformanceRemoteDataSource {
  final Dio dio;

  const PerformanceRemoteDataSourceImpl({required this.dio});

  @override
  Future<PerformanceModel> getPerformance() async {
    try {
      final response = await dio.get(
        ApiConstants.performance,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization':
                'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2hyLXN5c3RlbS5pcHR2ZGVtby5zZXJ2NWdyb3VwLmNvbS9hcGkvYXV0aC9sb2dpbiIsImlhdCI6MTc5MDQxMDAzMSwiZXhwIjoxNzkwNDk2NDMxLCJuYmYiOjE3OTA0MTAwMzEsImp0aSI6IklpZ29KWGRKYk1EZ056RUciLCJzdWIiOiI2IiwicHJ2IjoiMjNiZDVjODk0OWY2MDBhZGIzOWU3MDFjNDAwODcyZGI3YTU5NzZmNyIsInJvbGUiOiJFbXBsb3llZSJ9.cA6rYwVfYtx11o318C7tG8vae1GjJggTfkGXonJD7ts',
          },
        ),
      );

      final data = response.data['data'] as Map<String, dynamic>;

      return PerformanceModel.fromJson(data);
    } on DioException catch (e) {
      final responseData = e.response?.data;

      if (responseData is Map<String, dynamic>) {
        final message = responseData['message'];

        if (message is String && message.isNotEmpty) {
          throw Exception(message);
        }
      }

      throw Exception('Something went wrong');
    }
  }
}
