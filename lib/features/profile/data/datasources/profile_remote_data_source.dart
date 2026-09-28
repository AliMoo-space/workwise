// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:workwise/core/network/api_endpoints.dart';

// import '../models/profile_model.dart';

// abstract class ProfileRemoteDataSource {
//   Future<ProfileModel> updateProfile({
//     required String name,
//     required String phone,
//     required String address,
//     required String locale,
//     File? avatar,
//   });
// }

// class ProfileRemoteDataSourceImpl
//     implements ProfileRemoteDataSource {
//   final Dio dio;

//   ProfileRemoteDataSourceImpl(this.dio);

//   @override
//   Future<ProfileModel> updateProfile({
//     required String name,
//     required String phone,
//     required String address,
//     required String locale,
//     File? avatar,
//   }) async {
//     final formData = FormData.fromMap({
//       'name': name,
//       'phone': phone,
//       'address': address,
//       'locale': locale,

//       if (avatar != null)
//         'avatar': await MultipartFile.fromFile(
//           avatar.path,
//           filename: avatar.path.split(Platform.pathSeparator).last,
//         ),
//     });

//     final response = await dio.patch(
//       ApiEndpoints.updateProfile,
//       queryParameters: {
//         'lang': locale,
//       },
//       data: formData,
//     );

//     final data = response.data['data'];

//     return ProfileModel.fromJson(
//       data as Map<String, dynamic>,
//     );
//   }
// }