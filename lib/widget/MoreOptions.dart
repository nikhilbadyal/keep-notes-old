import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:notes/database/NotesHelper.dart';
import 'package:notes/database/note.dart';
import 'package:notes/main.dart';
import 'package:notes/util/Utilites.dart';
import 'package:notes/widget/Navigations.dart';
import 'package:provider/provider.dart';

class MoreOptions extends StatefulWidget {
  final Note note;
  final Timer autoSaver;
  final Function() saveNote;

  MoreOptions(this.note, this.autoSaver, this.saveNote);

  @override
  _MoreOptionsState createState() => _MoreOptionsState();
}

class _MoreOptionsState extends State<MoreOptions> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            widget.note.state == NoteState.hidden
                ? unhideIcon(context, widget.note, widget.autoSaver)
                : hideIcon(context, widget.note, widget.autoSaver),
            widget.note.state == NoteState.archived
                ? unarchiveIcon(context, widget.note, widget.autoSaver)
                : archiveIcon(context, widget.note, widget.autoSaver),
            copyIcon(context, widget.note, widget.autoSaver),
          ],
        ),
      ),
    );
  }

  Widget hideIcon(BuildContext context, Note note, Timer autoSaver) {
    return ListTile(
      leading: Icon(
        TablerIcons.ghost,
        color: Colors.blue,
      ),
      title: Text('Hide Note'),
      onTap: () {
        if (myNotes.lockChecker.passwordSet) {
          autoSaver.cancel();
          widget.saveNote();
          Provider.of<NotesHelper>(this.context, listen: false).hideNote(note);
          String whereToNavigate = Utilities.navChecker(note.state);
          Navigator.of(this.context).pushNamedAndRemoveUntil(
              whereToNavigate, (Route<dynamic> route) => false);
        } else {
          showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Set Passcode first'),
              actions: [
                TextButton(
                  child: Text(
                    'Set Now',
                  ),
                  onPressed: () {
                    goToSetPasswordScreen(context);
                  },
                ),
                TextButton(
                  child: Text(
                    'Cancel',
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget unhideIcon(BuildContext context, Note note, Timer autoSaver) {
    return ListTile(
      leading: Icon(
        Icons.inbox_outlined,
        color: Colors.blue,
      ),
      title: Text('Unhide Note'),
      onTap: () {
        autoSaver.cancel();
        widget.saveNote();
        Provider.of<NotesHelper>(this.context, listen: false).unHideNote(note);
        String whereToNavigate = Utilities.navChecker(note.state);
        Navigator.of(this.context).pushNamedAndRemoveUntil(
            whereToNavigate, (Route<dynamic> route) => false);
      },
    );
  }

  Widget archiveIcon(BuildContext context, Note note, Timer autoSaver) {
    return ListTile(
      leading: Icon(
        Icons.archive_outlined,
        color: Colors.blue,
      ),
      title: Text('Archive Note'),
      onTap: () {
        autoSaver.cancel();
        widget.saveNote();
        Provider.of<NotesHelper>(this.context, listen: false).archiveNote(note);
        String whereToNavigate = Utilities.navChecker(note.state);
        Navigator.of(this.context).pushNamedAndRemoveUntil(
            whereToNavigate, (Route<dynamic> route) => false);
      },
    );
  }

  Widget unarchiveIcon(BuildContext context, Note note, Timer autoSaver) {
    return ListTile(
      leading: Icon(
        Icons.unarchive_outlined,
        color: Colors.blue,
      ),
      title: Text('Unarchive Note'),
      onTap: () {
        autoSaver.cancel();
        widget.saveNote();
        Provider.of<NotesHelper>(this.context, listen: false)
            .unarchiveNote(note);
        String whereToNavigate = Utilities.navChecker(note.state);
        Navigator.of(this.context).pushNamedAndRemoveUntil(
            whereToNavigate, (Route<dynamic> route) => false);
      },
    );
  }

  Widget copyIcon(BuildContext context, Note note, Timer autoSaver) {
    return ListTile(
      leading: Icon(
        Icons.copy_outlined,
        color: Colors.blue,
      ),
      title: Text('Copy Note'),
      onTap: () async {
        autoSaver.cancel();
        await widget.saveNote();
        Provider.of<NotesHelper>(this.context, listen: false).copyNote(note);
        String whereToNavigate = Utilities.navChecker(note.state);
        Navigator.of(this.context).pushNamedAndRemoveUntil(
            whereToNavigate, (Route<dynamic> route) => false);
      },
    );
  }
}
