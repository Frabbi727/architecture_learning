import 'package:architecture_learning/core/result/result.dart';
import 'package:architecture_learning/domain/entities/auth_session.dart';
import 'package:architecture_learning/domain/repositories/auth_repository.dart';
import 'package:architecture_learning/domain/usecases/login_usecase.dart';
import 'package:architecture_learning/presentation/login/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _AuthRepositoryStub implements AuthRepository {
  _AuthRepositoryStub(this.result);

  final Result<AuthSession> result;

  @override
  Future<Result<AuthSession>> login({
    required String email,
    required String password,
  }) async {
    return result;
  }

  @override
  Future<Result<void>> logout() async => const Success<void>(null);
}

void main() {
  group('LoginController', () {
    testWidgets('exposes error message on failed login', (tester) async {
      final controller = LoginController(
        LoginUseCase(
          _AuthRepositoryStub(
            const Failure<AuthSession>('Invalid credentials'),
          ),
        ),
      );

      controller.onInit();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: controller.formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: controller.emailController,
                    validator: (_) => null,
                  ),
                  TextFormField(
                    controller: controller.passwordController,
                    validator: (_) => null,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      controller.emailController.text = 'wrong@demo.com';
      controller.passwordController.text = 'wrongpass';

      await controller.login();

      expect(controller.errorMessage.value, 'Invalid credentials');
      controller.onClose();
    });
  });
}
