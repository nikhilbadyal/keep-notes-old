import 'package:flutter/material.dart';
import 'package:notes/model/note.dart';
import 'package:notes/util/Utilites.dart';
import 'package:notes/views/ScreenHelpers/AboutMeScreen.dart';
import 'package:notes/views/ScreenHelpers/ArchiveScreen.dart';
import 'package:notes/views/ScreenHelpers/BackupRestore.dart';
import 'package:notes/views/ScreenHelpers/HiddenScreen.dart';
import 'package:notes/views/ScreenHelpers/HomeScreen.dart';
import 'package:notes/views/ScreenHelpers/NoteEditScreen.dart';
import 'package:notes/views/ScreenHelpers/SettingsScreen.dart';
import 'package:notes/views/ScreenHelpers/TrashScreen.dart';
import 'package:notes/views/TopWidget.dart';
import 'package:notes/views/screens/SetPassword.dart';

import '../app.dart';

Future<void> goToLockScreen(BuildContext context) async {
  myNotes.drawerManager.resetDrawerState(context);

  await Navigator.of(context)
      .pushNamedAndRemoveUntil('/lock', (Route<dynamic> route) => false);
}

Future<void> goToSetPasswordScreen(BuildContext context,
    [String password]) async {
  myNotes.drawerManager.resetDrawerState(context);
  await Navigator.of(context).pushNamedAndRemoveUntil(
    '/setpass',
    (Route<dynamic> route) => false,
    arguments: DataObj(true, password ?? '', 'Enter New Password'),
  );
}

Future<void> goToHiddenScreen(BuildContext context) async {
  myNotes.drawerManager.resetDrawerState(context);

  await Navigator.pushAndRemoveUntil(
      context,
      FadeInSlideOutRoute(
        builder: (BuildContext context) => ScreenContainer(
          topScreen: HiddenScreenHelper(),
        ),
      ),
      (route) => false);
}

Future<void> goToHomeScreen(BuildContext context) async {
  myNotes.drawerManager.resetDrawerState(context);
  await Navigator.pushAndRemoveUntil(
      context,
      FadeInSlideOutRoute(
        builder: (BuildContext context) => ScreenContainer(
          topScreen: HomeScreenHelper(),
        ),
      ),
      (route) => false);
  /* await Navigator.of(context)
      .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);*/
}

Future<void> goToArchiveScreen(BuildContext context) async {
  myNotes.drawerManager.resetDrawerState(context);

  /* await Navigator.of(context)
      .pushNamedAndRemoveUntil('/archive', (Route<dynamic> route) => false);*/

  await Navigator.pushAndRemoveUntil(
      context,
      FadeInSlideOutRoute(
        builder: (BuildContext context) => ScreenContainer(
          topScreen: ArchiveScreenHelper(),
        ),
      ),
      (route) => false);
}

Future<void> goToBackUpScreen(BuildContext context) async {
  myNotes.drawerManager.resetDrawerState(context);
  await Navigator.pushAndRemoveUntil(
      context,
      FadeInSlideOutRoute(
        builder: (BuildContext context) => ScreenContainer(
          topScreen: BackUpScreenHelper(),
        ),
      ),
      (route) => false);
  /*await Navigator.of(context)
      .pushNamedAndRemoveUntil('/backup', (Route<dynamic> route) => false);*/
}

Future<void> goToDeleteScreen(BuildContext context) async {
  myNotes.drawerManager.resetDrawerState(context);

  await Navigator.pushAndRemoveUntil(
      context,
      FadeInSlideOutRoute(
        builder: (BuildContext context) => ScreenContainer(
          topScreen: TrashScreenHelper(),
        ),
      ),
      (route) => false);
  /* await Navigator.of(context)
      .pushNamedAndRemoveUntil('/trash', (Route<dynamic> route) => false);*/
}

Future<void> goToAboutMeScreen(BuildContext context) async {
  myNotes.drawerManager.resetDrawerState(context);
  await Navigator.pushAndRemoveUntil(
      context,
      FadeInSlideOutRoute(
        builder: (BuildContext context) => const ScreenContainer(
          topScreen: AboutMeScreenHelper(),
        ),
      ),
      (route) => false);

  /*await Navigator.of(context)
      .pushNamedAndRemoveUntil('/about', (Route<dynamic> route) => false);*/
}

Future<void> goToSettingsScreen(BuildContext context) async {
  myNotes.drawerManager.resetDrawerState(context);
  await Navigator.pushAndRemoveUntil(
      context,
      FadeInSlideOutRoute(
        builder: (BuildContext context) => const ScreenContainer(
          topScreen: SettingsScreenHelper(),
        ),
      ),
      (route) => false);

  /* await Navigator.of(context)
      .pushNamedAndRemoveUntil('/settings', (Route<dynamic> route) => false);*/
}

void goToBugScreen(BuildContext context) {
  myNotes.drawerManager.resetDrawerState(context);

  Utilities.launchUrl(
    Utilities.emailLaunchUri.toString(),
  );
}
/*
void goToSetPasswordScreen(BuildContext context, [String password]) {
  myNotes.drawerManager.resetDrawerState(context);
  await Navigator.push(
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
Future<void> goToNoteEditScreen(
    {BuildContext context,
    NoteState noteState,
    String imagePath = '',
    shouldAutoFocus = false}) async {
  var autoFocus = true;
  final emptyNote = Note(
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
  await Navigator.push(
    context,
    FadeInSlideOutRoute(
      builder: (BuildContext context) => EditScreen(
        currentNote: emptyNote,
        shouldAutoFocus: autoFocus,
        fromWhere: noteState,
        isImageNote: imagePath.isNotEmpty || false,
      ),
    ),
  );
}

class FadeInSlideOutRoute<T> extends MaterialPageRoute<T> {
  FadeInSlideOutRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // /*if (settings.) */ return child; //TODO

    if (animation.status == AnimationStatus.reverse) {
      return super
          .buildTransitions(context, animation, secondaryAnimation, child);
    }

    return FadeTransition(opacity: animation, child: child);
  }
}
