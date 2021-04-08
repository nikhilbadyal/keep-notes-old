import 'package:flutter/material.dart';
import 'package:notes/model/note.dart';
import 'package:notes/util/Utilites.dart';
import 'package:notes/widget/AppBar.dart';
import 'package:notes/widget/Body.dart';
import 'package:notes/widget/BottomBar.dart';
import 'package:notes/widget/DoubleBackToClose.dart';
import 'package:notes/widget/FloatingActionButton.dart';

class ArchiveScreenHelper extends StatefulWidget {
  @override
  _ArchiveScreenHelperState createState() => _ArchiveScreenHelperState();
}

class _ArchiveScreenHelperState extends State<ArchiveScreenHelper>
    with TickerProviderStateMixin {
  Note note;

  @override
  Widget build(BuildContext context) {
    //debugPrint('building 5 ');
    return BodyOfBody(
      primary: primary,
      secondary: secondary,
      noteState: NoteState.archived,
      title: 'Archived',
    );
  }

  List<Widget> secondary(Note note) {
    final actionList = <Widget>[];
    actionList.add(Utilities.hideAction(context, note));
    actionList.add(Utilities.unArchiveAction(context, note));
    return actionList;
  }

  List<Widget> primary(Note note) {
    final actionList = <Widget>[];
    actionList.add(Utilities.trashAction(context, note));
    actionList.add(Utilities.copyAction(context, note));
    return actionList;
  }
}

class BodyOfBody extends StatelessWidget {
  const BodyOfBody(
      {Key key,
      @required this.primary,
      @required this.secondary,
      @required this.noteState,
      @required this.title})
      : super(key: key);

  final Function(Note note) primary;
  final Function(Note note) secondary;
  final NoteState noteState;
  final String title;

  @override
  Widget build(BuildContext context) {
    //debugPrint('Body o body building 6');
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
      floatingActionButton: const Fab(NoteState.unspecified),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar:
          noteState == NoteState.deleted ? null : const BottomBar(),
    );
  }
}
