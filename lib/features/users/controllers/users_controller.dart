import 'package:architecture_learning/app/routes/app_routes.dart';
import 'package:architecture_learning/core/enums/enums.dart';
import 'package:architecture_learning/features/users/models/user_model.dart';
import 'package:architecture_learning/features/users/repositories/user_repository.dart';
import 'package:get/get.dart';

class UsersController extends GetxController {
  UsersController(this._repository);

  final UserRepository _repository;

  final users = <UserModel>[].obs;
  final isLoading = false.obs;
  final isSaving = false.obs;
  final errorMessage = ''.obs;

  bool get hasUsers => users.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    isLoading.value = true;
    errorMessage.value = '';
    final result = await _repository.fetchUsers();
    if (result.status == ResourceStatus.success) {
      users.assignAll(result.model ?? const <UserModel>[]);
    } else {
      errorMessage.value = result.message ?? 'Failed to load users';
    }
    isLoading.value = false;
  }

  Future<bool> createUser({
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    isSaving.value = true;
    errorMessage.value = '';
    final result = await _repository.createUser({
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
    });
    isSaving.value = false;

    if (result.status == ResourceStatus.success && result.model != null) {
      users.insert(0, result.model!);
      return true;
    }
    errorMessage.value = result.message ?? 'Failed to create user';
    return false;
  }

  Future<bool> updateUser({
    required int id,
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    isSaving.value = true;
    errorMessage.value = '';
    final result = await _repository.updateUser(id, {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
    });
    isSaving.value = false;

    final updated = result.model;
    if (result.status == ResourceStatus.success && updated != null) {
      final index = users.indexWhere((user) => user.id == id);
      if (index != -1) {
        users[index] = updated;
        users.refresh();
      }
      return true;
    }
    errorMessage.value = result.message ?? 'Failed to update user';
    return false;
  }

  Future<bool> deleteUser(int id) async {
    isSaving.value = true;
    errorMessage.value = '';
    final result = await _repository.deleteUser(id);
    isSaving.value = false;
    if (result.status == ResourceStatus.success) {
      users.removeWhere((user) => user.id == id);
      return true;
    }
    errorMessage.value = result.message ?? 'Failed to delete user';
    return false;
  }

  Future<void> logout() async {
    await _repository.logout();
    Get.offAllNamed(AppRoutes.login);
  }

  void clearMessage() {
    errorMessage.value = '';
  }
}
