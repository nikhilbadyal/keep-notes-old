import 'package:flutter/material.dart';
import 'package:notes/ScreenHelpers/NoteEditScreen.dart';
import 'package:notes/database/note.dart';
import 'package:notes/main.dart';
import 'package:notes/screens/LockScreen.dart';
import 'package:notes/util/Utilites.dart';

//TODO optimize screen jumping
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

  Navigator.of(context)
      .pushNamedAndRemoveUntil('/suggestions', (Route<dynamic> route) => false);
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
  if (LockChecker.bioEnabled) {
    await Utilities.isBioAvailable();
    await Utilities.getListOfBiometricTypes();
    await Utilities.authenticateUser(context);
  } else {
    await Navigator.of(context)
        .pushNamedAndRemoveUntil('/lock', (Route<dynamic> route) => false);
  }
}

void goToSetPasswordScreen(BuildContext context) {
  myNotes.drawerManager.resetDrawerState();
  Navigator.of(context)
      .pushNamedAndRemoveUntil('/setpass', (Route<dynamic> route) => false);
}

void goToBiometricSetup(BuildContext context) {
  myNotes.drawerManager.resetDrawerState();
  Navigator.of(context)
      .pushNamedAndRemoveUntil('/setpass', (Route<dynamic> route) => false);
}

void goToNoteEditScreen(
    {BuildContext context,
    NoteState noteState,
    String imagePath = '',
    shouldAutoFocus = false}) {
  myNotes.drawerManager.resetDrawerState();
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
              )));
}
