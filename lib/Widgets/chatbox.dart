import 'package:flutter/material.dart';
import 'package:practice/color.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final String date;
  const ChatBubble({super.key, required this.message, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      constraints: BoxConstraints(maxWidth: 300),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: Palette.postcolor),
      child: Stack(
        children: [
          Container(
            //alignment: Alignment.topLeft,
            child: Text(
              date,
              style: TextStyle(
                color: Palette.secondcolor,
                fontFamily: 'Ale',
                fontSize: 12,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 12.0),
            child: Text(
              message,
              style: TextStyle(
                  color: Palette.secondcolor,
                  fontFamily: 'Ale',
                  fontSize: 16,
                  height: 1.1),
            ),
          ),
        ],
      ),
    );
  }
}
