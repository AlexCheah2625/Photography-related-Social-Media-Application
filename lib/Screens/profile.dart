import 'package:flutter/material.dart';
import 'package:practice/Login%20and%20Signup/login.dart';
import 'package:practice/Screens/chatting_page.dart';
import 'package:practice/Screens/discoverp2.dart';
import 'package:practice/Screens/edit_profile.dart';
import 'package:practice/Screens/follower_user.dart';
import 'package:practice/Screens/following_user.dart';
import 'package:practice/Widgets/follow_button.dart';
import 'package:practice/color.dart';
import 'package:practice/resources/auth.dart';
import 'package:practice/resources/features.dart';
import 'package:practice/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userdata = {};
  int postlen = 0;
  int follower = 0;
  int following = 0;
  bool isExpanded = false;
  bool isFollowing = false;
  bool loading = false;

  void toggleExpanded() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  //get user data
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      loading = true;
    });
    try {
      var usersnap = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.uid)
          .get();
      userdata = usersnap.data()!;

      var postsnap = await FirebaseFirestore.instance
          .collection("posts")
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      postlen = postsnap.docs.length;
      follower = usersnap.data()!['follower'].length;
      following = usersnap.data()!['following'].length;
      isFollowing = usersnap
          .data()!['follower']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Palette.thirdcolor),
              backgroundColor: Palette.postcolor,
              title: Text(
                userdata['username'],
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 40,
                    fontFamily: 'Ale',
                    fontWeight: FontWeight.w600),
              ),
            ),
            body: ListView(children: [
              Column(
                children: [
                  //profile pic
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                              top: 20, left: 50, right: 50, bottom: 20),
                          child: Center(
                            child: CircleAvatar(
                                backgroundColor: Palette.postcolor,
                                child: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(userdata['profilepic']),
                                    radius: 97),
                                radius: 100),
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [
                              //Username
                              Text(
                                userdata['username'],
                                style: TextStyle(
                                    color: Palette.postcolor,
                                    fontFamily: "Ale",
                                    fontSize: 26,
                                    fontWeight: FontWeight.w600),
                              ),
                              //bio
                              Container(
                                width: 350,
                                margin: EdgeInsets.only(top: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    ExpandableText(
                                      userdata['bio'],
                                      style: TextStyle(
                                          color: Palette.postcolor,
                                          fontFamily: "Ale",
                                          fontSize: 16),
                                      expandText: 'show more',
                                      collapseText: 'show less',
                                      linkColor: Palette.postcolor,
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              ),
                              //Post Follower Following
                              Container(
                                padding: EdgeInsets.only(
                                    top: 10, left: 15, right: 15, bottom: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          child: Text(
                                            "Posts",
                                            style: TextStyle(
                                                color: Palette.postcolor,
                                                fontFamily: "Ale",
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            "$postlen",
                                            style: TextStyle(
                                                color: Palette.postcolor,
                                                fontFamily: "Ale",
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  FollowerScreen(
                                                uid: userdata['uid'],
                                              ),
                                            ));
                                          },
                                          child: Container(
                                            child: Text(
                                              "Follower",
                                              style: TextStyle(
                                                  color: Palette.postcolor,
                                                  fontFamily: "Ale",
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            "$follower",
                                            style: TextStyle(
                                                color: Palette.postcolor,
                                                fontFamily: "Ale",
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  FollowingScreen(
                                                uid: userdata['uid'],
                                              ),
                                            ));
                                          },
                                          child: Container(
                                            child: Text(
                                              "Following",
                                              style: TextStyle(
                                                  color: Palette.postcolor,
                                                  fontFamily: "Ale",
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            "$following",
                                            style: TextStyle(
                                                color: Palette.postcolor,
                                                fontFamily: "Ale",
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              //Buttons
                              Container(
                                margin: EdgeInsets.all(5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FirebaseAuth.instance.currentUser!.uid ==
                                            widget.uid
                                        ? FollowButton(
                                            backgroundColor:
                                                Palette.secondcolor,
                                            borderColor: Palette.postcolor,
                                            text: "Edit Profile",
                                            textColor: Palette.postcolor,
                                            function: () async {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditProfile(
                                                            uid: FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid,
                                                          )));
                                            },
                                          )
                                        : isFollowing
                                            ? FollowButton(
                                                backgroundColor: Color.fromARGB(
                                                    255, 126, 137, 141),
                                                borderColor: Palette.postcolor,
                                                text: "Unfollow",
                                                textColor: Palette.postcolor,
                                                function: () async {
                                                  await Features().followUser(
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid,
                                                    userdata['uid'],
                                                  );

                                                  setState(() {
                                                    isFollowing = false;
                                                    follower--;
                                                  });
                                                })
                                            : FollowButton(
                                                backgroundColor: Color.fromARGB(
                                                    255, 0, 144, 201),
                                                borderColor: Palette.postcolor,
                                                text: "Follow",
                                                textColor: Palette.postcolor,
                                                function: () async {
                                                  await Features().followUser(
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                      userdata['uid']);
                                                  setState(() {
                                                    isFollowing = true;
                                                    follower++;
                                                  });
                                                }),
                                    FirebaseAuth.instance.currentUser!.uid ==
                                            widget.uid
                                        ? FollowButton(
                                            backgroundColor:
                                                Palette.secondcolor,
                                            borderColor: Palette.postcolor,
                                            text: "Log Out",
                                            textColor: Palette.postcolor,
                                            function: () async {
                                              await AuthMethods().Logout();
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const Login()));
                                            },
                                          )
                                        : isFollowing
                                            ? FollowButton(
                                                backgroundColor: Color.fromARGB(
                                                    255, 126, 137, 141),
                                                borderColor: Palette.postcolor,
                                                text: "Message",
                                                textColor: Palette.postcolor,
                                                function: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Chatting(
                                                                  uid: userdata[
                                                                      'uid'])));
                                                })
                                            : FollowButton(
                                                backgroundColor: Color.fromARGB(
                                                    255, 0, 144, 201),
                                                borderColor: Palette.postcolor,
                                                text: "Message",
                                                textColor: Palette.postcolor,
                                                function: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Chatting(
                                                                  uid: userdata[
                                                                      'uid'])));
                                                }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        Container(
                          width: 380,
                          child: FutureBuilder(
                              future: FirebaseFirestore.instance
                                  .collection('posts')
                                  .where('uid', isEqualTo: widget.uid)
                                  .get(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: const CircularProgressIndicator());
                                }
                                // Calculate the height based on the number of rows and row heights
                                int itemCount =
                                    (snapshot.data! as dynamic).docs.length;
                                double rowHeight =
                                    290.0; // Set the desired height for each row
                                int crossAxisCount =
                                    2; // Set the number of columns
                                double gridViewHeight =
                                    ((itemCount / crossAxisCount).ceil()) *
                                        rowHeight;

                                return Container(
                                  height: gridViewHeight,
                                  width: 50,
                                  child: StaggeredGridView.countBuilder(
                                      crossAxisCount: 2,
                                      itemCount: (snapshot.data! as dynamic)
                                          .docs
                                          .length,
                                      itemBuilder: (context, index) =>
                                          Container(
                                            padding: EdgeInsets.all(5.0),
                                            child: GestureDetector(
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          Post1(
                                                              snap: (snapshot
                                                                          .data!
                                                                      as dynamic)
                                                                  .docs[index]
                                                                  .data()),
                                                    ),
                                                  );
                                                },
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Image.network((snapshot
                                                          .data! as dynamic)
                                                      .docs[index]['postUrl']),
                                                ),
                                              ),
                                            ),
                                          ),
                                      staggeredTileBuilder: (index) =>
                                          const StaggeredTile.fit(1)),
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ]),
          );
  }
}
