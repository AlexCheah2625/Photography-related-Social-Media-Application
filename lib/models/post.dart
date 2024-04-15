import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String postID;
  final String caption;
  final date;
  final String uid;
  final String username;
  final String postUrl;
  final String profilepic;
  final likes;
  final String category;
  final String shuttlespeed;
  final String iso;
  final String apreture;
  final String location;
  //constructor
  const Post({
    required this.postID,
    required this.caption,
    required this.date,
    required this.uid,
    required this.username,
    required this.postUrl,
    required this.profilepic,
    required this.likes,
    required this.category,
    required this.apreture,
    required this.iso,
    required this.shuttlespeed,
    required this.location,
  });
  //object
  Map<String, dynamic> toJson() => {
        "postID": postID,
        "caption": caption,
        "date": date,
        "uid": uid,
        "username": username,
        "postUrl": postUrl,
        "profilepic": profilepic,
        "likes": likes,
        "category": category,
        "apreture": apreture,
        "iso": iso,
        "shuttlespeed": shuttlespeed,
        "location": location
      };
  //return post model
  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
        postID: snapshot["postID"],
        caption: snapshot["caption"],
        date: snapshot["date"],
        uid: snapshot["uid"],
        username: snapshot["username"],
        postUrl: snapshot["postUrl"],
        profilepic: snapshot["profilepic"],
        likes: snapshot["likes"],
        category: snapshot["category"],
        apreture: snapshot["apreture"],
        iso: snapshot["iso"],
        shuttlespeed: snapshot["shuttlespeed"],
        location: snapshot["location"]);
  }
}
