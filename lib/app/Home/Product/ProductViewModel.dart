import 'dart:async';

import 'package:home_gym_deals/database/ProductHistories/ProductHistoriesSvc.dart';
import 'package:home_gym_deals/database/Products/ProductModel.dart';

class ProductViewModel {

  //
  // Private members
  //
  List<StreamSubscription>? _listeners;

  //
  // Public Properties
  //
  Function updateWidget;
  bool isLoading = true;
  ProductModel product;
  List<ProductModel> productHistories = [];

  //
  // Getters
  //

  //
  // Constructor
  //
  ProductViewModel(this.updateWidget, this.product) {
    init();
  }

  //
  // Public functions
  //
  void init() async {
    if (_listeners == null) _attachListeners();

   productHistories = await ProductHistoriesSvc.getProductHistoriesByUrl(product.url);

    isLoading = false;
    updateWidget();
  }

  //
  // Private functions
  //
  void _attachListeners() {
    _listeners ??= [
       //
       // Put listeners here
       //
    ];
  }


  //
  // Dispose
  //
  void dispose() {
   _listeners?.forEach((_) => _.cancel());
  }
}