import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/screens/add_post_screen.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

import '../providers/user_picked_image_provider.dart';

import '../widget/album_list_pop_up_screen_widget.dart';

class UserGalleryWidget extends StatefulWidget {
  final List<AssetPathEntity> albumList;
  UserGalleryWidget({required this.albumList, Key? key}) : super(key: key);

  @override
  State<UserGalleryWidget> createState() => _UserGalleryWidgetState();
}

class _UserGalleryWidgetState extends State<UserGalleryWidget> {
  int currentAlbumIndex = 0;

  Future<void> updateRecentPicture(BuildContext context, int index) async {
    List<AssetEntity> imageList =
        await widget.albumList[index].getAssetListRange(start: 0, end: 2);
    Uint8List? image = await imageList[0].originBytes;
    Provider.of<UserPickedProvider>(context, listen: false).setImage(image!);
    setState(() {
      currentAlbumIndex = index;
    });
  }

  Future<List<AssetEntity>> loadCurrentAlbum() async {
    List<AssetEntity> currentAlbum = await widget.albumList[currentAlbumIndex]
        .getAssetListRange(
            start: 0, end: widget.albumList[currentAlbumIndex].assetCount);
    return currentAlbum;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Album chooisng section : choose album, select multiple, choose from camera
        Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 3),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            // Button to choose album

            InkWell(
              onTap: () async {
                // Moves to a page where user selects an album and returns a index
                var index = await Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => AlbumListPopUpScreenWidget(
                        albumList: widget.albumList)));
                // If the user did not cancel choosing album
                if (index != null) {
                  await updateRecentPicture(context, index);
                }
              },
              child: Ink(
                  child: Row(
                children: [
                  Text(
                    widget.albumList[currentAlbumIndex].name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.arrow_drop_down)
                ],
              )),
            ),

            // Selecting multiple pictures & from camera
            Row(
              children: [
                // Button for selecting multiple pictures or not
                InkWell(
                  onTap: () {},
                  child: Ink(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: ShapeDecoration(
                          color: Colors.grey[900],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                      child: Text("Select Multiple")),
                ),
                // Button for choose photo from camera
                InkWell(
                  onTap: () async {
                    Uint8List? cameraImage = await Utils().pickImage(ImageSource.camera);
                    if (cameraImage != null) {
                      Provider.of<UserPickedProvider>(context, listen: false).setImage(cameraImage);
                    }
                  },
                  child: Ink(
                      padding: EdgeInsets.all(5),
                      decoration: ShapeDecoration(
                        color: Colors.grey[900],
                        shape: CircleBorder(),
                      ),
                      child: Icon(
                        Icons.camera_alt_outlined,
                        size: 20,
                      )),
                )
              ],
            )
          ]),
        ),
        // Pictures from album
        Expanded(
          child: FutureBuilder(
              future: loadCurrentAlbum(),
              builder: (ctx, AsyncSnapshot<List<AssetEntity>> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return FutureBuilder(
                              future: snapshot.data![index].originBytes,
                              builder: (_, AsyncSnapshot<Uint8List?> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return InkWell(
                                      onTap: () {
                                        Provider.of<UserPickedProvider>(context,
                                                listen: false)
                                            .setImage(snapshot.data!);
                                      },
                                      child: Image.memory(
                                        snapshot.data!,
                                        fit: BoxFit.cover,
                                      ));
                                }
                                return Text("Error occured");
                              });
                        });
                  }
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
        )
      ],
    );
  }
}
