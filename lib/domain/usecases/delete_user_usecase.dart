import 'package:architecture_learning/core/result/result.dart';
import 'package:architecture_learning/domain/repositories/user_repository.dart';

class DeleteUserUseCase {
  const DeleteUserUseCase(this._userRepository);

  final UserRepository _userRepository;

  Future<Result<void>> call(String id) => _userRepository.deleteUser(id);
}
