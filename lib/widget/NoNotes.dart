import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:notes/database/note.dart';
import 'package:notes/util/constants.dart';
import 'package:notes/widget/Navigations.dart';

Widget noNotesUi(BuildContext context, NoteState noteState) {
  if (noteState == NoteState.deleted) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: _image(),
          ),
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 22.0,
                color: black2,
                fontWeight: FontWeight.w600,
              ),
              children: [
                TextSpan(text: ' No Deleted Notes'),
              ],
            ),
          ),
        ],
      ),
    );
  }
  return Center(
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Image.asset(
            'assets/images/crying_emoji.png',
            fit: BoxFit.cover,
            width: 200.0,
            height: 200.0,
          ),
        ),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 22.0,
              color: black2,
              fontWeight: FontWeight.w600,
            ),
            children: [
              TextSpan(text: ' There is no note available\nTap on "'),
              TextSpan(
                  text: '+',
                  style: TextStyle(
                    fontSize: 30.0,
                    color: headerColor,
                    fontWeight: FontWeight.bold,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      goToNoteEditScreen(
                          context: context, noteState: noteState);
                    }),
              TextSpan(text: '" to add new note'),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _image() {
  return Image.asset(
    'assets/images/crying_emoji.png',
    fit: BoxFit.fill,
    width: 200.0,
    height: 250.0,
  );
}
