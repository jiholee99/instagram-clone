import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:instagram_clone/screens/profile_screen/following_details_widget.dart';
import 'package:instagram_clone/screens/profile_screen/follwers_details_widget.dart';
import 'package:instagram_clone/utils/colors.dart';

class FollowerFollowingDetailScreen extends StatelessWidget {
  final  AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> userSnapshot;
  final bool isFollowers;
  const FollowerFollowingDetailScreen({required this.userSnapshot, this.isFollowers =false, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: isFollowers ? 0 : 1,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: Text(userSnapshot.data!['username']),
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                child: Text("${userSnapshot.data!['followers'].length.toString()} Followers"),
              ),
              Tab(
                child: Text("${userSnapshot.data!['following'].length.toString()} Following"),
              ),
            ],
          ),
        ),
        body: TabBarView(children: [
          FollwersDetailsWidget(follwersList: userSnapshot.data!['followers'] ),
          FollowingDetailsWidget(followingsList: userSnapshot.data!['following'],),
        ]),
      ),
    );
  }
}
