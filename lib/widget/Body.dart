import 'package:flutter/material.dart';
import 'package:notes/database/NotesHelper.dart';
import 'package:notes/database/note.dart';
import 'package:notes/util/DrawerManager.dart';
import 'package:notes/widget/Dismiss.dart';
import 'package:notes/widget/NoNotes.dart';
import 'package:provider/provider.dart';

import '../main.dart';


class Body extends StatefulWidget {
  final NoteState fromWhere;
  final DrawerManager drawerManager;

  const Body({Key key, @required this.fromWhere, this.drawerManager})
      : super(key: key);

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
    return FutureBuilder(
      future: Provider.of<NotesHelper>(context, listen: false)
          .getNotesAll(widget.fromWhere.index),
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.done) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
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
                            return Dismiss(
                              note: item,
                              fromWhere: widget.fromWhere,
                            );
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
