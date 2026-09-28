import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/update_profile.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final UpdateProfile updateProfile;

  ProfileCubit(this.updateProfile)
      : super(ProfileInitial());

  Future<void> update({
    required String name,
    required String phone,
    required String address,
    required String locale,
    File? avatar,
  }) async {
    emit(ProfileUpdating());

    try {
      final profile = await updateProfile(
        name: name,
        phone: phone,
        address: address,
        locale: locale,
        avatar: avatar,
      );

      emit(
        ProfileUpdated(profile),
      );
    } catch (e) {
      emit(
        ProfileUpdateError(
          e.toString(),
        ),
      );
    }
  }
}