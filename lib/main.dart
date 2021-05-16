import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products_provider.dart';
import './providers/cart.dart';
import './providers/auth.dart';
import './screens/cart_screen.dart';
import './providers/orders.dart';
import './screens/orders_screen.dart';
import './screens/user_products.dart';
import './screens/edit_product_screen.dart';
import './authentication/auth_screen/login-screen.dart';
import './authentication/auth_screen/create-new-account.dart';
import './authentication/auth_screen/forgot-password.dart';
import './authentication/auth_screen/screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (ctx) => Auth()),
          ListenableProxyProvider<Auth, Products>(
            update: (ctx, auth, prevProds) =>
                Products(auth.token, prevProds == null ? [] : prevProds.items),
          ),
          ChangeNotifierProvider(create: (ctx) => Cart()),
          ListenableProxyProvider<Auth, Orders>(
            update: (ctx, auth, prevProds) =>
                Orders(auth.token, prevProds == null ? [] : prevProds.orders),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'MyShop',
            theme: ThemeData(
              textTheme:
                  GoogleFonts.josefinSansTextTheme(Theme.of(context).textTheme),
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: auth.isAuth ? ProductsOverviewScreen() : LoginScreen(),
            routes: {
              ForgotPassword.routeName: (ctx) => ForgotPassword(),
              CreateNewAccount.routeName: (ctx) => CreateNewAccount(),
              ProductsOverviewScreen.routeName: (ctx) =>
                  ProductsOverviewScreen(),
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
            },
          ),
        ));
  }
}
