import 'dart:ffi';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:practice/Providers/user_provider.dart';
import 'things2.dart';

class Responsive extends StatefulWidget {
  final Widget mobileBody;
  final Widget desktopBody;
  //constructer
  const Responsive(
      {Key? key, required this.mobileBody, required this.desktopBody})
      : super(key: key);

  @override
  State<Responsive> createState() => _ResponsiveState();
}

class _ResponsiveState extends State<Responsive> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > webScreenSize) {
        return widget.desktopBody;
      } else {
        return widget.mobileBody;
      }
    });
  }
}
