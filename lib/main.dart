import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import './screen/auth_screen.dart';
import './screen/user_products_screen.dart';
import './screen/product_detail_screen.dart';
import './screen/product_overview_screen.dart';
import './screen/cart_screen.dart';
import './screen/orders_screen.dart';
import './screen/edit_product_screen.dart';
import './screen/splashScreen.dart';

import './providers/orders.dart';
import './providers/products.dart';
import './providers/cart.dart';
import 'providers/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders(),
          update: (_, auth, previousOrders) =>
              previousOrders..updateData(auth.token, auth.uId),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products(),
          update: (_, auth, previousProducts) => previousProducts
            ..update(
                auth.token,
                previousProducts == null ? [] : previousProducts.items,
                auth.uId),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
            title: 'Shop App',
            theme: ThemeData(
                primarySwatch: Colors.purple,
                accentColor: Colors.deepOrange,
                fontFamily: 'Lato',
                textTheme: ThemeData.light().textTheme.copyWith(
                      headline6: TextStyle(color: Colors.white, fontSize: 18),
                    )),
            home: auth.isAuth
                ? ProductOverviewScreen()
                : FutureBuilder(
                    future: auth.tryLogin(),
                    builder: (ctx, authDataSnapshot) =>
                        authDataSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),
            routes: {
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
            }),
      ),
    );
  }
}
