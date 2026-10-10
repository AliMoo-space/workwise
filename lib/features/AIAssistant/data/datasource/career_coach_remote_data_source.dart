import 'package:dio/dio.dart';
import 'package:workwise/core/network/api_consumer.dart';
import 'package:workwise/core/network/endpoints/api_endpoints.dart';
import 'package:workwise/core/network/error_message.dart';
import 'package:workwise/core/utils/json_helper.dart';

import '../models/career_coach_model.dart';

abstract interface class CareerCoachRemoteDataSource {
  Future<CareerCoachModel> getCareerCoach(Map<String, dynamic> body);
}

class CareerCoachRemoteDataSourceImpl implements CareerCoachRemoteDataSource {
  const CareerCoachRemoteDataSourceImpl({required this.apiConsumer});

  final ApiConsumer apiConsumer;

  @override
  Future<CareerCoachModel> getCareerCoach(Map<String, dynamic> body) async {
    try {
      // Added body to Career Coach API request
      // to send the employee code to the backend.
      final response = await apiConsumer.post(
        ApiEndpoints.careerCoach,
        data: body,
      );

      final responseData = response.data;

      if (responseData is! Map<String, dynamic>) {
        throw const FormatException('Invalid career coach response format');
      }

      final data = JsonHelper.required<Map<String, dynamic>>(
        responseData,
        'data',
      );

      return CareerCoachModel.fromJson(data);
    } on DioException catch (e) {
      throw Exception(ErrorMessage.fromDioException(e));
    } catch (e) {
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }
}
