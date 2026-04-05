import 'package:architecture_learning/core/result/result.dart';
import 'package:architecture_learning/domain/entities/user.dart';
import 'package:architecture_learning/domain/repositories/user_repository.dart';

class GetUsersUseCase {
  const GetUsersUseCase(this._userRepository);

  final UserRepository _userRepository;

  Future<Result<List<User>>> call() => _userRepository.getUsers();
}
