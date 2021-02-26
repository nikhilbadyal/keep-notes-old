import 'package:flutter/material.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:notes/database/note.dart';
import 'package:notes/util/DrawerManager.dart';
import 'package:notes/util/constants.dart';
import 'package:notes/widget/AppBar.dart';
import 'package:notes/widget/BottomBar.dart';
import 'package:notes/widget/DoubleBackToClose.dart';
import 'package:notes/widget/FloatingActionButton.dart';

_BackUpScreenHelperState backup ;
class BackUpScreenHelper extends StatefulWidget {
  final DrawerManager drawerManager ;

  BackUpScreenHelper(this.drawerManager);

  @override
  _BackUpScreenHelperState createState() => _BackUpScreenHelperState();
}

class _BackUpScreenHelperState extends State<BackUpScreenHelper> {
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
    setState(() {},);
  }

  @override
  Widget build(BuildContext context) {
    backup = this ;
    return AnimatedContainer(
      transform: Matrix4Transform()
          .translate(x: widget.drawerManager.xOffSet, y: widget.drawerManager.yOffSet)
          .rotate(widget.drawerManager.angle)
          .matrix4,
      duration: Duration(milliseconds: 250),
      child: Scaffold(
        appBar: MyAppBar(
          title: 'Backup and Restore',
          imagePath: 'assets/images/img3.jpg',
        ),
        body: DoubleBackToCloseWidget(
          child: SafeArea(
              child: Center(
                child: Container(
            child: Text("Hello I'm nikhil. Give me some sunshine and some ray and some fucking time to implement this.",style: TextStyle(
              color: headerColor,fontSize: 18,
            ),),
          ),
              )),
        ),
        floatingActionButton: fab(context, NoteState.archived),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: bottomBar(context, NoteState.archived),
      ),
    );
  }
}
