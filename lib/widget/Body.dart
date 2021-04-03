import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:notes/database/NotesHelper.dart';
import 'package:notes/database/note.dart';
import 'package:notes/widget/NoNotes.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'list_item.dart';

class Body extends StatelessWidget {
  final NoteState fromWhere;

  // final List<Widget> primary;
  final Function(Note note) primary;

  final Function(Note note) secondary;

  const Body({
    Key key,
    @required @required this.fromWhere,
    @required this.primary,
    @required this.secondary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('building body');
    return FutureBuilder(
      future: Provider.of<NotesHelper>(context, listen: false)
          .getNotesAll(fromWhere.index),
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.done) {
          return Container(
            child: Consumer<NotesHelper>(
                child: const NoNotesUi(),
                builder: (context, notehelper, child) {
                  if (notehelper.items.isEmpty) {
                    return child;
                  } else {
                    return nonEmptyUi(
                      notehelper: notehelper,
                      fromWhere: fromWhere,
                      primary: primary,
                      secondary: secondary,
                    );
                  }
                }),
          );
        } else {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: const Scaffold(
              body: const Center(
                child: const CircularProgressIndicator(),
              ),
            ),
          );
        }
      },
    );
  }
}

class nonEmptyUi extends StatelessWidget {
  final NotesHelper notehelper;

  final NoteState fromWhere;
  final Function(Note note) primary;
  final Function(Note note) secondary;

  const nonEmptyUi(
      {Key key,
      @required this.notehelper,
      @required this.fromWhere,
      @required this.primary,
      @required this.secondary})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Building list');
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: AbsorbPointer(
        absorbing: myNotes.drawerManager.isIgnoring,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: notehelper.items.length,
          itemBuilder: (context, index) {
            final item = notehelper.items[index];
            return Slidable(
              key: UniqueKey(),
              child: ListItem(
                note: item,
                fromWhere: fromWhere,
              ),
              actions: primary(item),
              secondaryActions: secondary(item),
              actionPane: const SlidableDrawerActionPane(),
            );
          },
        ),
      ),
    );
  }
}
