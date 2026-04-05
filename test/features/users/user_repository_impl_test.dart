import 'package:architecture_learning/core/enums/enums.dart';
import 'package:architecture_learning/core/network/api_client.dart';
import 'package:architecture_learning/core/network/auth_storage.dart';
import 'package:architecture_learning/features/users/models/user_model.dart';
import 'package:architecture_learning/features/users/repositories/user_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAuthStorage extends AuthStorage {}

class _FakeUsersApiClient extends ApiClient {
  _FakeUsersApiClient(super.authStorage);

  @override
  Future<T> get<T>(
    String endpoint, {
    required T Function(dynamic data) parser,
  }) async {
    return parser(<String, dynamic>{
      'users': <Map<String, dynamic>>[
        {
          'id': 1,
          'firstName': 'Emily',
          'lastName': 'Johnson',
          'email': 'emily.johnson@x.dummyjson.com',
          'image': 'https://dummyjson.com/icon/emilys/128',
        },
      ],
    });
  }
}

void main() {
  test('user repository parses list response', () async {
    final repository = UserRepositoryImpl(
      _FakeUsersApiClient(_FakeAuthStorage()),
      _FakeAuthStorage(),
    );

    final result = await repository.fetchUsers();

    expect(result.status, ResourceStatus.success);
    expect(result.model, hasLength(1));
    expect(result.model!.first, isA<UserModel>());
    expect(result.model!.first.fullName, 'Emily Johnson');
  });
}
