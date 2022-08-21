import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import './storage_methods.dart';

import '../models/user.dart' as user_model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<user_model.User> getUserDetials() async {
    User currentUser = _auth.currentUser!;
    //print("CurrentUser = ${currentUser}");
    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();
    //print("Documentsnapshot : ${documentSnapshot.data()}");
    return user_model.User.fromSnap(documentSnapshot);
  }

  Future<String> signUpUserWithEmail(
    String username,
    String userEmail,
    String userPassword,
    String userBio,
    Uint8List? userImage,
  ) async {
    var result = "Some error has occured";
    // check if the fields are empty and return string to show snackbar
    if (username.isEmpty ||
        userEmail.isEmpty ||
        userPassword.isEmpty ||
        userBio.isEmpty ||
        userImage == null) {
      result = "Enter all the fields";
      return result;
    }
    try {
      // create user profile
      UserCredential _user = await _auth.createUserWithEmailAndPassword(
          email: userEmail, password: userPassword);
      // Upload profile picture to the storage
      String imageUrl = await StorageMethod()
          .uploadImageToStorage('profilePic', userImage, false);

      // creating user model
      user_model.User userModel = user_model.User(
        userEmail: userEmail,
        username: username,
        userBio: userBio,
        uid: _user.user!.uid,
        photoUrl: imageUrl,
        following: [],
        followers: [],
      );
      // save user information in the firestore
      await _firestore
          .collection('users')
          .doc(_user.user!.uid)
          .set(userModel.toJson());
      // because function has completed all the task without error return sucess
      result = "success";
      return result;
    } on FirebaseAuthException catch (error) {
      return error.message!;
    } catch (error) {
      result = "error";
      //print(error.toString());
      return result;
    }
  }

  Future<String> signInWithGoogle() async {
    var result = "";
    var googleAuthPro = GoogleAuthProvider();
    return result;
  }

  Future<String> signIn(String email, String password) async {
    var snackbarMessage = "Some error has occured";
    try {
      UserCredential userCred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      snackbarMessage = "Success";
    } on FirebaseAuthException catch (error) {
      snackbarMessage = error.message!;
      return snackbarMessage;
    } catch (error) {
      snackbarMessage = error.toString();
    }
    return snackbarMessage;
  }
}
