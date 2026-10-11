import 'package:equatable/equatable.dart';
import '../../domain/entities/profile.dart';

enum ProfileStatus {
  initial,
  loading,
  success,
  failure,
}

class ProfileState extends Equatable {
  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.message,
  });

  final ProfileStatus status;
  final Profile? profile;
  final String? message;

  bool get isLoading => status == ProfileStatus.loading;

  bool get isSuccess => status == ProfileStatus.success;

  bool get isFailure => status == ProfileStatus.failure;

  ProfileState copyWith({
    ProfileStatus? status,
    Profile? profile,
    String? message,
    bool clearProfile = false,
    bool clearMessage = false,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: clearProfile ? null : profile ?? this.profile,
      message: clearMessage ? null : message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        status,
        profile,
        message,
      ];
}