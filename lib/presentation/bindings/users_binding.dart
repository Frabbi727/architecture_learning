import 'package:architecture_learning/domain/usecases/create_user_usecase.dart';
import 'package:architecture_learning/domain/usecases/delete_user_usecase.dart';
import 'package:architecture_learning/domain/usecases/get_users_usecase.dart';
import 'package:architecture_learning/domain/usecases/logout_usecase.dart';
import 'package:architecture_learning/domain/usecases/update_user_usecase.dart';
import 'package:architecture_learning/presentation/users/controllers/users_controller.dart';
import 'package:get/get.dart';

class UsersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UsersController>(
      () => UsersController(
        getUsersUseCase: Get.find<GetUsersUseCase>(),
        createUserUseCase: Get.find<CreateUserUseCase>(),
        updateUserUseCase: Get.find<UpdateUserUseCase>(),
        deleteUserUseCase: Get.find<DeleteUserUseCase>(),
        logoutUseCase: Get.find<LogoutUseCase>(),
      ),
    );
  }
}
