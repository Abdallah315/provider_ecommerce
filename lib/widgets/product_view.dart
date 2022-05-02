import 'package:flutter/material.dart';
import 'package:scholar_ecommerce_app/models/product.dart';
import 'package:scholar_ecommerce_app/screens/product_info.dart';
import '../functions.dart';

Widget productsView(String pCategory, List<Product> allProducts) {
  List<Product> products = [];
  products = getProductByCategory(pCategory, allProducts);
  return GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: .8,
    ),
    itemBuilder: (context, index) => Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(ProductInfo.routeName, arguments: products[index]);
        },
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Image.asset(
                products[index].location.toString(),
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
              bottom: 0,
              child: Opacity(
                opacity: .6,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          products[index].name.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('\$ ${products[index].price}')
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ),
    itemCount: products.length,
  );
}
