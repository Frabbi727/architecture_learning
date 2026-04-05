import 'package:architecture_learning/core/result/result.dart';
import 'package:architecture_learning/domain/entities/user.dart';
import 'package:architecture_learning/domain/usecases/create_user_usecase.dart';
import 'package:architecture_learning/domain/usecases/delete_user_usecase.dart';
import 'package:architecture_learning/domain/usecases/get_users_usecase.dart';
import 'package:architecture_learning/domain/usecases/logout_usecase.dart';
import 'package:architecture_learning/domain/usecases/update_user_usecase.dart';
import 'package:architecture_learning/presentation/routes/app_routes.dart';
import 'package:get/get.dart';

class UsersController extends GetxController {
  UsersController({
    required GetUsersUseCase getUsersUseCase,
    required CreateUserUseCase createUserUseCase,
    required UpdateUserUseCase updateUserUseCase,
    required DeleteUserUseCase deleteUserUseCase,
    required LogoutUseCase logoutUseCase,
  })  : _getUsersUseCase = getUsersUseCase,
        _createUserUseCase = createUserUseCase,
        _updateUserUseCase = updateUserUseCase,
        _deleteUserUseCase = deleteUserUseCase,
        _logoutUseCase = logoutUseCase;

  final GetUsersUseCase _getUsersUseCase;
  final CreateUserUseCase _createUserUseCase;
  final UpdateUserUseCase _updateUserUseCase;
  final DeleteUserUseCase _deleteUserUseCase;
  final LogoutUseCase _logoutUseCase;

  final users = <User>[].obs;
  final isLoading = false.obs;
  final isSaving = false.obs;
  final errorMessage = RxnString();

  bool get hasUsers => users.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    loadUsers();
  }

  Future<void> loadUsers() async {
    isLoading.value = true;
    errorMessage.value = null;

    final result = await _getUsersUseCase();

    isLoading.value = false;
    if (result is Success<List<User>>) {
      users.assignAll(result.data);
      return;
    }

    if (result is Failure<List<User>>) {
      errorMessage.value = result.message;
    }
  }

  Future<bool> createUser({
    required String name,
    required String email,
    required String role,
  }) async {
    isSaving.value = true;
    final result = await _createUserUseCase(
      User(id: '', name: name.trim(), email: email.trim(), role: role.trim()),
    );
    isSaving.value = false;

    if (result is Success<User>) {
      users.add(result.data);
      return true;
    }

    if (result is Failure<User>) {
      errorMessage.value = result.message;
    }
    return false;
  }

  Future<bool> updateUser({
    required String id,
    required String name,
    required String email,
    required String role,
  }) async {
    isSaving.value = true;
    final result = await _updateUserUseCase(
      User(id: id, name: name.trim(), email: email.trim(), role: role.trim()),
    );
    isSaving.value = false;

    if (result is Success<User>) {
      final index = users.indexWhere((user) => user.id == id);
      if (index != -1) {
        users[index] = result.data;
      }
      users.refresh();
      return true;
    }

    if (result is Failure<User>) {
      errorMessage.value = result.message;
    }
    return false;
  }

  Future<bool> deleteUser(String id) async {
    isSaving.value = true;
    final result = await _deleteUserUseCase(id);
    isSaving.value = false;

    if (result is Success<void>) {
      users.removeWhere((user) => user.id == id);
      return true;
    }

    if (result is Failure<void>) {
      errorMessage.value = result.message;
    }
    return false;
  }

  Future<void> logout() async {
    isSaving.value = true;
    final result = await _logoutUseCase();
    isSaving.value = false;

    if (result is Success<void>) {
      Get.offAllNamed(AppRoutes.login);
      return;
    }

    if (result is Failure<void>) {
      errorMessage.value = result.message;
    }
  }

  void clearMessage() {
    errorMessage.value = null;
  }
}
