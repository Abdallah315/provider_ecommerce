import 'package:flutter/material.dart';
import 'package:scholar_ecommerce_app/models/product.dart';
import 'package:scholar_ecommerce_app/services/store.dart';
import 'package:scholar_ecommerce_app/widgets/text_field.dart';

class AddProducts extends StatelessWidget {
  static const routeName = '/add-product';
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  late String _name, _price, _description, _category, _imageLocation;
  final _store = Store();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _globalKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.12,
              ),
              CustomTextField(
                hintText: 'Product Name',
                onClick: (value) {
                  _name = value;
                },
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextField(
                hintText: 'Product Price',
                onClick: (value) {
                  _price = value;
                },
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextField(
                hintText: 'Product Description',
                onClick: (value) {
                  _description = value;
                },
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextField(
                hintText: 'Product Category',
                onClick: (value) {
                  _category = value;
                },
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextField(
                hintText: 'Image Location',
                onClick: (value) {
                  _imageLocation = value;
                },
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_globalKey.currentState!.validate()) {
                    _globalKey.currentState!.save();
                    _globalKey.currentState!.reset();
                    _store.addProduct(Product(
                        category: _category,
                        description: _description,
                        location: _imageLocation,
                        name: _name,
                        price: _price));
                  }
                },
                child: Text('Add Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
