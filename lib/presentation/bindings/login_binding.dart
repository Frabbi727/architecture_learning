import 'package:architecture_learning/domain/usecases/login_usecase.dart';
import 'package:architecture_learning/presentation/login/controllers/login_controller.dart';
import 'package:get/get.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
      () => LoginController(Get.find<LoginUseCase>()),
    );
  }
}
