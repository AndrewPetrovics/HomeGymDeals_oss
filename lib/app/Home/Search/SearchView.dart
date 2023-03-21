import 'package:flutter/material.dart';
import 'package:home_gym_deals/app/Home/Product/ProductView.dart';
import 'package:home_gym_deals/app/components/ProductCard.dart';
import 'package:home_gym_deals/database/Products/ProductModel.dart';
import 'package:home_gym_deals/misc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'SearchViewModel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:home_gym_deals/app/components/SearchBar.dart';

class SearchView extends StatefulWidget {
  final String? searchQuery;
  const SearchView({Key? key, this.searchQuery}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late SearchViewModel vm;

  @override
  void initState() {
    vm = SearchViewModel(() {
      if (mounted) setState(() {});
    }, widget.searchQuery);

    super.initState();
  }

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: vm.scaffoldKey,
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Colors.white,
        title: SearchBar(
          textController: vm.searchTextController,
          //onSubmitted: (value) => vm.onSearch(context, value),
        ),
      ),
      body: vm.isLoading ? Loading() : _getBody(),
    );
  }

  Widget _getBody() {
    return ListView(
      children: [
        ResponsiveGridRow(
          children: [
            ResponsiveGridCol(
              lg: 2,
              child: _getFilters(),
            ),
            ResponsiveGridCol(
              lg: 10,
              child: _getSearchResults(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _getSearchResults() {
    return ResponsiveGridRow(
      children: vm.products.map((product) {
        return ResponsiveGridCol(xs: 6, md: 4, lg: 3, child: ProductCard(product),);
      }).toList(),
    );
  }

  Widget _getFilters() {
    return Column(children: [
      _getFilterCard(
        "Sort By",
        Wrap(
          children: vm.sortByOptions.map((sortByOption) {
            return RadioListTile(
              title: Text(sortByOption.label),
              groupValue: sortByOption.isSelected,
              selected: sortByOption.isSelected,
              value: true,
              onChanged: (selected) => vm.onSortByChanged(sortByOption, selected ?? false),
            );
          }).toList(),
        ),
      ),
      _getFilterCard(
        "Sellers",
        Column(
          children: vm.sellerFilters.map((sellerFilter) {
            return CheckboxListTile(
              value: sellerFilter.isSelected,
              title: Padding(
                padding: EdgeInsets.only(left: sellerFilter.isSellerSubtype ? 32 : 0),
                child: Text(sellerFilter.seller),
              ),
              onChanged: (isSelected) => vm.onSellerFilterChange(sellerFilter, isSelected ?? false),
            );
          }).toList(),
        ),
      ),
      _getFilterCard(
        "Show Only",
        Column(
          children: [
            CheckboxListTile(
              title: Text("On Sale"),
              value: vm.includeOnSale,
              onChanged: (selected) => vm.onShowOnSaleChange(selected ?? false),
            ),
            CheckboxListTile(
              title: Text("In Stock"),
              value: vm.includeInStock,
              onChanged: (selected) => vm.onShowInStockChange(selected ?? false),
            ),
          ],
        ),
      ),
      // vm.filters.map((filter) => _getFilter(filter)).toList(),
    ]);
  }

  Widget _getFilterCard(String title, Widget child) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(title),
          ),
          child,
        ],
      ),
    );
  }
}
