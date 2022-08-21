import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/screens/post_photo_selection_screen.dart';
import 'package:instagram_clone/screens/picture_detail_screen.dart';
import 'package:instagram_clone/screens/profile_screen/profile_screen.dart';

import '../screens/add_post_screen.dart';
import '../screens/feed_screen.dart';
import '../screens/search_screen.dart';

const webScreenSize = 600;
var pageViewScreenItems = [
  FeedScreen(),
  SearchScreen(),
  PostPhotoSelectionScreen(),
  Center(child: Text("Notification")),
  ProfileScreen(),
];
const TextStyle commentFunctionStyle = TextStyle(color: Colors.grey, fontSize: 13);
