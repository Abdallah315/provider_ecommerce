import 'package:flutter/material.dart';
import 'package:scholar_ecommerce_app/services/store.dart';
import 'package:scholar_ecommerce_app/widgets/text_field.dart';

class EditProduct extends StatelessWidget {
  static const routeName = '/edit-product';
  late String _name, _price, _description, _category, _imageLocation;
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final _store = Store();
  @override
  Widget build(BuildContext context) {
    dynamic product = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      body: Form(
        key: _globalKey,
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * .2,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
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
                  onClick: (value) {
                    _price = value;
                  },
                  hintText: 'Product Price',
                ),
                SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  onClick: (value) {
                    _description = value;
                  },
                  hintText: 'Product Description',
                ),
                SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  onClick: (value) {
                    _category = value;
                  },
                  hintText: 'Product Category',
                ),
                SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  onClick: (value) {
                    _imageLocation = value;
                  },
                  hintText: 'Product Location',
                ),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  onPressed: () {
                    if (_globalKey.currentState!.validate()) {
                      _globalKey.currentState!.save();

                      _store.editProduct({
                        'productName': _name,
                        'productLocation': _imageLocation,
                        'productCategory': _category,
                        'productDescription': _description,
                        'productPrice': _price
                      }, product.id);
                    }
                  },
                  child: Text('Edit Product'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
