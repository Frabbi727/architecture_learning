import 'package:architecture_learning/app/routes/app_routes.dart';
import 'package:architecture_learning/features/auth/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  LoginController(this._repository);

  final AuthRepository _repository;

  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController(text: 'emilys');
  final passwordController = TextEditingController(text: 'emilyspass');

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  Future<void> login() async {
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _repository.login(
        username: usernameController.text.trim(),
        password: passwordController.text.trim(),
      );

      Get.offAllNamed(AppRoutes.users);
    } catch (error) {
      errorMessage.value = _normalizeError(error);
    } finally {
      isLoading.value = false;
    }
  }

  String _normalizeError(Object error) {
    final message = error.toString();
    if (message.startsWith('Exception: ')) {
      return message.replaceFirst('Exception: ', '');
    }
    return message;
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
