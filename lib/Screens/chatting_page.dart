import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:practice/Providers/user_provider.dart';
import 'package:practice/Widgets/chatbox.dart';
import 'package:practice/resources/chatservice.dart';
import 'package:provider/provider.dart';
import 'package:practice/Screens/profile.dart';
import 'package:practice/Screens/search_posts.dart';
import 'package:practice/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:practice/models/users.dart';
import 'package:practice/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Chatting extends StatefulWidget {
  final String uid;
  const Chatting({Key? key, required this.uid});

  @override
  State<Chatting> createState() => _ChattingState();
}

class _ChattingState extends State<Chatting> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  var userdata = {};
  int postlen = 0;
  int follower = 0;
  int following = 0;
  bool isExpanded = false;
  bool isFollowing = false;
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  void sendmesage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          userdata['uid'], _messageController.text, userdata['username']);
      _messageController.clear();
    }
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
    final Users user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
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
      body: Column(children: [
        Expanded(
            child: StreamBuilder(
          stream: _chatService.getMessage(user.uid, userdata['uid']),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading...");
            }

            return ListView(
              children: snapshot.data!.docs
                  .map((document) => _buildMessageItem(document))
                  .toList(),
            );
          },
        ))
      ]),
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
                  controller: _messageController,
                  decoration: InputDecoration(
                      hintText: 'Write an message',
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
                onPressed: () {
                  sendmesage();
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

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    DateTime timestamp = (data['timestamp'] as Timestamp).toDate();

    var alignment = (data['senderID'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
        alignment: alignment,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              crossAxisAlignment:
                  (data['senderID'] == _firebaseAuth.currentUser!.uid)
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
              mainAxisAlignment:
                  (data['senderID'] == _firebaseAuth.currentUser!.uid)
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
              children: [
                Text(
                  data['senderName'],
                  style: TextStyle(
                      color: Palette.postcolor,
                      fontFamily: 'Ale',
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
                ChatBubble(
                  message: data['message'],
                  date: DateFormat('MMM d, y').format(timestamp),
                ),
                Text(
                  DateFormat('h:mm a').format(timestamp),
                  style: TextStyle(
                    color: Palette.postcolor,
                    fontFamily: 'Ale',
                    fontSize: 12,
                  ),
                )
              ]),
        ));
  }
}
