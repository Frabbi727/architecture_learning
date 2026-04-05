import 'package:architecture_learning/core/constants/app_constants.dart';
import 'package:architecture_learning/core/errors/app_error.dart';
import 'package:architecture_learning/domain/entities/auth_session.dart';

abstract class AuthRemoteDataSource {
  Future<AuthSession> login({
    required String email,
    required String password,
  });

  Future<void> logout();
}

class MockAuthRemoteDataSource implements AuthRemoteDataSource {
  Future<void> _simulateDelay() async {
    await Future<void>.delayed(
      const Duration(milliseconds: AppConstants.mockDelayMs),
    );
  }

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    await _simulateDelay();

    if (email.trim() == AppConstants.demoEmail &&
        password.trim() == AppConstants.demoPassword) {
      return const AuthSession(
        userId: 'admin-1',
        displayName: 'Interview Candidate',
        token: 'mock-token',
      );
    }

    throw const AppError(
      'Invalid credentials. Use interview@demo.com / password123',
    );
  }

  @override
  Future<void> logout() async {
    await _simulateDelay();
  }
}
