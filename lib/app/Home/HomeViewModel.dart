import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:home_gym_deals/app/Home/AddFeedback/AddFeedbackView.dart';
import 'package:home_gym_deals/database/Products/ProductModel.dart';
import 'package:home_gym_deals/database/Products/ProductsSvc.dart';
import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:home_gym_deals/services/TrackingSvc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html;
import 'package:algolia/algolia.dart';

class HomeViewModel {
  //
  // Private members
  //
  List<StreamSubscription>? _listeners;
  Timer? _debounce;
  final db = Supabase.instance.client;
  int _page = -1;
  int _itemsPerPage = 30;
  int? _totalItems;

  //
  // Public Properties
  //
  Function updateWidget;
  bool isLoading = true, isLoadingProducts = false;
  List<ProductModel> products = [];
  TextEditingController searchTextController = TextEditingController();
  late ScrollController scrollController = ScrollController()..addListener(_scrollListener);

  var sellerFilters = [
    CheckboxFilter(column: "Rogue", label: "Rogue"),
    CheckboxFilter(column: "Titan", label: "Titan"),
    CheckboxFilter(column: "Rep", label: "Rep"),
    CheckboxFilter(column: "Walmart", label: "Walmart"),
    CheckboxFilter(column: "Fringe Sport", label: "Fringe Sport"),
    CheckboxFilter(column: "Bells of Steel", label: "Bells of Steel"),
    CheckboxFilter(column: "Again Faster", label: "Again Faster"),

    // SellerFilter("American Barbell"),
    // SellerFilter("Get RX'd"),
  ];

  var scratchAndDentFilters = [
    CheckboxFilter(column: "Boneyard", label: "Boneyard (Rouge)"),
    CheckboxFilter(column: "Scratch & Dent", label: "Scratch & Dent (Titan)"),
  ];

  var sortByFilters = [
    CheckboxFilter(label: 'Recent Price Drop', column: 'lastPriceDrop', isSelected: true, isMultiSelect: false),
    CheckboxFilter(label: 'Sale Percentage', column: 'salePercentage', isMultiSelect: false),
    CheckboxFilter(label: 'Sale Amount', column: 'saleAmount', isMultiSelect: false),
  ];

  var selectedSortByType = SortByTypes.saleAmount;

  var categoryFilters = [
    CheckboxFilter(label: 'Barbells', column: 'BARBELLS', isMultiSelect: false),
    CheckboxFilter(label: 'Racks', column: 'RACKS', isMultiSelect: false),
    CheckboxFilter(label: 'Rack Accessories', column: 'RACK_ACCESSORIES', isMultiSelect: false),
    CheckboxFilter(label: 'Dumbbells', column: 'DUMBBELLS', isMultiSelect: false),
    CheckboxFilter(label: 'Kettlebells', column: 'KETTLEBELLS', isMultiSelect: false),
    CheckboxFilter(label: 'Weight Plates', column: 'PLATES', isMultiSelect: false),
    CheckboxFilter(label: 'Benches', column: 'BENCHES', isMultiSelect: false),
    CheckboxFilter(label: 'Storage', column: 'STORAGE', isMultiSelect: false),
  ];

  var includeFilters = [
    CheckboxFilter(label: 'Not on sale', column: 'isOnSale'),
    CheckboxFilter(label: 'Out of stock', column: 'isOutOfStock'),
  ];

  late var filters = [
    Filter(
      label: 'All',
      collections: [],
      updateWidget: updateWidget,
    ),
    Filter(
      label: 'Barbells',
      collections: ['BARBELLS'],
      updateWidget: updateWidget,
    ),
    Filter(
      label: 'Racks',
      collections: ['RACKS'],
      updateWidget: updateWidget,
    ),
    Filter(
      label: 'Rack Accessories',
      collections: ['RACK_ACCESSORIES'],
      updateWidget: updateWidget,
    ),
    Filter(
      label: 'Dumbbells',
      collections: ['DUMBBELLS'],
      updateWidget: updateWidget,
    ),
    Filter(
      label: 'Kettlebells',
      collections: ['KETTLEBELLS'],
      updateWidget: updateWidget,
    ),
    Filter(
      label: 'Weight Plates',
      collections: ['PLATES'],
      updateWidget: updateWidget,
    ),
    Filter(
      label: 'Benches',
      collections: ['BENCHES'],
      updateWidget: updateWidget,
    ),
    Filter(
      label: 'Storage',
      collections: ['STORAGE'],
      updateWidget: updateWidget,
    ),
  ];

  late var selectedFilter = filters[0];

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  BuildContext context;

  Algolia algolia = const Algolia.init(
    applicationId: 'X6O1O4EOXT',
    apiKey: '80a1eafa2038dbc1037a7f33fe53f6f3',
  );

  //
  // Getters
  //

  bool get canLoadMore => _totalItems == null || products.length < _totalItems!;

  //
  // Constructor
  //
  HomeViewModel(this.updateWidget, this.context) {
    TrackingSvc.track("Home Page", {});
    init();
  }

  //
  // Public functions
  //
  void init() async {
    if (_listeners == null) _attachListeners();

    //searchTextController.addListener(_refreshResults);

    loadProducts();

    isLoading = false;
    updateWidget();

    // Future.delayed(const Duration(milliseconds: 2000), () {
    //   _showSnackBar();
    // });
  }

  void getParams() {
    //   Uri.parse(html.window.location.href).queryParameters;
    // var uri = Uri.dataFromString(window.location.href);
    // Map<String, String> params = uri.queryParameters;
    // var origin = params['origin'];
    // var destiny = params['destiny'];
    // print(origin);
    // print(destiny);
  }

  void onCheckboxFilterChange(CheckboxFilter checkBoxFilter, bool isSelected) {
    checkBoxFilter.isSelected = isSelected;
    refreshResults();
    updateWidget();
  }

  void onRadioFilterByChanged(List<CheckboxFilter> checkBoxFilters, CheckboxFilter filter, bool isSelected) {
    checkBoxFilters.forEach((f) => f.isSelected = false);
    filter.isSelected = isSelected;
    refreshResults();
    updateWidget();
  }

  void onFilterSelected(Filter filter, bool isSelected) {
    selectedFilter = filter;

    refreshResults();
    updateWidget();
  }

  void clearFilters(List<CheckboxFilter> filters) {
    filters.forEach((f) => f.isSelected = false);
    refreshResults();
    updateWidget();
  }

  void onFilterPress() {
    scaffoldKey.currentState?.openEndDrawer();
  }

  void loadProducts() async {
    // html.window.history.pushState(null, 'home', '#/home/other');
    if (!canLoadMore || isLoadingProducts) return;
    isLoadingProducts = true;
    updateWidget();
    _page += 1;
    try {
      //if (false) {
      if (searchTextController.text.isEmpty) {
        var query = db.from('products').select('*', const FetchOptions(count: CountOption.exact));

        var includeNotOnSale = includeFilters.firstWhere((f) => f.column == "isOnSale").isSelected;
        if (!includeNotOnSale) query = query.eq('isOnSale', true);

        var includeOutOfStock = includeFilters.firstWhere((f) => f.column == "isOutOfStock").isSelected;
        if (!includeOutOfStock) query = query.eq('isOutOfStock', false);

        query = _addCategoryFiltersToQuery(query);
        query = _addScratchAndDentAndSellerFiltersToQuery(query);

        if (searchTextController.text.isNotEmpty) query.textSearch('fts', searchTextController.text.split(' ').join(' & '));

        var results = await _addOrderToQuery(query).range(_page * _itemsPerPage, (_page + 1) * _itemsPerPage - 1);
        var moreProducts = results.data.map<ProductModel>((result) => ProductModel.fromJson(result)).toList();

        products.addAll(moreProducts);
        _totalItems = results.count;
      } else {
        var algoliaQuery = algolia.instance.index('products').query(searchTextController.text);

        var includeNotOnSale = includeFilters.firstWhere((f) => f.column == "isOnSale").isSelected;
        if (!includeNotOnSale) algoliaQuery = algoliaQuery.facetFilter('isOnSale:true');

        var includeOutOfStock = includeFilters.firstWhere((f) => f.column == "isOutOfStock").isSelected;
        if (!includeOutOfStock) algoliaQuery = algoliaQuery.facetFilter('isOutOfStock:false');

        var filtersStrs = [];
        var sellerFiltersStr = sellerFilters.where((f) => f.isSelected).map((f) => "seller:${f.column}").join(' OR ');
        if (sellerFiltersStr.isNotEmpty) filtersStrs.add("(${sellerFiltersStr})");

        var collectionsFiltersStr = categoryFilters.where((f) => f.isSelected).map((f) => "collections:'${f.column}'");
        if (collectionsFiltersStr.isNotEmpty) filtersStrs.add("(${collectionsFiltersStr})");

        var subSellerFiltersStr = scratchAndDentFilters.where((f) => f.isSelected).map((f) => "sellerSubtype:'${f.column}'").join(' OR ');
        if (subSellerFiltersStr.isNotEmpty) filtersStrs.add("(${subSellerFiltersStr})");

        if (filtersStrs.isNotEmpty) algoliaQuery = algoliaQuery.filters(filtersStrs.join(" AND "));

        algoliaQuery = algoliaQuery.setPage(_page);
        AlgoliaQuerySnapshot snap = await algoliaQuery.getObjects();

        var algoliaProducts = snap.hits.map((hit) => ProductModel.fromJson(hit.data)).toList();
        products.addAll(algoliaProducts);
        _totalItems = snap.nbHits;
      }

      ///
      /// Perform Query
      ///

      // Perform multiple facetFilters

      // query = query.facetFilter('isDelete:false');

      // Get Result/Objects

      if (searchTextController.text.isNotEmpty) TrackingSvc.track("Search", {"query": searchTextController.text});
    } catch (e) {
      print("error" + e.toString());
    } finally {
      isLoadingProducts = false;
      updateWidget();
    }
  }

  void onAddSellerPress() {
    TrackingSvc.track("Add Seller Press", {});
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              child: AddFeedbackView()
          );
          return Dialog.fullscreen(
              child: AddFeedbackView()
              );
        });
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

  void refreshResults() async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      products = [];
      _page = -1;
      _totalItems = null;
      loadProducts();
    });
  }

  void _scrollListener() {
    if (scrollController.position.extentAfter == 0 && canLoadMore) {
      loadProducts();
    }
  }

  PostgrestTransformBuilder<dynamic> _addOrderToQuery(PostgrestFilterBuilder<dynamic> query) {
    var selectedSortBy = sortByFilters.firstWhere((sb) => sb.isSelected);

    //if (selectedSortBy.column == "lastChange") return query.in_('lastChange', [ProductChangeTypes.priceDrop.name, ProductChangeTypes.variantPriceDrop.name]).order("lastChanged");
    // var changeTypes = [ProductChangeTypes.priceDrop.name, ProductChangeTypes.variantPriceDrop.name].join(',');
    // if (selectedSortBy.column == "lastChange") return query.or('lastChange.in.($changeTypes),lastChange.is.null').order("lastChanged");
    if (selectedSortBy.column == "lastPriceDrop") return query.order("lastPriceDrop");

    return query.order(selectedSortBy.column);
  }

  PostgrestFilterBuilder<dynamic> _addScratchAndDentAndSellerFiltersToQuery(PostgrestFilterBuilder<dynamic> query) {
    var selectedCategories = categoryFilters.where((f) => f.isSelected).map((f) => f.column).toList();

    if (selectedCategories.isNotEmpty) {
      query = query.contains('collections', selectedCategories);
    }

    return query;
  }

  PostgrestFilterBuilder<dynamic> _addCategoryFiltersToQuery(PostgrestFilterBuilder<dynamic> query) {
    var selectedSellers = sellerFilters.where((f) => f.isSelected).map((f) => f.column).join(',');
    if (selectedSellers.isNotEmpty) query = query.or("seller.in.($selectedSellers)");

    var selectedSubSellerTypes = scratchAndDentFilters.where((f) => f.isSelected).map((f) => f.column).join(',');
    if (selectedSubSellerTypes.isNotEmpty) {
      query = query.or("sellerSubtype.in.($selectedSubSellerTypes)" + (selectedSellers.isNotEmpty ? ",sellerSubtype.is.null" : ""));
    }

    return query;
  }

  void _showSnackBar() {
    final snackBar = SnackBar(
        // padding:EdgeInsets.all(0.0),
        behavior: SnackBarBehavior.floating,
        content: const ListTile(
          title: Text('Earn a \$25 gift card!', style: TextStyle(color: Colors.white)),
          // subtitle: Text('Have a 30 minute zoom chat about your home gym and get a gift card'),
        ),
        // content: Text('Earn a \$25 gift card!'),
        duration: Duration(days: 1),
        action: SnackBarAction(
          label: 'Learn more',
          onPressed: _showModal,
        ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _showModal() {
    TrackingSvc.track("Snack Bar Button Press", {});
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Earn a \$25 gift card'),
            content: const Text(
                'Have a 30 minute zoom chat about your home gym and earn a \$25 gift card to your choice of almost any store (Amazon, Target, Uber, Whole Foods, and many more).\n\n'
                'Must be willing to send a picture of your home gym before the meeting and also have access to a decent internet conenction with Zoom.'),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Close'),
                onPressed: () {
                  TrackingSvc.track("Modal Close Button Press", {});
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Let\'s do it'),
                onPressed: () {
                  TrackingSvc.track("Modal Action  Button Press", {});
                  launchUrl(Uri.parse("https://www.userinterviews.com/projects/2pvXm8uaQQ/apply"));
                },
              ),
            ],
          );
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
  String label;
  SortByTypes type;
  bool isSelected;
  SortByOption(this.label, this.type, {this.isSelected = false});
}

class CheckboxFilter {
  String column, label;
  bool isSelected, isMultiSelect;
  CheckboxFilter({
    required this.column,
    required this.label,
    this.isSelected = false,
    this.isMultiSelect = true,
  });
}

class Filter {
  Function updateWidget;

  String label;
  List<String> collections;

  Filter({required this.label, required this.collections, required this.updateWidget});
}

enum SortByTypes { lastUpdated, saleAmount, salePercentage }

class QueryParams {}
