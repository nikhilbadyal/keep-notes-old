import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:local_auth/local_auth.dart';
import 'package:notes/app.dart';
import 'package:notes/model/database/NotesHelper.dart';
import 'package:notes/model/note.dart';
import 'package:notes/util/AppConfiguration.dart';
import 'package:notes/util/AppRoutes.dart';
import 'package:notes/widget/Navigations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:random_color/random_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

enum IconColorStatus { NoColor, RandomColor, PickedColor, UiColor }

MaterialColor createMaterialColor(Color color) {
  final strengths = <double>[.05];
  final swatch = <int, Color>{};
  final r = color.red;
  final g = color.green;
  final b = color.blue;

  for (var i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (final strength in strengths) {
    final ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

Color getRandomColor() {
  final _randomColor = RandomColor();
  var color = _randomColor.randomColor();
  while (color == selectedPrimaryColor || color == selectedAccentColor) {
    color = _randomColor.randomColor();
  }
  return color;
}

class Utilities {
  static final LocalAuthentication _localAuthentication = LocalAuthentication();
  static SharedPreferences prefs;
  static const passLength = 4;

  static Future<bool> isBioAvailable() async {
    var isAvailable = false;
    try {
      isAvailable = await _localAuthentication.canCheckBiometrics;
    } on PlatformException catch (_) {}
    return isAvailable;
  }

  static Future<void> resetPassword(BuildContext context,
      {bool deleteAllNotes = false}) async {
    if (deleteAllNotes) {
      await Provider.of<NotesHelper>(context, listen: false)
          .deleteAllHiddenNotes();
      Utilities.showSnackbar(
        context,
        'Deleted all Hidden Notes',
        const Duration(seconds: 2),
      );
    } else {
      Utilities.showSnackbar(
        context,
        'Password Reset',
        const Duration(seconds: 2),
      );
    }
    await myNotes.lockChecker.resetConfig();
    await navigate(
        ModalRoute.of(context).settings.name, context, NotesRoutes.homeScreen);
  }

  static Future<bool> launchUrl(String url) async {
    if (await canLaunch(url)) {
      return launch(url);
    } else {
      //debugPrint('unable');
      return false;
    }
  }

  static String navChecker(NoteState state) {
    if (state == NoteState.archived) {
      return NotesRoutes.archiveScreen;
    } else if (state == NoteState.hidden) {
      return NotesRoutes.hiddenScreen;
    } else if (state == NoteState.deleted) {
      return NotesRoutes.trashScreen;
    } else {
      return NotesRoutes.homeScreen;
    }
  }

  static Future<bool> requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      final result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  static SnackBarAction resetAction(BuildContext context) {
    return SnackBarAction(
      label: 'Reset?',
      onPressed: () async {
        await showDialog<bool>(
          context: context,
          builder: (context) => Center(
            child: SingleChildScrollView(
              child: MyAlertDialog(
                title: const Text('Delete all notes to reset Passcode'),
                actions: [
                  TextButton(
                    onPressed: () =>
                        resetPassword(context, deleteAllNotes: true),
                    child: const Text('Ok'),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'nikhildevelops@gmail.com',
      queryParameters: {'subject': 'Suggestion/Issues in the app'});

  static SnackBar getSnackBar(
      BuildContext context, String data, Duration duration,
      {Color dataColor, Color color, SnackBarAction action}) {
    return SnackBar(
      key: UniqueKey(),
      content: Text(
        data,
      ),
      action: action,
      duration: duration,
      padding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.38,
      ),
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  static void showSnackbar(BuildContext context, String data, Duration duration,
      {Color dataColor, Color color}) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      Utilities.getSnackBar(
        context,
        data,
        duration,
      ),
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
      await _handleError(errorCode: errorCode.code, context: context);
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
      await _handleError(errorCode: errorCode.code, context: context);
    }
    if (isAuthenticated) {
      await myNotes.lockChecker.bioEnabledConfig();
    }
    return isAuthenticated;
  }

  static Future<void> addStringToSF(String key, String value) async {
    prefs ??= await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<void> addBoolToSF(String key, {bool value}) async {
    prefs ??= await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  static Future<void> addIntToSF(String key, int value) async {
    prefs ??= await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  static Future<void> addDoubleToSF(String key, double value) async {
    prefs ??= await SharedPreferences.getInstance();
    await prefs.setDouble(key, value);
  }

  static String getStringValuesSF(String key) {
    return prefs.getString(key);
  }

  static bool getBoolValuesSF(String key) {
    return prefs.getBool(key);
  }

  static int getIntValuesSF(String key) {
    return prefs.getInt(key);
  }

  static double getDoubleValuesSF(String key) {
    return prefs.getDouble(key);
  }

  static Future<void> removeValues(String key) async {
    prefs ??= await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  static bool checkKey(String key) {
    return prefs.containsKey(key);
  }

  static Future<void> _handleError(
      {String errorCode, BuildContext context}) async {
    String error;
    if (errorCode == ' PasscodeNotSet') {
      error = 'Please first set passcode in your system settings';
    } else if (errorCode == 'LockedOut') {
      error = 'Too many attempts. Try after 30 seconds';
    } else if (errorCode == 'PermanentlyLockedOut') {
      error = 'Too many attempts. Please open your device with pass first';
    } else if (errorCode == 'NotAvailable') {
      error = 'Setup biometric from setting first';
    } else {
      error = 'Some issue occurred. Please report with code $errorCode';
    }
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return MyAlertDialog(
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
              onPressed: () async {
                Navigator.of(context).pop();
              },
              child: const Text('Ok :('),
            ),
          ],
        );
      },
    );
  }

  static Widget hideAction(BuildContext context, Note note) {
    return IconSlideAction(
      icon: TablerIcons.ghost,
      caption: 'Hide',
      color: Colors.transparent,
      foregroundColor: Theme.of(context).textTheme.bodyText1.color,
      onTap: () => onHideTap(context, note),
    );
  }

  static Future<void> onHideTap(BuildContext context, Note note) async {
    final value =
        await Provider.of<NotesHelper>(context, listen: false).hideNote(note);
    if (value) {
      Utilities.showSnackbar(
        context,
        'Note Hidden',
        const Duration(seconds: 2),
      );
    } else {
      Utilities.showSnackbar(
        context,
        'Some error occurred',
        const Duration(seconds: 2),
      );
    }
  }

  static Widget deleteAction(BuildContext context, Note note) {
    return IconSlideAction(
      icon: Icons.delete_forever_outlined,
      caption: 'Delete',
      color: Colors.transparent,
      foregroundColor: Theme.of(context).textTheme.bodyText1.color,
      //light

      onTap: () => onDeleteTap(context, note),
    );
  }

  static Future<void> onDeleteTap(BuildContext context, Note note) async {
    final value =
        await Provider.of<NotesHelper>(context, listen: false).deleteNote(note);
    if (value) {
      Utilities.showSnackbar(
        context,
        'Note Deleted',
        const Duration(seconds: 2),
      );
    } else {
      Utilities.showSnackbar(
        context,
        'Some error occurred',
        const Duration(seconds: 2),
      );
    }
  }

  static Widget trashAction(BuildContext context, Note note) {
    return IconSlideAction(
      icon: Icons.delete_outline,
      caption: 'Trash',
      color: Colors.transparent,
      foregroundColor: Theme.of(context).textTheme.bodyText1.color,
      //light
      onTap: () => onTrashTap(context, note),
    );
  }

  static Future<void> onTrashTap(BuildContext context, Note note) async {
    final value = await Provider.of<NotesHelper>(context, listen: false)
        .trashNote(note, context);
    if (value) {
      Utilities.showSnackbar(
        context,
        'Note Trashed',
        const Duration(seconds: 2),
      );
    } else {
      Utilities.showSnackbar(
        context,
        'Some error occurred',
        const Duration(seconds: 2),
      );
    }
  }

  static Widget copyAction(BuildContext context, Note note) {
    return IconSlideAction(
      icon: TablerIcons.copy,
      caption: 'Copy',
      color: Colors.transparent,
      foregroundColor: Theme.of(context).textTheme.bodyText1.color,
      //dark
      onTap: () => onCopyTap(context, note),
    );
  }

  static Future<void> onCopyTap(BuildContext context, Note note) async {
    final value =
        await Provider.of<NotesHelper>(context, listen: false).copyNote(note);
    if (value) {
      Utilities.showSnackbar(
        context,
        'Note Copied',
        const Duration(seconds: 2),
      );
    } else {
      Utilities.showSnackbar(
        context,
        'Some error occurred',
        const Duration(seconds: 2),
      );
    }
  }

  static Widget archiveAction(BuildContext context, Note note) {
    return IconSlideAction(
      icon: Icons.archive_outlined,
      caption: 'Archive',
      color: Colors.transparent,
      foregroundColor: Theme.of(context).textTheme.bodyText1.color,
      //light

      onTap: () => onArchiveTap(context, note),
    );
  }

  static Future<void> onArchiveTap(BuildContext context, Note note) async {
    final value = await Provider.of<NotesHelper>(context, listen: false)
        .archiveNote(note);
    if (value) {
      Utilities.showSnackbar(
        context,
        'Note Archived',
        const Duration(seconds: 2),
      );
    } else {
      Utilities.showSnackbar(
        context,
        'Some error occurred',
        const Duration(seconds: 2),
      );
    }
  }

  static Widget unHideAction(BuildContext context, Note note) {
    return IconSlideAction(
      icon: Icons.drive_file_move_outline,
      caption: 'UnHide',
      color: Colors.transparent,
      foregroundColor: Theme.of(context).textTheme.bodyText1.color,
      //light

      onTap: () => onUnHideTap(context, note),
    );
  }

  static Future<void> onUnHideTap(BuildContext context, Note note) async {
    final value =
        await Provider.of<NotesHelper>(context, listen: false).unHideNote(note);
    if (value) {
      Utilities.showSnackbar(
        context,
        'Note Restored',
        const Duration(seconds: 2),
      );
    } else {
      Utilities.showSnackbar(
        context,
        'Some error occurred',
        const Duration(seconds: 2),
      );
    }
  }

  static Widget unArchiveAction(BuildContext context, Note note) {
    return IconSlideAction(
      icon: TablerIcons.ghost,
      caption: 'Unarchive',
      color: Colors.transparent,
      foregroundColor: Theme.of(context).textTheme.bodyText1.color,
      //light

      onTap: () => onUnArchiveTap(context, note),
    );
  }

  static Future<void> onUnArchiveTap(BuildContext context, Note note) async {
    final value = await Provider.of<NotesHelper>(context, listen: false)
        .unarchiveNote(note);
    if (value) {
      Utilities.showSnackbar(
        context,
        'Note Unarchived',
        const Duration(seconds: 2),
      );
    } else {
      Utilities.showSnackbar(
        context,
        'Some error occurred',
        const Duration(seconds: 2),
      );
    }
  }

  static Widget restoreAction(BuildContext context, Note note) {
    return IconSlideAction(
      icon: Icons.restore_from_trash_outlined,
      caption: 'Restore',
      color: Colors.transparent,
      foregroundColor: Theme.of(context).textTheme.bodyText1.color,
      //light

      onTap: () => onRestoreTap(context, note),
    );
  }

  static Future<void> onRestoreTap(BuildContext context, Note note) async {
    final value =
        await Provider.of<NotesHelper>(context, listen: false).undelete(note);
    if (value) {
      Utilities.showSnackbar(
        context,
        'Note Restored',
        const Duration(seconds: 2),
      );
    } else {
      Utilities.showSnackbar(
        context,
        'Some error occurred',
        const Duration(seconds: 2),
      );
    }
  }

  static Future<void> onDeleteAllTap(BuildContext context) async {
    final value = await Provider.of<NotesHelper>(context, listen: false)
        .deleteAllTrashNotes();
    if (value) {
      Utilities.showSnackbar(
        context,
        'Deleted All',
        const Duration(seconds: 2),
      );
    } else {
      Utilities.showSnackbar(
        context,
        'Some error occurred',
        const Duration(seconds: 2),
      );
    }
  }

  static Color iconColor() {
    // debugPrint(selectedIconColorStatus.index.toString());
    switch (selectedIconColorStatus) {
      case IconColorStatus.RandomColor:
        return getRandomColor();
        break;
      case IconColorStatus.PickedColor:
        return selectedIconColor;
        break;
      case IconColorStatus.UiColor:
        return selectedPrimaryColor;
        break;
      default:
        return selectedAppTheme == AppTheme.Light ? Colors.black : Colors.white;
        break;
    }
  }

/*static Color lightDarkIconColor() {
    // debugPrint(selectedIconColorStatus.index.toString());
    switch (selectedAppTheme) {
      case AppTheme.Dark:
        return Colors.white;
        break;
      case AppTheme.Black:
        return Colors.white;
        break;
      default:
        return Colors.black;
        break;
    }
  }*/
}
