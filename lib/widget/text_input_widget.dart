import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';

class TextInputWidget extends StatefulWidget {
  final TextEditingController txtEditingController;
  final String labelTxt;
  final String hintTxt;
  final bool isPassword;
  final TextInputType txtInputType;

  const TextInputWidget({
    Key? key,
    required this.txtEditingController,
    required this.labelTxt,
    required this.hintTxt,
    this.isPassword = false,
    required this.txtInputType,
  }) : super(key: key);

  @override
  State<TextInputWidget> createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends State<TextInputWidget> {
  var isObscure = true;
  var showVisibilityWidget = false;
  @override
  Widget build(BuildContext context) {
    Widget visibilityWidget = InkWell(
      child: isObscure ? Icon(Icons.visibility_off,size: 18,) : Icon(Icons.visibility,size: 18,),
      onTap: () {
        setState(() {
          isObscure = !isObscure;
        });
      },
    );
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );
    return TextField(
      controller: widget.txtEditingController,
      obscureText: widget.isPassword ? isObscure : false,
      decoration: InputDecoration(
        //constraints: BoxConstraints(minHeight: 40),
        label: Text(widget.labelTxt),
        hintText: widget.hintTxt,
        border: inputBorder,
        // Visibility icon to show password
        suffixIconConstraints: BoxConstraints(maxHeight: 20),
        suffix: showVisibilityWidget
            ? null
            : widget.isPassword
                ? visibilityWidget
                : null,
      ),
    );
  }
}
