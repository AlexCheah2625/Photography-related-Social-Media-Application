import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderID;
  final String receiverID;
  final String senderEmail;
  final String senderName;
  final String receiverName;
  final String message;
  final Timestamp timestamp;

  Message(
      {required this.senderID,
      required this.receiverID,
      required this.senderEmail,
      required this.senderName,
      required this.receiverName,
      required this.message,
      required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'receiverID': receiverID,
      'senderEmail': senderEmail,
      'senderName': senderName,
      'receiverName': receiverName,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
