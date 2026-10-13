import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:workwise/core/errors/exception.dart';
import 'package:workwise/core/errors/failure.dart';
import '../../domain/repositories/profile_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._repository) : super(const ProfileState());

  final ProfileRepository _repository;

  Future<void> getProfile({
    required int? employeeId,
    required String language,
  }) async {
    emit(
      state.copyWith(
        status: ProfileStatus.loading,
        clearMessage: true,
        clearFailure: true,
      ),
    );

    if (employeeId == null || employeeId <= 0) {
      const failure = UnauthorizedFailure('Please sign in again.');
      emit(
        state.copyWith(
          status: ProfileStatus.failure,
          message: failure.message,
          failure: failure,
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
          clearFailure: true,
        ),
      );
    } catch (e) {
      final failure = _mapFailure(e);
      emit(
        state.copyWith(
          status: ProfileStatus.failure,
          message: failure.message,
          failure: failure,
        ),
      );
    }
  }

  Future<bool> updateProfile({
    required String language,
    String? name,
    String? phone,
    String? address,
    String? locale,
    XFile? avatar,
  }) async {
    emit(
      state.copyWith(
        status: ProfileStatus.loading,
        clearMessage: true,
        clearFailure: true,
      ),
    );

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
          clearFailure: true,
        ),
      );

      return true;
    } catch (e) {
      final failure = _mapFailure(e);
      emit(
        state.copyWith(
          status: ProfileStatus.failure,
          message: failure.message,
          failure: failure,
        ),
      );

      return false;
    }
  }

  Future<bool> deleteProfileAvatar(int fileId) async {
    emit(
      state.copyWith(
        status: ProfileStatus.loading,
        clearMessage: true,
        clearFailure: true,
      ),
    );

    try {
      await _repository.deleteProfileAvatar(fileId);
      final profile = state.profile;

      emit(
        state.copyWith(
          status: ProfileStatus.success,
          profile: profile?.copyWith(
            avatarUrl: '',
            clearAvatarFileId: true,
          ),
          clearMessage: true,
          clearFailure: true,
        ),
      );

      return true;
    } catch (e) {
      final failure = _mapFailure(e);
      emit(
        state.copyWith(
          status: ProfileStatus.failure,
          message: failure.message,
          failure: failure,
        ),
      );

      return false;
    }
  }

  Failure _mapFailure(Object error) {
    if (error is AppException) {
      return switch (error) {
        NetworkException() => NetworkFailure(error.message),
        UnauthorizedException() => UnauthorizedFailure(error.message),
        ValidationException() => ValidationFailure(error.message),
        ServerException() => ServerFailure(error.message),
        CacheException() => CacheFailure(error.message),
        _ => ServerFailure(error.message),
      };
    }

    return ServerFailure(error.toString());
  }
}
