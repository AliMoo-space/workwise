import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
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

    var map = Map<String, dynamic>.from(payload);

    if (map.containsKey('data') && map['data'] is Map) {
      map = Map<String, dynamic>.from(map['data'] as Map);
    }

    if (map.containsKey('employee') && map['employee'] is Map) {
      map = Map<String, dynamic>.from(map['employee'] as Map);
    } else if (map.containsKey('user') && map['user'] is Map) {
      map = Map<String, dynamic>.from(map['user'] as Map);
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
      '_method': 'PATCH',
    }..removeWhere((key, value) => value == null);

    if (avatar != null) {
      final ext = avatar.name.contains('.')
          ? avatar.name.split('.').last.toLowerCase()
          : 'jpg';
      final mimeSubtype = (ext == 'jpg' || ext == 'jpeg')
          ? 'jpeg'
          : (ext == 'png' ? 'png' : (ext == 'webp' ? 'webp' : 'jpeg'));

      fields['avatar'] = MultipartFile.fromBytes(
        await avatar.readAsBytes(),
        filename: avatar.name,
        contentType: MediaType('image', mimeSubtype),
      );
    }

    final formData = FormData.fromMap(fields);

    Response<dynamic> response;
    try {
      response = await apiConsumer.post(
        ApiEndpoints.employeeProfile,
        queryParameters: {'lang': language},
        data: formData,
        options: Options(
          headers: {'X-HTTP-Method-Override': 'PATCH'},
        ),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 405) {
        response = await apiConsumer.patch(
          ApiEndpoints.employeeProfile,
          queryParameters: {'lang': language},
          data: formData,
        );
      } else {
        rethrow;
      }
    }

    final data = normalizeProfilePayload(response.data);

    return ProfileModel.fromJson(data);
  }
}
