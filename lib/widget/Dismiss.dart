import 'package:flutter/material.dart';
import 'package:notes/database/NotesHelper.dart';
import 'package:notes/database/note.dart';
import 'package:notes/util/Utilites.dart';
import 'package:notes/widget/list_item.dart';
import 'package:provider/provider.dart';

class Dismiss extends StatelessWidget {
  final Note note;
  final NoteState fromWhere;

  const Dismiss({Key key, this.note, this.fromWhere}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Dismissible(
        confirmDismiss: (direction) =>
            promptUser(context, direction, note, fromWhere),
        background: _primaryBack(note.state),
        secondaryBackground: _secondaryBack(note.state),
        dismissThresholds: {
          DismissDirection.startToEnd: 0.7,
          DismissDirection.endToStart: 0.7
        },
        key: UniqueKey(),
        child: ListItem(
          note: note,
          fromWhere: fromWhere,
        ),
      ),
    );
  }

  Widget _primaryBack(NoteState state) {
    if (state == NoteState.deleted) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        alignment: AlignmentDirectional.centerStart,
        child: Icon(
          Icons.delete_forever_outlined,
          color: Colors.redAccent,
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        alignment: AlignmentDirectional.centerStart,
        child: Icon(
          Icons.delete,
          color: Colors.redAccent,
        ),
      );
    }
  }

  Widget _secondaryBack(NoteState noteState) {
    if (noteState == NoteState.archived) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        alignment: AlignmentDirectional.centerEnd,
        child: Icon(
          Icons.unarchive,
          color: Colors.green,
        ),
      );
    } else if (noteState == NoteState.unspecified ||
        noteState == NoteState.pinned) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        alignment: AlignmentDirectional.centerEnd,
        child: Icon(
          Icons.archive,
          color: Colors.green,
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        alignment: AlignmentDirectional.centerEnd,
        child: Icon(
          Icons.inbox_outlined,
          color: Colors.green,
        ),
      );
    }
  }

  Future<bool> promptUser(BuildContext buildContext, DismissDirection direction,
      Note note, NoteState fromWhere) async {
    //TODO add snackbar after dismiss
    String action;
    if (direction == DismissDirection.startToEnd &&
        note.state == NoteState.deleted) {
      action = 'delete permanently';
    } else if (direction == DismissDirection.startToEnd &&
        note.state != NoteState.deleted) {
      action = 'delete';
    } else if (direction == DismissDirection.endToStart &&
        note.state == NoteState.archived) {
      action = 'unarchive';
    } else if (direction == DismissDirection.endToStart &&
        note.state == NoteState.unspecified) {
      action = 'archive';
    } else if (direction == DismissDirection.endToStart &&
        note.state == NoteState.hidden) {
      action = 'unhide';
    } else {
      action = 'undelete';
    }
    return await showDialog<bool>(
        context: buildContext,
        builder: (context) =>
            AlertDialog(
              title: Text('Are you sure you want to $action?'),
              actions: [
                TextButton(
                  child: Text('Yes'),
                  onPressed: () async {
                    if (action == 'delete permanently') {
                      bool value = await Provider.of<NotesHelper>(
                          context, listen: false)
                          .deleteNote(note);
                      if (value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            Utilities.getSnackBar("Note Deleted",Colors.white,
                                Duration(seconds: 1), Colors.green));
                      }
                      else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            Utilities.getSnackBar(
                                "Some error occurred",Colors.white,
                                Duration(seconds: 1), Colors.redAccent));
                      }
                    } else if (action == 'delete') {
                      await Provider.of<NotesHelper>(context, listen: false)
                          .trashNote(
                          note: note,
                          context: context,
                          fromWhere: fromWhere);
                    } else if (action == 'unarchive') {
                      await Provider.of<NotesHelper>(context, listen: false)
                          .unarchiveNote(note);
                    } else if (action == 'archive') {
                      await Provider.of<NotesHelper>(context, listen: false)
                          .archiveNote(note);
                    } else if (action == 'unhide') {
                      await Provider.of<NotesHelper>(context, listen: false)
                          .unhideNote(note);
                    } else {
                      await Provider.of<NotesHelper>(context, listen: false)
                          .undelete(note);
                    }
                    Navigator.of(context).pop(true);
                  },
                ),
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(buildContext).pop(false);
                  },
                ),
              ],
            )) ??
        false; // In case the user dismisses the dialog by clicking away from it
  }
}
