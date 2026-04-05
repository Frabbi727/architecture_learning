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
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _repository.fetchShops();
      shops.assignAll(response.data ?? const <ShopModel>[]);
    } catch (error) {
      errorMessage.value = _normalizeError(error);
    } finally {
      isLoading.value = false;
    }
  }

  String _normalizeError(Object error) {
    final message = error.toString();
    if (message.startsWith('Exception: ')) {
      return message.replaceFirst('Exception: ', '');
    }
    return message;
  }
}
