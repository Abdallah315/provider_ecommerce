import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scholar_ecommerce_app/models/product.dart';
import 'package:scholar_ecommerce_app/providers/cart_item.dart';
import 'package:scholar_ecommerce_app/screens/cart_screen.dart';

class ProductInfo extends StatefulWidget {
  static const routeName = '/product-info';
  @override
  _ProductInfoState createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    dynamic product = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: Icon(Icons.add_shopping_cart))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addToCart(context, product);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.50,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              product.location,
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name.toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  Text(
                    '\$ ${product.price}'.toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ClipOval(
                        child: Material(
                          color: Colors.blueAccent,
                          child: GestureDetector(
                            onTap: add,
                            child: SizedBox(
                              child: Icon(Icons.add),
                              height: 32,
                              width: 32,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        _quantity.toString(),
                        style: TextStyle(fontSize: 60),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      ClipOval(
                        child: Material(
                          color: Colors.blueAccent,
                          child: GestureDetector(
                            onTap: subtract,
                            child: SizedBox(
                              child: Icon(Icons.remove),
                              height: 32,
                              width: 32,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  subtract() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  add() {
    setState(() {
      _quantity++;
    });
  }

  void addToCart(context, Product product) {
    CartItem cartItem = Provider.of<CartItem>(context, listen: false);
    product.quantity = _quantity;
    bool exist = false;
    var productsInCart = cartItem.products;
    for (var productInCart in productsInCart) {
      if (productInCart.name == product.name) {
        exist = true;
      }
    }
    if (exist) {
      return;
    } else {
      cartItem.addProduct(product);
    }
  }
}
