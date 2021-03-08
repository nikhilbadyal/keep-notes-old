import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes/database/note.dart';
import 'package:notes/util/Utilites.dart';
import 'package:notes/widget/Navigations.dart';

Widget bottomBar(BuildContext context, NoteState noteState) {
  return BottomAppBar(
    shape: CircularNotchedRectangle(),
    child: Container(
      height: 60.0,
      padding: EdgeInsets.symmetric(horizontal: 15),
    ),
  );
}

Future<void> pickImageAndGetNote(
    BuildContext context, NoteState noteState, ImageSource source) async {
  String imagePath;
  imagePath = await Utilities.getImage(source);
  goToNoteEditScreen(
      context: context,
      noteState: noteState,
      imagePath: imagePath,
      shouldAutoFocus: false);
}
