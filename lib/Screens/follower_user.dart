import 'package:flutter/material.dart';
import '../Widgets/userprofile_card.dart';
import 'package:practice/resources/features.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../color.dart';

class FollowerScreen extends StatefulWidget {
  final String uid;
  const FollowerScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<FollowerScreen> createState() => _FollowerScreenState();
}

class _FollowerScreenState extends State<FollowerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Palette.thirdcolor,
          title: const Text(
            "Follower",
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
              var followingList = (snapshot.data as dynamic)['follower'];

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
