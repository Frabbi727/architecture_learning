import 'package:architecture_learning/core/enums/enums.dart';
import 'package:architecture_learning/features/home_page/models/shop_model.dart';
import 'package:architecture_learning/features/home_page/repositories/home_page_repository.dart';
import 'package:get/get.dart';

class HomePageController extends GetxController {
  HomePageController(this._repository);

  final HomePageRepository _repository;

  final shops = <ShopModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchShops();
  }

  Future<void> fetchShops() async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await _repository.fetchShops();
    if (result.status == ResourceStatus.success) {
      shops.assignAll(result.model?.data ?? const <ShopModel>[]);
    } else {
      errorMessage.value = result.message ?? 'Failed to load shops';
    }

    isLoading.value = false;
  }
}
