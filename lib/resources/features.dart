import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:practice/models/post.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:practice/models/users.dart';
import 'package:practice/resources/storage.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Features {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int cate = 4;
  String postId = const Uuid().v1();
  //upload post
  Future<String> uploadPost(
    String caption,
    Uint8List file,
    String uid,
    String username,
    String profilepics,
    String apreture,
    String iso,
    String shuttlespeed,
    String location,
  ) async {
    String result = "some error occured";
    try {
      // _loadModel();
      String category = await classifyImage(file, cate);

      String photoUrl =
          await Storage().uploadPictoStorage('postImages', file, true);
      Post posts = Post(
          caption: caption,
          uid: uid,
          username: username,
          postID: postId,
          date: DateTime.now(),
          postUrl: photoUrl,
          profilepic: profilepics,
          likes: [],
          category: category,
          apreture: apreture,
          shuttlespeed: shuttlespeed,
          iso: iso,
          location: location);

      _firestore.collection("posts").doc(postId).set(posts.toJson());

      result = "Successfully created post";
    } catch (err) {
      result = err.toString();
    }
    return result;
  }

  Future<void> likePost(String postID, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postID).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postID).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> postComment(String postID, String comment, String uid,
      String username, String profilepic) async {
    try {
      final commlikes = [];
      if (comment.isNotEmpty) {
        String commentID = const Uuid().v1();
        _firestore
            .collection('posts')
            .doc(postID)
            .collection('comments')
            .doc(commentID)
            .set({
          'profilepic': profilepic,
          'postID': postID,
          'comment': comment,
          'username': username,
          'uid': uid,
          'commentID': commentID,
          'datePublished': DateTime.now(),
          'likes': commlikes,
        });
      } else {
        print('Comment is empty');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> likeComment(String postID, String commentID, String uid,
      String username, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore
            .collection('posts')
            .doc(postID)
            .collection('comments')
            .doc(commentID)
            .update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore
            .collection('posts')
            .doc(postID)
            .collection('comments')
            .doc(commentID)
            .update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future DownloadImage(String postID) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _firestore.collection('posts').doc(postID).get();
      if (documentSnapshot.exists) {
        // Access data from the document
        Map<String, dynamic> ImageUrl =
            documentSnapshot.data() as Map<String, dynamic>;
        String postUrl = ImageUrl['postUrl'];
        print(postUrl);
        final tempDir = await getTemporaryDirectory();
        final path = '${tempDir.path}/Xenon.png';
        await Dio().download(postUrl, path);
        await GallerySaver.saveImage(path);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'follower': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'follower': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> editProfile(Uint8List file1, String username, String bio,
      String age, String uid) async {
    try {
      if (username.isNotEmpty || age.isNotEmpty || bio.isNotEmpty) {
        String? photoURL;
        if (file1 != null) {
          photoURL = await Storage()
              .uploadPictoStorage('profilepictures', file1, false);
        }

        Map<String, dynamic> updateFields = {};

        if (username.isNotEmpty) {
          updateFields['username'] = username;
        }
        if (bio.isNotEmpty) {
          updateFields['bio'] = bio;
        }
        if (age.isNotEmpty) {
          updateFields['age'] = age;
        }
        if (photoURL != null) {
          updateFields['profilepic'] = photoURL;
        }

        // Update the user document in Firestore using the provided UID
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .update(updateFields);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deletePost(String postID) async {
    try {
      await _firestore.collection('posts').doc(postID).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> editPost(String postID, String caption, String iso,
      String apreture, String shuttlespeed, String location) async {
    try {
      if (caption.isNotEmpty ||
          iso.isNotEmpty ||
          apreture.isNotEmpty ||
          shuttlespeed.isNotEmpty ||
          location.isNotEmpty) {
        Map<String, dynamic> updateFields = {};
        if (caption.isNotEmpty) {
          updateFields['caption'] = caption;
        }
        if (iso.isNotEmpty) {
          updateFields['iso'] = iso;
        }
        if (apreture.isNotEmpty) {
          updateFields['apreture'] = apreture;
        }
        if (shuttlespeed != null) {
          updateFields['shuttlespeed'] = shuttlespeed;
        }
        if (location != null) {
          updateFields['location'] = location;
        }

        // Update the user document in Firestore using the provided UID
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(postID)
            .update(updateFields);
      }
    } catch (e) {
      print(e.toString());
    }
  }
  
  Future<void> AddTokenUser(String token) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('users').doc(uid);
      await userRef.update({'token': token});
      print("Token added");
    } catch (e) {
      print(e.toString());
    }
  }
}

Future<String> classifyImage(Uint8List image, int category) async {
  try {
    Tflite.close();
    String? res = await Tflite.loadModel(
        model: "asset/model_unquant.tflite",
        labels: "asset/labels.txt",
        numThreads: 1, // defaults to 1
        isAsset:
            true, // defaults to true, set to false to load resources outside assets
        useGpuDelegate:
            false // defaults to false, set to true to use GPU delegate
        );

    // Save the image to a temporary file
    Directory tempDir = await getTemporaryDirectory();
    File tempFile = File('${tempDir.path}/temp_image.jpg');
    await tempFile.writeAsBytes(image);

    // Obtain the file path
    String filePath = tempFile.path;

    var output = await Tflite.runModelOnImage(
      path: filePath,
      imageMean: 0.0,
      imageStd: 255.0,
      numResults: 1,
      threshold: 0.9,
      asynch: true,
    );

    if (output != null && output.isNotEmpty) {
      String result = output[0]['label'];
      String category = result.replaceAll(RegExp(r'[^0-9]'), '');

      // Now, 'numericPart' contains the numeric part of the classification result
      print('Numeric Part: $category');
      return category;
    } else {
      String category = '4';
      print('Image cannot be classify');
      return category;
    }
  } catch (e) {
    print('Error in classifyImage: $e');
    return 'Error';
  }
}
