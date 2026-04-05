import 'package:architecture_learning/data/datasources/auth_remote_data_source.dart';
import 'package:architecture_learning/data/datasources/user_remote_data_source.dart';
import 'package:architecture_learning/data/repositories/auth_repository_impl.dart';
import 'package:architecture_learning/data/repositories/user_repository_impl.dart';
import 'package:architecture_learning/domain/repositories/auth_repository.dart';
import 'package:architecture_learning/domain/repositories/user_repository.dart';
import 'package:architecture_learning/domain/usecases/create_user_usecase.dart';
import 'package:architecture_learning/domain/usecases/delete_user_usecase.dart';
import 'package:architecture_learning/domain/usecases/get_users_usecase.dart';
import 'package:architecture_learning/domain/usecases/login_usecase.dart';
import 'package:architecture_learning/domain/usecases/logout_usecase.dart';
import 'package:architecture_learning/domain/usecases/update_user_usecase.dart';
import 'package:get/get.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRemoteDataSource>(
      MockAuthRemoteDataSource.new,
      fenix: true,
    );
    Get.lazyPut<UserRemoteDataSource>(
      MockUserRemoteDataSource.new,
      fenix: true,
    );

    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(Get.find<AuthRemoteDataSource>()),
      fenix: true,
    );
    Get.lazyPut<UserRepository>(
      () => UserRepositoryImpl(Get.find<UserRemoteDataSource>()),
      fenix: true,
    );

    Get.lazyPut<LoginUseCase>(
      () => LoginUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );
    Get.lazyPut<LogoutUseCase>(
      () => LogoutUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );
    Get.lazyPut<GetUsersUseCase>(
      () => GetUsersUseCase(Get.find<UserRepository>()),
      fenix: true,
    );
    Get.lazyPut<CreateUserUseCase>(
      () => CreateUserUseCase(Get.find<UserRepository>()),
      fenix: true,
    );
    Get.lazyPut<UpdateUserUseCase>(
      () => UpdateUserUseCase(Get.find<UserRepository>()),
      fenix: true,
    );
    Get.lazyPut<DeleteUserUseCase>(
      () => DeleteUserUseCase(Get.find<UserRepository>()),
      fenix: true,
    );
  }
}
