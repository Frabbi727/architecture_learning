import 'package:architecture_learning/app/routes/app_routes.dart';
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
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final result = await _repository.fetchUsers();
      users.assignAll(result);
    } catch (error) {
      errorMessage.value = _normalizeError(error);
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createUser({
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    try {
      isSaving.value = true;
      errorMessage.value = '';
      final created = await _repository.createUser({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
      });
      users.insert(0, created);
      return true;
    } catch (error) {
      errorMessage.value = _normalizeError(error);
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  Future<bool> updateUser({
    required int id,
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    try {
      isSaving.value = true;
      errorMessage.value = '';
      final updated = await _repository.updateUser(id, {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
      });
      final index = users.indexWhere((user) => user.id == id);
      if (index != -1) {
        users[index] = updated;
        users.refresh();
      }
      return true;
    } catch (error) {
      errorMessage.value = _normalizeError(error);
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  Future<bool> deleteUser(int id) async {
    try {
      isSaving.value = true;
      errorMessage.value = '';
      await _repository.deleteUser(id);
      users.removeWhere((user) => user.id == id);
      return true;
    } catch (error) {
      errorMessage.value = _normalizeError(error);
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    Get.offAllNamed(AppRoutes.login);
  }

  void clearMessage() {
    errorMessage.value = '';
  }

  String _normalizeError(Object error) {
    final message = error.toString();
    if (message.startsWith('Exception: ')) {
      return message.replaceFirst('Exception: ', '');
    }
    return message;
  }
}
