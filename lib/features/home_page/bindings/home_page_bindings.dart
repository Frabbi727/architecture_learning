import 'package:architecture_learning/core/network/api_client.dart';
import 'package:architecture_learning/features/home_page/controllers/home_page_controller.dart';
import 'package:architecture_learning/features/home_page/repositories/home_page_remote_repository_impl.dart';
import 'package:architecture_learning/features/home_page/repositories/home_page_repository.dart';
import 'package:get/get.dart';

class HomePageBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<HomePageRepository>(() =>
        HomePageRemoteRepositoryImpl(
          Get.find<ApiClient>(),
        ));

    Get.lazyPut<HomePageController>(() =>
        HomePageController(
          Get.find<HomePageRepository>(),
        ));
  }

}