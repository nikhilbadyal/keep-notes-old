//26-02-2021

import 'Utilites.dart';

class LockChecker {
  LockChecker(this.passwordLength) {
    initConfig();
  }

  int passwordLength;
  String password;
  bool passwordSet;
  bool bioEnabled;
  bool bioAvailable;
  bool firstTimeNeeded;

  void updateDetails() {}

  Future<void> bioAvailCheck() async {
    bioAvailable = await Utilities.isBioAvailable();
  }

  Future<void> initConfig() async {
    password = await Utilities.getStringValuesSF('password');
    if (password == null) {
      passwordSet = false;
    } else {
      passwordSet = password.isNotEmpty;
    }
    // passwordSet = password.isNotEmpty || false;
    bioEnabled = await Utilities.getBoolValuesSF('bio');
    firstTimeNeeded = await Utilities.getBoolValuesSF('firstTimeNeeded');
    bioEnabled ??= false;
    if (bioEnabled) {
      bioAvailable = true;
    } else {
      await bioAvailCheck();
    }
    firstTimeNeeded ??= true;
  }
}
