// import 'dart:async';

// import 'package:collection/collection.dart';
// import 'package:flutter/material.dart';
// import 'package:home_gym_deals/app/Home/Search/SearchView.dart';
// import 'package:home_gym_deals/database/Products/ProductModel.dart';
// import 'package:home_gym_deals/database/Products/ProductsSvc.dart';
// import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
// import 'package:home_gym_deals/misc.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// import 'dart:async';

// import 'package:supabase_flutter/supabase_flutter.dart';

// class HomeViewModel {
//   //
//   // Private members
//   //
//   List<StreamSubscription>? _listeners;
//   Timer? _debounce;
//   final db = Supabase.instance.client;

//   //
//   // Public Properties
//   //
//   Function updateWidget;
//   bool isLoading = true;
//   List<Shelf> shelves = [];
//   List<ProductModel> recentPriceDrops = [];
//   List<ProductModel> barbells = [];
//   TextEditingController searchTextController = TextEditingController();
//   int recentPriceDropCount = 6;

//   GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

//   //
//   // Getters
//   //

//   //
//   // Constructor
//   //
//   HomeViewModel(this.updateWidget) {
//     init();
//   }

//   //
//   // Public functions
//   //
//   void init() async {
//     if (_listeners == null) _attachListeners();

//     //searchTextController.addListener();

//     shelves = [
//       Shelf("Recent Price Drops", await ProductsSvc.getProducts(onSale: true, sortBy: 'lastChanged', max: 100)),
//       Shelf("Barbells", await ProductsSvc.getProducts(onSale: true, sortBy: 'lastChanged', max: 100, collections: ["BARBELLS"])),
//       Shelf("Racks", await ProductsSvc.getProducts(onSale: true, sortBy: 'lastChanged', max: 100, collections: ["RACKS"])),
//       Shelf("Rack Accessories", await ProductsSvc.getProducts(onSale: true, sortBy: 'lastChanged', max: 100, collections: ["RACK_ACCESSORIES"])),
//       Shelf("Weights", await ProductsSvc.getProducts(onSale: true, sortBy: 'lastChanged', max: 100, collections: ["WEIGHTS"])),
//       Shelf("Weight Plates", await ProductsSvc.getProducts(onSale: true, sortBy: 'lastChanged', max: 100, collections: ["PLATES"])),
//       Shelf("Benches", await ProductsSvc.getProducts(onSale: true, sortBy: 'lastChanged', max: 100, collections: ["BENCHES"])),
//       Shelf("Storage", await ProductsSvc.getProducts(onSale: true, sortBy: 'lastChanged', max: 100, collections: ["STORAGE"])),
//     ];
  
//     isLoading = false;
//     updateWidget();
//   }

//   void onSearch(BuildContext context, String searchQuery) {
//     goTo(
//         context,
//         SearchView(
//           searchQuery: searchQuery,
//         ));
//   }

//   //
//   // Private functions
//   //
//   void _attachListeners() {
//     _listeners ??= [
//       //
//       // Put listeners here
//       //
//     ];
//   }

//   //
//   // Dispose
//   //
//   void dispose() {
//     searchTextController.dispose();

//     _listeners?.forEach((_) => _.cancel());
//   }
// }

// class Shelf {
//   String title;
//   List<ProductModel> products;
//   int showCount = 6;
//   Shelf(this.title, this.products);
// }
