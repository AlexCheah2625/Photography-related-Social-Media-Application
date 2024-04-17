import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:practice/color.dart';
import 'package:practice/resources/features.dart';
import 'package:practice/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:practice/Providers/user_provider.dart';
import 'package:practice/models/users.dart';
import 'package:image/image.dart' as img;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class EditPost extends StatefulWidget {
  final String postid;
  const EditPost({Key? key, required this.postid}) : super(key: key);

  @override
  State<EditPost> createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  late TextEditingController _captioncontroller = TextEditingController();
  late TextEditingController _isocontroller = TextEditingController();
  late TextEditingController _apreturecontroller = TextEditingController();
  late TextEditingController _shuttlespeedcontroller = TextEditingController();
  late TextEditingController _locationcontroller = TextEditingController();
  bool buttonvisible = true;
  double aspectRatio = 16 / 9;
  bool _Loading = false;

  @override
  void initState() {
    super.initState();
    _captioncontroller = TextEditingController();
    _isocontroller = TextEditingController();
    _apreturecontroller = TextEditingController();
    _shuttlespeedcontroller = TextEditingController();
    _locationcontroller = TextEditingController();
    getData();
    calRatio();
  }

  Future<void> calRatio() async {
    String imageURL = postdata["postUrl"].toString();
    final res = await http.get(Uri.parse(imageURL));

    if (res.statusCode == 200) {
      Uint8List imageSize = res.bodyBytes;
      img.Image? image = img.decodeImage(imageSize);
      double? aspectRatio1 = image?.width.toDouble();
      double? aspectRatio2 = image?.height.toDouble();
      if (aspectRatio1 != null && aspectRatio2 != null && aspectRatio2 != 0) {
        setState(() {
          aspectRatio = aspectRatio1 / aspectRatio2;
        });
      }
    }
  }

  var postdata = {};
  getData() async {
    if (mounted) {
      setState(() {
        _Loading = true;
      });
    }

    try {
      try {
        var postsnap = await FirebaseFirestore.instance
            .collection("posts")
            .doc(widget.postid)
            .get();
        postdata = postsnap.data()!;

        _captioncontroller.text = postdata['caption']?.toString() ?? '';
        _isocontroller.text = postdata['iso']?.toString() ?? '';
        _apreturecontroller.text = postdata['apreture']?.toString() ?? '';
        _shuttlespeedcontroller.text =
            postdata['shuttlespeed']?.toString() ?? '';
        _locationcontroller.text = postdata['location']?.toString() ?? '';
      } catch (e) {
        if (mounted) {
          showSnackBar(e.toString(), context);
        }
      }

      if (mounted) {
        setState(() {
          _Loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(e.toString(), context);
      }
    }

    if (mounted) {
      setState(() {
        _Loading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _captioncontroller.dispose();
    _isocontroller.dispose();
    _apreturecontroller.dispose();
    _locationcontroller.dispose();
    _shuttlespeedcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Users user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          toolbarHeight: 50,
          backgroundColor: Palette.postcolor,
          title: Text(
            'Edit  Post',
            style: TextStyle(
                fontSize: 24,
                color: Palette.thirdcolor,
                fontFamily: 'Ale',
                letterSpacing: -1.2,
                fontWeight: FontWeight.bold),
          ),
          centerTitle: false,
          floating: true,
          actions: [
            TextButton(
                onPressed: () {
                  Features().editPost(
                      widget.postid,
                      _captioncontroller.text,
                      _isocontroller.text,
                      _apreturecontroller.text,
                      _shuttlespeedcontroller.text,
                      _locationcontroller.text);
                  Navigator.of(context).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Post updated successfully'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: Text('Save',
                    style: TextStyle(
                        fontSize: 18,
                        color: Palette.secondcolor,
                        fontFamily: 'Ale')))
          ],
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              _Loading
                  ? const LinearProgressIndicator()
                  : Padding(padding: EdgeInsets.only(top: 0)),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Palette.postcolor,
                  border: Border.all(
                    color: Color.fromARGB(255, 194, 194, 194),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                        padding: EdgeInsets.only(
                            left: 10.0, top: 5, bottom: 5, right: 10),
                        child: CircleAvatar(
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(user.profilepic),
                            radius: 15,
                          ),
                          backgroundColor: Color(0xFF2B414A),
                          radius: 18,
                        )),
                    Container(
                      child: Text(
                        user.username,
                        style: TextStyle(
                            fontFamily: "Ale",
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Palette.postcolor,
                  border: Border.all(
                    color: Color.fromARGB(255, 194, 194, 194),
                  ),
                ),
                height: 365,
                child: SizedBox(
                  width: double.infinity,
                  child: AspectRatio(
                    aspectRatio: aspectRatio,
                    child: Image.network(postdata['postUrl'].toString()),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Palette.postcolor,
                  border: Border.all(
                    color: Color.fromARGB(255, 194, 194, 194),
                  ),
                ),
                height: 50,
                child: TextFormField(
                  textAlign: TextAlign.start,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "Write Something...",
                    hintStyle: TextStyle(
                        fontFamily: "Ale",
                        fontSize: 16,
                        color: Palette.thirdcolor),
                    filled: true,
                    fillColor: Palette.postcolor,
                  ),
                  controller: _captioncontroller,
                  maxLines: 8,
                  onChanged: (String value) {},
                  validator: (value) {
                    return value!.isEmpty ? 'Please Enter Your Caption' : null;
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Palette.postcolor,
                  border: Border.all(
                    color: Color.fromARGB(255, 194, 194, 194),
                  ),
                ),
                height: 50,
                child: TextFormField(
                  textAlign: TextAlign.start,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "Enter a Location",
                    hintStyle: TextStyle(
                        fontFamily: "Ale",
                        fontSize: 16,
                        color: Palette.thirdcolor),
                    filled: true,
                    fillColor: Palette.postcolor,
                  ),
                  controller: _locationcontroller,
                  maxLines: 8,
                  onChanged: (String value) {},
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Palette.postcolor,
                  border: Border.all(
                    color: Color.fromARGB(255, 194, 194, 194),
                  ),
                ),
                height: 50,
                child: TextFormField(
                  textAlign: TextAlign.start,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Apreature",
                    hintStyle: TextStyle(
                        fontFamily: "Ale",
                        fontSize: 16,
                        color: Palette.thirdcolor),
                    filled: true,
                    fillColor: Palette.postcolor,
                  ),
                  controller: _apreturecontroller,
                  maxLines: 8,
                  onChanged: (String value) {},
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Palette.postcolor,
                  border: Border.all(
                    color: Color.fromARGB(255, 194, 194, 194),
                  ),
                ),
                height: 50,
                child: TextFormField(
                  textAlign: TextAlign.start,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "ISO",
                    hintStyle: TextStyle(
                        fontFamily: "Ale",
                        fontSize: 16,
                        color: Palette.thirdcolor),
                    filled: true,
                    fillColor: Palette.postcolor,
                  ),
                  controller: _isocontroller,
                  maxLines: 8,
                  onChanged: (String value) {},
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Palette.postcolor,
                  border: Border.all(
                    color: Color.fromARGB(255, 194, 194, 194),
                  ),
                ),
                height: 50,
                child: TextFormField(
                  textAlign: TextAlign.start,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "Shuttle Speed",
                    hintStyle: TextStyle(
                        fontFamily: "Ale",
                        fontSize: 16,
                        color: Palette.thirdcolor),
                    filled: true,
                    fillColor: Palette.postcolor,
                  ),
                  controller: _shuttlespeedcontroller,
                  maxLines: 8,
                  onChanged: (String value) {},
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
