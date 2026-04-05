import 'package:architecture_learning/core/constants/api_constants.dart';
import 'package:architecture_learning/core/network/api_client.dart';
import 'package:architecture_learning/core/network/auth_storage.dart';
import 'package:architecture_learning/core/utils/resource.dart';
import 'package:architecture_learning/features/users/models/user_model.dart';
import 'package:architecture_learning/features/users/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  const UserRepositoryImpl(this._apiClient, this._authStorage);

  final ApiClient _apiClient;
  final AuthStorage _authStorage;

  @override
  Future<Resource<UserModel>> createUser(Map<String, dynamic> body) async {
    return _apiClient.postModelResource<UserModel>(
      ApiConstants.addUser,
      body,
      parser: UserModel.fromJson,
    );
  }

  @override
  Future<Resource<void>> deleteUser(int id) async {
    return _apiClient.deleteResource('${ApiConstants.users}/$id');
  }

  @override
  Future<Resource<List<UserModel>>> fetchUsers() async {
    return _apiClient.getListResource<UserModel>(
      ApiConstants.users,
      dataKey: 'users',
      itemParser: UserModel.fromJson,
    );
  }

  @override
  Future<void> logout() {
    return _authStorage.clearToken();
  }

  @override
  Future<Resource<UserModel>> updateUser(int id, Map<String, dynamic> body) async {
    return _apiClient.putModelResource<UserModel>(
      '${ApiConstants.users}/$id',
      body,
      parser: UserModel.fromJson,
    );
  }
}
