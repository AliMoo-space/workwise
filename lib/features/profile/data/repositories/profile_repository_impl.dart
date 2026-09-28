// import 'dart:io';

// import '../../domain/entities/profile.dart';
// import '../../domain/repositories/profile_repository.dart';
// import '../datasources/profile_remote_data_source.dart';

// class ProfileRepositoryImpl implements ProfileRepository {
//   final ProfileRemoteDataSource remoteDataSource;

//   ProfileRepositoryImpl(this.remoteDataSource);

//   @override
//   Future<Profile> updateProfile({
//     required String name,
//     required String phone,
//     required String address,
//     required String locale,
//     File? avatar,
//   }) async {
//     final model = await remoteDataSource.updateProfile(
//       name: name,
//       phone: phone,
//       address: address,
//       locale: locale,
//       avatar: avatar,
//     );

//     return model.toEntity();
//   }
// }