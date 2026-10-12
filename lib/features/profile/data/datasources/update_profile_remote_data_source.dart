import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/network/api_consumer.dart';
import '../../../../core/network/endpoints/api_endpoints.dart';
import '../models/profile_model.dart';
import 'profile_payload_normalizer.dart';

class UpdateProfileRemoteDataSource {
  UpdateProfileRemoteDataSource(this.apiConsumer);

  final ApiConsumer apiConsumer;

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
        options: Options(headers: {'X-HTTP-Method-Override': 'PATCH'}),
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

    final data = ProfilePayloadNormalizer.normalize(response.data);

    return ProfileModel.fromJson(data);
  }
}
