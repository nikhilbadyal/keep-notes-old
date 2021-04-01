import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notes/database/NotesHelper.dart';
import 'package:notes/database/note.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class DeletePopUp extends StatelessWidget {
  final Note toBeDeleted;
  final Timer autoSaver;
  final NoteState fromWhere;

  DeletePopUp(this.toBeDeleted, this.autoSaver, this.fromWhere);

  @override
  Widget build(BuildContext context) {
    var toWhere = '/';
    String currentScreen = myNotes.myRouteObserver.currentScreen;
    switch (currentScreen) {
      case "/":
        {
          toWhere = '/';
        }
        break;
      case "/archive":
        {
          toWhere = '/archive';
        }
        break;
      case "/trash":
        {
          toWhere = '/trash';
        }
        break;
      case "/hidden":
        {
          toWhere = '/hidden';
        }
        break;
    }
    return AlertDialog(
      title: Text('Delete'),
      actions: [
        TextButton(
          child: Text('Yes'),
          onPressed: () {
            autoSaver.cancel();
            Provider.of<NotesHelper>(context, listen: false)
                .trashNote(note: toBeDeleted);
            Navigator.of(context).pushNamedAndRemoveUntil(
                toWhere, (Route<dynamic> route) => false);
          },
        ),
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Provider.of<NotesHelper>(context, listen: false).falseDelete();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
