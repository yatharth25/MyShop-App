import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import '../screens/cart_screen.dart';

enum FiltersOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("MyShop"), actions: [
        PopupMenuButton(
            onSelected: (FiltersOptions selectedValue) {
              setState(() {
                if (selectedValue == FiltersOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
                  PopupMenuItem(
                    child: Text('Only Favorites'),
                    value: FiltersOptions.Favorites,
                  ),
                  PopupMenuItem(
                    child: Text('Show All'),
                    value: FiltersOptions.All,
                  ),
                ]),
        Consumer<Cart>(
          builder: (_, cartData, ch) => Badge(
            child: ch,
            value: cartData.itemCount.toString(),
          ),
          child: IconButton(
            icon: Icon(
              Icons.shopping_cart,
            ),
            onPressed: () =>
                {Navigator.of(context).pushNamed(CartScreen.routeName)},
          ),
        )
      ]),
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}
