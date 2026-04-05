import 'package:architecture_learning/features/users/models/user_model.dart';

abstract class UserRepository {
  Future<List<UserModel>> fetchUsers();

  Future<UserModel> createUser(Map<String, dynamic> body);

  Future<UserModel> updateUser(int id, Map<String, dynamic> body);

  Future<void> deleteUser(int id);

  Future<void> logout();
}
