import 'package:flutter/material.dart';
import 'package:notes/model/note.dart';
import 'package:notes/util/Utilites.dart';
import 'package:notes/views/ScreenHelpers/ArchiveScreen.dart';

class HiddenScreenHelper extends StatefulWidget {
  @override
  _HiddenScreenHelperState createState() => _HiddenScreenHelperState();
}

class _HiddenScreenHelperState extends State<HiddenScreenHelper>
    with TickerProviderStateMixin {
  Note note;

  @override
  Widget build(BuildContext context) {
    //debugPrint('building 8');
    return BodyOfBody(
      primary: primary,
      secondary: secondary,
      noteState: NoteState.hidden,
      title: 'Hidden',
    );
  }

  List<Widget> secondary(Note note) {
    final actionList = <Widget>[];
    actionList.add(Utilities.unHideAction(context, note));
    return actionList;
  }

  List<Widget> primary(Note note) {
    final actionList = <Widget>[];
    actionList.add(Utilities.deleteAction(context, note));
    return actionList;
  }
}
