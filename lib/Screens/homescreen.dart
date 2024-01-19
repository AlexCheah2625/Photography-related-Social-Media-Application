import 'package:flutter/material.dart';
import 'package:practice/Widgets/feed_post.dart';
import 'package:practice/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Palette.postcolor,
          title: const Text(
            "Xenon",
            style: TextStyle(
                color: Colors.black,
                fontSize: 40,
                fontFamily: 'Ale',
                fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("posts")
                .orderBy("date", descending: true)
                .snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (ctx, index) => Post(
                  snap: snapshot.data!.docs[index].data(),
                ),
              );
            }));
  }
}
