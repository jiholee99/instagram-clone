import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';

class FollwersDetailsWidget extends StatefulWidget {
  final List follwersList;
  FollwersDetailsWidget({required this.follwersList, Key? key}) : super(key: key);

  @override
  State<FollwersDetailsWidget> createState() => _FollwersDetailsWidgetState();
}

class _FollwersDetailsWidgetState extends State<FollwersDetailsWidget> {
  final searchController = TextEditingController();

  final scrollController = ScrollController();

  String searchText = "";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search textfield
            Container(
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.search,
                    size: 20,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchText = value;
                        });
                      },
                      controller: searchController,
                      decoration: InputDecoration(border: UnderlineInputBorder(borderSide: BorderSide.none), hintText: "Search"),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "All followers",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            if (widget.follwersList.isNotEmpty) FutureBuilder(
                future: searchText.isEmpty
                    ? FirebaseFirestore.instance.collection('users').where('uid', whereIn: widget.follwersList).get()
                    : FirebaseFirestore.instance
                        .collection('users')
                        .where('uid', whereIn: widget.follwersList)
                        .where('username', isEqualTo: searchText)
                        .get(),
                builder: (_, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                        controller: scrollController,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.size,
                        itemBuilder: (_, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(snapshot.data!.docs[index]['profileUrl']),
                                  radius: 30,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Text(snapshot.data!.docs[index]['username']),
                                      TextButton(onPressed: () async{
                                        await FirestoreMethods().followUser(snapshot.data!.docs[index]['uid']);
                                        setState(() {
                                          
                                        });
                                      }, child: Text("Follow"))
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    
                                  },
                                  child: Ink(
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.grey[800]),
                                    child: Center(
                                        child: Text(
                                      "Remove",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    )),
                                  ),
                                )
                              ],
                            ),
                          );
                        });
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                })
          ],
        ),
      ),
    );
  }
}
