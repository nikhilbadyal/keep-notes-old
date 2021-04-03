import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:notes/database/note.dart';
import 'package:notes/util/constants.dart';
import 'package:notes/widget/Navigations.dart';

class NoNotesUi extends StatelessWidget {
  const NoNotesUi({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('building 17');
    return Center(
      child: ListView(
        children: [
          const ImageWig(),
          Center(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 22.0,
                  color: black2,
                  fontWeight: FontWeight.w600,
                ),
                children: [
                  const TextSpan(text: ' Nothing here\nTap on "'),
                  TextSpan(
                      text: '+',
                      style: const TextStyle(
                        fontSize: 30.0,
                        color: headerColor,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          goToNoteEditScreen(
                              context: context,
                              noteState: NoteState.unspecified);
                        }),
                  const TextSpan(text: '" to add new note'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ImageWig extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    debugPrint('building 16');
    return Container(
      child: Image.asset(
        'assets/images/crying_emoji.png',
        fit: BoxFit.contain,
        width: 120.0,
        height: 200.0,
      ),
    );
  }

  const ImageWig();
}
