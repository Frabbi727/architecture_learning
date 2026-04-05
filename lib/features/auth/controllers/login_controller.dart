import 'package:architecture_learning/app/routes/app_routes.dart';
import 'package:architecture_learning/core/enums/enums.dart';
import 'package:architecture_learning/features/auth/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  LoginController(this._repository);

  final AuthRepository _repository;

  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController(text: 'super.admin@example.com');
  final passwordController = TextEditingController(text: 'Password123!');

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  Future<void> login() async {
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    final result = await _repository.login(
      email: usernameController.text.trim(),
      password: passwordController.text.trim(),
    );

    if (result.status == ResourceStatus.success) {
      Get.offAllNamed(AppRoutes.homePage);
    } else {
      errorMessage.value = result.message ?? 'Login failed';
    }

    isLoading.value = false;
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
