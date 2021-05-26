import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/svg.dart';

import '../providers/products_provider.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';
import '../screens/edit_product_screen.dart';
import '../pallete.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user_product';
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<void> _refreshProducts(BuildContext context) async {
    Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text(
            'Your Products',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: new IconButton(
              icon: new Icon(
                Icons.menu,
                color: kTextColor,
              ),
              onPressed: () => _scaffoldKey.currentState.openDrawer()),
          actions: [
            IconButton(
              icon: SvgPicture.asset(
                "assets/icons/search.svg",
                // By default our  icon color is white
                color: kTextColor,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.add),
              color: kTextColor,
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
            ),
            SizedBox(width: kDefaultPaddin / 2)
          ],
        ),
        drawer: AppDrawer(),
        body: RefreshIndicator(
          onRefresh: () => _refreshProducts(context),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: ListView.builder(
              itemCount: productsData.items.length,
              itemBuilder: (_, i) => Column(
                children: [
                  UserProductItem(
                    productsData.items[i].id,
                    productsData.items[i].title,
                    productsData.items[i].imageUrl,
                  ),
                  Divider(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
