// import 'package:dio/dio.dart';
// import 'package:workwise/core/network/api_consumer.dart';
// import 'package:workwise/core/network/endpoints/api_endpoints.dart';

// import '../models/goal_model.dart';

// abstract interface class GoalsRemoteDataSource {
//   Future<List<GoalModel>> getGoals();
// }

// class GoalsRemoteDataSourceImpl implements GoalsRemoteDataSource {
//   const GoalsRemoteDataSourceImpl(this.apiConsumer);

//   final ApiConsumer apiConsumer;

//   @override
//   Future<List<GoalModel>> getGoals() async {
//     try {
//       final response = await apiConsumer.get(ApiEndpoints.goals);

//       final responseData = response.data;

//       if (responseData is! Map<String, dynamic>) {
//         throw const FormatException('Invalid goals response format');
//       }

//       final data = responseData['data'];

//       if (data is! Map<String, dynamic>) {
//         throw const FormatException('Invalid goals data format');
//       }

//       final goalsData = data['data'];

//       if (goalsData is! List) {
//         throw const FormatException('Invalid goals list format');
//       }

//       return goalsData
//           .map((goal) => GoalModel.fromJson(goal as Map<String, dynamic>))
//           .toList();
//     } on DioException catch (e) {
//       final responseData = e.response?.data;

//       if (responseData is Map<String, dynamic>) {
//         final message = responseData['message'];

//         if (message is String && message.isNotEmpty) {
//           throw Exception(message);
//         }
//       }

//       throw Exception(e.message ?? 'Something went wrong');
//     } catch (e) {
//       throw Exception(e.toString().replaceFirst('Exception: ', ''));
//     }
//   }
// }
import 'package:dio/dio.dart';
import 'package:workwise/core/network/api_consumer.dart';
import 'package:workwise/core/network/endpoints/api_endpoints.dart';
import 'package:workwise/core/network/error_message.dart';

import '../models/goal_model.dart';

abstract interface class GoalsRemoteDataSource {
  Future<List<GoalModel>> getGoals();
}

class GoalsRemoteDataSourceImpl implements GoalsRemoteDataSource {
  const GoalsRemoteDataSourceImpl(this.apiConsumer);

  final ApiConsumer apiConsumer;

  @override
  Future<List<GoalModel>> getGoals() async {
    try {
      final response = await apiConsumer.get(ApiEndpoints.goals);

      final responseData = response.data;

      if (responseData is! Map<String, dynamic>) {
        throw const FormatException('Invalid goals response format');
      }

      final data = responseData['data'];

      if (data is! Map<String, dynamic>) {
        throw const FormatException('Invalid goals data format');
      }

      final goalsData = data['data'];

      if (goalsData is! List) {
        throw const FormatException('Invalid goals list format');
      }

      return goalsData
          .map((goal) => GoalModel.fromJson(goal as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(ErrorMessage.fromDioException(e));
    } catch (e) {
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }
}
