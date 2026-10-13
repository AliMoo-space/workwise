import 'package:dio/dio.dart';
import 'package:workwise/features/auth/login/data/models/login_response_model.dart';
import 'package:workwise/features/auth/login/data/datasources/login_api_service.dart';
import 'package:workwise/features/auth/login/data/datasources/permissions_api_service.dart';

abstract class LoginRemoteDataSource {
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  });

  Future<Response<dynamic>> getPermissions();
}

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  final LoginApiService loginApiService;
  final PermissionsApiService permissionsApiService;

  LoginRemoteDataSourceImpl({
    required this.loginApiService,
    required this.permissionsApiService,
  });

  @override
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await loginApiService.login(
      email: email,
      password: password,
    );

    final responseData = response.data as Map<String, dynamic>;
    return LoginResponseModel.fromJson(responseData);
  }

  @override
  Future<Response<dynamic>> getPermissions() async {
    return await permissionsApiService.getPermissions();
  }
}