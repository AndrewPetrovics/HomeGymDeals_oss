import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:home_gym_deals/database/Products/ProductModel.dart';
import 'package:home_gym_deals/database/Products/ProductsSvc.dart';
import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:home_gym_deals/services/TrackingSvc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

class SearchViewModel {
  //
  // Private members
  //
  List<StreamSubscription>? _listeners;
  Timer? _debounce;
  final db = Supabase.instance.client;

  //
  // Public Properties
  //
  Function updateWidget;
  bool isLoading = true;
  List<ProductModel> products = [];
  HitsSearcher hitsSearcher = HitsSearcher(applicationID: 'X6O1O4EOXT', apiKey: '80a1eafa2038dbc1037a7f33fe53f6f3', indexName: 'products');
  TextEditingController searchTextController = TextEditingController();
  Stream<SearchMetadata> get searchMetadata => hitsSearcher.responses.map(SearchMetadata.fromResponse);
  // final PagingController<int, ProductModel> pagingController = PagingController(firstPageKey: 0);
  // Stream<HitsPage> get searchPage => hitsSearcher.responses.map(HitsPage.fromResponse);

  FilterState filterState = FilterState();
  // late List<SearchFilter> filters = [
  //   SearchFilter("Seller", FacetList(searcher: hitsSearcher, filterState: filterState, attribute: 'seller')),
  //   SearchFilter("Out of stock", FacetList(searcher: hitsSearcher, filterState: filterState, attribute: 'isOutOfStock')),
  //   SearchFilter("On Sale", FacetList(searcher: hitsSearcher, filterState: filterState, attribute: 'isOnSale')),
  //   //SearchFilter("Price", FacetList(searcher: hitsSearcher, filterState: filterState, attribute: 'price')),
  //   //Filter.range('price'),
  //   //SearchFilter("Sale Amount", FacetList(searcher: hitsSearcher, filterState: filterState, attribute: 'saleAmount')),
  //   //SearchFilter("Sale Percentage", FacetList(searcher: hitsSearcher, filterState: filterState, attribute: 'salePercentage')),
  // ];

  var sellerFilters = [
    SellerFilter("Rouge"),
    SellerFilter("Boneyard", isSellerSubtype: true),
    SellerFilter("Titan"),
    SellerFilter("Scratch & Dent", isSellerSubtype: true),
    SellerFilter("Rep"),
    SellerFilter("Fringe Sport"),
    SellerFilter("Bells of Steel"),
    SellerFilter("Again Faster"),
    SellerFilter("American Barbell"),
    SellerFilter("Get RX'd"),
  ];
  var sortByOptions = [
    SortByOption("Recent Price Drop", 'lastChanged', isSelected: true),
    SortByOption("Sale Percentage", 'salePercentage'),
    SortByOption(
      "Sale Amount",
      'saleAmount',
    ),
  ];
  bool includeOnSale = true;
  bool includeInStock = true;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  //
  // Getters
  //

  //
  // Constructor
  //
  SearchViewModel(this.updateWidget, String? searchQuery) {
    searchTextController.text = searchQuery ?? '';
    init();
  }

  //
  // Public functions
  //
  void init() async {
    if (_listeners == null) _attachListeners();

    // filterState.add(FilterGroupID('isOnSale'), [Filter.facet('isOnSale', true)]);
    // filterState.add(FilterGroupID('price'), [Filter.range('price', lowerBound: 50, upperBound: 53)]);
    // hitsSearcher.responses.listen((searchResponse) {
    //   products = searchResponse.hits.map(ProductModel.fromJson).toList();
    //   updateWidget();
    // });
    //hitsSearcher.applyState((state) =>  state.copyWith(indexName: {"df": "asdf"}));
    // searchTextController.addListener(
    //   () => hitsSearcher.applyState(
    //     (state) => state.copyWith(
    //       query: searchTextController.text,
    //       page: 0,
    //     ),
    //   ),
    // );
    searchTextController.addListener(_refreshResults);
    // searchPage.listen((page) {
    //   if (page.pageKey == 0) {
    //     pagingController.refresh();
    //   }
    //   pagingController.appendPage(page.items, page.nextPageKey);
    // }).onError((error) => pagingController.error = error);
    // pagingController.addPageRequestListener((pageKey) => hitsSearcher.applyState((state) => state.copyWith(page: pageKey)));
    //filterState.add(groupID, filters)
    // hitsSearcher.connectFilterState(filterState);
    //filterState.filters.listen((_) => pagingController.refresh());
    //filterState.filters.listen((_) => pagingController.refresh());

    _refreshResults();

    isLoading = false;
    updateWidget();
  }

  void onSellerFilterChange(SellerFilter sellerFilter, bool isSelected) {
    sellerFilter.isSelected = isSelected;
    _refreshResults();
    updateWidget();
  }

  void onShowOnSaleChange(bool isSelected) {
    includeOnSale = isSelected;
    _refreshResults();
    updateWidget();
  }

  void onShowInStockChange(bool isSelected) {
    includeInStock = isSelected;
    _refreshResults();
    updateWidget();
  }

  void onSortByChanged(SortByOption sortByOption, bool isSelected) {
    sortByOptions.forEach((sb) => sb.isSelected = false);
    sortByOption.isSelected = isSelected;
    _refreshResults();
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

  void _refreshResults() async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      if (searchTextController.text.isNotEmpty) TrackingSvc.track("Search", {"searchText": searchTextController.text});

      var selectedSellers = sellerFilters.where((f) => f.isSelected && !f.isSellerSubtype).map((f) => f.seller).join(',');
      var selectedSubSellerTypes = sellerFilters.where((f) => f.isSelected && f.isSellerSubtype).map((f) => f.seller).join(',');
      List<String> orQueries = [];
      if (selectedSellers != "") orQueries.add("seller.in.($selectedSellers)");
      if (selectedSubSellerTypes != "") orQueries.add("sellerSubtype.is.null, sellerSubtype.in.($selectedSubSellerTypes)");

      var selectedSortBy = sortByOptions.firstWhereOrNull((sb) => sb.isSelected);

      products = await ProductsSvc.getProducts(
        searchText: searchTextController.text,
        orQueries: orQueries,
        onSale: includeOnSale,
        inStock: includeInStock,
        sortBy: selectedSortBy?.column ?? 'lastChange',
        max: 100,
      );
      updateWidget();
    });
  }

  //
  // Dispose
  //
  void dispose() {
    searchTextController.dispose();
    _debounce?.cancel();
    _listeners?.forEach((_) => _.cancel());
  }
}

class SearchMetadata {
  final int nbHits;

  const SearchMetadata(this.nbHits);

  factory SearchMetadata.fromResponse(SearchResponse response) => SearchMetadata(response.nbHits);
}

class HitsPage {
  const HitsPage(this.items, this.pageKey, this.nextPageKey);

  final List<ProductModel> items;
  final int pageKey;
  final int? nextPageKey;

  factory HitsPage.fromResponse(SearchResponse response) {
    final items = response.hits.map(ProductModel.fromJson).toList();
    final isLastPage = response.page >= response.nbPages;
    final nextPageKey = isLastPage ? null : response.page + 1;
    return HitsPage(items, response.page, nextPageKey);
  }
}

class SortByOption {
  String column, label;
  bool isSelected;
  SortByOption(this.label, this.column, {this.isSelected = false});
}

class SellerFilter {
  String seller;
  bool isSelected;
  bool isSellerSubtype;
  SellerFilter(this.seller, {this.isSelected = true, this.isSellerSubtype = false});
}
