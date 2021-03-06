import 'package:flutter/material.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:notes/database/note.dart';
import 'package:notes/widget/AppBar.dart';
import 'package:notes/widget/Body.dart';
import 'package:notes/widget/BottomBar.dart';
import 'package:notes/widget/DoubleBackToClose.dart';
import 'package:notes/widget/FloatingActionButton.dart';

import '../main.dart';

_HomeScreenHelperState homeScreen;

class HomeScreenHelper extends StatefulWidget {

  @override
  _HomeScreenHelperState createState() => _HomeScreenHelperState();
}

class _HomeScreenHelperState extends State<HomeScreenHelper> {
  MyAppBar appbar;

  @override
  void initState() {
    super.initState();
    appbar = MyAppBar(
      title: 'Notes',
      imagePath: 'assets/images/img3.jpg',
    );
  }

  void callSetState() {
    setState(() {},);
  }

  @override
  Widget build(BuildContext context) {
    homeScreen = this;
    return AnimatedContainer(
      transform: Matrix4Transform()
          .translate(x: myNotes.drawerManager.xOffSet, y: myNotes.drawerManager.yOffSet)
          .rotate(myNotes.drawerManager.angle)
          .matrix4,
      duration: Duration(milliseconds: 250),
      child: Scaffold(
        appBar: MyAppBar(
          title: 'Notes',
          imagePath: 'assets/images/img3.jpg',
        ),
        body: DoubleBackToCloseWidget(
          child: SafeArea(
            child: Body(
              fromWhere: NoteState.unspecified,
            ),
          ),
        ),
        floatingActionButton: fab(context, NoteState.unspecified),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: bottomBar(context, NoteState.unspecified),
      ),
    );
  }
}
