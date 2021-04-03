import 'package:flutter/material.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:notes/database/note.dart';
import 'package:notes/util/DrawerManager.dart';
import 'package:notes/util/Utilites.dart';
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

class _ArchiveScreenHelperState extends State<ArchiveScreenHelper>
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
    debugPrint('building 5 ');
    archive = this;
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
        primary: primary,
        secondary: secondary,
        noteState: NoteState.archived,
        title: "Archived",
      ),
    );
  }

  List<Widget> secondary(Note note) {
    List<Widget> actionList = [];
    actionList.add(Utilities.hideAction(context, note));
    actionList.add(Utilities.unArchiveAction(context, note));
    return actionList;
  }

  List<Widget> primary(Note note) {
    List<Widget> actionList = [];
    actionList.add(Utilities.trashAction(context, note));
    actionList.add(Utilities.copyAction(context, note));
    return actionList;
  }
}

class BodyOfBody extends StatelessWidget {
  final Function(Note note) primary;
  final Function(Note note) secondary;
  final NoteState noteState;

  final String title;

  const BodyOfBody(
      {Key key,
      @required this.primary,
      @required this.secondary,
      @required this.noteState,
      @required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('Body o body building 6');
    return Scaffold(
      appBar: MyAppBar(
        title: title,
      ),
      body: DoubleBackToCloseWidget(
        child: SafeArea(
          child: Body(
            fromWhere: noteState,
            primary: primary,
            secondary: secondary,
          ),
        ),
      ),
      floatingActionButton: Fab(noteState),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar:
          noteState == NoteState.deleted ? null : const BottomBar(),
    );
  }
}
