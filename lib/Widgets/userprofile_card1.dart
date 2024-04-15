import 'dart:math';

import 'package:flutter/material.dart';
import '../color.dart';
import '../resources/features.dart';
import 'package:practice/resources/features.dart';
import 'package:provider/provider.dart';
import 'package:practice/Providers/user_provider.dart';
import 'package:practice/Screens/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/utils.dart';
import 'follow_button.dart';
import 'follow_button1.dart';

class UserCard1 extends StatefulWidget {
  final String uid;
  const UserCard1({Key? key, required this.uid}) : super(key: key);

  @override
  State<UserCard1> createState() => _UserCard1State();
}

class _UserCard1State extends State<UserCard1> {
  bool isFollowing = false;
  bool loading = false;
  var userdata = {};
  int follower = 0;
  int following = 0;

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
    return Container(
        height: 60,
        decoration: BoxDecoration(
            color: Palette.thirdcolor,
            border: Border.all(
              color: Palette.postcolor,
              width: 0.05,
            )),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.only(left: 10, right: 5),
              width: MediaQuery.of(context).size.width * 0.19,
              child: CircleAvatar(
                child: CircleAvatar(
                  backgroundImage: NetworkImage(userdata['profilepic']),
                  radius: 22,
                ),
                backgroundColor: Color(0xFF2B414A),
                radius: 25,
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.only(left: 5, right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 50,
                          margin: EdgeInsets.only(right: 60),
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProfileScreen(
                                  uid: userdata['uid'],
                                ),
                              ));
                            },
                            child: Text(
                              '${userdata['username']}',
                              style: TextStyle(
                                  color: Palette.postcolor,
                                  fontFamily: 'Ale',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        isFollowing
                            ? FollowButton1(
                                backgroundColor:
                                    Color.fromARGB(255, 126, 137, 141),
                                borderColor: Palette.postcolor,
                                text: "Unfollow",
                                textColor: Palette.postcolor,
                                function: () async {
                                  await Features().followUser(
                                    FirebaseAuth.instance.currentUser!.uid,
                                    userdata['uid'],
                                  );

                                  setState(() {
                                    isFollowing = false;
                                    follower = max(0, follower - 1);
                                  });
                                })
                            : FollowButton1(
                                backgroundColor:
                                    Color.fromARGB(255, 0, 144, 201),
                                borderColor: Palette.postcolor,
                                text: "Follow",
                                textColor: Palette.postcolor,
                                function: () async {
                                  await Features().followUser(
                                      FirebaseAuth.instance.currentUser!.uid,
                                      userdata['uid']);
                                  setState(() {
                                    isFollowing = true;
                                    follower++;
                                  });
                                }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
