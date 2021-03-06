import 'package:flutter/material.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:notes/database/note.dart';
import 'package:notes/widget/AppBar.dart';
import 'package:notes/widget/Body.dart';

import '../main.dart';
// enum viewType { //TODO list grid toggle List, Grid }

_TrashScreenHelperState trash ;
class TrashScreenHelper extends StatefulWidget {

  @override
  _TrashScreenHelperState createState() => _TrashScreenHelperState();
}

class _TrashScreenHelperState extends State<TrashScreenHelper> {
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
    trash = this;
    return AnimatedContainer(
      transform: Matrix4Transform()
          .translate(x: myNotes.drawerManager.xOffSet, y: myNotes.drawerManager.yOffSet)
          .rotate(myNotes.drawerManager.angle)
          .matrix4,
      duration: Duration(milliseconds: 250),
      child: Scaffold(
        appBar: MyAppBar(
          title: 'Trash',
          imagePath: 'assets/images/img3.jpg',
        ),
        body: SafeArea(
          child: Body(
            fromWhere: NoteState.deleted,
          ),
        ),
      ),
    );
  }
}
