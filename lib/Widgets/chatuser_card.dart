import 'package:flutter/material.dart';
import 'package:practice/Screens/chatting_page.dart';
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

class ChatUserCard extends StatefulWidget {
  final String uid;
  const ChatUserCard({Key? key, required this.uid}) : super(key: key);

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
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
                      children: [
                        Container(
                          height: 50,
                          margin: EdgeInsets.only(right: 110),
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Chatting(
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
