import 'package:flutter/material.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:notes/database/note.dart';
import 'package:notes/util/Utilites.dart';
import 'package:notes/widget/AppBar.dart';
import 'package:notes/widget/Body.dart';
import 'package:notes/widget/BottomBar.dart';
import 'package:notes/widget/DoubleBackToClose.dart';
import 'package:notes/widget/FloatingActionButton.dart';

import '../main.dart';

_HiddenScreenHelperState hidden;

class HiddenScreenHelper extends StatefulWidget {
  @override
  _HiddenScreenHelperState createState() => _HiddenScreenHelperState();
}

class _HiddenScreenHelperState extends State<HiddenScreenHelper> {
  MyAppBar appbar;
  Note note;

  Widget currentPage;

  @override
  void initState() {
    super.initState();
    appbar = MyAppBar(
      title: 'Hidden',
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
    hidden = this;
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
          title: 'Hidden',
          imagePath: 'assets/images/img3.jpg',
        ),
        body: DoubleBackToCloseWidget(
          child: SafeArea(
            child: Body(
              fromWhere: NoteState.hidden,
              primary: primary,
              secondary: secondary,
            ),
          ),
        ),
        floatingActionButton: Fab(NoteState.hidden),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: BottomBar(),
      ),
    );
  }

  List<Widget> secondary(Note note) {
    List<Widget> actionList = [];
    actionList.add(Utilities.unHideAction(context, note));
    return actionList;
  }

  List<Widget> primary(Note note) {
    List<Widget> actionList = [];
    actionList.add(Utilities.deleteAction(context, note));
    return actionList;
  }
}
