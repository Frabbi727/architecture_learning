import 'package:architecture_learning/core/result/result.dart';
import 'package:architecture_learning/domain/entities/user.dart';

abstract class UserRepository {
  Future<Result<List<User>>> getUsers();

  Future<Result<User>> createUser(User user);

  Future<Result<User>> updateUser(User user);

  Future<Result<void>> deleteUser(String id);
}
