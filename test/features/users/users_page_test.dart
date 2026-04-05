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
  Future<UserModel> createUser(Map<String, dynamic> body) async {
    return UserModel(
      id: 1,
      firstName: body['firstName'] as String,
      lastName: body['lastName'] as String,
      email: body['email'] as String,
    );
  }

  @override
  Future<void> deleteUser(int id) async {}

  @override
  Future<List<UserModel>> fetchUsers() async => seedUsers;

  @override
  Future<void> logout() async {}

  @override
  Future<UserModel> updateUser(int id, Map<String, dynamic> body) async {
    return UserModel(
      id: id,
      firstName: body['firstName'] as String,
      lastName: body['lastName'] as String,
      email: body['email'] as String,
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
