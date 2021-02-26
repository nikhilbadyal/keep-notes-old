import 'package:flutter/material.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:notes/database/note.dart';
import 'package:notes/util/DrawerManager.dart';
import 'package:notes/widget/AppBar.dart';
import 'package:notes/widget/Body.dart';
// enum viewType { //TODO list grid toggle List, Grid }

_TrashScreenHelperState trash ;
class TrashScreenHelper extends StatefulWidget {
  final DrawerManager drawerManager;

  const TrashScreenHelper(this.drawerManager) ;

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
          .translate(x: widget.drawerManager.xOffSet, y: widget.drawerManager.yOffSet)
          .rotate(widget.drawerManager.angle)
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
