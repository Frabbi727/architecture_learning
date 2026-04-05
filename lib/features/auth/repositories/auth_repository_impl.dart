import 'package:architecture_learning/core/constants/api_constants.dart';
import 'package:architecture_learning/core/network/api_client.dart';
import 'package:architecture_learning/core/network/auth_storage.dart';
import 'package:architecture_learning/features/auth/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._apiClient, this._authStorage);

  final ApiClient _apiClient;
  final AuthStorage _authStorage;

  @override
  Future<void> login({
    required String username,
    required String password,
  }) async {
    final data = await _apiClient.post(
      ApiConstants.login,
      {
        'username': username,
        'password': password,
        'expiresInMins': 30,
      },
    );

    final token = data['accessToken'] as String?;
    final refreshToken = data['refreshToken'] as String?;

    if (token == null || token.isEmpty) {
      throw Exception('Login succeeded but token was missing');
    }

    await _authStorage.saveToken(token);
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await _authStorage.saveRefreshToken(refreshToken);
    }
  }

  @override
  Future<void> logout() {
    return _authStorage.clearToken();
  }
}
