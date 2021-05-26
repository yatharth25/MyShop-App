import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:flutter_svg/svg.dart';

import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import '../screens/cart_screen.dart';
import '../widgets/app_drawer.dart';
import '../pallete.dart';

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
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            title: Text("MyShop"),
            backgroundColor: Colors.white,
            elevation: 0,
            leading: new IconButton(
                icon: new Icon(
                  Icons.menu,
                  color: kTextColor,
                ),
                onPressed: () => _scaffoldKey.currentState.openDrawer()),
            actions: <Widget>[
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/search.svg",
                  // By default our  icon color is white
                  color: kTextColor,
                ),
                onPressed: () {},
              ),
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
                  icon: Icon(
                    Icons.filter_list_rounded,
                    color: kTextColor,
                  ),
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
                  icon: SvgPicture.asset(
                    "assets/icons/cart.svg",
                    color: kTextColor,
                  ),
                  onPressed: () =>
                      {Navigator.of(context).pushNamed(CartScreen.routeName)},
                ),
              ),
              SizedBox(width: kDefaultPaddin / 2)
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
            }),
            //bottomNavigationBar: BottomNavigationBar(),
      ),
    );
  }
}
