import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';


class AlbumListPopUpScreenWidget extends StatelessWidget {
  final List<AssetPathEntity> albumList;
  late Uint8List recentImage;
  AlbumListPopUpScreenWidget({required this.albumList, Key? key}) : super(key: key);

  Future<Uint8List?> getRecentPicture(int index) async {
    List<AssetEntity> imageList =
        await albumList[index].getAssetListRange(start: 0, end: 2);
    Uint8List? image = await imageList[0].originBytes;
    return image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(5),
          child: ListView.builder(
              itemCount: albumList.length,
              itemBuilder: ((context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(index);
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        // Album's most recent image
                        Flexible(
                            flex: 3,
                            child: FutureBuilder(
                              future: getRecentPicture(index),
                              builder: (context,
                                  AsyncSnapshot<Uint8List?> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  recentImage = snapshot.data!;
                                  return Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: MemoryImage(snapshot.data!),
                                            fit: BoxFit.cover)),
                                  );
                                }
                                return Container();
                              },
                            )),
                        // Album's name and number of pictures
                        Flexible(
                          flex: 7,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  albumList[index].name,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(albumList[index].assetCount.toString())
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              })),
        ),
      ),
    );
  }
}