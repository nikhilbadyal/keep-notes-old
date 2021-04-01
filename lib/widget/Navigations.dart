import 'package:flutter/material.dart';
import 'package:notes/ScreenHelpers/NoteEditScreen.dart';
import 'package:notes/database/note.dart';
import 'package:notes/screens/SetPassword.dart';
import 'package:notes/util/Utilites.dart';

import '../main.dart';

void goTOArchiveScreen(BuildContext context) {
  myNotes.drawerManager.resetDrawerState();
  Navigator.of(context)
      .pushNamedAndRemoveUntil('/archive', (Route<dynamic> route) => false);
}

void goToBackUpScreen(BuildContext context) {
  myNotes.drawerManager.resetDrawerState();

  Navigator.of(context)
      .pushNamedAndRemoveUntil('/backup', (Route<dynamic> route) => false);
}

void goTODeleteScreen(BuildContext context) {
  myNotes.drawerManager.resetDrawerState();

  Navigator.of(context)
      .pushNamedAndRemoveUntil('/trash', (Route<dynamic> route) => false);
}

void goTOAboutMeScreen(BuildContext context) {
  myNotes.drawerManager.resetDrawerState();
  Navigator.of(context)
      .pushNamedAndRemoveUntil('/about', (Route<dynamic> route) => false);
}

void goTOBugScreen(BuildContext context) {
  myNotes.drawerManager.resetDrawerState();
  Utilities.launchUrl(
    Utilities.emailLaunchUri.toString(),
  );
}

void goTOHomeScreen(BuildContext context) {
  myNotes.drawerManager.resetDrawerState();
  Navigator.of(context)
      .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
}

void goTOHiddenScreen(BuildContext context) {
  myNotes.drawerManager.resetDrawerState();
  Navigator.of(context)
      .pushNamedAndRemoveUntil('/hidden', (Route<dynamic> route) => false);
}

Future<void> goToLockScreen(BuildContext context) async {
  myNotes.drawerManager.resetDrawerState();

  await Navigator.of(context)
      .pushNamedAndRemoveUntil('/lock', (Route<dynamic> route) => false);
}

void goToSetPasswordScreen(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => SetPassword(),
      settings: RouteSettings(
        arguments: DataObj(true, "", "Enter New Password"),
      ),
    ),
  );
}

void goToBiometricSetup(BuildContext context) {
  Navigator.of(context)
      .pushNamedAndRemoveUntil('/setpass', (Route<dynamic> route) => false);
}

void goToNoteEditScreen(
    {BuildContext context,
    NoteState noteState,
    String imagePath = '',
    shouldAutoFocus = false}) {
  var autoFocus = true;
  var emptyNote = Note(
    id: -1,
    title: '',
    content: '',
    creationDate: DateTime.now(),
    lastModify: DateTime.now(),
    color: Colors.white,
    state: noteState,
    imagePath: imagePath,
  );
  if (emptyNote.imagePath != '') {
    autoFocus = false;
  }
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditScreen(
          currentNote: emptyNote,
          shouldAutoFocus: autoFocus,
          fromWhere: noteState,
          isImageNote: imagePath == '' ? false : true,
        ),
      ));
}
