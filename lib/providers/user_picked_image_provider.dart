import 'dart:typed_data';
import 'package:flutter/material.dart';

class UserPickedProvider with ChangeNotifier {
  Uint8List? _image;
  Uint8List? get image => _image;
  void setImage(Uint8List image) {
    _image = image;
    notifyListeners();
  }
}