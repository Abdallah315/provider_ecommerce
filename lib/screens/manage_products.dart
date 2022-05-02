import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scholar_ecommerce_app/models/product.dart';
import 'package:scholar_ecommerce_app/screens/edit_product.dart';
import 'package:scholar_ecommerce_app/services/store.dart';
import '../widgets/custom_menu.dart';

class ManageProduct extends StatefulWidget {
  static const routeName = '/manage-product';

  @override
  _ManageProductState createState() => _ManageProductState();
}

class _ManageProductState extends State<ManageProduct> {
  final _store = Store();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: _store.getProducts(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Product> products = [];
              snapshot.data!.docs.map((doc) {
                var data = doc;
                products.add(Product(
                  id: doc.id,
                  price: data['productPrice'],
                  name: data['productName'],
                  location: data['productLocation'],
                  description: data['productDescription'],
                  category: data['productCategory'],
                ));
              }).toList();
              return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 0.8),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: GestureDetector(
                        onTapUp: (details) {
                          double dx = details.globalPosition.dx;
                          double dy = details.globalPosition.dy;
                          double dx2 = MediaQuery.of(context).size.width - dx;
                          double dy2 = MediaQuery.of(context).size.height - dy;
                          showMenu(
                            context: context,
                            position: RelativeRect.fromLTRB(dx, dy, dx2, dy2),
                            items: [
                              MyPopupMenuItem(
                                  onClick: () {
                                    Navigator.of(context).pushNamed(
                                        EditProduct.routeName,
                                        arguments: products[index]);
                                  },
                                  child: Text('Edit')),
                              MyPopupMenuItem(
                                  onClick: () {
                                    _store.deleteProduct(products[index].id);
                                    Navigator.pop(context);
                                  },
                                  child: Text('Delete'))
                            ],
                          );
                        },
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image(
                                fit: BoxFit.fill,
                                image: AssetImage(
                                    products[index].location.toString()),
                              ),
                            ),
                            Positioned(
                                bottom: 0,
                                child: Opacity(
                                  opacity: 0.6,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 60,
                                    color: Colors.white60,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            products[index].name.toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text('\$ ${products[index].price}')
                                        ],
                                      ),
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      ),
                    );
                  });
            } else {
              return Text('Loading...');
            }
          }),
    );
  }
}
