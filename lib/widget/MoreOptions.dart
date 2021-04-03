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
    debugPrint('building 36');
    return Container(
      height: 200,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            widget.note.state == NoteState.hidden
                ? UnHideIcon(
                    note: widget.note,
                    autoSaver: widget.autoSaver,
                    saveNote: widget.saveNote,
                  )
                : HideIcon(
                    note: widget.note,
                    autoSaver: widget.autoSaver,
                    saveNote: widget.saveNote,
                  ),
            widget.note.state == NoteState.archived
                ? UnArchiveIcon(
                    note: widget.note,
                    autoSaver: widget.autoSaver,
                    saveNote: widget.saveNote,
                  )
                : ArchiveIcon(
                    note: widget.note,
                    autoSaver: widget.autoSaver,
                    saveNote: widget.saveNote,
                  ),
            CopyIcon(
              note: widget.note,
              autoSaver: widget.autoSaver,
              saveNote: widget.saveNote,
            ),
          ],
        ),
      ),
    );
  }
}

class CopyIcon extends StatelessWidget {
  final Note note;
  final Timer autoSaver;
  final Function() saveNote;

  const CopyIcon(
      {Key key,
      @required this.note,
      @required this.autoSaver,
      @required this.saveNote})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('building 37');
    return ListTile(
      leading: const Icon(
        Icons.copy_outlined,
        color: Colors.blue,
      ),
      title: const Text('Copy Note'),
      onTap: () async {
        autoSaver.cancel();
        await saveNote();
        Provider.of<NotesHelper>(context, listen: false).copyNote(note);
        String whereToNavigate = Utilities.navChecker(note.state);
        Navigator.of(context).pushNamedAndRemoveUntil(
            whereToNavigate, (Route<dynamic> route) => false);
      },
    );
  }
}

class UnHideIcon extends StatelessWidget {
  final Note note;
  final Timer autoSaver;
  final Function() saveNote;

  const UnHideIcon(
      {Key key,
      @required this.note,
      @required this.autoSaver,
      @required this.saveNote})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('building 38');
    return ListTile(
      leading: Icon(
        Icons.inbox_outlined,
        color: Colors.blue,
      ),
      title: const Text('Unhide Note'),
      onTap: () {
        autoSaver.cancel();
        saveNote();
        Provider.of<NotesHelper>(context, listen: false).unHideNote(note);
        String whereToNavigate = Utilities.navChecker(note.state);
        Navigator.of(context).pushNamedAndRemoveUntil(
            whereToNavigate, (Route<dynamic> route) => false);
      },
    );
  }
}

class UnArchiveIcon extends StatelessWidget {
  final Note note;
  final Timer autoSaver;
  final Function() saveNote;

  const UnArchiveIcon(
      {Key key,
      @required this.note,
      @required this.autoSaver,
      @required this.saveNote})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('building 39');
    return ListTile(
      leading: Icon(
        Icons.unarchive_outlined,
        color: Colors.blue,
      ),
      title: const Text('Unarchive Note'),
      onTap: () {
        autoSaver.cancel();
        saveNote();
        Provider.of<NotesHelper>(context, listen: false).unarchiveNote(note);
        String whereToNavigate = Utilities.navChecker(note.state);
        Navigator.of(context).pushNamedAndRemoveUntil(
            whereToNavigate, (Route<dynamic> route) => false);
      },
    );
  }
}

class HideIcon extends StatelessWidget {
  final Note note;
  final Timer autoSaver;
  final Function() saveNote;

  const HideIcon(
      {Key key,
      @required this.note,
      @required this.autoSaver,
      @required this.saveNote})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('building 40');
    return ListTile(
      leading: Icon(
        TablerIcons.ghost,
        color: Colors.blue,
      ),
      title: const Text('Hide Note'),
      onTap: () {
        if (myNotes.lockChecker.passwordSet) {
          autoSaver.cancel();
          saveNote();
          Provider.of<NotesHelper>(context, listen: false).hideNote(note);
          String whereToNavigate = Utilities.navChecker(note.state);
          Navigator.of(context).pushNamedAndRemoveUntil(
              whereToNavigate, (Route<dynamic> route) => false);
        } else {
          showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Set Passcode first'),
              actions: [
                TextButton(
                  child: const Text(
                    'Set Now',
                  ),
                  onPressed: () {
                    goToSetPasswordScreen(context);
                  },
                ),
                TextButton(
                  child: const Text(
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
}

class ArchiveIcon extends StatelessWidget {
  final Note note;
  final Timer autoSaver;
  final Function() saveNote;

  const ArchiveIcon(
      {Key key,
      @required this.note,
      @required this.autoSaver,
      @required this.saveNote})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('building 41');
    return ListTile(
      leading: Icon(
        Icons.archive_outlined,
        color: Colors.blue,
      ),
      title: const Text('Archive Note'),
      onTap: () {
        autoSaver.cancel();
        saveNote();
        Provider.of<NotesHelper>(context, listen: false).archiveNote(note);
        String whereToNavigate = Utilities.navChecker(note.state);
        Navigator.of(context).pushNamedAndRemoveUntil(
            whereToNavigate, (Route<dynamic> route) => false);
      },
    );
  }
}
