import 'package:image_picker/image_picker.dart';
import '../../../../core/network/api_consumer.dart';
import 'get_profile_remote_data_source.dart';
import '../models/profile_model.dart';
import 'profile_payload_normalizer.dart';
import 'update_profile_remote_data_source.dart';

class ProfileRemoteDataSource {
  ProfileRemoteDataSource(this.apiConsumer)
    : _getProfileDataSource = GetProfileRemoteDataSource(apiConsumer),
      _updateProfileDataSource = UpdateProfileRemoteDataSource(apiConsumer);

  final ApiConsumer apiConsumer;
  final GetProfileRemoteDataSource _getProfileDataSource;
  final UpdateProfileRemoteDataSource _updateProfileDataSource;

  static Map<String, dynamic> normalizeProfilePayload(dynamic payload) {
    return ProfilePayloadNormalizer.normalize(payload);
  }

  Future<ProfileModel> getProfile({
    required int employeeId,
    required String language,
  }) async {
    return _getProfileDataSource.getProfile(
      employeeId: employeeId,
      language: language,
    );
  }

  Future<ProfileModel> updateProfile({
    required String language,
    String? name,
    String? phone,
    String? address,
    String? locale,
    XFile? avatar,
  }) async {
    return _updateProfileDataSource.updateProfile(
      language: language,
      name: name,
      phone: phone,
      address: address,
      locale: locale,
      avatar: avatar,
    );
  }
}
