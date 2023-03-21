// import 'package:flutter/material.dart';
// import 'package:home_gym_deals/app/Home/Product/ProductView.dart';
// import 'package:home_gym_deals/app/components/ProductCard.dart';
// import 'package:home_gym_deals/app/components/SearchBar.dart';
// import 'package:home_gym_deals/database/Products/ProductModel.dart';
// import 'package:home_gym_deals/misc.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'NewHomeViewModel.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:responsive_grid/responsive_grid.dart';
// import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// import 'package:easy_search_bar/easy_search_bar.dart';
// import 'package:material_floating_search_bar/material_floating_search_bar.dart';

// class HomeView extends StatefulWidget {
//   const HomeView({Key? key}) : super(key: key);

//   @override
//   State<HomeView> createState() => _HomeViewState();
// }

// class _HomeViewState extends State<HomeView> {
//   late HomeViewModel vm;

//   @override
//   void initState() {
//     vm = HomeViewModel(() {
//       if (mounted) setState(() {});
//     });

//     super.initState();
//   }

//   @override
//   void dispose() {
//     vm.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: vm.scaffoldKey,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         iconTheme: Theme.of(context).iconTheme,
//         title: SearchBar(
//           textController: vm.searchTextController,
//           onSubmitted: (value) => vm.onSearch(context, value),
//         ),
//       ),
//       body: vm.isLoading ? Loading() : _getBody(),
//     );
//   }

//   Widget buildFloatingSearchBar() {
//     final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

//     return FloatingSearchBar(
//       hint: 'Search...',
//       scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
//       transitionDuration: const Duration(milliseconds: 800),
//       transitionCurve: Curves.easeInOut,
//       physics: const BouncingScrollPhysics(),
//       axisAlignment: isPortrait ? 0.0 : -1.0,
//       openAxisAlignment: 0.0,
//       width: isPortrait ? 600 : 500,
//       debounceDelay: const Duration(milliseconds: 500),
//       onQueryChanged: (query) {
//         // Call your model, bloc, controller here.
//       },
//       // Specify a custom transition to be used for
//       // animating between opened and closed stated.
//       transition: CircularFloatingSearchBarTransition(),
//       actions: [
//         FloatingSearchBarAction(
//           showIfOpened: false,
//           child: CircularButton(
//             icon: const Icon(Icons.place),
//             onPressed: () {},
//           ),
//         ),
//         FloatingSearchBarAction.searchToClear(
//           showIfClosed: false,
//         ),
//       ],
//       builder: (context, transition) {
//         return ClipRRect(
//           borderRadius: BorderRadius.circular(8),
//           child: Material(
//             color: Colors.white,
//             elevation: 4.0,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: Colors.accents.map((color) {
//                 return Container(height: 112, color: color);
//               }).toList(),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _getBody() {
//     return WebContainer(
//       child: ListView(
//         children: vm.shelves.map((shelf) => _getShelf(shelf)).toList(),
//       ),
//     );
//   }

//   Widget _getShelf(Shelf shelf) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(shelf.title, style: Theme.of(context).textTheme.headlineLarge),
//         ResponsiveGridRow(
//           children: shelf.products.take(shelf.showCount).map((p) {
//             return ResponsiveGridCol(
//               xs: 6,
//               md: 4,
//               lg: 2,
//               child: ProductCard(p),
//             );
//           }).toList(),
//         ),
//         if (shelf.showCount < shelf.products.length)
//           Align(
//             alignment: Alignment.center,
//             child: TextButton.icon(
//                 onPressed: () {
//                   shelf.showCount += 6;
//                   vm.updateWidget();
//                 },
//                 icon: Icon(Icons.arrow_drop_down),
//                 label: Text("View More")),
//           ),
//       ],
//     );
//   }
// }
