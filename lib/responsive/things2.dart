import 'package:flutter/material.dart';
import 'package:practice/Screens/homescreen.dart';
import 'package:practice/Screens/addpostscreen.dart';
import 'package:practice/Screens/discover.dart';
import 'package:practice/Screens/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

const webScreenSize = 600;
const mobileScreenSize = 500;

List<Widget> Screens = [
  HomeScreen(),
  Discover(),
  AddPost(),
  Text("hiiii"),
  ProfileScreen( uid: FirebaseAuth.instance.currentUser!.uid,),
];