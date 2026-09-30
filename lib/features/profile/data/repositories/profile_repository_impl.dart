import 'dart:io';

import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this.remoteDataSource);

  final ProfileRemoteDataSource remoteDataSource;

  @override
  Future<Profile> getProfile({
    required int employeeId,
    required String language,
  }) async {
    final model = await remoteDataSource.getProfile(
      employeeId: employeeId,
      language: language,
    );

    return Profile(
      id: model.id,
      name: model.name,
      email: model.email,
      phone: model.phone,
      employeeCode: model.employeeCode,
      jobTitle: model.jobTitle,
      employmentType: model.employmentType,
      startDate: model.startDate,
      status: model.status,
      address: model.address,
      avatarUrl: model.avatarUrl,
      role: model.role,
      roleLabel: model.roleLabel,
      locale: model.locale,
      departmentName: model.department?.name,
      companyLocationName: model.companyLocation?.name,
      managerName: model.manager?.name,
    );
  }

  @override
  Future<Profile> updateProfile({
    required String language,
    String? name,
    String? phone,
    String? address,
    String? locale,
    File? avatar,
  }) async {
    final model = await remoteDataSource.updateProfile(
      language: language,
      name: name,
      phone: phone,
      address: address,
      locale: locale,
      avatar: avatar,
    );

    return Profile(
      id: model.id,
      name: model.name,
      email: model.email,
      phone: model.phone,
      employeeCode: model.employeeCode,
      jobTitle: model.jobTitle,
      employmentType: model.employmentType,
      startDate: model.startDate,
      status: model.status,
      address: model.address,
      avatarUrl: model.avatarUrl,
      role: model.role,
      roleLabel: model.roleLabel,
      locale: model.locale,
      departmentName: model.department?.name,
      companyLocationName: model.companyLocation?.name,
      managerName: model.manager?.name,
    );
  }
}
