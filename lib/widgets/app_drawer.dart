import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/orders_screen.dart';
import '../screens/user_products.dart';
import '../providers/auth.dart';
import '../providers/products_provider.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  //var _isLoading=false;
  // name() async {
  //   final username =
  //       await Provider.of<Products>(context, listen: false).fetchUserName();
  //   return username;
  // }

  // @override
  // void initState() async {
  //   name();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder(
        future: Provider.of<Products>(context, listen: false).fetchUserName(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (dataSnapshot.error != null) {
            return Center(
              child: Text("An error occured"),
            );
          } else {
            return Consumer<Products>(
                builder: (ctx, username, child) =>
                    drawer(username.username, context));
          }
        },
      ),
    );
  }

  Column drawer(String username, BuildContext context) {
    return Column(children: <Widget>[
      AppBar(
        title: Text('Hi, $username!'),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png',
              ),
            ),
          ),
        ],
      ),
      Divider(),
      ListTile(
        leading: Icon(Icons.shop),
        title: Text('Shop'),
        onTap: () {
          Navigator.of(context).pushReplacementNamed('/');
        },
      ),
      Divider(),
      ListTile(
        leading: Icon(Icons.payment),
        title: Text('Orders'),
        onTap: () {
          Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
        },
      ),
      Divider(),
      ListTile(
        leading: Icon(Icons.edit),
        title: Text('Manage Products'),
        onTap: () {
          Navigator.of(context)
              .pushReplacementNamed(UserProductsScreen.routeName);
        },
      ),
      Divider(),
      ListTile(
        leading: Icon(Icons.exit_to_app),
        title: Text('Logout'),
        onTap: () {
          Navigator.of(context).pop();
          Provider.of<Auth>(context, listen: false).logout();
        },
      ),
    ]);
  }
}
