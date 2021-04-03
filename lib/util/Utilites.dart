import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:local_auth/local_auth.dart';
import 'package:notes/database/NotesHelper.dart';
import 'package:notes/database/note.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';

class Utilities {
  static final LocalAuthentication _localAuthentication = LocalAuthentication();
  static SharedPreferences prefs;
  static const Color uiColor1 = Color(0xFFFD5872);
  static const Color uiColor2 = Colors.blue;
  static const double padding = 20;
  static const double avatarRadius = 45;
  static const passLength = 4;
  static const Color dialogColor = Colors.white;

  static Future<bool> isBioAvailable() async {
    var isAvailable = false;
    try {
      isAvailable = await _localAuthentication.canCheckBiometrics;
    } on PlatformException catch (_) {}
    return isAvailable;
  }

  static SnackBar getExitSnackBar(BuildContext context, String data) {
    return SnackBar(
      action: SnackBarAction(
        textColor: Colors.white,
        label: "Reset?",
        onPressed: () async {
          showDialog<bool>(
            context: context,
            builder: (context) => Center(
              child: SingleChildScrollView(
                child: AlertDialog(
                  title: const Text(
                      'Passcode cant be reset. Delete all notes to reset Passcode'),
                  actions: [
                    TextButton(
                      child: const Text('Ok'),
                      onPressed: () async {
                        Utilities.showSnackbar(
                            context,
                            "Deleted all Hidden Notes",
                            Colors.white,
                            Duration(seconds: 2),
                            Colors.green);
                        Provider.of<NotesHelper>(context, listen: false)
                            .deleteAllHiddenNotes();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/', (Route<dynamic> route) => false);
                      },
                    ),
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () async {
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      content: Text(data),
      backgroundColor: Colors.red,
      duration: Duration(
        seconds: 2,
      ),
      behavior: SnackBarBehavior.floating,
    );
  }

  static Future<bool> launchUrl(String url) async {
    if (await canLaunch(url)) {
      return launch(url);
    } else {
      return false;
    }
  }

  static String navChecker(NoteState state) {
    if (state == NoteState.archived) {
      return '/archive';
    } else if (state == NoteState.unspecified) {
      return '/';
    } else if (state == NoteState.deleted) {
      return '/trash';
    } else {
      return '/hidden';
    }
  }

  static Future<bool> requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  static final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'nikhildevelops@gmail.com',
      queryParameters: {'subject': 'Suggestion/Issues in the app'});

  static SnackBar getSnackBar(
      String data, Color dataColor, Duration duration, Color color) {
    return SnackBar(
      content: Text(
        data,
        style: TextStyle(color: dataColor),
      ),
      backgroundColor: color,
      duration: duration,
      behavior: SnackBarBehavior.floating,
    );
  }

  static void showSnackbar(BuildContext context, String data, Color dataColor,
      Duration duration, Color color) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      Utilities.getSnackBar(data, dataColor, duration, color),
    );
  }

  static Future<bool> authenticateUser(BuildContext context) async {
    var isAuthenticated = false;
    await _localAuthentication.getAvailableBiometrics();
    try {
      isAuthenticated = await _localAuthentication.authenticate(
        localizedReason: 'Please authenticate',
        useErrorDialogs: false,
        stickyAuth: true,
        biometricOnly: true,
      );
    } on PlatformException catch (errorCode) {
      isAuthenticated = false;
      _handleError(errorCode: errorCode.code, context: context);
    }
    return isAuthenticated;
  }

  static Future<bool> authenticateFirstTimeUser(BuildContext context) async {
    var isAuthenticated = false;
    await _localAuthentication.getAvailableBiometrics();
    try {
      isAuthenticated = await _localAuthentication.authenticate(
        localizedReason: 'Please authenticate',
        useErrorDialogs: false,
        stickyAuth: true,
        biometricOnly: true,
      );
    } on PlatformException catch (errorCode) {
      isAuthenticated = false;
      _handleError(errorCode: errorCode.code, context: context);
    }
    if (isAuthenticated) {
      Utilities.addBoolToSF('bio', true);
      Utilities.addBoolToSF('firstTimeNeeded', true);
      myNotes.lockChecker.bioEnabled = true;
    }
    return isAuthenticated;
  }

  static void addStringToSF(String key, String value) async {
    prefs ??= await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static void addBoolToSF(String key, bool value) async {
    prefs ??= await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  static void addIntToSF(String key, int value) async {
    prefs ??= await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  static void addDoubleToSF(String key, double value) async {
    prefs ??= await SharedPreferences.getInstance();
    await prefs.setDouble(key, value);
  }

  static Future<String> getStringValuesSF(String key) async {
    prefs ??= await SharedPreferences.getInstance();
    var stringValue = prefs.getString(key);
    return stringValue;
  }

  static Future<bool> getBoolValuesSF(String key) async {
    prefs ??= await SharedPreferences.getInstance();
    var boolValue = prefs.getBool(key);
    return boolValue;
  }

  static Future<int> getIntValuesSF(String key) async {
    prefs ??= await SharedPreferences.getInstance();
    var intValue = prefs.getInt(key);
    return intValue;
  }

  static Future<double> getDoubleValuesSF(String key) async {
    prefs ??= await SharedPreferences.getInstance();
    var doubleValue = prefs.getDouble(key);
    return doubleValue;
  }

  static void removeValues(String key) async {
    prefs ??= await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  static Future<bool> checkKey(String key) async {
    prefs ??= await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }

  static Future<void> _handleError(
      {String errorCode, BuildContext context}) async {
    String error;
    if (errorCode == " PasscodeNotSet") {
      error = "Please first set passcode in your system settings";
    } else if (errorCode == "LockedOut") {
      error = "Too many attempts. Try after 30 seconds";
    } else if (errorCode == "PermanentlyLockedOut") {
      error = "Too many attempts. Please open your device with pass first";
    } else if (errorCode == "NotAvailable") {
      error = 'Setup biometric from setting first';
    } else {
      error = 'Some issue occurred. Please report with code ${errorCode}';
    }
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(error),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok :('),
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/lock', (Route<dynamic> route) => false);
              },
            ),
          ],
        );
      },
    );
  }

  static Widget hideAction(BuildContext context, Note note) {
    return IconSlideAction(
      icon: TablerIcons.ghost,
      caption: "Hide",
      color: Colors.blueAccent,
      onTap: () => _onHideTap(context, note),
      closeOnTap: true,
    );
  }

  static _onHideTap(BuildContext context, Note note) async {
    bool value =
        await Provider.of<NotesHelper>(context, listen: false).hideNote(note);
    if (value) {
      Utilities.showSnackbar(context, "Note Hidden", Colors.white,
          Duration(seconds: 2), Colors.green);
    } else {
      Utilities.showSnackbar(context, "Some error occurred", Colors.white,
          Duration(seconds: 2), Colors.redAccent);
    }
  }

  static Widget deleteAction(BuildContext context, Note note) {
    return IconSlideAction(
      icon: Icons.delete_forever_outlined,
      caption: "Delete",
      color: Colors.redAccent,
      onTap: () => _onDeleteTap(context, note),
      closeOnTap: true,
    );
  }

  static _onDeleteTap(BuildContext context, Note note) async {
    bool value =
        await Provider.of<NotesHelper>(context, listen: false).deleteNote(note);
    if (value) {
      Utilities.showSnackbar(context, "Note Deleted", Colors.white,
          Duration(seconds: 2), Colors.green);
    } else {
      Utilities.showSnackbar(context, "Some error occurred", Colors.white,
          Duration(seconds: 2), Colors.redAccent);
    }
  }

  static Widget trashAction(BuildContext context, Note note) {
    return IconSlideAction(
      icon: Icons.delete_outline,
      caption: "Trash",
      color: Colors.redAccent,
      onTap: () => _onTrashTap(context, note),
      closeOnTap: true,
    );
  }

  static _onTrashTap(BuildContext context, Note note) async {
    bool value =
        await Provider.of<NotesHelper>(context, listen: false).trashNote(
      note: note,
      context: context,
    );
    if (value) {
      Utilities.showSnackbar(context, "Note Trashed", Colors.white,
          Duration(seconds: 2), Colors.green);
    } else {
      Utilities.showSnackbar(context, "Some error occurred", Colors.white,
          Duration(seconds: 2), Colors.redAccent);
    }
  }

  static Widget archiveAction(BuildContext context, Note note) {
    return IconSlideAction(
      icon: Icons.archive_outlined,
      caption: "Archive",
      color: Colors.green,
      onTap: () => _onArchiveTap(context, note),
      closeOnTap: true,
    );
  }

  static _onArchiveTap(BuildContext context, Note note) async {
    bool value = await Provider.of<NotesHelper>(context, listen: false)
        .archiveNote(note);
    if (value) {
      Utilities.showSnackbar(context, "Note Archived", Colors.white,
          Duration(seconds: 2), Colors.green);
    } else {
      Utilities.showSnackbar(context, "Some error occurred", Colors.white,
          Duration(seconds: 2), Colors.redAccent);
    }
  }

  static Widget copyAction(BuildContext context, Note note) {
    return IconSlideAction(
      icon: TablerIcons.copy,
      caption: "Copy",
      color: Colors.black,
      onTap: () => _onCopyTap(context, note),
      closeOnTap: true,
    );
  }

  static _onCopyTap(BuildContext context, Note note) async {
    bool value =
        await Provider.of<NotesHelper>(context, listen: false).copyNote(note);
    if (value) {
      Utilities.showSnackbar(context, "Note Copied", Colors.white,
          Duration(seconds: 2), Colors.green);
    } else {
      Utilities.showSnackbar(context, "Some error occurred", Colors.white,
          Duration(seconds: 2), Colors.redAccent);
    }
  }

  static Widget unHideAction(BuildContext context, Note note) {
    return IconSlideAction(
      icon: Icons.inbox_outlined,
      caption: "UnHide",
      color: Colors.blueAccent,
      onTap: () => _onUnHideTap(context, note),
      closeOnTap: true,
    );
  }

  static _onUnHideTap(BuildContext context, Note note) async {
    bool value =
        await Provider.of<NotesHelper>(context, listen: false).unHideNote(note);
    if (value) {
      Utilities.showSnackbar(context, "Note Restored", Colors.white,
          Duration(seconds: 2), Colors.green);
    } else {
      Utilities.showSnackbar(context, "Some error occurred", Colors.white,
          Duration(seconds: 2), Colors.redAccent);
    }
  }

  static Widget unArchiveAction(BuildContext context, Note note) {
    return IconSlideAction(
      icon: TablerIcons.ghost,
      caption: "Unarchive",
      color: Colors.green,
      onTap: () => _onUnArchiveTap(context, note),
      closeOnTap: true,
    );
  }

  static _onUnArchiveTap(BuildContext context, Note note) async {
    bool value = await Provider.of<NotesHelper>(context, listen: false)
        .unarchiveNote(note);
    if (value) {
      Utilities.showSnackbar(context, "Note Unarchived", Colors.white,
          Duration(seconds: 2), Colors.green);
    } else {
      Utilities.showSnackbar(context, "Some error occurred", Colors.white,
          Duration(seconds: 2), Colors.redAccent);
    }
  }

  static Widget restoreAction(BuildContext context, Note note) {
    return IconSlideAction(
      icon: Icons.inbox_outlined,
      caption: "Restore",
      color: Colors.green,
      onTap: () => _onRestoreActionTap(context, note),
      closeOnTap: true,
    );
  }

  static _onRestoreActionTap(BuildContext context, Note note) async {
    bool value =
        await Provider.of<NotesHelper>(context, listen: false).undelete(note);
    if (value) {
      Utilities.showSnackbar(context, "Note Restored", Colors.white,
          Duration(seconds: 2), Colors.green);
    } else {
      Utilities.showSnackbar(context, "Some error occurred", Colors.white,
          Duration(seconds: 2), Colors.redAccent);
    }
  }
}
