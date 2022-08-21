import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widget/expandable_text_widget.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../models/user.dart' as user_model;
import '../widget/comment_card_widget.dart';

class CommentScreen extends StatefulWidget {
  static const routeName = '/comments';
  const CommentScreen({Key? key}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController _textEditingController = TextEditingController();
  var scrollController = ScrollController();
  final List<String> _emojiList = ["❤️", "🙌", "🔥", "👏", "🥲", "😍", "😮", "😂"];
  var _firebase = FirebaseFirestore.instance;

  insertEmoji(String emoji) {
    var currentText = _textEditingController.text;
    var selection = _textEditingController.selection;
    var newText = currentText.replaceRange(selection.start, selection.end, emoji);
    _textEditingController.value =
        TextEditingValue(text: newText, selection: TextSelection.collapsed(offset: selection.baseOffset + emoji.length));
  }

  postComment({required String username, required String uid, required String comment, required String postId}) async {
    final String? result = await FirestoreMethods().uploadComment(username: username, uid: uid, comment: comment, postId: postId);
    _textEditingController.clear();
    if (result != null) {
      Utils().showSnackbar(result, context);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _textEditingController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _textEditingController.text = "";
    final String postId = ModalRoute.of(context)!.settings.arguments as String;
    final user_model.User _user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
        backgroundColor: mobileBackgroundColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Description and Comment Section
            Expanded(
              // First load the post information
              child: FutureBuilder(
                  future: _firebase.collection('posts').doc(postId).get(),
                  builder: (_, postSnapshot) {
                    if (postSnapshot.connectionState == ConnectionState.done) {
                      // Load the comments and if changes occur rebuild the app to react to it.
                      return StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('posts').doc(postId).collection('comments').snapshots(),
                        builder: (ctx, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> commentSnapshot) {
                          if (commentSnapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return GestureDetector(
                            onTap: () {
                              if (FocusManager.instance.primaryFocus != null) {
                                FocusManager.instance.primaryFocus!.unfocus();
                              }
                            },
                            child: SingleChildScrollView(
                              controller: scrollController,
                              child: Column(
                                children: [
                                  // Description
                                  CommentCardWidget(
                                    snapshot: postSnapshot.data,
                                    isDescription: true,
                                  ),
                                  // Comments
                                  ListView.builder(
                                    controller: scrollController,
                                    shrinkWrap: true,
                                    itemCount: commentSnapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      return CommentCardWidget(
                                        snapshot: commentSnapshot.data!.docs[index],
                                        postId: postId,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
            ),

            // User type section
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(border: Border(top: BorderSide(width: 0.3, color: Colors.grey))),
              child: Column(
                children: [
                  // Emoji section
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: _emojiList.map((emoji) {
                        return InkWell(
                            onTap: () {
                              insertEmoji(emoji);
                            },
                            child: Text(
                              emoji,
                              style: TextStyle(fontSize: 20),
                            ));
                      }).toList(),
                    ),
                  ),

                  // User comment textfield section
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: CircleAvatar(
                            child: Container(),
                            radius: 25,
                            backgroundColor: Colors.red,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.grey, width: 1), borderRadius: BorderRadius.circular(20))),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                    child: TextField(
                                  controller: _textEditingController,
                                  minLines: 1,
                                  maxLines: 5,
                                  decoration: InputDecoration(border: UnderlineInputBorder(borderSide: BorderSide.none)),
                                )),
                                TextButton(
                                  onPressed: () {
                                    postComment(
                                        username: _user.username,
                                        uid: _user.uid,
                                        comment: _textEditingController.text,
                                        postId: postId);
                                  },
                                  child: Text("Post"),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
