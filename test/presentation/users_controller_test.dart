import 'package:architecture_learning/core/result/result.dart';
import 'package:architecture_learning/domain/entities/auth_session.dart';
import 'package:architecture_learning/domain/entities/user.dart';
import 'package:architecture_learning/domain/repositories/auth_repository.dart';
import 'package:architecture_learning/domain/repositories/user_repository.dart';
import 'package:architecture_learning/domain/usecases/create_user_usecase.dart';
import 'package:architecture_learning/domain/usecases/delete_user_usecase.dart';
import 'package:architecture_learning/domain/usecases/get_users_usecase.dart';
import 'package:architecture_learning/domain/usecases/logout_usecase.dart';
import 'package:architecture_learning/domain/usecases/update_user_usecase.dart';
import 'package:architecture_learning/presentation/users/controllers/users_controller.dart';
import 'package:flutter_test/flutter_test.dart';

class _UserRepositoryStub implements UserRepository {
  _UserRepositoryStub(this._users);

  final List<User> _users;

  @override
  Future<Result<User>> createUser(User user) async {
    final created = user.copyWith(id: '${_users.length + 1}');
    _users.add(created);
    return Success<User>(created);
  }

  @override
  Future<Result<void>> deleteUser(String id) async {
    _users.removeWhere((user) => user.id == id);
    return const Success<void>(null);
  }

  @override
  Future<Result<List<User>>> getUsers() async {
    return Success<List<User>>(List<User>.from(_users));
  }

  @override
  Future<Result<User>> updateUser(User user) async {
    final index = _users.indexWhere((item) => item.id == user.id);
    _users[index] = user;
    return Success<User>(user);
  }
}

class _LogoutRepositoryStub implements AuthRepository {
  @override
  Future<Result<AuthSession>> login({
    required String email,
    required String password,
  }) async {
    return const Failure<AuthSession>('Unused');
  }

  @override
  Future<Result<void>> logout() async => const Success<void>(null);
}

void main() {
  group('UsersController', () {
    test('loads empty state correctly', () async {
      final userRepository = _UserRepositoryStub([]);
      final controller = UsersController(
        getUsersUseCase: GetUsersUseCase(userRepository),
        createUserUseCase: CreateUserUseCase(userRepository),
        updateUserUseCase: UpdateUserUseCase(userRepository),
        deleteUserUseCase: DeleteUserUseCase(userRepository),
        logoutUseCase: LogoutUseCase(_LogoutRepositoryStub()),
      );

      await controller.loadUsers();

      expect(controller.users, isEmpty);
      expect(controller.hasUsers, isFalse);
    });

    test('create, update, and delete mutate controller state', () async {
      final userRepository = _UserRepositoryStub([
        const User(
          id: '1',
          name: 'Ava',
          email: 'ava@company.dev',
          role: 'Designer',
        ),
      ]);

      final controller = UsersController(
        getUsersUseCase: GetUsersUseCase(userRepository),
        createUserUseCase: CreateUserUseCase(userRepository),
        updateUserUseCase: UpdateUserUseCase(userRepository),
        deleteUserUseCase: DeleteUserUseCase(userRepository),
        logoutUseCase: LogoutUseCase(_LogoutRepositoryStub()),
      );

      await controller.loadUsers();
      await controller.createUser(
        name: 'Nabil',
        email: 'nabil@company.dev',
        role: 'Engineer',
      );
      await controller.updateUser(
        id: '1',
        name: 'Ava Rahman',
        email: 'ava@company.dev',
        role: 'Lead Designer',
      );
      await controller.deleteUser('2');

      expect(controller.users, hasLength(1));
      expect(controller.users.first.name, 'Ava Rahman');
      expect(controller.users.first.role, 'Lead Designer');
    });
  });
}
