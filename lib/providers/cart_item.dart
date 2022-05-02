import 'package:flutter/material.dart';
import 'package:scholar_ecommerce_app/models/product.dart';

class CartItem with ChangeNotifier {
  List<Product> products = [];

  addProduct(Product product) {
    products.add(product);
    notifyListeners();
  }

  deleteProduct(Product product) {
    products.remove(product);
    notifyListeners();
  }
}
