import 'package:architecture_learning/app/app.dart';
import 'package:architecture_learning/core/result/result.dart';
import 'package:architecture_learning/domain/entities/auth_session.dart';
import 'package:architecture_learning/domain/entities/user.dart';
import 'package:architecture_learning/domain/repositories/auth_repository.dart';
import 'package:architecture_learning/domain/repositories/user_repository.dart';
import 'package:architecture_learning/domain/usecases/create_user_usecase.dart';
import 'package:architecture_learning/domain/usecases/delete_user_usecase.dart';
import 'package:architecture_learning/domain/usecases/get_users_usecase.dart';
import 'package:architecture_learning/domain/usecases/logout_usecase.dart';
import 'package:architecture_learning/domain/usecases/update_user_usecase.dart';
import 'package:architecture_learning/presentation/users/controllers/users_controller.dart';
import 'package:architecture_learning/presentation/users/pages/users_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class _EmptyUsersController extends UsersController {
  _EmptyUsersController()
      : super(
          getUsersUseCase: GetUsersUseCase(_EmptyUserRepository()),
          createUserUseCase: CreateUserUseCase(_EmptyUserRepository()),
          updateUserUseCase: UpdateUserUseCase(_EmptyUserRepository()),
          deleteUserUseCase: DeleteUserUseCase(_EmptyUserRepository()),
          logoutUseCase: LogoutUseCase(_FakeLogoutRepository()),
        );
}

class _EmptyUserRepository implements UserRepository {
  @override
  Future<Result<User>> createUser(User user) async => Success<User>(user);

  @override
  Future<Result<void>> deleteUser(String id) async => const Success<void>(null);

  @override
  Future<Result<List<User>>> getUsers() async =>
      const Success<List<User>>(<User>[]);

  @override
  Future<Result<User>> updateUser(User user) async => Success<User>(user);
}

class _FakeLogoutRepository implements AuthRepository {
  @override
  Future<Result<AuthSession>> login({
    required String email,
    required String password,
  }) async {
    return const Failure<AuthSession>('Unused');
  }

  @override
  Future<Result<void>> logout() async => const Success<void>(null);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    Get.reset();
    Get.testMode = false;
  });

  tearDown(() {
    Get.reset();
    Get.testMode = false;
  });

  group('InterviewPrepApp', () {
    testWidgets('shows validation messages on empty login submit', (
      tester,
    ) async {
      await tester.pumpWidget(const InterviewPrepApp());

      await tester.enterText(find.byType(TextFormField).at(0), '');
      await tester.enterText(find.byType(TextFormField).at(1), '');
      await tester.tap(find.text('Login'));
      await tester.pump();

      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('navigates from login to user list', (tester) async {
      await tester.pumpWidget(const InterviewPrepApp());

      await tester.tap(find.text('Login'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 800));
      await tester.pumpAndSettle();

      expect(find.text('User Directory'), findsOneWidget);
      expect(find.text('Ava Rahman'), findsOneWidget);
    });

    testWidgets('renders empty state when controller has no users', (
      tester,
    ) async {
      Get.testMode = true;
      Get.put<UsersController>(_EmptyUsersController());

      await tester.pumpWidget(
        const GetMaterialApp(
          home: UsersPage(),
        ),
      );
      await tester.pump();

      expect(find.text('No users yet'), findsOneWidget);
      expect(find.text('Add User'), findsOneWidget);
    });
  });
}
