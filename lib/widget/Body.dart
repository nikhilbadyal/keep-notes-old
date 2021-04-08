import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:notes/model/database/NotesHelper.dart';
import 'package:notes/model/note.dart';
import 'package:notes/widget/NoNotes.dart';
import 'package:provider/provider.dart';

import '../app.dart';
import 'list_item.dart';

class Body extends StatelessWidget {
  const Body({
    Key key,
    @required @required this.fromWhere,
    @required this.primary,
    @required this.secondary,
  }) : super(key: key);

  final NoteState fromWhere;

  // final List<Widget> primary;
  final Function(Note note) primary;

  final Function(Note note) secondary;

  @override
  Widget build(BuildContext context) {
    //debugPrint('building body');
    return FutureBuilder(
      future: Provider.of<NotesHelper>(context, listen: false)
          .getNotesAll(fromWhere.index),
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.done) {
          return Consumer<NotesHelper>(
            builder: (context, notehelper, child) {
              if (notehelper.items.isEmpty) {
                return child;
              } else {
                return NonEmptyUi(
                  notehelper: notehelper,
                  fromWhere: fromWhere,
                  primary: primary,
                  secondary: secondary,
                );
              }
            },
            child: const NoNotesUi(),
          );
        } else {
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
      },
    );
  }
}

class NonEmptyUi extends StatelessWidget {
  const NonEmptyUi(
      {Key key,
      @required this.notehelper,
      @required this.fromWhere,
      @required this.primary,
      @required this.secondary})
      : super(key: key);

  final NotesHelper notehelper;

  final NoteState fromWhere;
  final Function(Note note) primary;
  final Function(Note note) secondary;

  @override
  Widget build(BuildContext context) {
    //print'Building list');
    return Padding(
      padding: const EdgeInsets.only(),
      child: AbsorbPointer(
        absorbing: myNotes.drawerManager.isIgnoring,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: notehelper.items.length,
          itemBuilder: (context, index) {
            final item = notehelper.items[index];
            return Slidable(
              key: UniqueKey(),
              actions: primary(item),
              secondaryActions: secondary(item),
              actionPane: const SlidableDrawerActionPane(),
              child: ListItem(
                note: item,
                fromWhere: fromWhere,
              ),
            );
          },
        ),
      ),
    );
  }
}
