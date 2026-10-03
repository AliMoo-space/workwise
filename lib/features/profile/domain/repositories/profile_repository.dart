import 'package:image_picker/image_picker.dart';

import '../entities/profile.dart';

abstract interface class ProfileRepository {
  Future<Profile> getProfile({
    required int employeeId,
    required String language,
  });

  Future<Profile> updateProfile({
    required String language,
    String? name,
    String? phone,
    String? address,
    String? locale,
    XFile? avatar,
  });
}