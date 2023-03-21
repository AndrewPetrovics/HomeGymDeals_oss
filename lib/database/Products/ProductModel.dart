import 'package:home_gym_deals/misc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ProductModel.g.dart';

@JsonSerializable()
class ProductModel {
  String? image, lastChange, sellerSubtype;
  String seller, url, title;
  double? price,
      oldPrice,
      priceLow,
      priceHigh,
      oldPriceLow,
      oldPriceHigh,
      saleAmount,
      saleAmountLow,
      saleAmountHigh,
      salePercentage,
      salePercentageLow,
      salePercentageHigh;
  bool hasVarients, isOutOfStock, isOnSale;
  List<String> categories, collections;
  List<VariantModel> varients;
  dynamic rawData;

  @JsonKey(fromJson: fromTimeStamp, toJson: toTimeStamp)
  DateTime lastUpdated, created;

  @JsonKey(fromJson: fromTimeStampOpt, toJson: toTimeStampOpt)
  DateTime? lastChanged, lastPriceDrop;

  ProductModel({
    this.image,
    required this.seller,
    required this.url,
    required this.title,
    this.price,
    this.priceHigh,
    this.priceLow,
    this.oldPrice,
    this.hasVarients = false,
    this.isOutOfStock = false,
    this.isOnSale = false,
    required this.categories,
    required this.lastUpdated,
    required this.created,
    this.lastChanged,
    this.lastChange,
    required this.varients,
    this.oldPriceHigh,
    this.oldPriceLow,
    this.saleAmount,
    this.saleAmountHigh,
    this.saleAmountLow,
    this.salePercentage,
    this.salePercentageHigh,
    this.salePercentageLow,
    this.rawData,
    required this.collections,
    this.lastPriceDrop,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}

@JsonSerializable()
class VariantModel {
  String name;
  double? price, oldPrice;
  bool isOutOfStock, isOnSale;

  VariantModel({
    required this.name,
    required this.price,
    this.oldPrice,
    this.isOutOfStock = false,
    this.isOnSale = false,
  });

  factory VariantModel.fromJson(Map<String, dynamic> json) => _$VariantModelFromJson(json);

  Map<String, dynamic> toJson() => _$VariantModelToJson(this);
}


enum ProductChangeTypes{
  productAdded("Product Added"),
  priceDrop("Price Drop"),
  priceIncrease("Price Increase"),
  variantAdded("Variant Added"),
  variantRemoved("Variant Removed"),
  variantPriceIncrease( "Variant Price Increase"),
  variantPriceDrop( "Variant Price Drop"),
  inStock('In Stock'),
  outOfStock('Out of Stock'),
  saleChange( 'Sale Change');

  final String name;
  const ProductChangeTypes(this.name);
 

}