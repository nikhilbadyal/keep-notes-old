import 'package:flutter/foundation.dart';
import 'package:notes/AnimatedDrawerHelper/SecondLayer.dart';
import 'package:notes/ScreenHelpers/AboutMeScreen.dart';
import 'package:notes/ScreenHelpers/ArchiveScreen.dart';
import 'package:notes/ScreenHelpers/BackupRestore.dart';
import 'package:notes/ScreenHelpers/HiddenScreen.dart';
import 'package:notes/ScreenHelpers/HomeScreen.dart';
import 'package:notes/ScreenHelpers/TrashScreen.dart';
import 'package:notes/main.dart';

class DrawerManager with ChangeNotifier {
  double xOffSet = 0;
  double yOffSet = 0;
  double angle = 0;
  bool isOpened = false;
  bool isIgnoring = false;

  void callback(bool isOpen) {
    if (isOpen) {
      xOffSet = 0;
      yOffSet = 0;
      angle = 0;
      isOpened = false;
      isIgnoring = false;
      secondLayer.callSetState(0, 0, 0);
      callSetState();
    } else {
      xOffSet = 150;
      yOffSet = 80;
      angle = -0.2;
      isOpened = true;
      isIgnoring = true;
      secondLayer.callSetState(123, 110, -0.275);
      callSetState();
    }
  }

  void openDrawer() {
    callback(false);
  }

  void closeDrawer() {
    callback(true);
  }

  void resetDrawerState() {
    xOffSet = 0;
    yOffSet = 0;
    angle = 0;
    isOpened = false;
    isIgnoring = false;
  }

  void callSetState() {
    String currentScreen = myNotes.myRouteObserver.currentScreen;
    switch (currentScreen) {
      case "/":
        {
          homeScreen.callSetState();
        }
        break;
      case "/about":
        {
          aboutMe.callSetState();
        }
        break;
      case "/archive":
        {
          archive.callSetState();
        }
        break;
      case "/trash":
        {
          trash.callSetState();
        }
        break;
      case "/hidden":
        {
          hidden.callSetState();
        }
        break;
      case "/backup":
        {
          backup.callSetState();
        }
        break;
    }
  }
}
