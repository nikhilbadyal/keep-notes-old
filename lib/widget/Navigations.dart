import 'package:flutter/material.dart';
import 'package:notes/ScreenHelpers/NoteEditScreen.dart';
import 'package:notes/database/note.dart';
import 'package:notes/screens/SetPassword.dart';
import 'package:notes/util/Utilites.dart';

import '../main.dart';

void goToArchiveScreen(BuildContext context) {
  myNotes.drawerManager.resetDrawerState();
  Navigator.of(context)
      .pushNamedAndRemoveUntil('/archive', (Route<dynamic> route) => false);
}

void goToBackUpScreen(BuildContext context) {
  myNotes.drawerManager.resetDrawerState();

  Navigator.of(context)
      .pushNamedAndRemoveUntil('/backup', (Route<dynamic> route) => false);
}

void goToDeleteScreen(BuildContext context) {
  myNotes.drawerManager.resetDrawerState();

  Navigator.of(context)
      .pushNamedAndRemoveUntil('/trash', (Route<dynamic> route) => false);
}

void goToAboutMeScreen(BuildContext context) {
  myNotes.drawerManager.resetDrawerState();
  Navigator.of(context)
      .pushNamedAndRemoveUntil('/about', (Route<dynamic> route) => false);
}

void goToBugScreen(BuildContext context) {
  myNotes.drawerManager.resetDrawerState();
  Utilities.launchUrl(
    Utilities.emailLaunchUri.toString(),
  );
}

void goToSettingsScreen(BuildContext context) {
  myNotes.drawerManager.resetDrawerState();
  Navigator.of(context)
      .pushNamedAndRemoveUntil('/settings', (Route<dynamic> route) => false);
}

void goToHomeScreen(BuildContext context) {
  myNotes.drawerManager.resetDrawerState();
  Navigator.of(context)
      .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
}

void goToHiddenScreen(BuildContext context) {
  myNotes.drawerManager.resetDrawerState();
  Navigator.of(context)
      .pushNamedAndRemoveUntil('/hidden', (Route<dynamic> route) => false);
}

Future<void> goToLockScreen(BuildContext context) async {
  myNotes.drawerManager.resetDrawerState();

  await Navigator.of(context)
      .pushNamedAndRemoveUntil('/lock', (Route<dynamic> route) => false);
}

Future<void> goToSetPasswordScreen(BuildContext context,
    [String password]) async {
  myNotes.drawerManager.resetDrawerState();

  await Navigator.of(context).pushNamedAndRemoveUntil(
    '/setpass',
    (Route<dynamic> route) => false,
    arguments:
        DataObj(true, password != null ? password : "", "Enter New Password"),
  );
}
/*
void goToSetPasswordScreen(BuildContext context, [String password]) {
  myNotes.drawerManager.resetDrawerState();
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) {
        return SetPassword();
      },
      settings: RouteSettings(
        arguments: DataObj(
            true, password != null ? password : "", "Enter New Password"),
      ),
    ),
  );
}*/

//TODO remove noteState from here
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
