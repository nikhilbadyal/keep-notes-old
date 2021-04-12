import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:notes/app.dart';
import 'package:notes/model/database/NotesHelper.dart';
import 'package:notes/model/note.dart';
import 'package:notes/util/AppRoutes.dart';
import 'package:notes/util/Utilites.dart';
import 'package:notes/widget/Navigations.dart';
import 'package:provider/provider.dart';

class MoreOptions extends StatefulWidget {
  const MoreOptions(this.note, this.autoSaver, this.saveNote);

  final Note note;
  final Timer autoSaver;
  final Function() saveNote;

  @override
  _MoreOptionsState createState() => _MoreOptionsState();
}

class _MoreOptionsState extends State<MoreOptions> {
  @override
  Widget build(BuildContext context) {
    //debugPrint('building 36');
    return SizedBox(
      height: 200,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            if (widget.note.state == NoteState.hidden)
              UnHideIcon(
                note: widget.note,
                autoSaver: widget.autoSaver,
                saveNote: widget.saveNote,
              )
            else
              HideIcon(
                note: widget.note,
                autoSaver: widget.autoSaver,
                saveNote: widget.saveNote,
              ),
            if (widget.note.state == NoteState.archived)
              UnArchiveIcon(
                note: widget.note,
                autoSaver: widget.autoSaver,
                saveNote: widget.saveNote,
              )
            else
              ArchiveIcon(
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
  const CopyIcon(
      {Key key,
      @required this.note,
      @required this.autoSaver,
      @required this.saveNote})
      : super(key: key);

  final Note note;
  final Timer autoSaver;
  final Function() saveNote;

  @override
  Widget build(BuildContext context) {
    //debugPrint('building 37');
    return ListTile(
      leading: Icon(
        Icons.copy_outlined,
        color: Utilities.iconColor(),
      ),
      title: const Text('Copy Note'),
      onTap: () async {
        autoSaver.cancel();
        await saveNote();
        final whereToNavigate = Utilities.navChecker(note.state);
        await Provider.of<NotesHelper>(context, listen: false)
            .copyNoteHelper(note);
        await navigate(
            ModalRoute.of(context).settings.name, context, whereToNavigate);
      },
    );
  }
}

class UnHideIcon extends StatelessWidget {
  const UnHideIcon(
      {Key key,
      @required this.note,
      @required this.autoSaver,
      @required this.saveNote})
      : super(key: key);

  final Note note;
  final Timer autoSaver;
  final Function() saveNote;

  @override
  Widget build(BuildContext context) {
    //debugPrint('building 38');
    return ListTile(
      leading: Icon(
        Icons.inbox_outlined,
        color: Utilities.iconColor(),
      ),
      title: const Text('Unhide Note'),
      onTap: () async {
        autoSaver.cancel();
        saveNote();
        final whereToNavigate = Utilities.navChecker(note.state);
        await Provider.of<NotesHelper>(context, listen: false)
            .unhideNoteHelper(note);
        await navigate(
            ModalRoute.of(context).settings.name, context, whereToNavigate);
      },
    );
  }
}

class UnArchiveIcon extends StatelessWidget {
  const UnArchiveIcon(
      {Key key,
      @required this.note,
      @required this.autoSaver,
      @required this.saveNote})
      : super(key: key);

  final Note note;
  final Timer autoSaver;
  final Function() saveNote;

  @override
  Widget build(BuildContext context) {
    //debugPrint('building 39');
    return ListTile(
      leading: Icon(
        Icons.unarchive_outlined,
        color: Utilities.iconColor(),
      ),
      title: const Text('Unarchive Note'),
      onTap: () async {
        autoSaver.cancel();
        saveNote();
        final whereToNavigate = Utilities.navChecker(note.state);

        await Provider.of<NotesHelper>(context, listen: false)
            .unarchiveNoteHelper(note);
        await navigate(
            ModalRoute.of(context).settings.name, context, whereToNavigate);
      },
    );
  }
}

class HideIcon extends StatelessWidget {
  const HideIcon(
      {Key key,
      @required this.note,
      @required this.autoSaver,
      @required this.saveNote})
      : super(key: key);

  final Note note;
  final Timer autoSaver;
  final Function() saveNote;

  @override
  Widget build(BuildContext context) {
    //debugPrint('building 40');
    return ListTile(
      leading: Icon(
        TablerIcons.ghost,
        color: Utilities.iconColor(),
      ),
      title: const Text('Hide Note'),
      onTap: () async {
        if (myNotes.lockChecker.passwordSet) {
          autoSaver.cancel();
          saveNote();
          final whereToNavigate = Utilities.navChecker(note.state);
          await Provider.of<NotesHelper>(context, listen: false)
              .hideNoteHelper(note);
          await navigate(
              ModalRoute.of(context).settings.name, context, whereToNavigate);
        } else {
          await showDialog<bool>(
            context: context,
            builder: (context) => MyAlertDialog(
              title: const Text('Set Passcode first'),
              actions: [
                TextButton(
                  onPressed: () async {
                    await navigate(ModalRoute.of(context).settings.name,
                        context, NotesRoutes.setpassScreen);
                  },
                  child: const Text(
                    'Set Now',
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text(
                    'Cancel',
                  ),
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
  const ArchiveIcon(
      {Key key,
      @required this.note,
      @required this.autoSaver,
      @required this.saveNote})
      : super(key: key);

  final Note note;
  final Timer autoSaver;
  final Function() saveNote;

  @override
  Widget build(BuildContext context) {
    //debugPrint('building 41');
    return ListTile(
      leading: Icon(
        Icons.archive_outlined,
        color: Utilities.iconColor(),
      ),
      title: const Text('Archive Note'),
      onTap: () async {
        autoSaver.cancel();
        saveNote();
        final whereToNavigate = Utilities.navChecker(note.state);
        await Provider.of<NotesHelper>(context, listen: false)
            .archiveNoteHelper(note);
        await navigate(
            ModalRoute.of(context).settings.name, context, whereToNavigate);
      },
    );
  }
}
