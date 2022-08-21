import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/widget/expandable_text_widget.dart';
import 'package:instagram_clone/widget/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/user.dart' as user_model;
import '../providers/user_provider.dart';
import '../utils/colors.dart';
import '../utils/global_variable.dart';
import '../utils/utils.dart';

class CommentCardWidget extends StatefulWidget {
  final bool isDescription;
  final snapshot;
  final String? postId;
  const CommentCardWidget({this.isDescription = false, required this.snapshot, this.postId, Key? key}) : super(key: key);

  @override
  State<CommentCardWidget> createState() => _CommentCardWidgetState();
}

class _CommentCardWidgetState extends State<CommentCardWidget> {
  @override
  Widget build(BuildContext context) {
    final user_model.User _user = Provider.of<UserProvider>(context).getUser;
    DateTime datePublished = (widget.snapshot['datePublished'] as Timestamp).toDate();
    var formattedDate = Utils().calculateDate(datePublished);
    return Container(
        decoration:
            widget.isDescription ? const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey, width: 0.3))) : null,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //UserProfile Image
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/default_profile_pic.png'),
                child: Container(),
              ),
            ),
            // Main comment information section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Username and comment
                  // if it's description load description
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(text: widget.snapshot['username'] + " ", style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: widget.isDescription ? widget.snapshot['description'] : widget.snapshot['comment'])
                  ])),
                  //date, likes, reply, send
                  // if it's description load only post date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: widget.isDescription
                        ? [
                            Text(
                              formattedDate,
                              style: commentFunctionStyle,
                            )
                          ]
                        : [
                            Text(
                              formattedDate,
                              style: commentFunctionStyle,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              widget.snapshot['likes'].length.toString() + " likes",
                              style: commentFunctionStyle,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Reply",
                              style: commentFunctionStyle,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Send",
                              style: commentFunctionStyle,
                            ),
                          ],
                  )
                ],
              ),
            ),
            // like button
            // only load it when it is not description that is if it is comment
            if (widget.isDescription == false)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: LikeAnimation(
                  isAnimating: widget.snapshot['likes'].contains(_user.uid),
                  smallLike: true,
                  child: IconButton(
                    onPressed: () {
                      FirestoreMethods().likePostOrComment(widget.postId!, _user.uid, widget.snapshot['likes'],
                          isComment: true, commentId: widget.snapshot['commentId']);
                    },
                    icon: widget.snapshot['likes'].contains(_user.uid)
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : const Icon(
                            Icons.favorite_border,
                            color: Colors.grey,
                          ),
                  ),
                ),
              ),
          ],
        ));
  }
}
