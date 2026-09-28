import 'dart:io';

import '../entities/profile.dart';
import '../repositories/profile_repository.dart';

class UpdateProfile {
  final ProfileRepository repository;

  UpdateProfile(this.repository);

  Future<Profile> call({
    required String name,
    required String phone,
    required String address,
    required String locale,
    File? avatar,
  }) {
    return repository.updateProfile(
      name: name,
      phone: phone,
      address: address,
      locale: locale,
      avatar: avatar,
    );
  }
}