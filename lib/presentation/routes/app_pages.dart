import 'package:architecture_learning/presentation/bindings/login_binding.dart';
import 'package:architecture_learning/presentation/bindings/users_binding.dart';
import 'package:architecture_learning/presentation/login/pages/login_page.dart';
import 'package:architecture_learning/presentation/routes/app_routes.dart';
import 'package:architecture_learning/presentation/users/pages/users_page.dart';
import 'package:get/get.dart';

class AppPages {
  static final pages = <GetPage<dynamic>>[
    GetPage<LoginPage>(
      name: AppRoutes.login,
      page: LoginPage.new,
      binding: LoginBinding(),
    ),
    GetPage<UsersPage>(
      name: AppRoutes.users,
      page: UsersPage.new,
      binding: UsersBinding(),
    ),
  ];
}
