import 'dart:typed_data';
import 'package:practice/Screens/profile.dart';
import 'package:practice/resources/auth.dart';
import 'package:practice/resources/features.dart';
import 'package:practice/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:practice/color.dart';
import 'package:practice/resources/auth.dart';

import '../utils/utils.dart';

class EditProfile extends StatefulWidget {
  final String uid;
  const EditProfile({Key? key, required this.uid}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

final TextEditingController _ageController = TextEditingController();
final TextEditingController _usernameController = TextEditingController();
final TextEditingController _bioController = TextEditingController();
Uint8List? _image;

bool _Loading = false;

class _EditProfileState extends State<EditProfile> {
  late TextEditingController _ageController;
  late TextEditingController _usernameController;
  late TextEditingController _bioController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _ageController = TextEditingController();
    _usernameController = TextEditingController();
    _bioController = TextEditingController();

    getData();
  }

  var userdata = {};
  bool loading = false;

  getData() async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }

    try {
      try {
        var usersnap = await FirebaseFirestore.instance
            .collection("users")
            .doc(widget.uid)
            .get();
        userdata = usersnap.data()!;

        // Set initial values for TextFormFields
        _usernameController.text = userdata['username'] ?? '';
        _bioController.text = userdata['bio'] ?? '';
        _ageController.text = userdata['age']?.toString() ?? '';
      } catch (e) {
        if (mounted) {
          showSnackBar(e.toString(), context);
        }
      }

      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(e.toString(), context);
      }
    }

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  void selectImage() async {
    Uint8List pic = await pickImage(ImageSource.gallery);
    setState(() {
      _image = pic;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _ageController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.scaffold,
      appBar: AppBar(
        backgroundColor: Palette.postcolor,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: const Text(
          "Xenon",
          style: TextStyle(
              color: Colors.black,
              fontSize: 32,
              fontFamily: 'Ale',
              fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Text(
                    "Edit Your Profile",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontFamily: 'Noto',
                        fontWeight: FontWeight.bold,
                        decorationColor: Color(0xFFDADADA),
                        decoration: TextDecoration.underline,
                        decorationThickness: 1.0),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 50),
                  child: Center(
                    child: Stack(
                      children: [
                        _image != null
                            ? CircleAvatar(
                                child: CircleAvatar(
                                  backgroundImage: MemoryImage(_image!),
                                  radius: 95,
                                ),
                                backgroundColor: Color(0xFF2B414A),
                                radius: 100,
                              )
                            : CircleAvatar(
                                backgroundColor: Color(0xFF2B414A),
                                radius: 100,
                                child: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(userdata['profilepic']),
                                  radius: 95,
                                ),
                              ),
                        Positioned(
                            bottom: -5,
                            left: 140,
                            child: IconButton(
                              onPressed: selectImage,
                              icon: const Icon(
                                Icons.add_a_photo,
                                color: Palette.postcolor,
                              ),
                            ))
                      ],
                    ),
                  )),
              Container(
                child: Column(
                  children: [
                    Container(
                      //Username
                      child: Row(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 20),
                            margin: const EdgeInsets.only(top: 50),
                            child: const Text(
                              "Username ",
                              style: TextStyle(
                                color: Color(0xFFDADADA),
                                fontFamily: 'Noto',
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 1),
                            margin: const EdgeInsets.only(top: 50),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.019,
                              child: const Text(
                                ":",
                                style: TextStyle(
                                  color: Color(0xFFDADADA),
                                  fontFamily: 'Noto',
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 5),
                            margin: const EdgeInsets.only(top: 50),
                            child: Flexible(
                              // Wrap the Text widget in Flexible
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.55,
                                height: 32,
                                child: TextFormField(
                                  textAlign: TextAlign.start,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onChanged: (String value) {},
                                  validator: (value) {
                                    return value!.isEmpty
                                        ? 'Please Enter Your Username'
                                        : null;
                                  },
                                  controller: _usernameController,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      //Username
                      child: Row(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 20),
                            margin: const EdgeInsets.only(top: 20),
                            child: const Text(
                              "Bio",
                              style: TextStyle(
                                  color: Color(0xFFD9D9D9),
                                  fontFamily: 'Noto',
                                  fontSize: 20),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 73),
                            margin: const EdgeInsets.only(top: 20),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.017,
                              child: const Text(
                                ":",
                                style: TextStyle(
                                    color: Color(0xFFD9D9D9),
                                    fontFamily: 'Noto',
                                    fontSize: 20),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 5),
                            margin: const EdgeInsets.only(top: 20),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.55,
                              height: 32,
                              child: TextFormField(
                                textAlign: TextAlign.start,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onChanged: (String value) {},
                                validator: (value) {
                                  return value!.isEmpty
                                      ? 'Please Enter Your Bio'
                                      : null;
                                },
                                controller: _bioController,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Container(
                            //Age
                            padding: const EdgeInsets.only(left: 20),
                            margin: const EdgeInsets.only(top: 20),
                            child: const Text(
                              "Age",
                              style: TextStyle(
                                  color: Color(0xFFD9D9D9),
                                  fontSize: 20,
                                  fontFamily: "Noto"),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 70),
                            margin: const EdgeInsets.only(top: 20),
                            child: const Text(
                              ":",
                              style: TextStyle(
                                  color: Color(0xFFD9D9D9),
                                  fontFamily: 'Noto',
                                  fontSize: 20),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 5),
                            margin: const EdgeInsets.only(top: 20),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.55,
                              height: 32,
                              child: TextFormField(
                                textAlign: TextAlign.start,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onChanged: (String value) {},
                                validator: (value) {
                                  return value!.isEmpty
                                      ? 'Please Enter Your Age'
                                      : null;
                                },
                                controller: _ageController,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: SizedBox(
                  width: 151,
                  height: 42,
                  child: ElevatedButton(
                    onPressed: () {
                      Features().editProfile(
                          _image!,
                          _usernameController.text,
                          _bioController.text,
                          _ageController.text,
                          userdata['uid']);

                      Navigator.of(context).pop();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Profile updated successfully'),
                          duration: Duration(
                              seconds: 2), // Adjust the duration as needed
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDADADA),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    child: _Loading
                        ? const Center(
                            child: CircularProgressIndicator(
                            color: Colors.black,
                          ))
                        : const Text(
                            'Submit',
                            style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: "Noto",
                                color: Colors.black),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
