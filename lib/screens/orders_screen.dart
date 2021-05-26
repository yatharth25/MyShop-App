import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/orders_item.dart';
import '../widgets/app_drawer.dart';
import '../providers/cart.dart';
import '../screens/cart_screen.dart';
import '../widgets/badge.dart';
import '../pallete.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            "Your Orders",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: new IconButton(
            icon: new Icon(
              Icons.menu,
              color: kTextColor,
            ),
            onPressed: () => _scaffoldKey.currentState.openDrawer(),
          ),
          actions: [
            IconButton(
              icon: SvgPicture.asset(
                "assets/icons/search.svg",
                // By default our  icon color is white
                color: kTextColor,
              ),
              onPressed: () {},
            ),
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
          ],
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future:
              Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (dataSnapshot.error != null) {
              return Center(
                child: Text("An error occured"),
              );
            } else {
              return Consumer<Orders>(
                  builder: (ctx, orderData, child) => orderData.orders.isEmpty
                      ? Center(child: Text(" You have no orders yet : ("))
                      : ListView.builder(
                          itemCount: orderData.orders.length,
                          itemBuilder: (ctx, i) =>
                              OrderItem(orderData.orders[i]),
                        ));
            }
          },
        ),
      ),
    );
  }
}
