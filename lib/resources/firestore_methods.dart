import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import '../resources/storage_methods.dart';

import '../models/post.dart';
import '../models/comment.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // stores picture of a post to cloud store and informations in the firebase database
  // this method returns messages whether the process was successful or not
  Future<String> storePostInCloudAndDatabase(
      String username, String description, String uid, Uint8List file, String profileImageUrl) async {
    var snackbarMessage = "Some error has occured";
    try {
      // Uploading post photo to the firebasea cloud store
      String postPhotoUrl = await StorageMethod().uploadImageToStorage('posts', file, true);

      // Creating post model for storing information in the database.
      final String postId = Uuid().v1();
      Post post = Post(
          username: username,
          description: description,
          uid: uid,
          postId: postId,
          datePublished: DateTime.now(),
          postPhotoUrl: postPhotoUrl,
          profImageUrl: profileImageUrl,
          likes: []);
      Map<String, dynamic> postInformation = post.toJson();
      // uploading post informations to the firebase database.
      await _firestore.collection('posts').doc(postId).set(postInformation);
      snackbarMessage = "Success";
      return snackbarMessage;
    } catch (error) {
      // If there are any errors return that message
      snackbarMessage = error.toString();
      return snackbarMessage;
    }
  }

  Future<void> likePostOrComment(String postId, String uid, List likes, {bool isComment = false, String? commentId}) async {
    try {
      var path = isComment
          ? _firestore.collection('posts').doc(postId).collection('comments').doc(commentId)
          : _firestore.collection('posts').doc(postId);
      // If likes list contains userId then get rid of it and vice versa
      if (likes.contains(uid)) {
        await path.update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await path.update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (error) {
      print(error.toString());
    }
  }

  Future<String?> uploadComment(
      {required String username, required String uid, required String comment, required String postId}) async {
    try {
      final String commentId = Uuid().v1();
      final commentObject =
          Comment(username: username, uid: uid, comment: comment, commentId: commentId, datePublished: DateTime.now(), likes: []);
      await _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).set(commentObject.toJson());
    } catch (error) {
      print(error.toString());
      return error.toString();
    }
  }

  Future<void> followUser(String uid) async {
    try {
      await  _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      'following': FieldValue.arrayUnion([uid])
    });
    } catch (error) {
      print("FollowUser function error : ${error.toString()}");
    }
   
  }

  Future<void> unfollowUser(String uid) async {
    try {
      await  _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      'following': FieldValue.arrayRemove([uid])
    });
    } catch (error) {
      print("FollowUser function error : ${error.toString()}");
    }
   
  }

}
