import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/network/api_consumer.dart';
import '../../../../core/network/endpoints/api_endpoints.dart';
import '../models/profile_model.dart';

class ProfileRemoteDataSource {
  ProfileRemoteDataSource(this.apiConsumer);

  final ApiConsumer apiConsumer;

  static Map<String, dynamic> normalizeProfilePayload(dynamic payload) {
    if (payload is! Map) {
      return <String, dynamic>{};
    }

    final map = Map<String, dynamic>.from(payload);

    if (map.containsKey('data') && map['data'] is Map) {
      return Map<String, dynamic>.from(map['data'] as Map);
    }

    if (map.containsKey('employee') && map['employee'] is Map) {
      return Map<String, dynamic>.from(map['employee'] as Map);
    }

    return map;
  }

  Future<ProfileModel> getProfile({
    required int employeeId,
    required String language,
  }) async {
    final response = await apiConsumer.get(
      ApiEndpoints.employeeDetails(employeeId),
      queryParameters: {'lang': language},
    );

    final data = normalizeProfilePayload(response.data);

    return ProfileModel.fromJson(data);
  }

  Future<ProfileModel> updateProfile({
    required String language,
    String? name,
    String? phone,
    String? address,
    String? locale,
    XFile? avatar,
  }) async {
    final fields = <String, dynamic>{
      'name': name,
      'phone': phone,
      'address': address,
      'locale': locale,
    }..removeWhere((key, value) => value == null);

    if (avatar != null) {
      fields['avatar'] = MultipartFile.fromBytes(
        await avatar.readAsBytes(),
        filename: avatar.name,
      );
    }

    final formData = FormData.fromMap(fields);

    final response = await apiConsumer.patch(
      ApiEndpoints.employeeProfile,
      queryParameters: {'lang': language},
      data: formData,
    );

    final data = normalizeProfilePayload(response.data);

    return ProfileModel.fromJson(data);
  }
}
