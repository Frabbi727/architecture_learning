import 'package:architecture_learning/core/network/api_client.dart';
import 'package:architecture_learning/core/network/auth_storage.dart';
import 'package:architecture_learning/features/auth/controllers/login_controller.dart';
import 'package:architecture_learning/features/auth/repositories/auth_repository.dart';
import 'package:architecture_learning/features/auth/repositories/auth_repository_impl.dart';
import 'package:get/get.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(
        Get.find<ApiClient>(),
        Get.find<AuthStorage>(),
      ),
    );
    Get.lazyPut<LoginController>(
      () => LoginController(Get.find<AuthRepository>()),
    );
  }
}
