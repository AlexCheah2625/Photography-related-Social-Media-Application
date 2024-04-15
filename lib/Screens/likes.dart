import 'package:flutter/material.dart';
import 'package:practice/Widgets/userprofile_card1.dart';
import 'package:practice/resources/features.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../color.dart';

class Likes extends StatefulWidget {
  final String postid;

  const Likes({Key? key, required this.postid}) : super(key: key);

  @override
  State<Likes> createState() => _LikesState();
}

class _LikesState extends State<Likes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Palette.thirdcolor,
          iconTheme: IconThemeData(color: Palette.postcolor),
          title: const Text(
            "Likes",
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
                .collection('posts')
                .doc(widget.postid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  !snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              var likeList = (snapshot.data as dynamic)['likes'];

              return ListView.builder(
                  itemCount: likeList.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection("users")
                            .doc(likeList[index])
                            .get(),
                        builder: (context, userSnapshot) {
                          if (userSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          var userData = userSnapshot.data as dynamic;

                          return UserCard1(uid: userData['uid']);
                        });
                  });
            }));
  }
}
