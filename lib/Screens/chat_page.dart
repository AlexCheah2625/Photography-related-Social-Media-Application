import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:practice/Providers/user_provider.dart';
import 'package:practice/Screens/profile.dart';
import 'package:practice/Screens/search_posts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:practice/Widgets/chatuser_card.dart';
import 'package:practice/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:practice/models/users.dart';
import 'package:practice/resources/chatservice.dart';
import 'package:practice/resources/local_notification.dart';
import 'package:practice/utils/utils.dart';
import 'package:provider/provider.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});
  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController searchUser = TextEditingController();
  final LocalNotification localnoti = LocalNotification();
  bool showUser = false;
  bool loading = false;
  List<String> documentIds = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDocumentID();
  }

  @override
  void dispose() {
    super.dispose();
    searchUser.dispose();
  }


  Future<Object?> getPostDataByPostUrl(String postUrl) async {
    // Query the Firestore collection to get the document containing the postUrl
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .where('postUrl', isEqualTo: postUrl)
        .limit(1)
        .get();

    // Check if a document with the postUrl exists
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.data();
    } else {
      return null; // Document with postUrl not found
    }
  }

  getDocumentID() async {
    setState(() {
      loading = true;
    });
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('chatroom');

    try {
      QuerySnapshot querySnapshot = await collectionReference.get();

      documentIds.clear();

      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        // Access the document ID and add it to the list
        documentIds.add(docSnapshot.id);
      }

      String currentUserId = FirebaseAuth.instance.currentUser!.uid;

      for (int i = 0; i < documentIds.length; i++) {
        String currentString = documentIds[i];

        // Check if the currentString contains the dataToRemove
        if (currentString.contains(currentUserId)) {
          // If it does, remove the dataToRemove from the currentString
          String modifiedString = currentString.replaceAll(currentUserId, '');
          // Update the string in the list with the modifiedString
          modifiedString = modifiedString.replaceAll(' ', '');
          documentIds[i] = modifiedString;
        }
      }
      // Now, documentIds contains all the document IDs in the collection
      print("Document IDs: $documentIds");
    } catch (e) {
      print("Error getting document IDs: $e");
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
          backgroundColor: Color(0xFF213037),
          title: Container(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.035,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Search Users',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  filled: true,
                  fillColor: Color(0xFF2B414A),
                  labelStyle: TextStyle(
                    color: Palette.postcolor,
                    fontFamily: 'Ale',
                  ),
                ),
                style: TextStyle(color: Palette.postcolor),
                onFieldSubmitted: (String _) {
                  setState(() {
                    showUser = true;
                  });
                },
                controller: searchUser,
              ),
            ),
          ),
        ),
        body: showUser
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where('username', isGreaterThanOrEqualTo: searchUser.text)
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                              uid: (snapshot.data! as dynamic).docs[index]
                                  ['uid'],
                            ),
                          ),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              (snapshot.data! as dynamic).docs[index]
                                  ['profilepic'],
                            ),
                            radius: 16,
                          ),
                          title: Text(
                              (snapshot.data! as dynamic).docs[index]
                                  ['username'],
                              style: TextStyle(
                                  fontFamily: 'Ale',
                                  fontSize: 18,
                                  color: Palette.postcolor)),
                        ),
                      );
                    },
                  );
                },
              )
            : ListView.builder(
                itemCount: documentIds.length,
                itemBuilder: (context, index) {
                  return ChatUserCard(
                    uid: documentIds[index],
                  );
                },
              ));
  }
}
