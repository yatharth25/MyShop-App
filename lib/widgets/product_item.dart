import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import '../providers/product.dart';
import '../providers/cart.dart';
import '../screens/product_detail_screen.dart';
import '../providers/auth.dart';
import '../pallete.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          ProductDetailScreen.routeName,
          arguments: product.id,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(kDefaultPaddin),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(product.imageUrl), fit: BoxFit.cover),
                color:
                    Colors.primaries[Random().nextInt(Colors.primaries.length)],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Hero(
                tag: "${product.id}", //child: Image.asset(product.imageUrl),
                child: Align(
                  alignment: Alignment(1.4,1.3),
                  child: Consumer<Product>(
                    builder: (ctx, product, child) => IconButton(
                      iconSize: 30,
                      icon: Icon(
                        product.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                      ),
                      onPressed: () {
                        product.toggleFavoriteStatus(
                            authData.token, authData.userId);
                      },
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: kDefaultPaddin / 4),
                      child: Text(
                        // products is out demo list
                        product.title,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Text(
                      "\u20B9${product.price}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.shopping_cart),
                  iconSize: 26,
                  onPressed: () {
                    cart.addItem(product.id, product.price, product.title);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Added to cart!"),
                      duration: Duration(seconds: 2),
                      action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          cart.subtractQuantity(product.id);
                        },
                      ),
                    ));
                  },
                ),
              ]),
        ],
      ),
    );
  }
}
