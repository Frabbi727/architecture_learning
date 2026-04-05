import 'package:architecture_learning/features/auth/models/login_response_model.dart';

abstract class AuthRepository {
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  });

  Future<void> logout();
}
