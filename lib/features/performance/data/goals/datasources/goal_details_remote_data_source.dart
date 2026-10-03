// import 'package:dio/dio.dart';
// import 'package:workwise/core/network/api_consumer.dart';
// import 'package:workwise/core/network/endpoints/api_endpoints.dart';

// import '../models/goal_details_model.dart';

// abstract interface class GoalDetailsRemoteDataSource {
//   Future<GoalDetailsModel> getGoalDetails(int goalId);
// }

// class GoalDetailsRemoteDataSourceImpl implements GoalDetailsRemoteDataSource {
//   const GoalDetailsRemoteDataSourceImpl({required this.apiConsumer});

//   final ApiConsumer apiConsumer;

//   @override
//   Future<GoalDetailsModel> getGoalDetails(int goalId) async {
//     try {
//       final response = await apiConsumer.get(ApiEndpoints.goalDetails(goalId));

//       final responseData = response.data;

//       if (responseData is! Map<String, dynamic>) {
//         throw const FormatException('Invalid goal details response format');
//       }

//       final data = responseData['data'];

//       if (data is! Map<String, dynamic>) {
//         throw const FormatException('Invalid goal details data format');
//       }

//       return GoalDetailsModel.fromJson(data);
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

import '../models/goal_details_model.dart';

abstract interface class GoalDetailsRemoteDataSource {
  Future<GoalDetailsModel> getGoalDetails(int goalId);
}

class GoalDetailsRemoteDataSourceImpl implements GoalDetailsRemoteDataSource {
  const GoalDetailsRemoteDataSourceImpl({required this.apiConsumer});

  final ApiConsumer apiConsumer;

  @override
  Future<GoalDetailsModel> getGoalDetails(int goalId) async {
    try {
      final response = await apiConsumer.get(ApiEndpoints.goalDetails(goalId));

      final responseData = response.data;

      if (responseData is! Map<String, dynamic>) {
        throw const FormatException('Invalid goal details response format');
      }

      final data = responseData['data'];

      if (data is! Map<String, dynamic>) {
        throw const FormatException('Invalid goal details data format');
      }

      return GoalDetailsModel.fromJson(data);
    } on DioException catch (e) {
      throw Exception(ErrorMessage.fromDioException(e));
    } catch (e) {
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }
}
