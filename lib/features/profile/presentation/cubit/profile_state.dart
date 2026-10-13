import 'package:equatable/equatable.dart';
import 'package:workwise/core/errors/failure.dart';
import '../../domain/entities/profile.dart';

enum ProfileStatus { initial, loading, success, failure }

class ProfileState extends Equatable {
  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.message,
    this.failure,
  });

  final ProfileStatus status;
  final Profile? profile;
  final String? message;
  final Failure? failure;

  bool get isLoading => status == ProfileStatus.loading;

  bool get isSuccess => status == ProfileStatus.success;

  bool get isFailure => status == ProfileStatus.failure;

  ProfileState copyWith({
    ProfileStatus? status,
    Profile? profile,
    String? message,
    Failure? failure,
    bool clearProfile = false,
    bool clearMessage = false,
    bool clearFailure = false,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: clearProfile ? null : profile ?? this.profile,
      message: clearMessage ? null : message ?? this.message,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [status, profile, message, failure];
}
