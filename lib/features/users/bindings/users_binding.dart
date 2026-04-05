import 'package:architecture_learning/core/network/api_client.dart';
import 'package:architecture_learning/core/network/auth_storage.dart';
import 'package:architecture_learning/features/users/controllers/users_controller.dart';
import 'package:architecture_learning/features/users/repositories/user_repository.dart';
import 'package:architecture_learning/features/users/repositories/user_repository_impl.dart';
import 'package:get/get.dart';

class UsersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserRepository>(
      () => UserRepositoryImpl(
        Get.find<ApiClient>(),
        Get.find<AuthStorage>(),
      ),
    );
    Get.lazyPut<UsersController>(
      () => UsersController(
        Get.find<UserRepository>(),
      ),
    );
  }
}
