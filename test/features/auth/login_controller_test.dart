import 'package:architecture_learning/features/auth/controllers/login_controller.dart';
import 'package:architecture_learning/features/auth/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _FailingAuthRepository implements AuthRepository {
  @override
  Future<void> login({
    required String username,
    required String password,
  }) async {
    throw Exception('Invalid credentials');
  }

  @override
  Future<void> logout() async {}
}

void main() {
  testWidgets('login controller exposes login error', (tester) async {
    final controller = LoginController(_FailingAuthRepository());

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Form(
            key: controller.formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: controller.usernameController,
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

    controller.usernameController.text = 'wrong';
    controller.passwordController.text = 'wrong';

    await controller.login();

    expect(controller.errorMessage.value, 'Invalid credentials');
    controller.onClose();
  });
}
