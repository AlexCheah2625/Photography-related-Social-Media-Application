import 'package:flutter/cupertino.dart';
import 'package:practice/Providers/user_provider.dart';
import 'package:practice/responsive/things2.dart';
import 'Login and Signup/things.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:practice/models/users.dart' as model;
import 'color.dart';

class MobileLayout extends StatefulWidget {
  const MobileLayout({Key? key}) : super(key: key);

  @override
  State<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  int _page = 0;
  late PageController pgcontroller;

  @override
  void initState() {
    super.initState();
    pgcontroller = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pgcontroller.dispose();
  }

  void changecolornav(int page) {
    pgcontroller.jumpToPage(page);
  }

  void pageChange(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: Screens,
        controller: pgcontroller,
        onPageChanged: pageChange,
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
        child: BottomNavigationBar(
          backgroundColor: Palette.postcolor,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined,
                  size: 30,
                  color: _page == 0
                      ? Palette.thirdcolor
                      : Color.fromARGB(255, 94, 94, 94)),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined,
                  size: 30,
                  color: _page == 1
                      ? Palette.thirdcolor
                      : Color.fromARGB(255, 94, 94, 94)),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline_sharp,
                  size: 30,
                  color: _page == 2
                      ? Palette.thirdcolor
                      : Color.fromARGB(255, 94, 94, 94)),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline_sharp,
                  size: 30,
                  color: _page == 3
                      ? Palette.thirdcolor
                      : Color.fromARGB(255, 94, 94, 94)),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline,
                  size: 30,
                  color: _page == 4
                      ? Palette.thirdcolor
                      : Color.fromARGB(255, 94, 94, 94)),
              label: "",
            ),
          ],
          onTap: changecolornav,
        ),
      ),
    );
  }
}
