import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

import '../providers/user_picked_image_provider.dart';

import '../widget/picked_image_widget.dart';
import '../widget/user_gallery_widget.dart';
import 'add_post_screen.dart';

class PostPhotoSelectionScreen extends StatefulWidget {
  const PostPhotoSelectionScreen({Key? key}) : super(key: key);

  @override
  State<PostPhotoSelectionScreen> createState() => _PostPhotoSelectionScreenState();
}

class _PostPhotoSelectionScreenState extends State<PostPhotoSelectionScreen> {
  Uint8List? _recentImage;

  Future<List<AssetPathEntity>> loadUserAlbums() async {
    final PermissionState _ps = await PhotoManager.requestPermissionExtend();
    if (_ps.isAuth) {
      // Granted.
      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList();

      //Setting the default image
      var recentAlbum = await albums[0].getAssetListRange(start: 0, end: 1);
      var recentImage = await recentAlbum[0].originBytes;
      _recentImage = recentImage;

      return albums;
    } else {
      // Limited(iOS) or Rejected, use `==` for more precise judgements.
      // You can call `PhotoManager.openSetting()` to open settings for further steps.
    }
    return Future.delayed(Duration(seconds: 0));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loadUserAlbums(),
        builder: (_, AsyncSnapshot<List<AssetPathEntity>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: mobileBackgroundColor,
                  leading: IconButton(onPressed: () {}, icon: Icon(Icons.cancel_outlined)),
                  title: Text("Select photos"),
                  actions: [
                    // Go to post editing page where there is captions text field
                    TextButton(
                        // get the image from the provider and pass it to AddpostScreen
                        onPressed: () async {
                          final image = await Provider.of<UserPickedProvider>(context, listen: false).image;
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                            return AddPostScreen(postImageFile: image == null ? _recentImage : image);
                          }));
                        },
                        child: Text("Next"))
                  ],
                ),
                body: SafeArea(
                    child: Container(
                  height: MediaQuery.of(context).size.height - MediaQuery.of(context).viewPadding.vertical,
                  child: Column(
                    children: [
                      // part where user picked the image.
                      PickedImageWidget(
                        firstImage: _recentImage,
                      ),
                      // shows user's gallery
                      Expanded(
                        child: UserGalleryWidget(
                          albumList: snapshot.data!,
                        ),
                      ),
                    ],
                  ),
                )),
              );
            }
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
