import 'package:architecture_learning/core/constants/api_constants.dart';
import 'package:architecture_learning/core/network/api_client.dart';
import 'package:architecture_learning/core/network/auth_storage.dart';
import 'package:architecture_learning/core/enums/enums.dart';
import 'package:architecture_learning/core/utils/resource.dart';
import 'package:architecture_learning/features/auth/models/login_response_model.dart';
import 'package:architecture_learning/features/auth/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._apiClient, this._authStorage);

  final ApiClient _apiClient;
  final AuthStorage _authStorage;

  @override
  Future<Resource<LoginResponseModel>> login({
    required String email,
    required String password,
  }) async {
    final result = await _apiClient.postModelResource<LoginResponseModel>(
      ApiConstants.login,
      {
        'email': email,
        'password': password,
      },
      parser: LoginResponseModel.fromJson,
    );

    final loginResponse = result.model;
    if (result.status != ResourceStatus.success || loginResponse == null) {
      return result;
    }

    if (loginResponse.data.accessToken.isEmpty) {
      return Resource<LoginResponseModel>(
        status: ResourceStatus.error,
        message: 'Login succeeded but token was missing',
      );
    }

    await _authStorage.saveToken(loginResponse.data.accessToken);
    if (loginResponse.data.refreshToken.isNotEmpty) {
      await _authStorage.saveRefreshToken(loginResponse.data.refreshToken);
    }

    return Resource<LoginResponseModel>(
      status: ResourceStatus.success,
      model: loginResponse,
      code: result.code,
    );
  }

  @override
  Future<void> logout() {
    return _authStorage.clearToken();
  }
}
