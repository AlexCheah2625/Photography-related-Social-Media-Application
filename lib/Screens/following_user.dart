import 'package:flutter/material.dart';
import 'package:practice/Widgets/userprofile_card.dart';
import 'package:practice/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FollowingScreen extends StatefulWidget {
  final String uid;
  const FollowingScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Palette.thirdcolor,
          title: const Text(
            "Following",
            style: TextStyle(
              color: Palette.postcolor,
              fontFamily: 'Ale',
              fontSize: 23,
            ),
          ),
          centerTitle: false,
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(widget.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              var followingList = (snapshot.data as dynamic)['following'];

              return ListView.builder(
                  itemCount: followingList.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection("users")
                            .doc(followingList[index])
                            .get(),
                        builder: (context, userSnapshot) {
                          if (userSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          var userData = userSnapshot.data as dynamic;

                          return UserCard(uid: userData['uid']);
                        });
                  });
            }));
  }
}
