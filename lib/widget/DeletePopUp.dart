import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notes/model/database/NotesHelper.dart';
import 'package:notes/model/note.dart';
import 'package:provider/provider.dart';

import '../app.dart';

class DeletePopUp extends StatelessWidget {
  const DeletePopUp(this.toBeDeleted, this.autoSaver, this.fromWhere);

  final Note toBeDeleted;
  final Timer autoSaver;
  final NoteState fromWhere;

  @override
  Widget build(BuildContext context) {
    //debugPrint('building 33');
    var toWhere = '/';
    final currentScreen = myNotes.myRouteObserver.currentScreen;
    switch (currentScreen) {
      case '/':
        {
          toWhere = '/';
        }
        break;
      case '/archive':
        {
          toWhere = '/archive';
        }
        break;
      case '/trash':
        {
          toWhere = '/trash';
        }
        break;
      case '/hidden':
        {
          toWhere = '/hidden';
        }
        break;
    }
    return AlertDialog(
      title: const Text('Delete'),
      actions: [
        TextButton(
          onPressed: () async {
            autoSaver.cancel();
            await Provider.of<NotesHelper>(context, listen: false)
                .trashNote(note: toBeDeleted);
            await Navigator.of(context).pushNamedAndRemoveUntil(
                toWhere, (Route<dynamic> route) => false);
          },
          child: const Text('Yes'),
        ),
        TextButton(
          onPressed: () async {
            Provider.of<NotesHelper>(context, listen: false).falseDelete();
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
