import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scholar_ecommerce_app/functions.dart';
import 'package:scholar_ecommerce_app/models/product.dart';
import 'package:scholar_ecommerce_app/providers/auth.dart';
import 'package:scholar_ecommerce_app/screens/auth_screen.dart';
import 'package:scholar_ecommerce_app/screens/cart_screen.dart';
import 'package:scholar_ecommerce_app/screens/product_info.dart';
import 'package:scholar_ecommerce_app/services/store.dart';
import 'package:scholar_ecommerce_app/widgets/product_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home-page';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = Auth();
  int bottomNavIndex = 0;
  int tapBarIndex = 0;
  final _store = Store();
  late List<Product> _products = [];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DefaultTabController(
          length: 4,
          child: Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              unselectedItemColor: Colors.grey,
              fixedColor: Colors.blue.shade400,
              currentIndex: bottomNavIndex,
              onTap: (value) async {
                if (value == 2) {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  pref.clear();
                  await _auth.signOut();
                  Navigator.of(context)
                      .pushReplacementNamed(AuthScreen.routename);
                }
                setState(() {
                  bottomNavIndex = value;
                });
              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: 'Test'),
                BottomNavigationBarItem(
                  label: 'Test',
                  icon: Icon(Icons.person),
                ),
                BottomNavigationBarItem(
                  label: 'Sign Out',
                  icon: Icon(Icons.close),
                )
              ],
            ),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              bottom: TabBar(
                indicatorColor: Colors.blue.shade400,
                onTap: (value) {
                  setState(() {
                    tapBarIndex = value;
                  });
                },
                tabs: [
                  Text(
                    'Jackets',
                    style: TextStyle(
                        color: tapBarIndex == 0 ? Colors.black : Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: tapBarIndex == 0 ? 10 : 6),
                  ),
                  Text(
                    'Trousers',
                    style: TextStyle(
                        color: tapBarIndex == 1 ? Colors.black : Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: tapBarIndex == 1 ? 10 : 6),
                  ),
                  Text(
                    'T-Shirts',
                    style: TextStyle(
                        color: tapBarIndex == 2 ? Colors.black : Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: tapBarIndex == 2 ? 10 : 6),
                  ),
                  Text(
                    'Shoes',
                    style: TextStyle(
                        color: tapBarIndex == 3 ? Colors.black : Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: tapBarIndex == 3 ? 10 : 6),
                  )
                ],
              ),
            ),
            body: TabBarView(
              children: [
                jacketView(),
                productsView('trousers', _products),
                productsView('shirts', _products),
                productsView('shoes', _products),
              ],
            ),
          ),
        ),
        Material(
          child: Padding(
            padding: EdgeInsets.only(top: 30, right: 20, bottom: 0, left: 20),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Discover'.toUpperCase(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(CartScreen.routeName);
                    },
                    child: Icon(Icons.shopping_cart),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  jacketView() {
    return StreamBuilder<QuerySnapshot>(
        stream: _store.getProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            late List<Product> products = [];
            snapshot.data!.docs.map((doc) {
              var data = doc;
              products.add(Product(
                id: doc.id,
                price: data.get('productPrice'),
                name: data.get('productName'),
                location: data.get('productLocation'),
                description: data.get('productDescription'),
                category: data.get('productCategory'),
              ));
            }).toList();
            _products = [...products];
            products.clear();
            products = getProductByCategory('jackets', _products);
            return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 0.8),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(ProductInfo.routeName,
                            arguments: products[index]);
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
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
