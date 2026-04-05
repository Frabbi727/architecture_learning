import 'package:architecture_learning/features/auth/controllers/login_controller.dart';
import 'package:architecture_learning/features/auth/pages/login_page.dart';
import 'package:architecture_learning/features/auth/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

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
  setUp(Get.reset);
  tearDown(Get.reset);

  testWidgets('login page validates empty fields', (tester) async {
    Get.put<LoginController>(LoginController(_FailingAuthRepository()));

    await tester.pumpWidget(
      const GetMaterialApp(
        home: LoginPage(),
      ),
    );

    await tester.enterText(find.byType(TextFormField).first, '');
    await tester.enterText(find.byType(TextFormField).last, '');
    await tester.tap(find.text('Login'));
    await tester.pump();

    expect(find.text('Username is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
  });
}
