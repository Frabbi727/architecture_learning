import 'package:architecture_learning/core/constants/api_constants.dart';
import 'package:architecture_learning/core/network/api_client.dart';
import 'package:architecture_learning/core/utils/resource.dart';
import 'package:architecture_learning/features/home_page/models/shop_model.dart';
import 'package:architecture_learning/features/home_page/repositories/home_page_repository.dart';

class HomePageRemoteRepositoryImpl extends HomePageRepository {
  HomePageRemoteRepositoryImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<Resource<ShopListResponseModel>> fetchShops() async {
    return _apiClient.getModelResource<ShopListResponseModel>(
      ApiConstants.shops,
      parser: ShopListResponseModel.fromJson,
    );
  }
}
