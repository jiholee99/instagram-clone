import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';

class PostOptionCardWidget extends StatelessWidget {
  const PostOptionCardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Uint8List? imageFile;
    return SafeArea(
      child: Container(
          padding: EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height * 0.3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () async{
                  imageFile = await Utils().pickImage(ImageSource.camera);
                  Navigator.of(context).pop(imageFile);
                },
                child: Text("Choose from Camera",
                    style: TextStyle(color: primaryColor)),
              ),
              Divider(),
              TextButton(
                onPressed: () async{
                  imageFile = await Utils().pickImage(ImageSource.gallery);
                  Navigator.of(context).pop(imageFile);
                },
                child: Text(
                  "Choose from Gallery",
                  style: TextStyle(color: primaryColor),
                ),
              ),
              Divider(),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancel", style: TextStyle(color: primaryColor)),
              ),
            ],
          )),
    );
  }
}
