import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:practice/Screens/discoverp2.dart';
import 'package:practice/color.dart';

class PostSearch extends StatefulWidget {
  const PostSearch({super.key});

  @override
  State<PostSearch> createState() => _PostSearchState();
}

class _PostSearchState extends State<PostSearch> {
  final TextEditingController searchPosts = TextEditingController();
  bool showPosts = false;

  @override
  void dispose() {
    super.dispose();
    searchPosts.dispose();
  }

  Future<Object?> getPostDataByPostUrl(String postUrl) async {
    // Query the Firestore collection to get the document containing the postUrl
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .where('postUrl', isEqualTo: postUrl)
        .limit(1)
        .get();

    // Check if a document with the postUrl exists
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.data();
    } else {
      return null; // Document with postUrl not found
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF213037),
        iconTheme: IconThemeData(color: Palette.postcolor),
        title: Container(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.035,
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Search Posts',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Color(0xFF2B414A),
                labelStyle: TextStyle(
                  color: Palette.postcolor,
                  fontFamily: 'Ale',
                ),
              ),
              style: TextStyle(color: Palette.postcolor),
              onFieldSubmitted: (String _) {
                setState(() {
                  showPosts = true;
                });
              },
              controller: searchPosts,
            ),
          ),
        ),
      ),
      body: showPosts
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('posts')
                  .where('caption', isEqualTo: searchPosts.text)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return StaggeredGridView.countBuilder(
                  crossAxisCount: 2,
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) => Container(
                    padding: EdgeInsets.all(5.0),
                    child: GestureDetector(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Post1(
                                snap: (snapshot.data! as dynamic)
                                    .docs[index]
                                    .data(),
                              ),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            (snapshot.data! as dynamic).docs[index]['postUrl'],
                          ),
                        ),
                      ),
                    ),
                  ),
                  staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
                );
              },
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance.collection('posts').get(),
              builder: ((context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                return StaggeredGridView.countBuilder(
                    crossAxisCount: 2,
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) => Container(
                          padding: EdgeInsets.all(5.0),
                          child: GestureDetector(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Post1(
                                        snap: (snapshot.data! as dynamic)
                                            .docs[index]
                                            .data()),
                                  ),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network((snapshot.data! as dynamic)
                                    .docs[index]['postUrl']),
                              ),
                            ),
                          ),
                        ),
                    staggeredTileBuilder: (index) =>
                        const StaggeredTile.fit(1));
              }),
            ),
    );
  }
}