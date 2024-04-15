import 'package:flutter/material.dart';
import 'package:practice/Screens/POTW_screen.dart';
import 'package:practice/Widgets/feed_post.dart';
import 'package:practice/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:practice/models/potw.dart';
import 'package:practice/models/users.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Users currentUser;

  @override
  void initState() {
    super.initState();
    fetchCurrentUser();
  }

  Future<void> fetchCurrentUser() async {
    try {
      // Replace 'currentUserId' with the actual user ID of the current user
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get();

      if (userSnapshot.exists) {
        setState(() {
          currentUser = Users.fromSnap(userSnapshot);
        });
      }
    } catch (e) {
      print("Error fetching current user: $e");
    }
  }

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
            fontWeight: FontWeight.w600,
          ),
        ),
        //centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.celebration_sharp),
            iconSize: 30.0,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => POTWScreen()),
              );
            },
          ),
        ],
      ),
      body: currentUser != null && currentUser.following.isNotEmpty
          ? StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("posts")
                  .where('uid',
                      whereIn: [...currentUser.following, currentUser.uid])
                  .orderBy("date", descending: true)
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("No posts to display."),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (ctx, index) => Post(
                    snap: snapshot.data!.docs[index].data(),
                  ),
                );
              },
            )
          : const Center(
              child: Text("Following list is empty."),
            ),
    );
  }
}
