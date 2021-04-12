import 'package:flutter/material.dart';
import 'package:notes/model/note.dart';
import 'package:notes/widget/BottomSheet.dart';
import 'package:notes/widget/Navigations.dart';

class Fab extends StatelessWidget {
  const Fab(this.noteState);

  final NoteState noteState;

  @override
  Widget build(BuildContext context) {
    //debugPrint('FAB building 35');
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: FloatingActionButton(
        onPressed: () async {
          await goToNoteEditScreen(
              context: context, noteState: noteState, shouldAutoFocus: true);
        },
        tooltip: 'Add Note',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TrashFab extends StatelessWidget {
  const TrashFab();

  @override
  Widget build(BuildContext context) {
    //debugPrint('FAB building 35');
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: FloatingActionButton(
        onPressed: () async {
          moreOptions(context);
        },
        tooltip: 'Add Note',
        child: const Icon(Icons.delete_forever_outlined),
      ),
    );
  }
}
