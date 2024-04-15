import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:practice/Providers/user_provider.dart';
import 'package:practice/models/message.dart';
import 'package:practice/models/users.dart';

class ChatService extends ChangeNotifier {
//get instance of auth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  //send message
  Future<void> sendMessage(
    String receiverID,
    String message,
    String receiverName,
  ) async {
    final String currentuserid = _firebaseAuth.currentUser!.uid;
    final String currentuseremail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp time = Timestamp.now();

    String senderName = await getcurrentuserName(currentuserid);

    Message newMessage = Message(
        senderID: currentuserid,
        receiverID: receiverID,
        senderEmail: currentuseremail,
        senderName: senderName,
        receiverName: receiverName,
        message: message,
        timestamp: time);

    List<String> ids = [currentuserid, receiverID];
    ids.sort();
    String chatroomid = ids.join(" ");

    await _fireStore
        .collection('chatroom')
        .doc(chatroomid)
        .collection('messages')
        .add(newMessage.toMap());

    await _fireStore.collection('chatroom').doc(chatroomid).set({
      'receiverID': receiverID,
      'currentuserID': currentuserid,
      // Add more fields as needed
    });
  }

  //receive message
  Stream<QuerySnapshot> getMessage(String userID, String reciversID) {
    List<String> ids = [userID, reciversID];
    ids.sort();
    String chatroomID = ids.join(" ");
    return _fireStore
        .collection('chatroom')
        .doc(chatroomID)
        // .collection(reciversID)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Future<String> getcurrentuserName(String userId) async {
    try {
      // Assuming you have a 'users' collection in Firestore
      DocumentSnapshot userSnapshot =
          await _fireStore.collection('users').doc(userId).get();

      if (userSnapshot.exists) {
        // 'name' is the field in the user document that contains the user's name
        String userName = userSnapshot.get('username');
        return userName;
      } else {
        // Handle the case where the user document doesn't exist
        return "Unknown User";
      }
    } catch (e) {
      // Handle any errors that may occur during the process
      print("Error getting user name: $e");
      return "Error";
    }
  }
}
