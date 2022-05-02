import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final Function? onClick;
  CustomTextField({this.hintText, this.labelText, this.onClick});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: TextFormField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white38,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
          labelText: labelText,
          hintText: hintText,
          labelStyle: TextStyle(color: Colors.blue),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please fill the fields';
          }
          return null;
        },
        onSaved: onClick!(String),
      ),
    );
  }
}
