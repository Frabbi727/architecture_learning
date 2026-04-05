import 'package:architecture_learning/core/constants/app_constants.dart';
import 'package:architecture_learning/core/validation/input_validators.dart';
import 'package:architecture_learning/presentation/login/controllers/login_controller.dart';
import 'package:architecture_learning/presentation/login/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEAE2D6), Color(0xFFF9F6F1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: controller.formKey,
                    child: Obx(
                      () => Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MVVM Interview Demo',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Login is mocked so you can focus on architecture discussion.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 24),
                          AppTextField(
                            controller: controller.emailController,
                            label: 'Email',
                            hint: 'interview@demo.com',
                            keyboardType: TextInputType.emailAddress,
                            validator: InputValidators.validateEmail,
                          ),
                          const SizedBox(height: 16),
                          AppTextField(
                            controller: controller.passwordController,
                            label: 'Password',
                            hint: 'password123',
                            obscureText: true,
                            validator: InputValidators.validatePassword,
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9F6F1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Demo credentials: '
                              '${AppConstants.demoEmail} / ${AppConstants.demoPassword}',
                            ),
                          ),
                          if (controller.errorMessage.value != null) ...[
                            const SizedBox(height: 16),
                            Text(
                              controller.errorMessage.value!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ],
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: controller.isLoading.value
                                  ? null
                                  : controller.login,
                              child: controller.isLoading.value
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text('Login'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
