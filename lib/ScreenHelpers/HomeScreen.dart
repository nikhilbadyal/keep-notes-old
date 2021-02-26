import 'package:flutter/material.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:notes/database/note.dart';
import 'package:notes/util/DrawerManager.dart';
import 'package:notes/widget/AppBar.dart';
import 'package:notes/widget/Body.dart';
import 'package:notes/widget/BottomBar.dart';
import 'package:notes/widget/DoubleBackToClose.dart';
import 'package:notes/widget/FloatingActionButton.dart';

_HomeScreenHelperState homeScreen;

class HomeScreenHelper extends StatefulWidget {
  final DrawerManager drawerManager ;

  HomeScreenHelper(this.drawerManager);

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
          .translate(x: widget.drawerManager.xOffSet, y: widget.drawerManager.yOffSet)
          .rotate(widget.drawerManager.angle)
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
