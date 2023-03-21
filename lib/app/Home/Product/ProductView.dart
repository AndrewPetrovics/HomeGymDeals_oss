import 'package:flutter/material.dart';
import 'package:home_gym_deals/database/Products/ProductModel.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../misc.dart';
import './ProductViewModel.dart';
import 'dart:convert';

class ProductView extends StatefulWidget {
  final ProductModel product;
  const ProductView({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  late ProductViewModel vm;

  @override
  void initState() {
    vm = ProductViewModel(() {
      if (mounted) setState(() {});
    }, widget.product);

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
      appBar: AppBar(),
      body: vm.isLoading ? Loading() : _getBody(),
    );
  }

  Widget _getBody(){
     JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    return ListView(
      children:[
        Text(encoder.convert(vm.product.toJson())),
        ListTile(title: Text("URL"), onTap: () {
          launchUrl(Uri.parse(vm.product.url));
        },),
        ...vm.productHistories.map((productHistory)  {
          return Text(encoder.convert(productHistory.toJson()));
        })
      ],
    );
  }
}