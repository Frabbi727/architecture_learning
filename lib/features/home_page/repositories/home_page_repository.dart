import 'package:architecture_learning/core/utils/resource.dart';
import 'package:architecture_learning/features/home_page/models/shop_model.dart';

abstract class HomePageRepository {
  Future<Resource<ShopListResponseModel>> fetchShops();
}
