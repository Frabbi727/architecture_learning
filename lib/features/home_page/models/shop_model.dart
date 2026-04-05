import 'package:architecture_learning/core/utils/generic_model/meta_data_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'shop_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ShopListResponseModel {
  @JsonKey(name: 'success')
  final bool? success;

  @JsonKey(name: 'data')
  final List<ShopModel>? data;

  @JsonKey(name: 'meta')
  final MetaModel? meta;

  ShopListResponseModel({
    this.success,
    this.data,
    this.meta,
  });

  factory ShopListResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ShopListResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShopListResponseModelToJson(this);

  @override
  String toString() {
    return 'ShopListResponseModel{success: $success, data: $data, meta: $meta}';
  }
  static List<ShopListResponseModel> listFromJson(List<dynamic> list) =>
      List<ShopListResponseModel>.from(
        list.map((x) => ShopListResponseModel.fromJson(x as Map<String, dynamic>)),
      );

}

@JsonSerializable(explicitToJson: true)
class ShopModel {
  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'market_id')
  final int? marketId;

  @JsonKey(name: 'market_name')
  final String? marketName;

  @JsonKey(name: 'shop_name')
  final String? shopName;

  @JsonKey(name: 'shop_code')
  final String? shopCode;

  @JsonKey(name: 'owner_id')
  final int? ownerId;

  @JsonKey(name: 'owner_name')
  final String? ownerName;

  @JsonKey(name: 'shop_sqft')
  final int? shopSqft;

  @JsonKey(name: 'status')
  final String? status;

  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'phone')
  final String? phone;

  @JsonKey(name: 'email')
  final String? email;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  ShopModel({
    this.id,
    this.marketId,
    this.marketName,
    this.shopName,
    this.shopCode,
    this.ownerId,
    this.ownerName,
    this.shopSqft,
    this.status,
    this.description,
    this.phone,
    this.email,
    this.createdAt,
    this.updatedAt,
  });

  factory ShopModel.fromJson(Map<String, dynamic> json) =>
      _$ShopModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShopModelToJson(this);

  static List<ShopModel> listFromJson(List<dynamic> list) =>
      List<ShopModel>.from(
        list.map((x) => ShopModel.fromJson(x as Map<String, dynamic>)),
      );

  @override
  String toString() {
    return 'ShopModel{id: $id, marketId: $marketId, marketName: $marketName, shopName: $shopName, shopCode: $shopCode, ownerId: $ownerId, ownerName: $ownerName, shopSqft: $shopSqft, status: $status, description: $description, phone: $phone, email: $email, createdAt: $createdAt, updatedAt: $updatedAt}';
  }

}
