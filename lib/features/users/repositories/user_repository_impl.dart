import 'package:architecture_learning/core/constants/api_constants.dart';
import 'package:architecture_learning/core/network/api_client.dart';
import 'package:architecture_learning/core/network/auth_storage.dart';
import 'package:architecture_learning/features/users/models/user_model.dart';
import 'package:architecture_learning/features/users/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  const UserRepositoryImpl(this._apiClient, this._authStorage);

  final ApiClient _apiClient;
  final AuthStorage _authStorage;

  @override
  Future<UserModel> createUser(Map<String, dynamic> body) async {
    final data = await _apiClient.post(ApiConstants.addUser, body);
    return UserModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteUser(int id) async {
    await _apiClient.delete('${ApiConstants.users}/$id');
  }

  @override
  Future<List<UserModel>> fetchUsers() async {
    final data = await _apiClient.get(ApiConstants.users);
    final users = (data['users'] as List<dynamic>? ?? <dynamic>[])
        .cast<Map<String, dynamic>>();

    return users.map(UserModel.fromJson).toList(growable: false);
  }

  @override
  Future<void> logout() {
    return _authStorage.clearToken();
  }

  @override
  Future<UserModel> updateUser(int id, Map<String, dynamic> body) async {
    final data = await _apiClient.put('${ApiConstants.users}/$id', body);
    return UserModel.fromJson(data as Map<String, dynamic>);
  }
}
