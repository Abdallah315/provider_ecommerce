import 'package:flutter/material.dart';
import 'package:scholar_ecommerce_app/screens/add_products.dart';
import 'package:scholar_ecommerce_app/screens/manage_products.dart';
import 'package:scholar_ecommerce_app/screens/order_screen.dart';

class AdminPanel extends StatelessWidget {
  static const routeName = '/adminPanel';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: double.infinity,
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AddProducts.routeName);
          },
          child: Text('Add Products'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushNamed(ManageProduct.routeName);
          },
          child: Text('Edit Products'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushNamed(
              OrdersScreen.routeName,
            );
          },
          child: Text('Order Screen'),
        )
      ],
    ));
  }
}
