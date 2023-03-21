import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:home_gym_deals/app/Home/Product/ProductView.dart';
import 'package:home_gym_deals/app/components/ProductCard.dart';
import 'package:home_gym_deals/database/Products/ProductModel.dart';
import 'package:home_gym_deals/misc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'HomeViewModel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:home_gym_deals/app/components/SearchBar.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late HomeViewModel vm;

  @override
  void initState() {
    vm = HomeViewModel(() {
      if (mounted) setState(() {});
    }, context);

    super.initState();
  }

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var routeName = ModalRoute.of(context);

    return Scaffold(
      key: vm.scaffoldKey,
      // drawer: Drawer(
      //   child: _getMenu(),
      // ),
      endDrawer: Drawer(
        child: _getFilters(),
      ),
      appBar: AppBar(
        toolbarHeight: 75.0,
        //leading: IconButton(onPressed: vm.onMenuPress, icon: Icon(Icons.menu)),
        iconTheme: Theme.of(context).iconTheme,
        actions: [isMobile(context) ? IconButton(onPressed: vm.onFilterPress, icon: Icon(Icons.tune)) : Nothing()],
        backgroundColor: Colors.white,
        title: Column(
          children: [
            // Row(
            //   children: [
            //     IconButton(onPressed: vm.onMenuPress, icon: Icon(Icons.menu))
            //   ],
            // ),
            SearchBar(
              textController: vm.searchTextController,
              //onSubmitted: (value) => vm.onSearch(context, value),
              onChanged: (value) => vm.refreshResults(),
            ),
          ],
        ),
      ),
      body: vm.isLoading ? Loading() : _getBody(),
    );
  }

  Widget _getMenu() {
    return ListView(
      children: [
        DrawerHeader(child: Text("Home Gym Deals")),
        ListTile(
          title: Text("Sugest a feature"),
          subtitle: Text("Is there some functionality you would like to see? Let us know."),
        ),
        ListTile(
          title: Text("Suggest a store"),
          subtitle: Text("Is there a store we should be tracking deals for? Let us know."),
        ),
      ],
    );
  }

  Widget _getBody() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isMobile(context))
          Container(
            width: 275,
            child: _getFilters(),
          ),
        Expanded(
          child: CustomScrollView(
            controller: vm.scrollController,
            primary: false,
            slivers: <Widget>[
              // SliverPadding(
              //   padding: EdgeInsets.symmetric(vertical: 16.0),
              //   sliver: SliverToBoxAdapter(
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         ...vm.filters.map((filter) {
              //           return Padding(
              //             padding: EdgeInsets.only(right: 8.0),
              //             child: ChoiceChip(
              //               label: Text(filter.label),
              //               selected: vm.selectedFilter.label == filter.label,
              //               onSelected: (selected) => vm.onFilterSelected(filter, selected),
              //             ),
              //           );
              //         }).toList(),
              //         SegmentedButton<SortByTypes>(
              //           showSelectedIcon: false,
              //           segments: const <ButtonSegment<SortByTypes>>[
              //             ButtonSegment<SortByTypes>(
              //               value: SortByTypes.lastUpdated,
              //               label: Text('Last Updated'),
              //             ),
              //             ButtonSegment<SortByTypes>(
              //               value: SortByTypes.saleAmount,
              //               label: Text('Sale Amount'),
              //             ),
              //           ],
              //           selected: <SortByTypes>{vm.selectedSortByType},
              //           onSelectionChanged: vm.onSortBySelected,
              //         ),
              //       ],
              //     ),
              //   ),
              // ),

              SliverPadding(
                  padding:
                      //EdgeInsets.symmetric(vertical: 16.0, horizontal: MediaQuery.of(context).size.width > 1440 ? (MediaQuery.of(context).size.width - 1440) / 2 : 0),
                      EdgeInsets.only(left: 4.0, top: 16.0, bottom: 16.0, right: isMobile(context) ? 4.0 : 4.0),
                  sliver: SliverGrid.count(
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                    crossAxisCount: getItemsPerRow(
                      context,
                      xs: 2,
                      sm: 3,
                      md: 4,
                      lg: 4,
                      xl: 5,
                    ),
                    childAspectRatio: 9 / 16,
                    children: vm.products.map((product) {
                      return ProductCard(product);
                    }).toList(),
                  )),

              if (vm.isLoadingProducts)
                SliverPadding(
                  padding: EdgeInsets.only(top: 16.0),
                  sliver: SliverToBoxAdapter(
                    child: Loading(),
                  ),
                ),
              if (!vm.isLoadingProducts && vm.products.isEmpty)
                SliverPadding(
                  padding: EdgeInsets.only(top: 16.0),
                  sliver: SliverToBoxAdapter(
                    child: Center(
                      child: Text("No results found"),
                    ),
                  ),
                ),
            ],
          ),
        ),

        // ListView(children: [
        //   Text("Column"),
        //   Text("Column"),
        //   Text("Column"),
        //   Text("Column"),
        //   Text("Column"),
        //   Text("Column"),
        //   Text("Column"),
        // ]),
      ],
    );

    return CustomScrollView(
      controller: vm.scrollController,
      primary: false,
      slivers: <Widget>[
        // SliverPadding(
        //   padding: EdgeInsets.symmetric(vertical: 16.0),
        //   sliver: SliverToBoxAdapter(
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         ...vm.filters.map((filter) {
        //           return Padding(
        //             padding: EdgeInsets.only(right: 8.0),
        //             child: ChoiceChip(
        //               label: Text(filter.label),
        //               selected: vm.selectedFilter.label == filter.label,
        //               onSelected: (selected) => vm.onFilterSelected(filter, selected),
        //             ),
        //           );
        //         }).toList(),
        //         SegmentedButton<SortByTypes>(
        //           showSelectedIcon: false,
        //           segments: const <ButtonSegment<SortByTypes>>[
        //             ButtonSegment<SortByTypes>(
        //               value: SortByTypes.lastUpdated,
        //               label: Text('Last Updated'),
        //             ),
        //             ButtonSegment<SortByTypes>(
        //               value: SortByTypes.saleAmount,
        //               label: Text('Sale Amount'),
        //             ),
        //           ],
        //           selected: <SortByTypes>{vm.selectedSortByType},
        //           onSelectionChanged: vm.onSortBySelected,
        //         ),
        //       ],
        //     ),
        //   ),
        // ),

        SliverGrid.count(
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            //childAspectRatio: 9 / 16,
            children: [Text("asdfasdf"), Text("asdfasdf")]),

        SliverPadding(
            padding:
                EdgeInsets.symmetric(vertical: 16.0, horizontal: MediaQuery.of(context).size.width > 1440 ? (MediaQuery.of(context).size.width - 1440) / 2 : 0),
            sliver: SliverGrid.count(
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: getItemsPerRow(
                context,
                xs: 2,
                md: 3,
                lg: 6,
              ),
              childAspectRatio: 9 / 16,
              children: vm.products.map((product) {
                return ProductCard(product);
              }).toList(),
            )),

        if (vm.isLoadingProducts)
          SliverPadding(
            padding: EdgeInsets.only(top: 16.0),
            sliver: SliverToBoxAdapter(
              child: Loading(),
            ),
          ),
        if (!vm.isLoadingProducts && vm.products.isEmpty)
          SliverPadding(
            padding: EdgeInsets.only(top: 16.0),
            sliver: SliverToBoxAdapter(
              child: Center(
                child: Text("No results found"),
              ),
            ),
          ),
      ],
    );
    // return WebContainer(
    //   child: ListView(
    //     controller: vm.scrollController,
    //     children: [
    //       Padding(
    //         padding: EdgeInsets.symmetric(vertical: 16.0),
    //         child: Row(
    //           children: [
    //             ...vm.filters.map((filter) {
    //               return Padding(
    //                 padding: EdgeInsets.only(right: 8.0),
    //                 child: ChoiceChip(
    //                   label: Text(filter.label),
    //                   selected: vm.selectedFilter.label == filter.label,
    //                   onSelected: (selected) => vm.onFilterSelected(filter, selected),
    //                 ),
    //               );
    //             }).toList(),
    //             SegmentedButton<SortByTypes>(
    //               showSelectedIcon: false,
    //               segments: const <ButtonSegment<SortByTypes>>[
    //                 ButtonSegment<SortByTypes>(
    //                   value: SortByTypes.lastUpdated,
    //                   label: Text('Last Updated'),
    //                 ),
    //                 ButtonSegment<SortByTypes>(
    //                   value: SortByTypes.saleAmount,
    //                   label: Text('Sale Amount'),
    //                 ),
    //               ],
    //               selected: <SortByTypes>{vm.selectedSortByType},
    //               onSelectionChanged: vm.onSortBySelected,
    //             ),
    //           ],
    //         ),
    //       ),
    //       // ...vm.products.map((product) {
    //       //   return ProductCard(product);
    //       // }).toList(),
    //       _getSearchResults(),
    //       if (vm.isLoadingProducts) Loading(),
    //     ],
    //   ),
    // );
  }

  Widget _getSearchResults() {
    return ResponsiveGridRow(
      children: vm.products.map((product) {
        return ResponsiveGridCol(
          xs: 6,
          md: 4,
          lg: 2,
          child: ProductCard(product),
        );
      }).toList(),
    );
  }

  Widget _getFilters() {
    return ListView(
      children: [
        if (vm.searchTextController.text.isEmpty)
          FilterCard(
            title: "Sort By",
            filters: vm.sortByFilters,
            onFilterChange: (
              filter,
              isSelected,
            ) =>
                vm.onRadioFilterByChanged(vm.sortByFilters, filter, isSelected),
          ),
        FilterCard(
          title: "Sellers",
          filters: vm.sellerFilters,
          onFilterChange: (
            filter,
            isSelected,
          ) =>
              vm.onCheckboxFilterChange(filter, isSelected),
          onClear: () => vm.clearFilters(vm.sellerFilters),
          trailing: TextButton.icon(onPressed: vm.onAddSellerPress, icon: Icon(Icons.add), label: Text("Suggest a seller")),
        ),
        FilterCard(
          title: "Scratch and dent",
          filters: vm.scratchAndDentFilters,
          onFilterChange: (
            filter,
            isSelected,
          ) =>
              vm.onCheckboxFilterChange(filter, isSelected),
          onClear: () => vm.clearFilters(vm.scratchAndDentFilters),
        ),
        FilterCard(
          title: "Categories",
          filters: vm.categoryFilters,
          onFilterChange: (
            filter,
            isSelected,
          ) =>
              vm.onRadioFilterByChanged(vm.categoryFilters, filter, isSelected),
          onClear: () => vm.clearFilters(vm.categoryFilters),
        ),
        FilterCard(
          title: "Include",
          filters: vm.includeFilters,
          onFilterChange: (
            filter,
            isSelected,
          ) =>
              vm.onCheckboxFilterChange(filter, isSelected),
        ),
      ],
    );
  }
}

enum FilterTypes { checkbox, radio }

class FilterCard extends StatelessWidget {
  List<CheckboxFilter> filters;
  FilterTypes filterType;
  Function()? onClear;
  Function(CheckboxFilter filter, bool selected) onFilterChange;
  Widget? trailing;

  String title;
  FilterCard({required this.title, required this.filters, required this.onFilterChange, this.filterType = FilterTypes.checkbox, this.onClear, this.trailing});

  @override
  Widget build(BuildContext context) {
    bool hasSelected = filters.any((f) => f.isSelected);

    return Padding(
      padding: EdgeInsets.only(top: 16.0),
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Color(0xffdadce0)),
          borderRadius: BorderRadius.circular(8.0),
        ),
        borderOnForeground: false,
        elevation: 0,
        child: Column(
          children: [
            ListTile(
              title: Text(title),
              trailing: hasSelected && onClear != null
                  ? TextButton(
                      child: Text("Clear"),
                      onPressed: onClear,
                    )
                  : null,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...filters.map((filter) {
                  return filter.isMultiSelect
                      ? CheckBoxItem(
                          value: filter.isSelected,
                          label: filter.label,
                          onChanged: (selected) => onFilterChange(filter, selected ?? false),
                        )
                      : RadioItem(
                          groupValue: filter.isSelected,
                          value: true,
                          label: filter.label,
                          onChanged: (selected) => onFilterChange(filter, selected ?? false),
                        );
                }),
                if (trailing != null) Padding(padding: EdgeInsets.all(4.0), child: trailing!),
                Spacing(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CheckBoxItem extends StatelessWidget {
  bool value;
  Function(bool?) onChanged;
  String label;
  CheckBoxItem({required this.value, required this.onChanged, required this.label});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onChanged(!value),
        child: Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Row(
            children: [
              Checkbox(value: value, onChanged: onChanged),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}

class RadioItem extends StatelessWidget {
  bool value;
  bool? groupValue;
  Function(bool?) onChanged;
  String label;
  RadioItem({required this.value, required this.onChanged, required this.label, required this.groupValue});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onChanged(value),
        child: Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Row(
            children: [
              Radio<bool>(
                value: value,
                groupValue: groupValue,
                onChanged: onChanged,
              ),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}
