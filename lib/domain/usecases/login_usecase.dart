import 'package:architecture_learning/core/result/result.dart';
import 'package:architecture_learning/domain/entities/auth_session.dart';
import 'package:architecture_learning/domain/repositories/auth_repository.dart';

class LoginUseCase {
  const LoginUseCase(this._authRepository);

  final AuthRepository _authRepository;

  Future<Result<AuthSession>> call({
    required String email,
    required String password,
  }) {
    return _authRepository.login(email: email, password: password);
  }
}
