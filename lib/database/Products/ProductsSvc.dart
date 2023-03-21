import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import './ProductModel.dart';

final db = Supabase.instance.client;

class ProductsSvc {
  static Future<List<ProductModel>> getProducts({
    int max = 20,
    bool? onSale,
    bool? inStock,
    String? searchText,
    List<String>? orQueries,
    List<String>? containsQueries,
    List<String>? collections,
    String? sortBy,
  }) async {
    var queryFiters = db.from("products").select();
    if (onSale == true) queryFiters = queryFiters.filter('isOnSale', 'eq', onSale);
    if (inStock == true) queryFiters = queryFiters.filter('isOutOfStock', 'eq', false);

    orQueries?.forEach((orQuery) {
      queryFiters = queryFiters.or(orQuery);
    });
    if (collections != null) queryFiters = queryFiters.contains('collections', collections);

    if (searchText != null && searchText != '') queryFiters = queryFiters.textSearch('fts', searchText.split(' ').join(' & '));

    var query = queryFiters.range(0, max - 1);
    if (sortBy != null && sortBy != '') query.order(sortBy, nullsFirst: false);

    var results = await query;
    return results.map<ProductModel>((result) {
      try {
        return ProductModel.fromJson(result);
      } catch (e) {
        print("here");
        return ProductModel.fromJson(result);
      }
    }).toList();
  }

  static Future<List<ProductModel>> getProductsByQuery(PostgrestTransformBuilder<dynamic> query) async {
    var results = await query;
    return results.map<ProductModel>((result) => ProductModel.fromJson(result)).toList();
  }

  static Future<List<ProductModel>> getRecentPriceDrops({
    int max = 20,
  }) async {
    final db = Supabase.instance.client;
    var results = await db.from("products").select().range(0, max - 1).order("lastChanged", nullsFirst: false);

    return results.map<ProductModel>((result) => ProductModel.fromJson(result)).toList();
  }

  // static Future<List<ProductModel>> getProductsByOnSale({onSale = true, int max = 250}) async {
  //   final db = Supabase.instance.client;
  //   var results = await db.from("products").select('*').eq('isOnSale', onSale).range(0, max);

  //   return results.map<ProductModel>((result) => ProductModel.fromJson(result)).toList();
  // }

  // static Future<ProductModel?> getProductById(String id) async {
  //   var snapshot = await db.collection("products").doc(id).get();
  //   return snapshot.exists ? ProductModel.fromJson(snapshot.data()!) : null;
  // }

  // static Future<void> saveProduct(ProductModel product) async {
  //   await db.collection("products").doc(product.id).set(product.toJson(), SetOptions(merge: true));
  // }

  // static Future<void> upsertProduct(ProductModel product) async {
  //   product.id ??= db.collection("products").doc().id;
  //   await db.collection("products").doc(product.id).set(product.toJson());
  // }

  // static StreamSubscription listen(Function(List<ProductModel>) onData){
  //   return db.collection('products').snapshots().listen((snapshots) => onData(snapshots.docs.map((doc) => ProductModel.fromJson(doc.data())).toList()));
  // }

  // static StreamSubscription listenById(String id, Function(ProductModel?) onData){
  //   return db.collection('products').doc(id).snapshots().listen((snapshot) => onData(snapshot.exists ? ProductModel.fromJson(snapshot.data()!) : null));
  // }

  // static StreamSubscription listenToProductsByUserId(String userId, Function(List<ProductModel>) onData) {
  //   return db.collection('equipment').where('userId', isEqualTo: userId).snapshots().listen((snapshots) => onData(snapshots.docs.map((doc) => ProductModel.fromJson(doc.data())).toList()));
  // }
}
