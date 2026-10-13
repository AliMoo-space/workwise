import 'package:dio/dio.dart';
import 'package:workwise/core/network/api_consumer.dart';
import 'package:workwise/core/network/endpoints/api_endpoints.dart';
import 'package:workwise/core/network/error_message.dart';
import 'package:workwise/core/utils/json_helper.dart';

import '../models/policy_assistant_model.dart';

abstract interface class PolicyAssistantRemoteDataSource {
  Future<PolicyAssistantModel> askPolicyQuestion(Map<String, dynamic> body);
}

class PolicyAssistantRemoteDataSourceImpl
    implements PolicyAssistantRemoteDataSource {
  const PolicyAssistantRemoteDataSourceImpl({required this.apiConsumer});

  final ApiConsumer apiConsumer;

  @override
  Future<PolicyAssistantModel> askPolicyQuestion(
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await apiConsumer.post(
        ApiEndpoints.policyAssistant,
        data: body,
      );

      final responseData = response.data;

      if (responseData is! Map<String, dynamic>) {
        throw const FormatException('Invalid policy assistant response format');
      }

      final data = JsonHelper.required<Map<String, dynamic>>(
        responseData,
        'data',
      );

      return PolicyAssistantModel.fromJson({'data': data});
    } on DioException catch (e) {
      throw Exception(ErrorMessage.fromDioException(e));
    } on FormatException {
      rethrow;
    } catch (e) {
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }
}
