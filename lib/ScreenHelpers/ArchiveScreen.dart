import 'package:flutter/material.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:notes/database/note.dart';
import 'package:notes/main.dart';
import 'package:notes/widget/AppBar.dart';
import 'package:notes/widget/Body.dart';
import 'package:notes/widget/BottomBar.dart';
import 'package:notes/widget/DoubleBackToClose.dart';
import 'package:notes/widget/FloatingActionButton.dart';

_ArchiveScreenHelperState archive;

class ArchiveScreenHelper extends StatefulWidget {
  @override
  _ArchiveScreenHelperState createState() => _ArchiveScreenHelperState();
}

class _ArchiveScreenHelperState extends State<ArchiveScreenHelper> {
  MyAppBar appbar;

  @override
  void initState() {
    super.initState();
    appbar = MyAppBar(
      title: 'Archive',
      imagePath: 'assets/images/img3.jpg',
    );
  }

  void callSetState() {
    setState(
      () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    archive = this;
    return AnimatedContainer(
      transform: Matrix4Transform()
          .translate(
              x: myNotes.drawerManager.xOffSet,
              y: myNotes.drawerManager.yOffSet)
          .rotate(myNotes.drawerManager.angle)
          .matrix4,
      duration: Duration(milliseconds: 250),
      child: Scaffold(
        appBar: MyAppBar(
          title: 'Archived',
          imagePath: 'assets/images/img3.jpg',
        ),
        body: DoubleBackToCloseWidget(
          child: SafeArea(
            child: Body(
              fromWhere: NoteState.archived,
            ),
          ),
        ),
        floatingActionButton: fab(context, NoteState.archived),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: bottomBar(context, NoteState.archived),
      ),
    );
  }
}
