import 'package:architecture_learning/core/result/result.dart';
import 'package:architecture_learning/domain/repositories/auth_repository.dart';

class LogoutUseCase {
  const LogoutUseCase(this._authRepository);

  final AuthRepository _authRepository;

  Future<Result<void>> call() => _authRepository.logout();
}
