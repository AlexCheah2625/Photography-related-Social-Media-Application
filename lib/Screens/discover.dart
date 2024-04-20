import 'package:flutter/material.dart';
import 'package:practice/Screens/profile.dart';
import 'package:practice/Screens/search_posts.dart';
import 'package:practice/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:practice/Widgets/feed_post.dart';
import 'package:practice/Screens/discoverp2.dart';
import 'package:practice/resources/features.dart';
import 'package:practice/Screens/landscape.dart';
import 'package:practice/Screens/street.dart';
import 'package:practice/Screens/potrait.dart';
import 'package:practice/Screens/sport.dart';

class Discover extends StatefulWidget {
  const Discover({super.key});

  @override
  State<Discover> createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  final TextEditingController searchUser = TextEditingController();
  bool showUser = false;

  @override
  void dispose() {
    super.dispose();
    searchUser.dispose();
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
          title: Container(
            child: Row(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.035,
                  width: MediaQuery.of(context).size.width * 0.785,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Search Users',
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
                        showUser = true;
                      });
                    },
                    controller: searchUser,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.005,
                  height: MediaQuery.of(context).size.height * 0.085,
                ),
                IconButton(
                  color: Palette.postcolor,
                  icon: Icon(Icons.image_search_sharp),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => PostSearch()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        body: showUser
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where('username', isGreaterThanOrEqualTo: searchUser.text)
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                              uid: (snapshot.data! as dynamic).docs[index]
                                  ['uid'],
                            ),
                          ),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              (snapshot.data! as dynamic).docs[index]
                                  ['profilepic'],
                            ),
                            radius: 16,
                          ),
                          title: Text(
                              (snapshot.data! as dynamic).docs[index]
                                  ['username'],
                              style: TextStyle(
                                  fontFamily: 'Ale',
                                  fontSize: 18,
                                  color: Palette.postcolor)),
                        ),
                      );
                    },
                  );
                },
              )
            : Container(
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
                                    builder: (context) => const landscape()),
                              );
                            },
                            style: ButtonStyle(
                              fixedSize: MaterialStateProperty.all<Size>(
                                  Size(106.0, 20.0)),
                              backgroundColor:
                                  MaterialStateProperty.all(Palette.postcolor),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      side: BorderSide(color: Colors.white10))),
                            ),
                            child: Text("Landscape",
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
                                    builder: (context) => const street()),
                              );
                            },
                            style: ButtonStyle(
                              fixedSize: MaterialStateProperty.all<Size>(
                                  Size(87.0, 10.0)),
                              backgroundColor:
                                  MaterialStateProperty.all(Palette.postcolor),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      side: BorderSide(color: Colors.white10))),
                            ),
                            child: Text("Street",
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
                                    builder: (context) => const potrait()),
                              );
                            },
                            style: ButtonStyle(
                              fixedSize: MaterialStateProperty.all<Size>(
                                  Size(90.0, 10.0)),
                              backgroundColor:
                                  MaterialStateProperty.all(Palette.postcolor),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      side: BorderSide(color: Colors.white10))),
                            ),
                            child: Text("Potrait",
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
                                    builder: (context) => const sport()),
                              );
                            },
                            style: ButtonStyle(
                              fixedSize: MaterialStateProperty.all<Size>(
                                  Size(87.0, 10.0)),
                              backgroundColor:
                                  MaterialStateProperty.all(Palette.postcolor),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      side: BorderSide(color: Colors.white10))),
                            ),
                            child: Text("Sport",
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
                        future: FirebaseFirestore.instance
                            .collection('posts')
                            .orderBy('date', descending: true)
                            .get(),
                        builder: ((context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          return StaggeredGridView.countBuilder(
                              crossAxisCount: 2,
                              itemCount:
                                  (snapshot.data! as dynamic).docs.length,
                              itemBuilder: (context, index) => Container(
                                    padding: EdgeInsets.all(5.0),
                                    child: GestureDetector(
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Post1(
                                                  snap: (snapshot.data!
                                                          as dynamic)
                                                      .docs[index]
                                                      .data()),
                                            ),
                                          );
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
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
