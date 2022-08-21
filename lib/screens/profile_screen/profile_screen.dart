import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widget/expandable_text_widget.dart';
import 'package:instagram_clone/screens/profile_screen/follower_following_detail_screen.dart';
import 'package:instagram_clone/widget/post_card_widget.dart';
import 'package:instagram_clone/widget/post_grid_view_widget.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart' as user_model;

import '../../providers/user_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  showAuthOptions() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.horizontal(
          left: Radius.circular(30),
          right: Radius.circular(30),
        )),
        context: context,
        builder: (_) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      child: Ink(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.all(Radius.circular(10))),
                        child: Center(child: Text("Future button")),
                      ),
                    ),
                    InkWell(
                      child: Ink(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.all(Radius.circular(10))),
                        child: Center(child: Text("Future button")),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.of(context).pop();
                      },
                      child: Ink(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.all(Radius.circular(10))),
                        child: Center(child: Text("Log out")),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final user_model.User _user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
            future: FirebaseFirestore.instance.collection('users').doc(_user.uid).get(),
            builder: (ctx, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.done) {
                return StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('posts').where('uid', isEqualTo: _user.uid).snapshots(),
                    builder: (_, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> userPostSnapshot) {
                      if (userPostSnapshot.connectionState == ConnectionState.active) {
                        return Container(
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        _user.username,
                                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    IconButton(onPressed: () {}, icon: Icon(Icons.add)),
                                    IconButton(
                                        onPressed: () {
                                          showAuthOptions();
                                        },
                                        icon: Icon(Icons.more_horiz_rounded)),
                                  ],
                                ),
                                //Profile Image & number of post & followers and following section
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Profile picture
                                    Flexible(
                                      flex: 3,
                                      child: Container(
                                        //color: Colors.amber,
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(_user.photoUrl),
                                          radius: 40,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 7,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          // Number of posts
                                          Column(
                                            children: [Text(userPostSnapshot.data!.docs.length.toString()), Text("Posts")],
                                          ),
                                          // Number of followers
                                          GestureDetector(
                                            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                                              builder: (_) =>
                                                  FollowerFollowingDetailScreen(userSnapshot: userSnapshot, isFollowers: true),
                                            )),
                                            child: Column(
                                              children: [
                                                Text(userSnapshot.data!['followers'].length.toString()),
                                                Text("Followers")
                                              ],
                                            ),
                                          ),
                                          // Number of follwings
                                          GestureDetector(
                                            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                                              builder: (_) => FollowerFollowingDetailScreen(userSnapshot: userSnapshot),
                                            )),
                                            child: Column(
                                              children: [
                                                Text(userSnapshot.data!['following'].length.toString()),
                                                Text("Following")
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                // User description
                                Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _user.username,
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          _user.userBio,
                                        ),
                                      ],
                                    )),
                                //Edit profile button
                                Container(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.grey)),
                                      onPressed: () {},
                                      child: Text("Edit profile"),
                                    )),
                                // User posts
                                Expanded(
                                  child: PostGridViewWidget(userPostSnapshot: userPostSnapshot),
                                )
                              ],
                            ));
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    });
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }
}
