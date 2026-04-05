import 'package:architecture_learning/core/errors/app_error.dart';
import 'package:architecture_learning/core/result/result.dart';
import 'package:architecture_learning/data/datasources/user_remote_data_source.dart';
import 'package:architecture_learning/data/models/user_model.dart';
import 'package:architecture_learning/domain/entities/user.dart';
import 'package:architecture_learning/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  const UserRepositoryImpl(this._remoteDataSource);

  final UserRemoteDataSource _remoteDataSource;

  @override
  Future<Result<User>> createUser(User user) async {
    try {
      final created = await _remoteDataSource.createUser(
        UserModel.fromEntity(user),
      );
      return Success<User>(created.toEntity());
    } on AppError catch (error) {
      return Failure<User>(error.message);
    } catch (_) {
      return const Failure<User>('Unexpected create user error');
    }
  }

  @override
  Future<Result<void>> deleteUser(String id) async {
    try {
      await _remoteDataSource.deleteUser(id);
      return const Success<void>(null);
    } on AppError catch (error) {
      return Failure<void>(error.message);
    } catch (_) {
      return const Failure<void>('Unexpected delete user error');
    }
  }

  @override
  Future<Result<List<User>>> getUsers() async {
    try {
      final users = await _remoteDataSource.getUsers();
      return Success<List<User>>(
        users.map((user) => user.toEntity()).toList(growable: false),
      );
    } on AppError catch (error) {
      return Failure<List<User>>(error.message);
    } catch (_) {
      return const Failure<List<User>>('Unexpected fetch users error');
    }
  }

  @override
  Future<Result<User>> updateUser(User user) async {
    try {
      final updated = await _remoteDataSource.updateUser(
        UserModel.fromEntity(user),
      );
      return Success<User>(updated.toEntity());
    } on AppError catch (error) {
      return Failure<User>(error.message);
    } catch (_) {
      return const Failure<User>('Unexpected update user error');
    }
  }
}
