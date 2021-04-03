import 'package:flutter/material.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:notes/ScreenHelpers/ArchiveScreen.dart';
import 'package:notes/database/note.dart';
import 'package:notes/util/DrawerManager.dart';
import 'package:notes/util/Utilites.dart';

_HomeScreenHelperState homeScreen;

class HomeScreenHelper extends StatefulWidget {
  @override
  _HomeScreenHelperState createState() => _HomeScreenHelperState();

  const HomeScreenHelper();
}

class _HomeScreenHelperState extends State<HomeScreenHelper>
    with TickerProviderStateMixin {
  Note note;
  AnimationController _xController;
  AnimationController _yController;
  AnimationController _angleController;

  @override
  void initState() {
    _xController = AnimationController(
      duration: Duration(milliseconds: DrawerManager.animationTime),
      vsync: this,
      lowerBound: 0,
      upperBound: 150,
    );
    _yController = AnimationController(
      duration: Duration(milliseconds: DrawerManager.animationTime),
      vsync: this,
      lowerBound: 0,
      upperBound: 80,
    );
    _angleController = AnimationController(
      duration: Duration(milliseconds: DrawerManager.animationTime),
      vsync: this,
      lowerBound: 0,
      upperBound: 0.2,
    );
    super.initState();
  }

  animate() {
    if (_xController.isCompleted) {
      _xController.reverse();
      _yController.reverse();
      _angleController.reverse();
    } else {
      _xController.forward(from: 0);
      _yController.forward(from: 0);
      _angleController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _xController.dispose();
    _yController.dispose();
    _angleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Home screen building 9');
    homeScreen = this;
    return AnimatedBuilder(
      animation: _xController,
      builder: (BuildContext context, Widget child) {
        return Transform(
          transform: Matrix4Transform()
              .translate(x: _xController.value, y: _yController.value)
              .rotate(-_angleController.value)
              .matrix4,
          child: child,
        );
      },
      child: BodyOfBody(
        noteState: NoteState.unspecified,
        title: "Notes",
        primary: primary,
        secondary: secondary,
      ),
    );
  }

  List<Widget> primary(Note note) {
    List<Widget> actionList = [];
    actionList.add(Utilities.hideAction(context, note));
    actionList.add(Utilities.archiveAction(context, note));
    return actionList;
  }

  List<Widget> secondary(Note note) {
    List<Widget> actionList = [];
    actionList.add(Utilities.trashAction(context, note));
    actionList.add(Utilities.copyAction(context, note));
    return actionList;
  }
}
