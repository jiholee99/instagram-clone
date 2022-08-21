import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/post_photo_selection_screen.dart';
import 'package:instagram_clone/screens/search_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:provider/provider.dart';

import '../screens/add_post_screen.dart';
import '../screens/feed_screen.dart';
import '../utils/global_variable.dart';

import '../models/user.dart' as user_model;

import '../providers/user_provider.dart';

import '../resources/auth_methods.dart';

import '../widget/post_option_card_widget.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  Uint8List? _postImageFile;
  int _page = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
  }

  void naviateToPage(int page) async {
    _pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        // disable scrolling sideways
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        // After the navigation bar item is tapped it goes to the page and then onpagechange method updates the _page value
        onPageChanged: onPageChanged,
        children: pageViewScreenItems,
      ),
      bottomNavigationBar: CupertinoTabBar(
          border: Border(top: BorderSide(color: Colors.grey, width: 0.2)),
          currentIndex: _page,
          // First jump to the page
          onTap: naviateToPage,
          backgroundColor: mobileBackgroundColor,
          activeColor: blueColor,
          items: const [
            // Home screen tab bar
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
            ),
            // search tab bar
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
            ),
            // adding post tab bar
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle),
            ),
            // favorite tab bar
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
            ),
            // profile tab bar
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
            ),
          ]),
    );
  }
}
