

import 'package:json_annotation/json_annotation.dart';
part 'meta_data_model.g.dart';
@JsonSerializable()
class MetaModel {
  @JsonKey(name: 'pagination')
  final PaginationModel? pagination;

  MetaModel({
     this.pagination,
  });

  factory MetaModel.fromJson(Map<String, dynamic> json) =>
      _$MetaModelFromJson(json);

  Map<String, dynamic> toJson() => _$MetaModelToJson(this);

  @override
  String toString() {
    return 'MetaModel{pagination: $pagination}';
  }

}

@JsonSerializable()
class PaginationModel {
  @JsonKey(name: 'current_page')
  final int? currentPage;

  @JsonKey(name: 'last_page')
  final int? lastPage;

  @JsonKey(name: 'per_page')
  final int? perPage;

  @JsonKey(name: 'total')
  final int? total;

  PaginationModel({
     this.currentPage,
     this.lastPage,
     this.perPage,
     this.total,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) =>
      _$PaginationModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationModelToJson(this);

  @override
  String toString() {
    return 'PaginationModel{currentPage: $currentPage, lastPage: $lastPage, perPage: $perPage, total: $total}';
  }

}