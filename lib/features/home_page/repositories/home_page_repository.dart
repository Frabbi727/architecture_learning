import 'package:architecture_learning/features/home_page/models/shop_model.dart';

abstract class HomePageRepository {
  Future<ShopListResponseModel> fetchShops();
}
