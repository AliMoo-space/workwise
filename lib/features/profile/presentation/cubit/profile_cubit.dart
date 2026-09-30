import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/profile_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._repository) : super(const ProfileState());

  final ProfileRepository _repository;

  Future<void> getProfile({
    required int? employeeId,
    required String language,
  }) async {
    emit(state.copyWith(status: ProfileStatus.loading, clearMessage: true));

    if (employeeId == null || employeeId <= 0) {
      emit(
        state.copyWith(
          status: ProfileStatus.failure,
          message: 'Employee ID is unavailable. Please sign in again.',
        ),
      );
      return;
    }

    try {
      final profile = await _repository.getProfile(
        employeeId: employeeId,
        language: language,
      );

      emit(
        state.copyWith(
          status: ProfileStatus.success,
          profile: profile,
          clearMessage: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: ProfileStatus.failure, message: e.toString()),
      );
    }
  }

  Future<void> updateProfile({
    required String language,
    String? name,
    String? phone,
    String? address,
    String? locale,
    File? avatar,
  }) async {
    emit(state.copyWith(status: ProfileStatus.loading, clearMessage: true));

    try {
      final profile = await _repository.updateProfile(
        language: language,
        name: name,
        phone: phone,
        address: address,
        locale: locale,
        avatar: avatar,
      );

      emit(
        state.copyWith(
          status: ProfileStatus.success,
          profile: profile,
          message: 'Profile updated successfully.',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: ProfileStatus.failure, message: e.toString()),
      );
    }
  }
}
