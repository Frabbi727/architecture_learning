import 'package:architecture_learning/core/result/result.dart';
import 'package:architecture_learning/domain/entities/user.dart';
import 'package:architecture_learning/domain/repositories/user_repository.dart';

class UpdateUserUseCase {
  const UpdateUserUseCase(this._userRepository);

  final UserRepository _userRepository;

  Future<Result<User>> call(User user) => _userRepository.updateUser(user);
}
