import 'package:flutter/material.dart';
import 'package:notes/model/note.dart';
import 'package:notes/util/constants.dart';
import 'package:notes/widget/Navigations.dart';

class Fab extends StatelessWidget {
  const Fab(this.noteState);

  final NoteState noteState;

  @override
  Widget build(BuildContext context) {
    // debugPrint('FAB building 35');
    return FloatingActionButton(
      onPressed: () async {
        await goToNoteEditScreen(
            context: context, noteState: noteState, shouldAutoFocus: true);
      },
      tooltip: 'Add Notes',
      foregroundColor: Colors.white,
      backgroundColor: headerColor,
      child: const Icon(Icons.add),
    );
  }
}
