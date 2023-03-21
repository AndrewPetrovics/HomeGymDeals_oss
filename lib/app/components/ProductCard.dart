import 'package:flutter/material.dart';
import 'package:home_gym_deals/app/Home/Product/ProductView.dart';
import 'package:home_gym_deals/database/Products/ProductModel.dart';
import 'package:home_gym_deals/misc.dart';
import 'package:home_gym_deals/services/TrackingSvc.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:jiffy/jiffy.dart';

class ProductCard extends StatelessWidget {
  ProductModel product;
  ProductCard(this.product);

  void _onTap() {
    TrackingSvc.track("Product Clicked", {"url": product.url});
    launchUrl(Uri.parse(product.url));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MouseRegion(
          //key: key,
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            //onTap: () => goTo(context, ProductView(product: product)),
            onTap: _onTap,
            behavior: HitTestBehavior.opaque,
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Color(0xffdadce0)),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    product.image != null ? AspectRatio(aspectRatio: 1, child: Image.network(product.image!)) : Nothing(),
                    Spacing(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SelectableText(product.title,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(overflow: TextOverflow.ellipsis),
                            maxLines: 3,
                            scrollPhysics: NeverScrollableScrollPhysics()),
                        if (product.lastPriceDrop != null)
                          Padding(
                            padding: EdgeInsets.only(top: 4.0),
                            child: Text(Jiffy(product.lastPriceDrop!.toUtc()).fromNow(), style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12)),
                          ),
                      ],
                    ),

                    Spacing(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(product.hasVarients && product.priceLow != product.priceHigh
                            ? "${money(product.priceLow)}-${money(product.priceHigh)}"
                            : money(product.price)),
                        if (!product.hasVarients && product.isOnSale)
                          Text(' ' + money(product.oldPrice),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12, decoration: TextDecoration.lineThrough)),
                      ],
                    ),
                    // if (product.hasVarients) Text("\nUp to ${product.salePercentage}% off") ,
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () => launchUrl(Uri.parse(product.url)),
                      child: Text(product.seller),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16, left: 16),
          child: _getBadge(),
        ),
      ],
    );
  }

  Widget _getBadge() {
    if (product.isOnSale && product.salePercentage != null && product.salePercentage! > 0)
      return Chip(
        label: Text("${product.hasVarients ? 'UP TO ' : ''}${product.salePercentage}% OFF"),
      );

    if (product.isOutOfStock)
      return Chip(
        label: Text("Out of stock"),
      );

    return Nothing();
  }
}
