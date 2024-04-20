import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:practice/Providers/user_provider.dart';
import 'package:practice/Screens/chat_page.dart';
import 'package:practice/models/message.dart';
import 'package:practice/models/users.dart';
import 'package:practice/resources/local_notification.dart';
import 'package:practice/resources/message_service.dart';

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

    Messages newMessage = Messages(
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

    DocumentSnapshot receivertoken = await FirebaseFirestore.instance
        .collection('users')
        .doc(receiverID)
        .get();

    String ReceiverToken = receivertoken.get('token');

    PushNotificationService()
        .sendPushNotification(senderName, message, ReceiverToken);
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
