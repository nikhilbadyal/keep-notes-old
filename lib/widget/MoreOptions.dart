import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:notes/database/NotesHelper.dart';
import 'package:notes/database/note.dart';
import 'package:notes/main.dart';
import 'package:provider/provider.dart';

class MoreOptions extends StatefulWidget {
  final Note note;
  final Timer autoSaver;

  MoreOptions(this.note, this.autoSaver);

  @override
  _MoreOptionsState createState() => _MoreOptionsState();
}

class _MoreOptionsState extends State<MoreOptions> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ListTile(
            leading: Icon(
              TablerIcons.ghost,
              color: Colors.blue,
            ),
            title: Text('Hide Note'),
            onTap: () {
              if (!myNotes.lockChecker.passwordSet) {
                errorPopUp(context, "Please set password first.");
                // Navigator.of(context).pop(true);
              }
              widget.autoSaver.cancel();
              Provider.of<NotesHelper>(context, listen: false)
                  .hideNote(widget.note);
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.archive,
              color: Colors.blue,
            ),
            title: Text('Archive Note'),
            onTap: () {
              widget.autoSaver.cancel();
              Provider.of<NotesHelper>(context, listen: false)
                  .archiveNote(widget.note);
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
          ),
          ListTile(
            leading: Icon(
              TablerIcons.copy,
              color: Colors.blue,
            ),
            title: Text('Copy Note'),
            onTap: () {
              widget.autoSaver.cancel();
              Provider.of<NotesHelper>(context, listen: false)
                  .copyNote(widget.note);
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
          ),
        ],
      ),
    );
  }

  static Future<void> errorPopUp(BuildContext context, String data) async {
    await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(data),
        actions: [
          TextButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/setpass', (Route<dynamic> route) => false);
            },
          ),
          TextButton(
            child: Text('Later'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      ),
    );
  }
}
