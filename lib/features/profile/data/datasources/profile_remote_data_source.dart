import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/network/api_consumer.dart';
import '../../../../core/network/endpoints/api_endpoints.dart';
import '../models/profile_model.dart';

class ProfileRemoteDataSource {
  ProfileRemoteDataSource(this.apiConsumer);

  final ApiConsumer apiConsumer;

  Future<ProfileModel> getProfile({
    required int employeeId,
    required String language,
  }) async {
    final response = await apiConsumer.get(
      ApiEndpoints.employeeDetails(employeeId),
      queryParameters: {'lang': language},
    );

    final data = response.data['data'];

    return ProfileModel.fromJson(Map<String, dynamic>.from(data));
  }

  Future<ProfileModel> updateProfile({
    required String language,
    String? name,
    String? phone,
    String? address,
    String? locale,
    File? avatar,
  }) async {
    final fields = <String, dynamic>{
      'name': name,
      'phone': phone,
      'address': address,
      'locale': locale,
    }..removeWhere((key, value) => value == null);

    if (avatar != null) {
      fields['avatar'] = await MultipartFile.fromFile(
        avatar.path,
        filename: avatar.path.split('/').last,
      );
    }

    final formData = FormData.fromMap(fields);

    final response = await apiConsumer.patch(
      ApiEndpoints.employeeProfile,
      queryParameters: {'lang': language},
      data: formData,
    );

    final data = response.data['data'];

    return ProfileModel.fromJson(Map<String, dynamic>.from(data));
  }
}
