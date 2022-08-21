import 'dart:core';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String username;
  final String userEmail;
  final String userBio;
  final String uid;
  final String photoUrl;
  final List following;
  final List followers;

  User({
    required this.username,
    required this.userEmail,
    required this.userBio,
    required this.uid,
    this.photoUrl = "https://www.nicepng.com/maxp/u2q8r5t4i1r5a9w7/",
    required this.following,
    required this.followers,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'email': userEmail,
        'bio': userBio,
        'uid': uid,
        'profileUrl': photoUrl,
        'following': following,
        'followers': followers,
      };

  static User fromSnap(DocumentSnapshot snapshot) {
    // get the informationa about user from cloudstore as map and return User model
    var data = snapshot.data() as Map<String, dynamic>;
    return User(
      username: data['username'],
      uid: data['uid'],
      userBio: data['bio'],
      photoUrl: data['profileUrl'],
      userEmail: data['email'],
      followers: data['followers'],
      following: data['following'],
    );
  }
}
