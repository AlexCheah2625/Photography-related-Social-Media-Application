import 'package:flutter/material.dart';
import 'package:practice/Screens/apreture_search.dart';
import 'package:practice/Screens/discoverp2.dart';
import 'package:practice/Screens/location_search.dart';
import 'package:practice/Screens/search_posts.dart';
import 'package:practice/Screens/shuttle_speed_search.dart';
import 'package:practice/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ISO_Search extends StatefulWidget {
  const ISO_Search({super.key});

  @override
  State<ISO_Search> createState() => _ISO_SearchState();
}

class _ISO_SearchState extends State<ISO_Search> {
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
    return  Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF213037),
          iconTheme: IconThemeData(color: Palette.postcolor),
          title: Container(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.035,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Search ISO',
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
        body:  showPosts
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('posts')
                    .where('iso', isEqualTo: searchPosts.text)
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
                              (snapshot.data! as dynamic).docs[index]
                                  ['postUrl'],
                            ),
                          ),
                        ),
                      ),
                    ),
                    staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
                  );
                },
              )
            :Container(
          child: Column(
            children: [
              Expanded(
                flex: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Aperture_Search()),
                        );
                      },
                      style: ButtonStyle(
                        fixedSize:
                            MaterialStateProperty.all<Size>(Size(100.0, 20.0)),
                        backgroundColor:
                            MaterialStateProperty.all(Palette.postcolor),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            side: BorderSide(color: Colors.white10))),
                      ),
                      child: Text("Aperture",
                          style: TextStyle(
                              fontFamily: 'Ale',
                              fontSize: 12,
                              color: Palette.thirdcolor)),
                    )),
                    Container(
                        child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PostSearch()),
                        );
                      },
                      style: ButtonStyle(
                        fixedSize:
                            MaterialStateProperty.all<Size>(Size(90.0, 10.0)),
                        backgroundColor:
                            MaterialStateProperty.all(Palette.postcolor),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            side: BorderSide(color: Colors.white10))),
                      ),
                      child: Text("Caption",
                          style: TextStyle(
                              fontFamily: 'Ale',
                              fontSize: 12,
                              color: Palette.thirdcolor)),
                    )),
                    Container(
                        child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Location_Search()),
                        );
                      },
                      style: ButtonStyle(
                        fixedSize:
                            MaterialStateProperty.all<Size>(Size(95.0, 10.0)),
                        backgroundColor:
                            MaterialStateProperty.all(Palette.postcolor),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            side: BorderSide(color: Colors.white10))),
                      ),
                      child: Text("Location",
                          style: TextStyle(
                              fontFamily: 'Ale',
                              fontSize: 12,
                              color: Palette.thirdcolor)),
                    )),
                    Container(
                        child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Shuttle_Search()),
                        );
                      },
                      style: ButtonStyle(
                        fixedSize:
                            MaterialStateProperty.all<Size>(Size(90.0, 10.0)),
                        backgroundColor:
                            MaterialStateProperty.all(Palette.postcolor),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            side: BorderSide(color: Colors.white10))),
                      ),
                      child: Text("Shuttle Speed",
                          style: TextStyle(
                              fontFamily: 'Ale',
                              fontSize: 12,
                              color: Palette.thirdcolor)),
                    )),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: FutureBuilder(
                  future:
                          FirebaseFirestore.instance.collection('posts').get(),
                      builder: ((context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
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
                                                snap:
                                                    (snapshot.data! as dynamic)
                                                        .docs[index]
                                                        .data()),
                                          ),
                                        );
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                            (snapshot.data! as dynamic)
                                                .docs[index]['postUrl']),
                                      ),
                                    ),
                                  ),
                                ),
                            staggeredTileBuilder: (index) =>
                                const StaggeredTile.fit(1));
                      }),
                    ),
                  )
            ],
          ),
        ));
  }
}