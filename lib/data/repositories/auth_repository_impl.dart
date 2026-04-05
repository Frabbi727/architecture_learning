import 'package:architecture_learning/core/errors/app_error.dart';
import 'package:architecture_learning/core/result/result.dart';
import 'package:architecture_learning/data/datasources/auth_remote_data_source.dart';
import 'package:architecture_learning/domain/entities/auth_session.dart';
import 'package:architecture_learning/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<Result<AuthSession>> login({
    required String email,
    required String password,
  }) async {
    try {
      final session = await _remoteDataSource.login(
        email: email,
        password: password,
      );
      return Success<AuthSession>(session);
    } on AppError catch (error) {
      return Failure<AuthSession>(error.message);
    } catch (_) {
      return const Failure<AuthSession>('Unexpected login error');
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _remoteDataSource.logout();
      return const Success<void>(null);
    } on AppError catch (error) {
      return Failure<void>(error.message);
    } catch (_) {
      return const Failure<void>('Unexpected logout error');
    }
  }
}
