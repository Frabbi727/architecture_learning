// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShopListResponseModel _$ShopListResponseModelFromJson(
  Map<String, dynamic> json,
) => ShopListResponseModel(
  success: json['success'] as bool?,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => ShopModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: json['meta'] == null
      ? null
      : MetaModel.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ShopListResponseModelToJson(
  ShopListResponseModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data?.map((e) => e.toJson()).toList(),
  'meta': instance.meta?.toJson(),
};

ShopModel _$ShopModelFromJson(Map<String, dynamic> json) => ShopModel(
  id: (json['id'] as num?)?.toInt(),
  marketId: (json['market_id'] as num?)?.toInt(),
  marketName: json['market_name'] as String?,
  shopName: json['shop_name'] as String?,
  shopCode: json['shop_code'] as String?,
  ownerId: (json['owner_id'] as num?)?.toInt(),
  ownerName: json['owner_name'] as String?,
  shopSqft: (json['shop_sqft'] as num?)?.toInt(),
  status: json['status'] as String?,
  description: json['description'] as String?,
  phone: json['phone'] as String?,
  email: json['email'] as String?,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$ShopModelToJson(ShopModel instance) => <String, dynamic>{
  'id': instance.id,
  'market_id': instance.marketId,
  'market_name': instance.marketName,
  'shop_name': instance.shopName,
  'shop_code': instance.shopCode,
  'owner_id': instance.ownerId,
  'owner_name': instance.ownerName,
  'shop_sqft': instance.shopSqft,
  'status': instance.status,
  'description': instance.description,
  'phone': instance.phone,
  'email': instance.email,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};
