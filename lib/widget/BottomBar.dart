import 'package:flutter/material.dart';
import 'package:notes/database/note.dart';

Widget bottomBar(BuildContext context, NoteState noteState) {
  return BottomAppBar(
    shape: CircularNotchedRectangle(),
    child: Container(
      height: 60.0,
      padding: EdgeInsets.symmetric(horizontal: 15),
    ),
  );
}
