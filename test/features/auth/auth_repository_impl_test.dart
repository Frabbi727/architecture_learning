import 'package:architecture_learning/core/network/api_client.dart';
import 'package:architecture_learning/core/network/auth_storage.dart';
import 'package:architecture_learning/features/auth/repositories/auth_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAuthStorage extends AuthStorage {
  String? savedToken;
  String? savedRefreshToken;

  @override
  Future<void> saveRefreshToken(String refreshToken) async {
    savedRefreshToken = refreshToken;
  }

  @override
  Future<void> saveToken(String token) async {
    savedToken = token;
  }

  @override
  Future<String?> getToken() async => savedToken;
}

class _FakeApiClient extends ApiClient {
  _FakeApiClient(super.authStorage);

  @override
  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    return <String, dynamic>{
      'accessToken': 'jwt-token',
      'refreshToken': 'refresh-token',
    };
  }
}

void main() {
  test('login saves access and refresh tokens', () async {
    final storage = _FakeAuthStorage();
    final repository = AuthRepositoryImpl(_FakeApiClient(storage), storage);

    await repository.login(username: 'emilys', password: 'emilyspass');

    expect(storage.savedToken, 'jwt-token');
    expect(storage.savedRefreshToken, 'refresh-token');
  });
}
