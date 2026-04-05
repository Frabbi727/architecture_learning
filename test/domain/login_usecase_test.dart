import 'package:architecture_learning/core/result/result.dart';
import 'package:architecture_learning/domain/entities/auth_session.dart';
import 'package:architecture_learning/domain/repositories/auth_repository.dart';
import 'package:architecture_learning/domain/usecases/login_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({required this.shouldSucceed});

  final bool shouldSucceed;

  @override
  Future<Result<AuthSession>> login({
    required String email,
    required String password,
  }) async {
    if (shouldSucceed) {
      return const Success<AuthSession>(
        AuthSession(
          userId: '1',
          displayName: 'Candidate',
          token: 'token',
        ),
      );
    }

    return const Failure<AuthSession>('Invalid credentials');
  }

  @override
  Future<Result<void>> logout() async => const Success<void>(null);
}

void main() {
  group('LoginUseCase', () {
    test('returns success from repository', () async {
      final useCase = LoginUseCase(_FakeAuthRepository(shouldSucceed: true));

      final result = await useCase(
        email: 'interview@demo.com',
        password: 'password123',
      );

      expect(result, isA<Success<AuthSession>>());
    });

    test('returns failure from repository', () async {
      final useCase = LoginUseCase(_FakeAuthRepository(shouldSucceed: false));

      final result = await useCase(
        email: 'wrong@demo.com',
        password: 'wrongpass',
      );

      expect(result, isA<Failure<AuthSession>>());
    });
  });
}
