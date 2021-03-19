import 'package:flutter/material.dart';
import 'package:notes/database/note.dart';
import 'package:notes/util/constants.dart';
import 'package:notes/widget/Navigations.dart';

class Fab extends StatelessWidget {
  final NoteState noteState;

  const Fab(this.noteState);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        goToNoteEditScreen(
            context: context, noteState: noteState, shouldAutoFocus: true);
      },
      tooltip: 'Add Notes',
      child: Icon(Icons.add),
      foregroundColor: Colors.white,
      backgroundColor: headerColor,
    );
  }
}
