import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:scholar_ecommerce_app/models/product.dart';

class Store {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  addProduct(Product product) {
    _fireStore.collection('Products').add({
      'productName': product.name,
      'productDescription': product.description,
      'productPrice': product.price,
      'productCategory': product.category,
      'productLocation': product.location
    });
  }

  Stream<QuerySnapshot> getProducts() {
    return _fireStore.collection('Products').snapshots();
  }

  deleteProduct(productId) {
    _fireStore.collection('Products').doc(productId).delete();
  }

  editProduct(data, productId) {
    _fireStore.collection('Products').doc(productId).update(data);
  }

  Stream<QuerySnapshot> loadOrders() {
    return _fireStore.collection('Orders').snapshots();
  }

  Stream<QuerySnapshot> loadOrderDetails(documentId) {
    return _fireStore
        .collection('Orders')
        .doc(documentId)
        .collection('OrderDetails')
        .snapshots();
  }

  storeOrders(data, List<Product> products) {
    var documentRef = _fireStore.collection('Orders').doc();
    documentRef.set(data);
    for (var product in products) {
      documentRef.collection('OrderDetails').doc().set({
        'productName': product.name,
        'productPrice': product.price,
        'Quantity': product.quantity,
        'productLocation': product.location,
        'productCategory': product.category
      });
    }
  }
}
