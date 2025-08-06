import 'package:json_annotation/json_annotation.dart';

part 'product_details.g.dart';

@JsonSerializable()
class Dimensions {
  final double height;
  final double width;
  final double depth;

  Dimensions({required this.height, required this.width, required this.depth});

  factory Dimensions.fromJson(Map<String, dynamic> json) => _$DimensionsFromJson(json);
  Map<String, dynamic> toJson() => _$DimensionsToJson(this);
}

@JsonSerializable()
class ProductDetails {
  final int id;
  final double weight;
  final Dimensions dimensions;

  ProductDetails({required this.id, required this.weight, required this.dimensions});

  factory ProductDetails.fromJson(Map<String, dynamic> json) => _$ProductDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$ProductDetailsToJson(this);
}
