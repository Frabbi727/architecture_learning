import 'package:architecture_learning/core/utils/resource.dart';
import 'package:architecture_learning/features/auth/models/login_response_model.dart';

abstract class AuthRepository {
  Future<Resource<LoginResponseModel>> login({
    required String email,
    required String password,
  });

  Future<void> logout();
}
