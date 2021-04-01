import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:notes/database/note.dart';
import 'package:notes/widget/list_item.dart';

class Dismiss extends StatelessWidget {
  final Note note;
  final NoteState fromWhere;
  final List<Widget> primary;
  final List<Widget> secondary;

  const Dismiss(
      {Key key, this.note, this.fromWhere, this.primary, this.secondary})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: UniqueKey(),
      child: ListItem(
        note: note,
        fromWhere: fromWhere,
      ),
      actions: primary,
      secondaryActions: secondary,
      actionPane: SlidableDrawerActionPane(),
    );
    /*return GestureDetector(
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
    );*/
  }


}
