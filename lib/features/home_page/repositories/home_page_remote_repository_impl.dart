import 'package:architecture_learning/core/constants/api_constants.dart';
import 'package:architecture_learning/core/network/api_client.dart';
import 'package:architecture_learning/features/home_page/models/shop_model.dart';
import 'package:architecture_learning/features/home_page/repositories/home_page_repository.dart';

class HomePageRemoteRepositoryImpl extends HomePageRepository {
  HomePageRemoteRepositoryImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<ShopListResponseModel> fetchShops() async {
    final data = await _apiClient.get(ApiConstants.shops);

    if (data is Map<String, dynamic>) {
      return ShopListResponseModel.fromJson(data);
    }

    if (data is List<dynamic>) {
      final shops = data
          .whereType<Map<String, dynamic>>()
          .map(ShopModel.fromJson)
          .toList(growable: false);

      return ShopListResponseModel(success: true, data: shops);
    }

    throw Exception('Invalid shop list response');
  }
}
