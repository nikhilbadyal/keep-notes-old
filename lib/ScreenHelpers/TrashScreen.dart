import 'package:flutter/material.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:notes/database/NotesHelper.dart';
import 'package:notes/database/note.dart';
import 'package:notes/util/DrawerManager.dart';
import 'package:notes/util/Utilites.dart';
import 'package:notes/util/constants.dart';
import 'package:notes/widget/AppBar.dart';
import 'package:notes/widget/Body.dart';
import 'package:notes/widget/DoubleBackToClose.dart';
import 'package:provider/provider.dart';

_TrashScreenHelperState trash;

class TrashScreenHelper extends StatefulWidget {
  @override
  _TrashScreenHelperState createState() => _TrashScreenHelperState();
}

class _TrashScreenHelperState extends State<TrashScreenHelper>
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
    debugPrint('building 12');
    trash = this;
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
      child: Scaffold(
        appBar: MyAppBar(
          title: "Trash",
        ),
        body: DoubleBackToCloseWidget(
          child: SafeArea(
            child: Body(
              fromWhere: NoteState.deleted,
              primary: primary,
              secondary: secondary,
            ),
          ),
        ),
        bottomSheet: _bottomBar(context),
      ),
    );
  }

  List<Widget> secondary(Note note) {
    List<Widget> actionList = [];
    actionList.add(Utilities.deleteAction(context, note));
    return actionList;
  }

  List<Widget> primary(Note note) {
    List<Widget> actionList = [];
    actionList.add(Utilities.restoreAction(context, note));
    return actionList;
  }

  Widget _bottomBar(BuildContext context) {
    return BottomAppBar(
      child: Container(
        height: kBottomNavigationBarHeight,
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width / 6,
            ),
            IconButton(
              onPressed: () {
                _moreOptions(context);
              },
              icon: Icon(Icons.more_vert_outlined),
              color: headerColor,
              tooltip: 'More ',
            ),
          ],
        ),
      ),
    );
  }

  void _moreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return _moreOptionsMenu(context);
      },
    );
  }

  Widget _moreOptionsMenu(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            deleteAllIcon(context),
          ],
        ),
      ),
    );
  }

  Widget deleteAllIcon(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.delete_forever_outlined,
        color: Colors.blue,
      ),
      title: const Text('Delete all Notes'),
      onTap: () async {
        await Provider.of<NotesHelper>(this.context, listen: false)
            .deleteAllTrashNotes();
        Navigator.of(context).pop();
        String whereToNavigate = Utilities.navChecker(NoteState.deleted);
        Navigator.of(this.context).pushNamedAndRemoveUntil(
            whereToNavigate, (Route<dynamic> route) => false);
      },
    );
  }
}
