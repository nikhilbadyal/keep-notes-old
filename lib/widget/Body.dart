import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:notes/model/database/NotesHelper.dart';
import 'package:notes/model/note.dart';
import 'package:notes/widget/ItemsList.dart';
import 'package:notes/widget/NoNotes.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  const Body({
    Key key,
    @required this.fromWhere,
    @required this.primary,
    @required this.secondary,
  }) : super(key: key);

  final NoteState fromWhere;

  // final List<Widget> primary;
  final Function(Note note, BuildContext context) primary;

  final Function(Note note, BuildContext context) secondary;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Future _myFuture;

  @override
  Widget build(BuildContext context) {
    assert(widget.fromWhere != NoteState.unspecified);
    //debugPrint('building Body');
    return FutureBuilder(
      future: _myFuture,
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.done) {
          return Consumer<NotesHelper>(
            builder: (context, notehelper, child) {
              if (notehelper.otherNotes.isEmpty) {
                return child;
              } else {
                return NonEmptyUi(
                  notehelper: notehelper,
                  fromWhere: widget.fromWhere,
                  primary: widget.primary,
                  secondary: widget.secondary,
                );
              }
            },
            child: NoNotesUi(
              noteState: widget.fromWhere,
            ),
          );
        } else {
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  @override
  void initState() {
    _myFuture = Provider.of<NotesHelper>(context, listen: false)
        .getNotesAll(widget.fromWhere.index);
    super.initState();
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
  final Function(Note note, BuildContext context) primary;
  final Function(Note note, BuildContext context) secondary;

  @override
  Widget build(BuildContext context) {
    // print('Building list');
    return Padding(
      padding: const EdgeInsets.only(),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: notehelper.otherNotes.length,
        itemBuilder: (context, index) {
          final item = notehelper.otherNotes[index];
          return Slidable(
            key: UniqueKey(),
            actions: primary(item, context),
            secondaryActions: secondary(item, context),
            actionPane: const SlidableDrawerActionPane(),
            child: ListItem(
              note: item,
              fromWhere: fromWhere,
            ),
          );
        },
      ),
    );
  }
}

class HomeBody extends StatelessWidget {
  const HomeBody({
    Key key,
    @required this.primary,
    @required this.secondary,
  }) : super(key: key);

  final Function(Note note, BuildContext context) primary;

  final Function(Note note, BuildContext context) secondary;

  @override
  Widget build(BuildContext context) {
    //debugPrint('building HomeBody');
    return FutureBuilder(
      future: Provider.of<NotesHelper>(context, listen: false)
          .getNotesAll(NoteState.unspecified.index),
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.done) {
          return Consumer<NotesHelper>(
            builder: (context, notehelper, child) {
              if (notehelper.mainItems.isEmpty) {
                return child;
              } else {
                return NonEmptyHomeUi(
                  notehelper: notehelper,
                  primary: primary,
                  secondary: secondary,
                );
              }
            },
            child: const NoNotesUi(
              noteState: NoteState.unspecified,
            ),
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

class NonEmptyHomeUi extends StatelessWidget {
  const NonEmptyHomeUi(
      {Key key,
      @required this.notehelper,
      @required this.primary,
      @required this.secondary})
      : super(key: key);

  final NotesHelper notehelper;

  final Function(Note note, BuildContext context) primary;
  final Function(Note note, BuildContext context) secondary;

  @override
  Widget build(BuildContext context) {
    // print('Building list');
    return Padding(
      padding: const EdgeInsets.only(),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: notehelper.mainItems.length,
        itemBuilder: (context, index) {
          final item = notehelper.mainItems[index];
          return Slidable(
            key: UniqueKey(),
            actions: primary(item, context),
            secondaryActions: secondary(item, context),
            actionPane: const SlidableDrawerActionPane(),
            child: ListItem(
              note: item,
              fromWhere: NoteState.unspecified,
            ),
          );
        },
      ),
    );
  }
}
