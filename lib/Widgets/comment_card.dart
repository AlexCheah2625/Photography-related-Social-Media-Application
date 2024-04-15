import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:practice/Providers/user_provider.dart';
import 'package:practice/Screens/profile.dart';
import 'package:practice/models/users.dart';
import 'package:practice/resources/features.dart';
import 'package:provider/provider.dart';
import '../color.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    final Users user = Provider.of<UserProvider>(context).getUser;
    return Container(
        decoration: BoxDecoration(
            color: Palette.thirdcolor,
            border: Border.all(
              color: Palette.postcolor,
              width: 0.05,
            )),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.only(left: 10, right: 8),
              width: MediaQuery.of(context).size.width * 0.19,
              child: CircleAvatar(
                child: CircleAvatar(
                  backgroundImage: NetworkImage(widget.snap['profilepic']),
                  radius: 20,
                ),
                backgroundColor: Color(0xFF2B414A),
                radius: 23,
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.only(left: 5, right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 35,
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProfileScreen(
                                  uid: widget.snap['uid'],
                                ),
                              ));
                            },
                            child: Text(
                              '${widget.snap['username']}',
                              style: TextStyle(
                                  color: Palette.postcolor,
                                  fontFamily: 'Ale',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.topRight,
                          margin: EdgeInsets.only(left: 15),
                          child: Text(
                            DateFormat('dd MMMM yyyy').format(
                              widget.snap['datePublished'].toDate(),
                            ),
                            style: TextStyle(
                              color: Palette.postcolor,
                              fontSize: 12,
                              fontFamily: 'Ale',
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, bottom: 10),
                      child: ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          ExpandableText(
                            widget.snap['comment'],
                            style: TextStyle(
                              color: Palette.postcolor,
                              fontFamily: 'Ale',
                              fontSize: 16,
                            ),
                            expandText: 'Show more',
                            collapseText: 'Show less',
                            maxLines: 2,
                            linkColor: Palette.postcolor,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () async {
                    await Features().likeComment(
                        widget.snap['postID'],
                        widget.snap['commentID'],
                        user.uid,
                        user.username,
                        widget.snap['likes']);
                  },
                  icon: widget.snap['likes'].contains(user.uid)
                      ? Icon(
                          Icons.favorite_sharp,
                          color: Colors.red,
                        )
                      : Icon(
                          Icons.favorite_border_sharp,
                          color: Palette.postcolor,
                        ),
                  iconSize: 18,
                ),
              ),
            )
          ],
        ));
  }
}
