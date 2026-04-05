import 'package:architecture_learning/core/enums/enums.dart';
import 'package:architecture_learning/core/utils/resource.dart';
import 'package:architecture_learning/features/users/controllers/users_controller.dart';
import 'package:architecture_learning/features/users/models/user_model.dart';
import 'package:architecture_learning/features/users/pages/users_page.dart';
import 'package:architecture_learning/features/users/repositories/user_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class _FakeUserRepository implements UserRepository {
  _FakeUserRepository(this.seedUsers);

  final List<UserModel> seedUsers;

  @override
  Future<Resource<UserModel>> createUser(Map<String, dynamic> body) async {
    return Resource<UserModel>(
      status: ResourceStatus.success,
      model: UserModel(
        id: 1,
        firstName: body['firstName'] as String,
        lastName: body['lastName'] as String,
        email: body['email'] as String,
      ),
    );
  }

  @override
  Future<Resource<void>> deleteUser(int id) async {
    return Resource<void>(status: ResourceStatus.success);
  }

  @override
  Future<Resource<List<UserModel>>> fetchUsers() async {
    return Resource<List<UserModel>>(
      status: ResourceStatus.success,
      model: seedUsers,
    );
  }

  @override
  Future<void> logout() async {}

  @override
  Future<Resource<UserModel>> updateUser(int id, Map<String, dynamic> body) async {
    return Resource<UserModel>(
      status: ResourceStatus.success,
      model: UserModel(
        id: id,
        firstName: body['firstName'] as String,
        lastName: body['lastName'] as String,
        email: body['email'] as String,
      ),
    );
  }
}

void main() {
  setUp(Get.reset);
  tearDown(Get.reset);

  testWidgets('users page renders empty state', (tester) async {
    Get.put<UsersController>(UsersController(_FakeUserRepository([])));

    await tester.pumpWidget(
      const GetMaterialApp(
        home: UsersPage(),
      ),
    );
    await tester.pump();

    expect(find.text('No users yet'), findsOneWidget);
    expect(find.text('Add User'), findsOneWidget);
  });
}
