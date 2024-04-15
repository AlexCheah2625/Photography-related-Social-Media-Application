import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:practice/color.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:practice/models/users.dart';
import 'package:practice/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:practice/Providers/user_provider.dart';
import 'package:image/image.dart' as img;
import 'package:practice/resources/features.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  Uint8List? _postimage;
  final TextEditingController _captioncontroller = TextEditingController();
  final TextEditingController _isocontroller = TextEditingController();
  final TextEditingController _apreturecontroller = TextEditingController();
  final TextEditingController _shuttlespeedcontroller = TextEditingController();
  final TextEditingController _locationcontroller = TextEditingController();
  bool buttonvisible = true;
  double aspectRatio = 16 / 9;
  bool _Loading = false;

  void selectedImg() async {
    Uint8List file1 = await pickImage(
      ImageSource.gallery,
    );

    setState(() {
      _postimage = file1;
      buttonvisible = false;
    });
  }

  double calRatio() {
    img.Image? image = img.decodeImage(_postimage!);
    //get the image heigh and length and calculate the aspect ratio
    double? imageAspectRatio = image?.width.toDouble();
    double? imageAspectRatio1 = image?.height.toDouble();
    double? imgratio = imageAspectRatio! / imageAspectRatio1!;
    return imgratio;
  }

  @override
  void dispose() {
    super.dispose();
    _captioncontroller.dispose();
    _isocontroller.dispose();
    _apreturecontroller.dispose();
    _locationcontroller.dispose();
    _shuttlespeedcontroller.dispose();
    Tflite.close();
  }

  void clearImage() {
    setState(() {
      _postimage = null;
    });
  }

  void postPhoto(String uid, String username, String profilepic) async {
    setState(() {
      _Loading = true;
    });
    try {
      String result = await Features().uploadPost(
          _captioncontroller.text,
          _postimage!,
          uid,
          username,
          profilepic,
          _apreturecontroller.text,
          _isocontroller.text,
          _shuttlespeedcontroller.text,
          _locationcontroller.text);

      if (result == "Successfully created post") {
        setState(() {
          _Loading = false;
        });
        showSnackBar("Your post has been successfully uploaded", context);
        clearImage();
      } else {
        showSnackBar(result, context);
        setState(() {
          _Loading = false;
        });
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
      setState(() {
        _Loading = false;
      });
    }
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
            'Create  Post',
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
                onPressed: () =>
                    postPhoto(user.uid, user.username, user.profilepic),
                child: Text('Post',
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
                child: Stack(
                  children: [
                    _postimage != null
                        ? AspectRatio(
                            aspectRatio: calRatio(),
                            child: Image(image: MemoryImage(_postimage!)),
                          )
                        : Visibility(
                            visible: buttonvisible,
                            child: Positioned(
                              left: 150,
                              top: 170,
                              child: TextButton(
                                child: Text(
                                  "Select Photo",
                                  style: TextStyle(
                                    color: Palette.thirdcolor,
                                    fontFamily: "Ale",
                                    fontSize: 18,
                                  ),
                                ),
                                onPressed: selectedImg,
                              ),
                            ),
                          ),
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
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Palette.postcolor,
                  border: Border.all(
                    color: Color.fromARGB(255, 194, 194, 194),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 15),
                      child: Text(
                        "Select Camera",
                        style: TextStyle(
                          fontFamily: "Ale",
                          fontSize: 16,
                          color: Palette.thirdcolor,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 3),
                      child: IconButton(
                        onPressed: () async {
                          Uint8List file = await pickImage(ImageSource.camera);
                          setState(() {
                            _postimage = file;
                          });
                        },
                        icon: Icon(Icons.camera_alt_sharp),
                        iconSize: 20,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
