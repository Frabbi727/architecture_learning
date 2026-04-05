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
      'success': true,
      'data': <String, dynamic>{
        'token_type': 'Bearer',
        'access_token': 'jwt-token',
        'expires_in': 3600,
        'refresh_token': 'refresh-token',
        'refresh_expires_in': 2592000,
        'user': <String, dynamic>{
          'id': 1,
          'name': 'Super Admin',
          'email': 'super.admin@example.com',
          'role': 'super_admin',
          'created_at': '2026-03-04T05:27:19.000000Z',
        },
      },
      'meta': <String, dynamic>{},
    };
  }
}

void main() {
  test('login saves access and refresh tokens', () async {
    final storage = _FakeAuthStorage();
    final repository = AuthRepositoryImpl(_FakeApiClient(storage), storage);

    await repository.login(email: 'emilys', password: 'emilyspass');

    expect(storage.savedToken, 'jwt-token');
    expect(storage.savedRefreshToken, 'refresh-token');
  });
}
