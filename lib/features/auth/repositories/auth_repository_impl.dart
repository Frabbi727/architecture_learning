import 'package:architecture_learning/core/constants/api_constants.dart';
import 'package:architecture_learning/core/network/api_client.dart';
import 'package:architecture_learning/core/network/auth_storage.dart';
import 'package:architecture_learning/features/auth/models/login_response_model.dart';
import 'package:architecture_learning/features/auth/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._apiClient, this._authStorage);

  final ApiClient _apiClient;
  final AuthStorage _authStorage;

  @override
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.login,
      {
        'email': email,
        'password': password,
      },
    );

    if (response is! Map<String, dynamic>) {
      throw Exception('Login response format was invalid');
    }

    final loginResponse = LoginResponseModel.fromJson(response);

    if (loginResponse.data.accessToken.isEmpty) {
      throw Exception('Login succeeded but token was missing');
    }

    await _authStorage.saveToken(loginResponse.data.accessToken);
    if (loginResponse.data.refreshToken.isNotEmpty) {
      await _authStorage.saveRefreshToken(loginResponse.data.refreshToken);
    }

    return loginResponse;
  }

  @override
  Future<void> logout() {
    return _authStorage.clearToken();
  }
}
