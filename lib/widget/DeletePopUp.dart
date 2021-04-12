import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notes/model/database/NotesHelper.dart';
import 'package:notes/model/note.dart';
import 'package:notes/util/AppRoutes.dart';
import 'package:notes/util/Utilites.dart';

class DeletePopUp extends StatelessWidget {
  const DeletePopUp(this.toBeDeleted, this.autoSaver, this.fromWhere);

  final Note toBeDeleted;
  final Timer autoSaver;
  final NoteState fromWhere;

  @override
  Widget build(BuildContext context) {
    final toWhere = getToWhere();
    return MyAlertDialog(
      title: const Text('Delete'),
      actions: [
        TextButton(
          onPressed: () async {
            autoSaver.cancel();
            await Utilities.onTrashTap(context, toBeDeleted);
            Navigator.popUntil(
              context,
              (Route<dynamic> route) {
                return route.settings.name == toWhere;
              },
            );
          },
          child: const Text('Sure'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  String getToWhere() {
    switch (toBeDeleted.state) {
      case NoteState.archived:
        return NotesRoutes.archiveScreen;
        break;
      case NoteState.hidden:
        return NotesRoutes.hiddenScreen;
        break;
      case NoteState.deleted:
        return NotesRoutes.trashScreen;
        break;
      default:
        return '/';
        break;
    }
  }
}
