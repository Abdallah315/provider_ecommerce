import 'package:scholar_ecommerce_app/models/product.dart';
import 'package:scholar_ecommerce_app/services/store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderDetails extends StatelessWidget {
  static const routeName = 'OrderDetails';
  Store store = Store();
  @override
  Widget build(BuildContext context) {
    dynamic documentId = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: store.loadOrderDetails(documentId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Product> products = [];
              for (var doc in snapshot.data!.docs) {
                products.add(Product(
                  name: doc['productName'],
                  quantity: doc['Quantity'],
                  category: doc['productCategory'],
                ));
              }

              return Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(20),
                        child: Container(
                          height: MediaQuery.of(context).size.height * .5,
                          color: Colors.blue,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('product name : ${products[index].name}',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Quantity : ${products[index].quantity}',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'product Category : ${products[index].category}',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      itemCount: products.length,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: ButtonTheme(
                            buttonColor: Colors.green,
                            child: RaisedButton(
                              onPressed: () {},
                              child: Text('Confirm Order'),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: ButtonTheme(
                            buttonColor: Colors.blue,
                            child: RaisedButton(
                              onPressed: () {},
                              child: Text('Delete Order'),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: Text('Loading Order Details'),
              );
            }
          }),
    );
  }
}
