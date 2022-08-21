import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import './colors.dart';

class Utils {
  Future<Uint8List?> pickImage(ImageSource imageSource) async {
    final ImagePicker imagePicker = ImagePicker();
    try {
      final XFile? userPickedImage = await imagePicker.pickImage(source: imageSource);
      if (userPickedImage != null) {
        return await userPickedImage.readAsBytes();
      }
    } catch (error) {
      print("Utils.dart : pickImage error : ${error.toString()}");
      return null;
    }
  }

  void showSnackbar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 1),
        content: Text(
          message,
          textAlign: TextAlign.center,
        )));
  }

  String calculateDate(DateTime datePublished, {bool isFullLength = false}) {
    var dateDifference = DateTime.now().difference(datePublished);
    // if the dateDifference is longer than 7 days represent it with weeks
    if (dateDifference.inDays > 6) {
      return isFullLength ? DateFormat.Md().format(datePublished) : "${dateDifference.inDays ~/ 7}w";
      // if the dateDifference is longer than 24 days represent it with days
    } else if (dateDifference.inHours > 24) {
      return isFullLength ? "${dateDifference.inDays} days ago" : "${dateDifference.inDays}d";
      // otherwise represent it with hours
    } else {
      if (dateDifference.inHours == 0) {
        return isFullLength ? '${dateDifference.inMinutes} minutes ago' : '${dateDifference.inMinutes}m';
      }
      return isFullLength ? "${dateDifference.inHours} hours ago" : "${dateDifference.inHours}h";
    }
  }
}
