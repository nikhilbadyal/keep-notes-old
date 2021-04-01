import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:notes/database/note.dart';
import 'package:notes/util/constants.dart';
import 'package:notes/widget/Navigations.dart';

Widget noNotesUi(BuildContext context, NoteState noteState) {
  if (noteState == NoteState.deleted) {
    return Center(
      child: ListView(
        children: [
          image(),
          Center(
            child: RichText(
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
          ),
        ],
      ),
    );
  } else {
    return Center(
      child: ListView(
        children: [
          image(),
          Center(
            child: RichText(
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
          ),
        ],
      ),
    );
  }
}

Widget image() {
  return Container(
    child: Image.asset(
      'assets/images/crying_emoji.png',
      fit: BoxFit.contain,
      width: 120.0,
      height: 200.0,
    ),
  );
}
