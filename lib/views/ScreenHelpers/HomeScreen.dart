import 'package:flutter/material.dart';
import 'package:notes/model/note.dart';
import 'package:notes/util/Utilites.dart';

import 'ArchiveScreen.dart';

_HomeScreenHelperState homeScreen;

class HomeScreenHelper extends StatefulWidget {
  @override
  _HomeScreenHelperState createState() => _HomeScreenHelperState();
}

class _HomeScreenHelperState extends State<HomeScreenHelper>
    with TickerProviderStateMixin {
  Note note;

  @override
  Widget build(BuildContext context) {
    //debugPrint('Home screen building 9');
    homeScreen = this;
    return BodyOfBody(
      noteState: NoteState.unspecified,
      title: 'Notes',
      primary: primary,
      secondary: secondary,
    );
  }

  List<Widget> primary(Note note) {
    final actionList = <Widget>[];
    actionList.add(Utilities.hideAction(context, note));
    actionList.add(Utilities.archiveAction(context, note));
    return actionList;
  }

  List<Widget> secondary(Note note) {
    final actionList = <Widget>[];
    actionList.add(Utilities.trashAction(context, note));
    actionList.add(Utilities.copyAction(context, note));
    return actionList;
  }
}
