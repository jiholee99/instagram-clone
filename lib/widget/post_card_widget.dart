import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/comment_screen.dart';
import 'package:instagram_clone/utils/global_variable.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widget/expandable_text_widget.dart';
import 'package:instagram_clone/widget/like_animation.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../utils/colors.dart';

import '../models/user.dart' as user_model;

class PostCardWidget extends StatefulWidget {
  final snapshot;
  const PostCardWidget({required this.snapshot, Key? key}) : super(key: key);

  @override
  State<PostCardWidget> createState() => _PostCardWidgetState();
}

class _PostCardWidgetState extends State<PostCardWidget> {
  var isLikeAnimating = false;
  @override
  Widget build(BuildContext context) {
    final user_model.User _user = Provider.of<UserProvider>(context).getUser;
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      color: mobileBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top of the post card : Profile pic; username; follow; options
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.snapshot['profileImageUrl']),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(widget.snapshot['username']),
                TextButton(onPressed: () {}, child: Text("follow")),
                Expanded(
                    child:
                        Align(alignment: Alignment.centerRight, child: IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))))
              ],
            ),
          ),
          // Body : Image section
          GestureDetector(
            onDoubleTap: () async {
              await FirestoreMethods()
                  .likePostOrComment(widget.snapshot['postId'].toString(), _user.uid, widget.snapshot['likes']);
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Image of the post
                Container(
                  height: MediaQuery.of(context).size.height * 0.45,
                  child: Image.network(
                    widget.snapshot['postUrl'],
                    fit: BoxFit.cover,
                  ),
                ),
                // Heart animation when user double taps the image
                // -> user double tab -> setState is called and rebuilds LikeAnimation and Animated Opacity
                // -> After LikeAnimation is done SetState is called and both widgets change again
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    duration: const Duration(milliseconds: 400),
                    onEndCallBack: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 100,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Like section: like;comment;message; bookmark
          Row(
            mainAxisAlignment: MainAxisAlignment.start, 
            children: [
            Flexible(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Like Button
                  LikeAnimation(
                    isAnimating: widget.snapshot['likes'].contains(_user.uid),
                    smallLike: true,
                    child: InkWell(
                        onTap: () async {
                          await FirestoreMethods()
                              .likePostOrComment(widget.snapshot['postId'].toString(), _user.uid, widget.snapshot['likes']);
                        },
                        child: widget.snapshot['likes'].contains(_user.uid)
                            ? const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : const Icon(
                                Icons.favorite_border,
                                color: Colors.red,
                              )),
                  ),
                  // Comment Button
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(CommentScreen.routeName, arguments: widget.snapshot['postId']);
                    },
                    child: Icon(Icons.chat_bubble),
                  ),
                  // Message Button
                  InkWell(onTap: () {}, child: Icon(Icons.send_sharp)),
                ],
              ),
            ),

            // Bookmark Button
            Flexible(
              flex: 7,
                child: Align(alignment: Alignment.centerRight, child: IconButton(onPressed: () {}, icon: Icon(Icons.bookmark)))),
          ]),
          // Description section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Number of Likes
              DefaultTextStyle(
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(fontWeight: FontWeight.w800),
                  child: Text("${widget.snapshot['likes'].length} likes")),
              // Description
              ExpandableTextWidget(
                username: widget.snapshot['username'],
                description: widget.snapshot['description'],
              )
            ],
          ),
          // Comment section
          InkWell(
            onTap: () {},
            child: Ink(
              child: FutureBuilder(
                  future:
                      FirebaseFirestore.instance.collection('posts').doc(widget.snapshot['postId']).collection('comments').get(),
                  builder: (_, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.data!.size > 0) {
                        return Text(
                          "View ${snapshot.data!.size} comments",
                          style: commentFunctionStyle,
                        );
                      }
                    }
                    return Text(
                          "View comments",
                          style: commentFunctionStyle,
                        );
                  }),
            ),
          ),
          // Date section
          Text(
            Utils().calculateDate(widget.snapshot['datePublished'].toDate(), isFullLength: true),
            style: commentFunctionStyle,
          )
        ],
      ),
    );
  }
}
