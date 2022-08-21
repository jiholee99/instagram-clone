import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widget/post_card_widget.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: SvgPicture.asset(
          'assets/ic_instagram.svg',
          color: primaryColor,
          fit: BoxFit.contain,
          height: 30,
        ),
        leading: IconButton(
          icon: Icon(Icons.camera_alt_rounded),
          onPressed: () {},
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.send_sharp))],
      ),
      body: Container(
        padding: const EdgeInsets.all(5),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('posts').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
      
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return PostCardWidget(snapshot: snapshot.data!.docs[index]);
              },
            );
          },
        ),
      ),
    );
  }
}
