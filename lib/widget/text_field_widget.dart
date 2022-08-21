import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../models/auth_models.dart';

class TextFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String labelTxt;
  final String hintTxt;
  final Auth_models typeOfFields;
  final TextInputType txtInputType;
  TextFieldWidget(
      {Key? key,
      required this.controller,
      required this.labelTxt,
      required this.hintTxt,
      this.typeOfFields = Auth_models.others,
      required this.txtInputType})
      : super(key: key);

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  String? validateFunction(String? inputText) {
    // validator for all types of field
    if (inputText == null || inputText == "") {
      return 'You need to enter values';
    }
    // validator for email
    if (widget.typeOfFields == Auth_models.email) {
      if (!inputText.contains("@") || !inputText.endsWith('.com')) {
        return "Enter valid email address";
      }
    }

    // validator for password
    if (widget.typeOfFields == Auth_models.password) {
      if (inputText.length < 8) {
        return "Password has to be longer than 8 characters";
      }
    }
  }

  void togglePasswordVisibility() {
    setState(() {
      _passwordVisibility = !_passwordVisibility;
    });
  }

  var _passwordVisibility = false;

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );
    return TextFormField(
      controller: widget.controller,
      obscureText: _passwordVisibility ? true : false,
      decoration: InputDecoration(
        suffix: widget.typeOfFields == Auth_models.password
            ? InkWell(
                onTap: togglePasswordVisibility,
                child: Ink(
                  child: _passwordVisibility
                      ? Icon(Icons.visibility_off, size: 20,)
                      : Icon(Icons.visibility, size: 20,),
                ),
              )
            : null,
        border: inputBorder,
        label: Text(widget.labelTxt),
        hintText: widget.hintTxt,
      ),
      validator: (value) {
        return validateFunction(value);
      },
    );
  }
}
