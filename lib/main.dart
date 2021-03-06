import 'package:flutter/material.dart';
import 'package:shop/helpers/custom_route.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/orders.dart';
import 'package:shop/screens/auth_screen.dart';
import 'package:shop/screens/cart_screen.dart';
import 'package:shop/screens/edit_product_screen.dart';
import 'package:shop/screens/orders_screen.dart';
import 'package:shop/screens/product_detail_screen.dart';
import 'package:shop/screens/products_overview_screen.dart';
import 'package:shop/screens/splash_screen.dart';
import 'package:shop/screens/user_product_screen.dart';
import './colors.dart';
import './providers/products.dart';
import 'package:provider/provider.dart';


void main() async {
  runApp(MyApp());


}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            update: (ctx, auth, previousProducts) => Products(
              auth.token,
              auth.userId,
              previousProducts == null ? [] : previousProducts.items,
            ),
          ),
          ChangeNotifierProvider(create: (ctx) => Cart()),
          ChangeNotifierProxyProvider<Auth, Orders>(
            update: (ctx, auth, previousOrders) => Orders(
              auth.token,
              auth.userId,
              previousOrders == null ? [] : previousOrders.orders,
            ),
          ),
        ],
        child: Consumer<Auth>(
            builder: (ctx, auth, _) => MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: '',
                  theme: ThemeData(
                    primaryIconTheme:
                        IconThemeData(color: kSecondaryColor[100]),

                    // This is the theme of your application.
                    //
                    // Try running your application with "flutter run". You'll see the
                    // application has a blue toolbar. Then, without quitting the app, try
                    // changing the primarySwatch below to Colors.green and then invoke
                    // "hot reload" (press "r" in the console where you ran "flutter run",
                    // or simply save your changes to "hot reload" in a Flutter IDE).
                    // Notice that the counter didn't reset back to zero; the application
                    // is not restarted.
                    primaryColorLight: kPrimaryColor[100],
                    primaryColor: kPrimaryColor[100],
                    accentColor: kPrimaryColorAccent[100],
                    textTheme: ThemeData.light().textTheme.copyWith(
                          bodyText1: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Handlee'),
                          bodyText2: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Handlee',
                          ),
                          headline6: TextStyle(
                            color: kPrimaryColorAccent[100],

                            fontSize: 15,
                            fontFamily: 'PlayfairDisplay',
                          ),
                          headline5: TextStyle(
                            color: kSecondaryColor[100],
                            fontSize: 12,
                            fontFamily: 'PlayfairDisplay',
                          ),
                          headline4: TextStyle(
                            color: kSecondaryColor[100],
                            fontSize: 14,
                            fontFamily: 'PlayfairDisplay',
                          ),
                          headline3: TextStyle(
                            color: kSecondaryColor[100],
                            fontSize: 16,
                            fontFamily: 'PlayfairDisplay',
                          ),
                          headline2: TextStyle(
                            color: kSecondaryColor[100],
                            fontSize: 18,
                            fontFamily: 'PlayfairDisplay',
                          ),
                          headline1: TextStyle(
                            color: kSecondaryColor[100],
                            fontSize: 25,
                            fontFamily: 'Lato',
                          ),
                        ),
                    pageTransitionsTheme: PageTransitionsTheme(builders: {
                      TargetPlatform.android: CustomPageTransitionBuilder(),
                      TargetPlatform.iOS: CustomPageTransitionBuilder()
                    })

                  ),
                  home: auth.isAuth
                      ? ProductsOverviewScreen()
                      : FutureBuilder(
                          future: auth.tryAutoLogin(),
                          builder: (ctx, authResultSnapshot) =>
                              authResultSnapshot.connectionState ==
                                      ConnectionState.waiting
                                  ? SplashScreen()
                                  : AuthScreen()),
                  routes: {
                    ProductDetailScreen.routeName: (ctx) =>
                        ProductDetailScreen(),
                    CartScreen.routeName: (ctx) => CartScreen(),
                    OrdersScreen.routeName: (ctx) => OrdersScreen(),
                    UserProductScreen.routeName: (ctx) => UserProductScreen(),
                    EditProductScreen.routeName: (ctx) => EditProductScreen()
                  },
                )));
  }
}
