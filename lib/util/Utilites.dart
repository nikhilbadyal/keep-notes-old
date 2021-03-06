import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:notes/widget/PopUp.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class Utilities {
  static final LocalAuthentication _localAuthentication = LocalAuthentication();
  static SharedPreferences prefs;

  static Color uiColor1 = Color(0xFFFD5872);
  static Color uiColor2 = Colors.blue;
  static const double padding = 20;

  static const double avatarRadius = 45;
  static const passLength = 4;
  static const Color dialogColor = Colors.white;

  static Future<String> getImage(ImageSource imageSource) async {
    final picker = ImagePicker();
    var imageFile = await picker.getImage(source: imageSource);

    if (imageFile == null) {
      return "";
    }
    var tmpFile = File(imageFile.path);
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = basename(imageFile.path);
    tmpFile = await tmpFile.copy('${appDir.path}/$fileName');
    return tmpFile.path;
  }

  static void showMyToast(String content, int time,
      [ToastGravity bottom = ToastGravity.BOTTOM,
      MaterialColor color = Colors.blue]) async {
    await Fluttertoast.showToast(
        msg: content,
        toastLength: Toast.LENGTH_SHORT,
        gravity: bottom,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static Future<void> getListOfBiometricTypes() async {
    List<BiometricType> listOfBiometrics;
    try {
      listOfBiometrics = await _localAuthentication.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }

    print(listOfBiometrics);
  }

  static Future<bool> isBioAvailable() async {
    var isAvailable = false;
    try {
      isAvailable = await _localAuthentication.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    return isAvailable;
  }

  static Future<void> authenticateUser(BuildContext context) async {
    var isAuthenticated = false;
    String errorCode = '';
    try {
      isAuthenticated = await _localAuthentication.authenticateWithBiometrics(
        localizedReason: 'Please authenticate',
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } on PlatformException catch (e) {
      errorCode = e.code;
      print(e);
    }

    if (errorCode != '') {
      return _handleError(errorCode: errorCode, context: context);
    }
    isAuthenticated
        ? print('User is authenticated!')
        : print('User is not authenticated.');

    if (isAuthenticated) {
      myNotes.lockChecker.bioEnabled = true;
      Utilities.addBoolToSF('bio', true);
      await Navigator.of(context)
          .pushNamedAndRemoveUntil('/hidden', (Route<dynamic> route) => false);
    } else {
      myNotes.lockChecker.bioEnabled
          ? await showDialog<bool>(
              context: context,
              builder: (context) => CustomDialog(
                title: '',
                descriptions: 'Want to use password ?',
                firstOption: 'Yes',
                secondOption: 'Cancel',
                onFirstPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/lock', (Route<dynamic> route) => false);
                },
                onSecondPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            )
          : myNotes.lockChecker.passwordSet
              ? Navigator.of(context).pushNamedAndRemoveUntil(
                  '/lock', (Route<dynamic> route) => false)
              : Navigator.of(context).pop(true);
    }
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
    } else {
      error = 'Some issue occurred. Please report with code "errorCode"';
    }
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(error),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok :('),
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
}
