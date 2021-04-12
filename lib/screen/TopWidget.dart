import 'package:flutter/material.dart';
import 'package:notes/model/note.dart';
import 'package:notes/screen/AboutMeScreen.dart';
import 'package:notes/screen/BackupRestore.dart';
import 'package:notes/screen/LockScreen.dart';
import 'package:notes/screen/SetPassword.dart';
import 'package:notes/screen/SettingsScreen.dart';
import 'package:notes/screen/TopWidgetBase.dart';
import 'package:notes/util/Utilites.dart';
import 'package:notes/widget/AppBar.dart';
import 'package:notes/widget/Body.dart';
import 'package:notes/widget/FloatingActionButton.dart';
import 'package:notes/widget/MyDrawer.dart';

typedef slidableActions = Function(Note note, BuildContext context);
typedef actionGen = Widget Function(Note note, BuildContext context);

class ScreenContainer extends TopWidgetBase {
  const ScreenContainer({Key key, this.topScreen}) : super(key: key);
  final ScreenTypes topScreen;

  @override
  Widget get myDrawer {
    switch (topScreen) {
      case ScreenTypes.Lock:
        return null;
        break;
      case ScreenTypes.Setpass:
        return null;
        break;
      default:
        return MyDrawer();
        break;
    }
  }

  @override
  Widget get appBar {
    switch (topScreen) {
      case ScreenTypes.Hidden:
        return const MyAppBar(
          title: Text('Hidden'),
        );
        break;

      case ScreenTypes.Home:
        return const MyAppBar(
          title: Text('Notes'),
        );
        break;

      case ScreenTypes.Archive:
        return const MyAppBar(
          title: Text('Archive'),
        );
        break;

      case ScreenTypes.Backup:
        return const MyAppBar(
          title: Text('Backup and Restore'),
        );
        break;

      case ScreenTypes.Trash:
        return const MyAppBar(
          title: Text('Trash'),
        );
        break;
      case ScreenTypes.AboutMe:
        return const MyAppBar(
          title: Text('About'),
          // TODO add attribution
          /*appBarWidget: IconButton(
              icon: const Icon(TablerIcons.license, color: Colors.green),
              onPressed: () {
                const LicensePage(
                  applicationName: 'My Notes',
                );
              },
            )*/
        );
        break;

      case ScreenTypes.Settings:
        return const MyAppBar(
          title: Text('Settings'),
        );
        break;
      default:
        return null;
        break;
    }
  }

  @override
  Widget get floatingActionButton {
    switch (topScreen) {
      case ScreenTypes.Hidden:
        return const Fab(NoteState.hidden);
        break;
      case ScreenTypes.Home:
        return const Fab(NoteState.unspecified);
        break;
      case ScreenTypes.Archive:
        return const Fab(NoteState.archived);
        break;
      case ScreenTypes.Trash:
        return const TrashFab();
        break;
      default:
        return null;
        break;
    }
  }

  /*@override
  Widget get bottomNavigationBar {
    switch (topScreen) {
      case ScreenTypes.Trash:
        return null;
        break;
      case ScreenTypes.Lock:
        return null;
        break;
      case ScreenTypes.Setpass:
        return null;
        break;
      default:
        return const BottomBar();
        break;
    }
  }*/

  @override
  Widget get body {
    switch (topScreen) {
      case ScreenTypes.Backup:
        return const BackUpScreenHelper();
        break;
      case ScreenTypes.AboutMe:
        return const AboutMe();
        break;
      case ScreenTypes.Settings:
        return const SettingsScreenHelper();
        break;
      case ScreenTypes.Lock:
        return const LockScreen();
        break;
      case ScreenTypes.Setpass:
        return const SetPassword();
        break;
      case ScreenTypes.Home:
        final primary = getPrimary(topScreen);
        final secondary = getSecondary(topScreen);
        return HomeBody(
          primary: primary,
          secondary: secondary,
        );
        break;
      default:
        final notesType = getNotesType(topScreen);
        final primary = getPrimary(topScreen);
        final secondary = getSecondary(topScreen);
        return Body(
          fromWhere: notesType,
          primary: primary,
          secondary: secondary,
        );
        break;
    }
  }

  NoteState getNotesType(ScreenTypes topScreen) {
    switch (topScreen) {
      case ScreenTypes.Hidden:
        return NoteState.hidden;
        break;
      case ScreenTypes.Archive:
        return NoteState.archived;
        break;
      case ScreenTypes.Trash:
        return NoteState.deleted;
        break;
      default:
        return NoteState.unspecified;
        break;
    }
  }

  List<Widget> homePrimary(Note note, BuildContext context) {
    final actionList = <Widget>[];
    actionList.add(
      Utilities.hideAction(context, note),
    );
    actionList.add(
      Utilities.archiveAction(context, note),
    );
    return actionList;
  }

  List<Widget> homeSecondary(Note note, BuildContext context) {
    final actionList = <Widget>[];
    actionList.add(
      Utilities.copyAction(context, note),
    );
    actionList.add(
      Utilities.trashAction(context, note),
    );
    return actionList;
  }

  List<Widget> hiddenPrimary(Note note, BuildContext context) {
    final actionList = <Widget>[];
    actionList.add(
      Utilities.unHideAction(context, note),
    );
    return actionList;
  }

  List<Widget> hiddenSecondary(Note note, BuildContext context) {
    final actionList = <Widget>[];
    actionList.add(
      Utilities.trashAction(context, note),
    );
    return actionList;
  }

  List<Widget> archivePrimary(Note note, BuildContext context) {
    final actionList = <Widget>[];
    actionList.add(
      Utilities.hideAction(context, note),
    );
    actionList.add(
      Utilities.unArchiveAction(context, note),
    );
    return actionList;
  }

  List<Widget> archiveSecondary(Note note, BuildContext context) {
    final actionList = <Widget>[];
    actionList.add(
      Utilities.copyAction(context, note),
    );
    actionList.add(
      Utilities.trashAction(context, note),
    );
    return actionList;
  }

  List<Widget> trashSecondary(Note note, BuildContext context) {
    final actionList = <Widget>[];
    actionList.add(
      Utilities.deleteAction(context, note),
    );
    return actionList;
  }

  List<Widget> trashPrimary(Note note, BuildContext context) {
    final actionList = <Widget>[];
    actionList.add(
      Utilities.restoreAction(context, note),
    );
    return actionList;
  }

  slidableActions getPrimary(ScreenTypes topScreen) {
    switch (topScreen) {
      case ScreenTypes.Hidden:
        return hiddenPrimary;
        break;
      case ScreenTypes.Archive:
        return archivePrimary;
        break;
      case ScreenTypes.Trash:
        return trashPrimary;
        break;
      default:
        return homePrimary;
        break;
    }
  }

  slidableActions getSecondary(ScreenTypes topScreen) {
    switch (topScreen) {
      case ScreenTypes.Hidden:
        return hiddenSecondary;
        break;
      case ScreenTypes.Archive:
        return archiveSecondary;
        break;
      case ScreenTypes.Trash:
        return trashSecondary;
        break;
      default:
        return homeSecondary;
        break;
    }
  }

/*@override
  Widget get bottomSheet {
    switch (topScreen) {
      case ScreenTypes.Trash:
        return MyBottomSheet();
        break;
      default:
        return null;
        break;
    }
  }*/
}
