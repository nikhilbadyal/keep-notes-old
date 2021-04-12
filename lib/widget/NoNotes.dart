import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:notes/model/note.dart';
import 'package:notes/widget/Navigations.dart';

class NoNotesUi extends StatelessWidget {
  const NoNotesUi({Key key, this.noteState}) : super(key: key);
  final NoteState noteState;

  @override
  Widget build(BuildContext context) {
    //debugPrint('building 17');
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const ImageWig(),
            if (noteState == NoteState.deleted)
              Center(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600,
                    ),
                    children: [
                      TextSpan(
                        text: 'Nothing here',
                        style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1.color),
                      ),
                    ],
                  ),
                ),
              )
            else
              Center(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600,
                    ),
                    children: [
                      TextSpan(
                        text: '\t\t\t\t\t\t\t\t\t\t\t\tNothing here\n',
                        style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1.color),
                      ),
                      TextSpan(
                        text: 'Tap on "',
                        style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1.color),
                      ),
                      TextSpan(
                          text: '+',
                          style: TextStyle(
                            fontSize: 30.0,
                            color: Theme.of(context)
                                .floatingActionButtonTheme
                                .backgroundColor,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              goToNoteEditScreen(
                                  context: context,
                                  noteState: NoteState.unspecified);
                            }),
                      TextSpan(
                        text: '" to add new note',
                        style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1.color),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ImageWig extends StatelessWidget {
  const ImageWig();

  @override
  Widget build(BuildContext context) {
    //debugPrint('building 16');
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width * 0.5,
      child: Image.asset(
        'assets/images/noNotes.png',
        fit: BoxFit.contain,
        width: 120.0,
        height: 200.0,
      ),
    );
  }
}
