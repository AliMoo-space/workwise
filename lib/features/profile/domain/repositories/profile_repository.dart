import 'dart:io';

import '../entities/profile.dart';

abstract class ProfileRepository {
  Future<Profile> updateProfile({
    required String name,
    required String phone,
    required String address,
    required String locale,
    File? avatar,
  });
}