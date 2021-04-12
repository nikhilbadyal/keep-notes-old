import 'package:flutter/material.dart';
import 'package:notes/util/Utilites.dart';

class LockChecker {
  LockChecker() {
    initConfig();
  }

  final int passwordLength = 4;
  String password;
  bool passwordSet;
  bool bioEnabled;
  bool bioAvailable;
  bool firstTimeNeeded;

  void updateDetails() {}

  Future<void> initConfig() async {
    password = Utilities.getStringValuesSF('password') ?? '';
    passwordSet = password.isNotEmpty;
    bioEnabled = Utilities.getBoolValuesSF('bio') ?? false;
    firstTimeNeeded = Utilities.getBoolValuesSF('firstTimeNeeded') ?? false;
    bioAvailable = bioEnabled || await bioAvailCheck();

    debugPrint(
      password +
          passwordSet.toString() +
          bioEnabled.toString() +
          firstTimeNeeded.toString() +
          bioAvailable.toString(),
    );
  }

  Future<void> resetConfig() async {
    password = '';
    passwordSet = false;
    bioEnabled = false;
    firstTimeNeeded = false;
    await Utilities.removeValues('password');
    await Utilities.removeValues('bio');
    await Utilities.removeValues('biofirstTimeNeeded');
    debugPrint(
      password +
          passwordSet.toString() +
          bioEnabled.toString() +
          firstTimeNeeded.toString() +
          bioAvailable.toString(),
    );
  }

  Future<void> passwordSetConfig(String enteredPassword) async {
    password = enteredPassword;
    passwordSet = true;
    await Utilities.addStringToSF('password', enteredPassword);
    debugPrint(
      password +
          passwordSet.toString() +
          bioEnabled.toString() +
          firstTimeNeeded.toString() +
          bioAvailable.toString(),
    );
  }

  Future<void> bioEnabledConfig() async {
    bioEnabled = true;
    bioAvailable = true;
    firstTimeNeeded = true;
    await Utilities.addBoolToSF('bio', value: true);
    await Utilities.addBoolToSF('firstTimeNeeded', value: true);
    debugPrint(
      password +
          passwordSet.toString() +
          bioEnabled.toString() +
          firstTimeNeeded.toString() +
          bioAvailable.toString(),
    );
  }

  Future<bool> bioAvailCheck() async {
    return Utilities.isBioAvailable();
  }
}
