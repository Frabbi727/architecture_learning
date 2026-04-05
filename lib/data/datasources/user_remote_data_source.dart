import 'package:architecture_learning/core/constants/app_constants.dart';
import 'package:architecture_learning/core/errors/app_error.dart';
import 'package:architecture_learning/data/models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<List<UserModel>> getUsers();

  Future<UserModel> createUser(UserModel user);

  Future<UserModel> updateUser(UserModel user);

  Future<void> deleteUser(String id);
}

class MockUserRemoteDataSource implements UserRemoteDataSource {
  MockUserRemoteDataSource({
    List<UserModel>? initialUsers,
  }) : _users = initialUsers ??
            [
              const UserModel(
                id: 'u1',
                name: 'Ava Rahman',
                email: 'ava@company.dev',
                role: 'Product Designer',
              ),
              const UserModel(
                id: 'u2',
                name: 'Nabil Hasan',
                email: 'nabil@company.dev',
                role: 'Flutter Engineer',
              ),
              const UserModel(
                id: 'u3',
                name: 'Sara Ahmed',
                email: 'sara@company.dev',
                role: 'QA Analyst',
              ),
            ];

  final List<UserModel> _users;

  Future<void> _simulateDelay() async {
    await Future<void>.delayed(
      const Duration(milliseconds: AppConstants.mockDelayMs),
    );
  }

  @override
  Future<UserModel> createUser(UserModel user) async {
    await _simulateDelay();
    _throwIfEmailExists(user.email, excludeId: user.id);

    final created = user.id.isEmpty
        ? user.copyWith(id: DateTime.now().microsecondsSinceEpoch.toString())
        : user;
    _users.add(created);
    return created;
  }

  @override
  Future<void> deleteUser(String id) async {
    await _simulateDelay();

    final index = _users.indexWhere((user) => user.id == id);
    if (index == -1) {
      throw const AppError('User not found');
    }
    _users.removeAt(index);
  }

  @override
  Future<List<UserModel>> getUsers() async {
    await _simulateDelay();
    return List<UserModel>.from(_users);
  }

  @override
  Future<UserModel> updateUser(UserModel user) async {
    await _simulateDelay();
    _throwIfEmailExists(user.email, excludeId: user.id);

    final index = _users.indexWhere((item) => item.id == user.id);
    if (index == -1) {
      throw const AppError('User not found');
    }

    _users[index] = user;
    return user;
  }

  void _throwIfEmailExists(String email, {required String excludeId}) {
    final exists = _users.any(
      (user) =>
          user.email.toLowerCase() == email.toLowerCase() &&
          user.id != excludeId,
    );

    if (exists) {
      throw const AppError('Email already exists');
    }
  }
}
