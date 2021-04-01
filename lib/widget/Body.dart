import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:notes/database/NotesHelper.dart';
import 'package:notes/database/note.dart';
import 'package:notes/util/DrawerManager.dart';
import 'package:notes/widget/NoNotes.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'list_item.dart';

class Body extends StatefulWidget {
  final NoteState fromWhere;
  final DrawerManager drawerManager;

  // final List<Widget> primary;
  final Function(Note note) primary;

  final Function(Note note) secondary;

  // final List<Widget> secondary;

  const Body({
    Key key,
    @required this.fromWhere,
    this.drawerManager,
    this.primary,
    this.secondary,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('rebuild');
    return FutureBuilder(
      future: Provider.of<NotesHelper>(context, listen: false)
          .getNotesAll(widget.fromWhere.index),
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.done) {
          return Container(
            child: Consumer<NotesHelper>(
                child: noNotesUi(context, widget.fromWhere),
                builder: (context, notehelper, child) {
                  if (notehelper.items.isEmpty) {
                    return child;
                  } else {
                    return Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: AbsorbPointer(
                        absorbing: myNotes.drawerManager.isIgnoring,
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: notehelper.items.length,
                          itemBuilder: (context, index) {
                            final item = notehelper.items[index];
                            return Slidable(
                              key: UniqueKey(),
                              child: ListItem(
                                note: item,
                                fromWhere: widget.fromWhere,
                              ),
                              actions: widget.primary(item),
                              secondaryActions: widget.secondary(item),
                              actionPane: SlidableDrawerActionPane(),
                            );
                            /* return Dismiss(
                              note: item,
                              fromWhere: widget.fromWhere,
                              primary: primary,
                              secondary: secondary,
                            );*/
                          },
                        ),
                      ),
                    );
                  }
                }),
          );
        } else {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Scaffold(
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
