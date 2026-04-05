import 'package:architecture_learning/features/users/controllers/users_controller.dart';
import 'package:architecture_learning/features/users/models/user_model.dart';
import 'package:architecture_learning/features/users/repositories/user_repository.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeUserRepository implements UserRepository {
  _FakeUserRepository(this.seedUsers);

  final List<UserModel> seedUsers;

  @override
  Future<UserModel> createUser(Map<String, dynamic> body) async {
    return UserModel(
      id: 2,
      firstName: body['firstName'] as String,
      lastName: body['lastName'] as String,
      email: body['email'] as String,
    );
  }

  @override
  Future<void> deleteUser(int id) async {}

  @override
  Future<List<UserModel>> fetchUsers() async => seedUsers;

  @override
  Future<void> logout() async {}

  @override
  Future<UserModel> updateUser(int id, Map<String, dynamic> body) async {
    return UserModel(
      id: id,
      firstName: body['firstName'] as String,
      lastName: body['lastName'] as String,
      email: body['email'] as String,
    );
  }
}

void main() {
  test('users controllers loads users successfully', () async {
    final controller = UsersController(
      _FakeUserRepository([
        const UserModel(
          id: 1,
          firstName: 'Emily',
          lastName: 'Johnson',
          email: 'emily.johnson@x.dummyjson.com',
        ),
      ]),
    );

    await controller.fetchUsers();

    expect(controller.users, hasLength(1));
    expect(controller.users.first.fullName, 'Emily Johnson');
  });
}
