import 'dart:typed_data';

import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageMethod {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadImageToStorage(
      String childName, Uint8List userPickedImage, bool isPost) async {
    // Reference to the location of the storage where image will be stored
  Reference _ref =
      _storage.ref().child(childName).child(_auth.currentUser!.uid);

    // If image is from a post then create a unique id and create a child after user's uid
    if (isPost) {
      String _id = const Uuid().v1();
      _ref = _ref.child(_id);
    }

    UploadTask upload_task = _ref.putData(userPickedImage);
    // this makes upload_task async even though it does not return future
    TaskSnapshot task_snapshot = await upload_task;
    String imageUrl = await task_snapshot.ref.getDownloadURL();
    return imageUrl;
  }
}
