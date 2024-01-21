import 'package:flutter/material.dart';
import 'package:practice/color.dart';
import 'package:practice/Providers/user_provider.dart';
import 'package:practice/models/users.dart';
import 'package:provider/provider.dart';
import '../Widgets/comment_card.dart';
import 'package:practice/resources/features.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Commment extends StatefulWidget {
  final snap;
  const Commment({Key? key, required this.snap}) : super(key: key);
  @override
  State<Commment> createState() => _CommmentState();
}

class _CommmentState extends State<Commment> {
  final TextEditingController _commentController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.thirdcolor,
        iconTheme: IconThemeData(color: Palette.thirdcolor),
        title: const Text(
          "Comment",
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
            .doc(widget.snap['postID'])
            .collection('comments')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
              itemCount: (snapshot.data! as dynamic).docs.length,
              itemBuilder: (context, index) => CommentCard(
                  snap: (snapshot.data! as dynamic).docs[index].data()));
        },
      ),
      bottomNavigationBar: SafeArea(
          child: Container(
        height: 60,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(color: Palette.thirdcolor),
        padding: EdgeInsets.only(left: 16, right: 8),
        child: Row(
          children: [
            CircleAvatar(
              child: CircleAvatar(
                backgroundImage: NetworkImage(user.profilepic),
                radius: 16,
              ),
              backgroundColor: Color(0xFF2B414A),
              radius: 17,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 8.0),
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                      hintText: 'Write a comment',
                      hintStyle: TextStyle(
                          color: Palette.postcolor,
                          fontFamily: 'Ale',
                          fontSize: 17),
                      border: InputBorder.none),
                  style: TextStyle(
                    fontFamily: 'Ale',
                    fontSize: 17,
                    color: Palette.postcolor,
                  ),
                ),
              ),
            ),
            IconButton(
                onPressed: () async {
                  await Features().postComment(
                      widget.snap['postID'],
                      _commentController.text,
                      user.uid,
                      user.username,
                      user.profilepic);
                  setState(() {
                    _commentController.text = "";
                  });
                },
                icon: Icon(
                  Icons.send_sharp,
                  color: Palette.postcolor,
                )),
          ],
        ),
      )),
    );
  }
}
