import 'package:flutter/material.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:notes/AnimatedDrawerHelper/SecondLayer.dart';
import 'package:notes/database/note.dart';
import 'package:notes/widget/AppBar.dart';
import 'package:notes/widget/Body.dart';
import 'package:notes/widget/BottomBar.dart';
import 'package:notes/widget/FloatingActionButton.dart';

// enum viewType { //TODO list grid toggle List, Grid }

class HomeScreenHelper extends StatefulWidget {
  @override
  _HomeScreenHelperState createState() => _HomeScreenHelperState();
}

class _HomeScreenHelperState extends State<HomeScreenHelper> {
  MyAppBar appbar;
  Widget currentPage;
  double xOffSet = 0;
  double yOffSet = 0;
  double angle = 0;
  bool isOpen = false;
  bool isIgnoring = false;
  bool isPlaying = false;


  @override
  void initState() {
    super.initState();
    appbar = MyAppBar(
      callback: callback,
      title: 'Notes',
      imagePath: 'assets/images/img3.jpg',
    );
  }

  void callback(bool isOpen) {
    if (isOpen == true) {
      setState(() {
        xOffSet = 0;
        yOffSet = 0;
        angle = 0;
        isOpen = false;
        isIgnoring = false;
      });

      secondLayer.setState(() {
        secondLayer.xOffSet = 0;
        secondLayer.yOffSet = 0;
        secondLayer.angle = 0;
      });
    } else {
      setState(() {
        xOffSet = 150;
        yOffSet = 80;
        angle = -0.2;
        isOpen = true;
        isIgnoring = true;
      });

      secondLayer.setState(
        () {
          secondLayer.xOffSet = 122;
          secondLayer.yOffSet = 110;
          secondLayer.angle = -0.275;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      transform: Matrix4Transform()
          .translate(x: xOffSet, y: yOffSet)
          .rotate(angle)
          .matrix4,
      duration: Duration(milliseconds: 250),
      child: Scaffold(
        appBar: MyAppBar(
          callback: callback,
          title: 'Notes',
          imagePath: 'assets/images/img3.jpg',
        ),
        body: SafeArea(
          child: Body(
            fromWhere: NoteState.unspecified,
            isIgnoring: isIgnoring,
          ),
        ),
        floatingActionButton: fab(context, NoteState.unspecified),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: bottomBar(context, NoteState.unspecified),
      ),
    );
  }
}
