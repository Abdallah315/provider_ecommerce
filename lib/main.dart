import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scholar_ecommerce_app/providers/cart_item.dart';
import 'package:scholar_ecommerce_app/screens/add_products.dart';
import 'package:scholar_ecommerce_app/screens/admin_panel.dart';
import 'package:scholar_ecommerce_app/screens/auth_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:scholar_ecommerce_app/screens/cart_screen.dart';
import 'package:scholar_ecommerce_app/screens/home_page.dart';
import 'package:scholar_ecommerce_app/screens/manage_products.dart';
import 'package:scholar_ecommerce_app/screens/order_detail.dart';
import 'package:scholar_ecommerce_app/screens/order_screen.dart';
import 'package:scholar_ecommerce_app/screens/product_info.dart';
import 'package:scholar_ecommerce_app/screens/product_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './screens/edit_product.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  bool isUserLoggedIn = false;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return MaterialApp(
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else {
            isUserLoggedIn = snapshot.data!.getBool('keepMeLoggedIn') ?? false;
            return MultiProvider(
              providers: [
                ChangeNotifierProvider<CartItem>(
                    create: (context) => CartItem())
              ],
              child: MaterialApp(
                title: 'Flutter Demo',
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                ),
                home: isUserLoggedIn ? HomePage() : AuthScreen(),
                routes: {
                  ManageProduct.routeName: (context) => ManageProduct(),
                  ProductScreen.routeName: (context) => ProductScreen(),
                  AuthScreen.routename: (context) => AuthScreen(),
                  AdminPanel.routeName: (context) => AdminPanel(),
                  AddProducts.routeName: (context) => AddProducts(),
                  EditProduct.routeName: (context) => EditProduct(),
                  HomePage.routeName: (context) => HomePage(),
                  ProductInfo.routeName: (context) => ProductInfo(),
                  CartScreen.routeName: (context) => CartScreen(),
                  OrdersScreen.routeName: (context) => OrdersScreen(),
                  OrderDetails.routeName: (context) => OrderDetails(),
                },
              ),
            );
          }
        });
  }
}
