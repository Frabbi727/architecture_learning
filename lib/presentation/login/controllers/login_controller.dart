import 'package:architecture_learning/core/result/result.dart';
import 'package:architecture_learning/domain/entities/auth_session.dart';
import 'package:architecture_learning/domain/usecases/login_usecase.dart';
import 'package:architecture_learning/presentation/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  LoginController(this._loginUseCase);

  final LoginUseCase _loginUseCase;

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final errorMessage = RxnString();

  Future<void> login() async {
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    isLoading.value = true;
    errorMessage.value = null;

    final result = await _loginUseCase(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    isLoading.value = false;

    if (result is Success) {
      Get.offAllNamed(AppRoutes.users);
      return;
    }

    if (result is Failure<AuthSession>) {
      errorMessage.value = result.message;
    }
  }

  @override
  void onInit() {
    super.onInit();
    emailController.text = 'interview@demo.com';
    passwordController.text = 'password123';
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
