// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meta_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MetaModel _$MetaModelFromJson(Map<String, dynamic> json) => MetaModel(
  pagination: json['pagination'] == null
      ? null
      : PaginationModel.fromJson(json['pagination'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MetaModelToJson(MetaModel instance) => <String, dynamic>{
  'pagination': instance.pagination,
};

PaginationModel _$PaginationModelFromJson(Map<String, dynamic> json) =>
    PaginationModel(
      currentPage: (json['current_page'] as num?)?.toInt(),
      lastPage: (json['last_page'] as num?)?.toInt(),
      perPage: (json['per_page'] as num?)?.toInt(),
      total: (json['total'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PaginationModelToJson(PaginationModel instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'last_page': instance.lastPage,
      'per_page': instance.perPage,
      'total': instance.total,
    };
