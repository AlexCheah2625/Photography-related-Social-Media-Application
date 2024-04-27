import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:practice/Screens/comment_sections.dart';
import 'package:practice/Screens/edit_post.dart';
import 'package:practice/Screens/homescreen.dart';
import 'package:practice/Screens/likes.dart';
import 'package:practice/color.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'package:practice/Providers/user_provider.dart';
import 'package:practice/models/users.dart';
import '../Screens/profile.dart';
import 'like_animation.dart';
import 'package:provider/provider.dart';
import 'package:practice/Widgets/like_animation.dart';
import 'package:practice/resources/features.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';

class Post extends StatefulWidget {
  final snap;
  const Post({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  bool isLikeanimating = false;
  //set a default aspect ratio
  double aspectRatio = 1.0;
  //rebuild the image widget
  @override
  void initState() {
    super.initState();
    calRatio();
  }

  @override
  void dispose() {
    calRatio();
    super.dispose();
  }

  Future<void> calRatio() async {
    String imageURL = widget.snap['postUrl'].toString();

    try {
      final res = await http.get(Uri.parse(imageURL));

      if (res.statusCode == 200) {
        Uint8List imageSize = res.bodyBytes;
        img.Image? image = img.decodeImage(imageSize);
        double? aspectRatio1 = image?.width.toDouble();
        double? aspectRatio2 = image?.height.toDouble();

        if (mounted &&
            aspectRatio1 != null &&
            aspectRatio2 != null &&
            aspectRatio2 != 0) {
          setState(() {
            aspectRatio = aspectRatio1 / aspectRatio2;
          });
        }
      }
    } catch (e) {
      // Handle any potential errors here.
    }
  }

  @override
  Widget build(BuildContext context) {
    final Users user = Provider.of<UserProvider>(context).getUser;
    final bool isCurrentUserPost = user.uid == widget.snap['uid'];
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 0.0,
        vertical: 2.0,
      ),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30), color: Palette.postcolor),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFD9D9D9))),
            ),
            child: Row(
              children: [
                Container(
                    padding: EdgeInsets.only(
                        left: 10.0, top: 5, bottom: 5, right: 10),
                    child: CircleAvatar(
                      child: CircleAvatar(
                        backgroundImage:
                            NetworkImage(widget.snap['profilepic'].toString()),
                        radius: 16,
                      ),
                      backgroundColor: Color(0xFF2B414A),
                      radius: 17,
                    )),
                Container(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                          uid: widget.snap['uid'],
                        ),
                      ));
                    },
                    child: Text(
                      widget.snap['username'].toString(),
                      style: TextStyle(
                        color: Palette.thirdcolor,
                        fontFamily: "Ale",
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => Dialog(
                                  child: Container(
                                      height: isCurrentUserPost ? 360 : 300,
                                      child: Column(
                                        children: [
                                          Container(
                                              child: Column(
                                            children: [
                                              Container(
                                                margin:
                                                    EdgeInsets.only(top: 5.0),
                                                child: const Text(
                                                  "Photo Detail",
                                                  style: TextStyle(
                                                      color: Palette.thirdcolor,
                                                      fontSize: 25,
                                                      fontFamily: "Ale",
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      decoration: TextDecoration
                                                          .underline),
                                                ),
                                              ),
                                              Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  margin: EdgeInsets.all(10.0),
                                                  child: Text(
                                                    "ISO: ${widget.snap['iso']}",
                                                    style: TextStyle(
                                                      color: Palette.thirdcolor,
                                                      fontSize: 20,
                                                      fontFamily: "Ale",
                                                    ),
                                                  )),
                                              Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  margin: EdgeInsets.all(10.0),
                                                  child: Text(
                                                    "Apreture: f ${widget.snap['apreture']}",
                                                    style: TextStyle(
                                                      color: Palette.thirdcolor,
                                                      fontSize: 20,
                                                      fontFamily: "Ale",
                                                    ),
                                                  )),
                                              Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  margin: EdgeInsets.all(10.0),
                                                  child: Text(
                                                    "Shuttle Speed: ${widget.snap['shuttlespeed']}",
                                                    style: TextStyle(
                                                      color: Palette.thirdcolor,
                                                      fontSize: 20,
                                                      fontFamily: "Ale",
                                                    ),
                                                  )),
                                              Container(
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.all(10.0),
                                                  child: Text(
                                                    "At",
                                                    style: TextStyle(
                                                      color: Palette.thirdcolor,
                                                      fontSize: 20,
                                                      fontFamily: "Ale",
                                                    ),
                                                  )),
                                              Container(
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.only(
                                                      bottom: 10.0, top: 0),
                                                  child: Text(
                                                    widget.snap['location'],
                                                    style: TextStyle(
                                                      color: Palette.thirdcolor,
                                                      fontSize: 20,
                                                      fontFamily: "Ale",
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  )),
                                              if (isCurrentUserPost)
                                                Container(
                                                  height: 70,
                                                  child: Column(children: [
                                                    Container(
                                                      width: 320,
                                                      height:
                                                          1, // Adjust the height of the divider line
                                                      color: Colors
                                                          .black, // Adjust the color of the divider line
                                                      margin: EdgeInsets.only(
                                                          top:
                                                              10), // Adjust the horizontal margin
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: 5, bottom: 5),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Container(
                                                            alignment: Alignment
                                                                .center,
                                                            child:
                                                                TextButton.icon(
                                                              onPressed: () {
                                                                Features().deletePost(
                                                                    widget.snap[
                                                                        'postID']);

                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              icon: Icon(
                                                                Icons.delete,
                                                                color: Palette
                                                                    .secondcolor,
                                                              ),
                                                              label: Text(
                                                                'Delete Post',
                                                                style:
                                                                    TextStyle(
                                                                  color: Palette
                                                                      .secondcolor,
                                                                  fontFamily:
                                                                      'Ale',
                                                                  fontSize: 18,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            alignment: Alignment
                                                                .center,
                                                            child:
                                                                TextButton.icon(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .push(MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                EditPost(postid: widget.snap['postID'])));
                                                              },
                                                              icon: Icon(
                                                                Icons
                                                                    .edit_sharp,
                                                                color: Palette
                                                                    .secondcolor,
                                                              ),
                                                              label: Text(
                                                                'Edit Post',
                                                                style:
                                                                    TextStyle(
                                                                  color: Palette
                                                                      .secondcolor,
                                                                  fontFamily:
                                                                      'Ale',
                                                                  fontSize: 18,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ]),
                                                )
                                            ],
                                          ))
                                        ],
                                      )),
                                ));
                      },
                      icon: Icon(Icons.more_horiz_sharp),
                    ),
                  ),
                )
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () async {
              await Features().likePost(
                  widget.snap['postID'], user.uid, widget.snap['likes']);
              setState(() {
                isLikeanimating = true;
              });
            },
            child: Stack(alignment: Alignment.center, children: [
              SizedBox(
                width: double.infinity,
                child: AspectRatio(
                  aspectRatio: aspectRatio,
                  child: InstaImageViewer(
                      child: Image.network(widget.snap['postUrl'].toString())),
                ),
              ),
              AnimatedOpacity(
                opacity: isLikeanimating ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: Likeanimation(
                  isAnimating: isLikeanimating,
                  duratrion: const Duration(milliseconds: 400),
                  onEnd: () {
                    setState(() {
                      isLikeanimating = false;
                    });
                  },
                  child: widget.snap['likes'].contains(user.uid)
                      ? Icon(
                          Icons.favorite_sharp,
                          color: Palette.postcolor,
                          size: 100,
                        )
                      : Icon(
                          Icons.heart_broken_sharp,
                          color: Palette.postcolor,
                          size: 100,
                        ),
                ),
              )
            ]),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(5.0),
            child: Text(
              widget.snap['caption'].toString(),
              style: TextStyle(
                  color: Palette.thirdcolor,
                  fontSize: 15,
                  fontFamily: "Ale",
                  fontWeight: FontWeight.w400),
            ),
          ),
          Container(
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(5.0),
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              Likes(postid: widget.snap['postID'])));
                    },
                    child: Text(
                      '${widget.snap['likes'].length} Likes',
                      style: TextStyle(
                          color: Palette.thirdcolor,
                          fontSize: 15,
                          fontFamily: "Ale",
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 10.0),
                    child: Text(
                      "-${DateFormat('dd MMMM yyyy').format(
                        widget.snap['date'].toDate(),
                      )}",
                      style: TextStyle(
                          color: Palette.thirdcolor,
                          fontSize: 15,
                          fontFamily: "Ale",
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(
                color: Color(0xFFD9D9D9),
              )),
            ),
            child: Row(
              children: [
                Likeanimation(
                    isAnimating: widget.snap['likes'].contains(user.uid),
                    smallLike: true,
                    child: IconButton(
                        onPressed: () async {
                          await Features().likePost(widget.snap['postID'],
                              user.uid, widget.snap['likes']);
                        },
                        icon: widget.snap['likes'].contains(user.uid)
                            ? const Icon(
                                Icons.favorite_sharp,
                                size: 22,
                                color: Colors.red,
                                fill: 0.5,
                              )
                            : const Icon(
                                Icons.favorite_border_sharp,
                                size: 22,
                              ))),
                IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Commment(
                          snap: widget.snap,
                        ),
                      ));
                    },
                    icon: Icon(
                      Icons.mode_comment_outlined,
                      size: 22,
                    )),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        onPressed: () {
                          Features().DownloadImage(widget.snap['postID']);
                        },
                        icon: Icon(
                          Icons.download_sharp,
                          size: 22,
                        )),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
