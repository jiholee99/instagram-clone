import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widget/post_card_widget.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:provider/provider.dart';

import '../models/user.dart' as user_model;

import '../providers/user_provider.dart';

class PostGridViewWidget extends StatelessWidget {
  final AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> userPostSnapshot;
  const PostGridViewWidget({required this.userPostSnapshot, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: userPostSnapshot.data!.docs.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 1),
        itemBuilder: (ctx, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return UserPostListWidget(
                  userPostSnapshot: userPostSnapshot,
                  initialIndex: index,
                );
              }));
            },
            child: Image.network(userPostSnapshot.data!.docs[index]['postUrl'], fit: BoxFit.cover),
          );
        });
  }
}

class UserPostListWidget extends StatelessWidget {
  final AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> userPostSnapshot;
  final int initialIndex;
  const UserPostListWidget({Key? key, required this.userPostSnapshot, required this.initialIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user_model.User _user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: Column(
            children: [
              Text(
                _user.username,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                "Posts",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: ScrollablePositionedList.builder(
            initialScrollIndex: initialIndex,
            itemCount: userPostSnapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return PostCardWidget(snapshot: userPostSnapshot.data!.docs[index]);
            },
          ),
        ));
  }
}
