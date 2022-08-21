import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/picture_detail_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:dotted_border/dotted_border.dart';

import '../resources/storage_methods.dart';

import '../utils/utils.dart';

import '../models/user.dart';

import '../providers/user_provider.dart';

class AddPostScreen extends StatefulWidget {
  Uint8List? postImageFile;
  AddPostScreen({required this.postImageFile, Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _descriptionTextEditingController = TextEditingController();
  var _isPosting = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _descriptionTextEditingController.dispose();
  }

  // Store post information in the firebase
  Future<void> storePost(String username, String description, String uid, Uint8List file, String profileImageUrl) async {
    // if the post picture is chosen by user, that is if it is not null
    if (widget.postImageFile != null) {
      try {
        setState(() {
          _isPosting = true;
        });
        final String snackbarMessage =
            await FirestoreMethods().storePostInCloudAndDatabase(username, description, uid, file, profileImageUrl);
        Utils().showSnackbar(snackbarMessage == "Success" ? "Successfully posted" : snackbarMessage, context);
        setState(() {
          clearPostPictureFile();
          _isPosting = false;
        });
      } catch (error) {
        setState(() {
          _isPosting = false;
        });
        Utils().showSnackbar(error.toString(), context);
      }
    }
  }

  void clearPostPictureFile() {
    setState(() {
      _descriptionTextEditingController.clear();
      widget.postImageFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User _user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text("Post to"),
        centerTitle: false,
        actions: [
          // Post button
          TextButton(
              onPressed: () {
                storePost(
                    _user.username, _descriptionTextEditingController.text, _user.uid, widget.postImageFile!, _user.photoUrl);
              },
              child: const Text(
                "Post",
                style: TextStyle(color: Colors.blueAccent),
              ))
        ],
      ),
      body: Column(children: [
        // Progress indicator when uploading
        _isPosting
            ? const LinearProgressIndicator()
            : Container(
                padding: const EdgeInsets.all(0),
              ),
        const Divider(),
        Container(
          color: mobileBackgroundColor,
          height: MediaQuery.of(context).size.height * 0.15,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image file that user is uploading
              Flexible(
                flex: 3,
                child: GestureDetector(
                  onTap: () {
                    if (widget.postImageFile != null) {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (ctx) => PictureDetailScreen(picture: widget.postImageFile!)));
                    } else {}
                  },
                  child: Container(
                    padding: const EdgeInsets.all(3.0),
                    child: widget.postImageFile == null
                        ? DottedBorder(
                            color: primaryColor,
                            child: Text("No image selected"),
                          )
                        : Hero(
                            tag: 'picture',
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                fit: BoxFit.cover,
                                alignment: FractionalOffset.topCenter,
                                image: MemoryImage(widget.postImageFile!),
                              )),
                            ),
                          ),
                  ),
                ),
              ),
              // TextField for captions
              Flexible(
                flex: 7,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: TextField(
                    controller: _descriptionTextEditingController,
                    maxLines: 8,
                    decoration: const InputDecoration(hintText: "Write a caption...", border: InputBorder.none),
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: secondaryColor,
        ),
        Text("Tag people"),
        Divider(),
        Text("Tag people"),
        Divider(),
        Text("Tag people"),
        Divider(),
        Text("Tag people"),
        Divider(),
        Text("Tag people"),
      ]),
    );
  }
}
