import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../providers/user_picked_image_provider.dart';

class PickedImageWidget extends StatefulWidget {
  Uint8List? firstImage;
  PickedImageWidget({required this.firstImage, Key? key}) : super(key: key);

  @override
  State<PickedImageWidget> createState() => _PickedImageWidgetState();
}

class _PickedImageWidgetState extends State<PickedImageWidget> {
  // Have to use photoView later for fullScreen to move around the photo!
  var isFullScreen = false;

  @override
  Widget build(BuildContext context) {
    var image = Provider.of<UserPickedProvider>(context).image;
    return Stack(children: [
      Container(
        height: MediaQuery.of(context).size.height * 0.4,
        width: double.infinity,
        child: Image.memory(
          image == null ? widget.firstImage! : image,
          fit: isFullScreen ? BoxFit.cover : BoxFit.contain,
        ),
      ),
      Positioned(
          bottom: 10,
          left: 10,
          child: IconButton(
            onPressed: () {
              setState(() {
                isFullScreen = !isFullScreen;
              });
            },
            icon: isFullScreen ? Icon(Icons.open_in_full_rounded) : Icon(Icons.close_fullscreen_rounded),
          ))
    ]);
  }
}
