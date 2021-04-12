import 'package:flutter/material.dart';
import 'package:notes/model/note.dart';
import 'package:notes/screen/EditScreen.dart';
import 'package:notes/util/AppRoutes.dart';
import 'package:notes/util/Utilites.dart';

Future navigate(String activeRoute, BuildContext context, String route,
    [Object arguments]) async {
  if (activeRoute == route && route != NotesRoutes.setpassScreen) {
    return Navigator.pop(context);
  }
  if (route == NotesRoutes.homeScreen) {
    await Navigator.pushNamedAndRemoveUntil(
        context, route, (Route<dynamic> route) => false,
        arguments: arguments);
  } else {
    if (activeRoute == '/') {
      Navigator.pop(context);
      await Navigator.pushNamed(context, route, arguments: arguments);
    } else {
      await Navigator.pushReplacementNamed(context, route,
          arguments: arguments);
    }
  }
}

void goToBugScreen(BuildContext context) {
  //debugPrint('launching');
  Utilities.launchUrl(
    Utilities.emailLaunchUri.toString(),
  );
}

//TODO remove noteState from here
Future<void> goToNoteEditScreen(
    {BuildContext context,
    NoteState noteState,
    String imagePath = '',
    shouldAutoFocus = false}) async {
  // var autoFocus = true;
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
  // if (emptyNote.imagePath != '') {
  //   autoFocus = false;
  // }
  await Navigator.push(
    context,
    FadeInSlideOutRoute(
      builder: (BuildContext context) => EditScreen(
        currentNote: emptyNote,
        shouldAutoFocus: shouldAutoFocus,
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
