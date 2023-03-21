import 'dart:async';
import 'package:home_gym_deals/database/Products/ProductModel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductHistoriesSvc {
  static Future<List<ProductModel>> getProductHistoriesByUrl(String url) async {
    final db = Supabase.instance.client;
 
    var results = await db.from("product_histories").select().eq("url", url);
    return results.map<ProductModel>((result) => ProductModel.fromJson(result)).toList();
  }

 
}
