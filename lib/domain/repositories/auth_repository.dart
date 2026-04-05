import 'package:architecture_learning/core/result/result.dart';
import 'package:architecture_learning/domain/entities/auth_session.dart';

abstract class AuthRepository {
  Future<Result<AuthSession>> login({
    required String email,
    required String password,
  });

  Future<Result<void>> logout();
}
