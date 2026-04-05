import 'package:architecture_learning/app/routes/app_routes.dart';
import 'package:architecture_learning/features/auth/bindings/auth_binding.dart';
import 'package:architecture_learning/features/auth/pages/login_page.dart';
import 'package:architecture_learning/features/users/bindings/users_binding.dart';
import 'package:architecture_learning/features/users/pages/users_page.dart';
import 'package:get/get.dart';

class AppPages {
  static final pages = <GetPage<dynamic>>[
    GetPage<LoginPage>(
      name: AppRoutes.login,
      page: LoginPage.new,
      binding: AuthBinding(),
    ),
    GetPage<UsersPage>(
      name: AppRoutes.users,
      page: UsersPage.new,
      binding: UsersBinding(),
    ),
  ];
}
