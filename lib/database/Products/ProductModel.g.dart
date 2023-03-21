// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ProductModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
      image: json['image'] as String?,
      seller: json['seller'] as String,
      url: json['url'] as String,
      title: json['title'] as String,
      price: (json['price'] as num?)?.toDouble(),
      priceHigh: (json['priceHigh'] as num?)?.toDouble(),
      priceLow: (json['priceLow'] as num?)?.toDouble(),
      oldPrice: (json['oldPrice'] as num?)?.toDouble(),
      hasVarients: json['hasVarients'] as bool? ?? false,
      isOutOfStock: json['isOutOfStock'] as bool? ?? false,
      isOnSale: json['isOnSale'] as bool? ?? false,
      categories: (json['categories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      lastUpdated: fromTimeStamp(json['lastUpdated'] as String),
      created: fromTimeStamp(json['created'] as String),
      lastChanged: fromTimeStampOpt(json['lastChanged'] as String?),
      lastChange: json['lastChange'] as String?,
      varients: (json['varients'] as List<dynamic>)
          .map((e) => VariantModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      oldPriceHigh: (json['oldPriceHigh'] as num?)?.toDouble(),
      oldPriceLow: (json['oldPriceLow'] as num?)?.toDouble(),
      saleAmount: (json['saleAmount'] as num?)?.toDouble(),
      saleAmountHigh: (json['saleAmountHigh'] as num?)?.toDouble(),
      saleAmountLow: (json['saleAmountLow'] as num?)?.toDouble(),
      salePercentage: (json['salePercentage'] as num?)?.toDouble(),
      salePercentageHigh: (json['salePercentageHigh'] as num?)?.toDouble(),
      salePercentageLow: (json['salePercentageLow'] as num?)?.toDouble(),
      rawData: json['rawData'],
      collections: (json['collections'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      lastPriceDrop: fromTimeStampOpt(json['lastPriceDrop'] as String?),
    )..sellerSubtype = json['sellerSubtype'] as String?;

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'image': instance.image,
      'lastChange': instance.lastChange,
      'sellerSubtype': instance.sellerSubtype,
      'seller': instance.seller,
      'url': instance.url,
      'title': instance.title,
      'price': instance.price,
      'oldPrice': instance.oldPrice,
      'priceLow': instance.priceLow,
      'priceHigh': instance.priceHigh,
      'oldPriceLow': instance.oldPriceLow,
      'oldPriceHigh': instance.oldPriceHigh,
      'saleAmount': instance.saleAmount,
      'saleAmountLow': instance.saleAmountLow,
      'saleAmountHigh': instance.saleAmountHigh,
      'salePercentage': instance.salePercentage,
      'salePercentageLow': instance.salePercentageLow,
      'salePercentageHigh': instance.salePercentageHigh,
      'hasVarients': instance.hasVarients,
      'isOutOfStock': instance.isOutOfStock,
      'isOnSale': instance.isOnSale,
      'categories': instance.categories,
      'collections': instance.collections,
      'varients': instance.varients,
      'rawData': instance.rawData,
      'lastUpdated': toTimeStamp(instance.lastUpdated),
      'created': toTimeStamp(instance.created),
      'lastChanged': toTimeStampOpt(instance.lastChanged),
      'lastPriceDrop': toTimeStampOpt(instance.lastPriceDrop),
    };

VariantModel _$VariantModelFromJson(Map<String, dynamic> json) => VariantModel(
      name: json['name'] as String,
      price: (json['price'] as num?)?.toDouble(),
      oldPrice: (json['oldPrice'] as num?)?.toDouble(),
      isOutOfStock: json['isOutOfStock'] as bool? ?? false,
      isOnSale: json['isOnSale'] as bool? ?? false,
    );

Map<String, dynamic> _$VariantModelToJson(VariantModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'price': instance.price,
      'oldPrice': instance.oldPrice,
      'isOutOfStock': instance.isOutOfStock,
      'isOnSale': instance.isOnSale,
    };
