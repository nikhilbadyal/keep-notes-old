import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notes/database/NotesHelper.dart';
import 'package:notes/database/note.dart';
import 'package:notes/widget/PopUp.dart';
import 'package:provider/provider.dart';

class DeletePopUp extends StatelessWidget {
  final Note toBeDeleted;
  final Timer autoSaver;
  final NoteState fromWhere;

  DeletePopUp(this.toBeDeleted, this.autoSaver, this.fromWhere);

  @override
  Widget build(BuildContext context) {
    var toWhere = '/';
    if (fromWhere.index == 2) {
      toWhere = '/archive';
    } else {
      toWhere = '/hidden';
    }
    return CustomDialog(
      title: "Delete",
      descriptions: "Delete the note",
      firstOption: "Yes",
      secondOption: "Cancel",
      onFirstPressed: () {
        autoSaver.cancel();
        Provider.of<NotesHelper>(context, listen: false).trashNote(
            note: toBeDeleted, context: context, fromWhere: fromWhere);
        Navigator.of(context)
            .pushNamedAndRemoveUntil(toWhere, (Route<dynamic> route) => false);
      },
      onSecondPressed: () {
        Provider.of<NotesHelper>(context, listen: false).falseDelete();
        Navigator.of(context).pop();
        //Navigator.popUntil(context, ModalRoute.withName('/'));
      },
    );
  }
}
