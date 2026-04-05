import 'package:architecture_learning/core/utils/resource.dart';
import 'package:architecture_learning/features/users/models/user_model.dart';

abstract class UserRepository {
  Future<Resource<List<UserModel>>> fetchUsers();

  Future<Resource<UserModel>> createUser(Map<String, dynamic> body);

  Future<Resource<UserModel>> updateUser(int id, Map<String, dynamic> body);

  Future<Resource<void>> deleteUser(int id);

  Future<void> logout();
}
