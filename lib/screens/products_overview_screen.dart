import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';

import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import '../screens/cart_screen.dart';
import '../widgets/app_drawer.dart';

enum FiltersOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = '/products';
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
        drawer: AppDrawer(),
        body: FutureBuilder(
            future: Provider.of<Products>(context, listen: false)
                .fetchAndSetProducts(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Consumer<Products>(
                    builder: (ctx, _, child) =>
                        ProductsGrid(_showOnlyFavorites));
              } else if (snapshot.error != null) {
                return Center(child: Text("Sorry! An error occured :("));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }
}
