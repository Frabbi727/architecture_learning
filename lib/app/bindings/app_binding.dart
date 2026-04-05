import 'package:architecture_learning/core/network/api_client.dart';
import 'package:architecture_learning/core/network/auth_storage.dart';
import 'package:get/get.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthStorage>(
      AuthStorage.new,
      fenix: true,
    );
    Get.lazyPut<ApiClient>(
      () => ApiClient(Get.find<AuthStorage>()),
      fenix: true,
    );
  }
}
