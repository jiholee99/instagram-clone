import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:instagram_clone/utils/colors.dart';

class PictureDetailScreen extends StatelessWidget {
  final Uint8List picture;
  const PictureDetailScreen({required this.picture, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
      ),
      body: Center(
        child: Hero(
          tag: 'picture',
          child: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.contain,
              alignment: FractionalOffset.center,
              image: MemoryImage(picture),
            )),
          ),
        ),
      ),
    );
  }
}
