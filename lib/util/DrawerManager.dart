import 'package:flutter/foundation.dart';
import 'package:notes/AnimatedDrawerHelper/SecondLayer.dart';
import 'package:notes/ScreenHelpers/AboutMeScreen.dart';
import 'package:notes/ScreenHelpers/ArchiveScreen.dart';
import 'package:notes/ScreenHelpers/BackupRestore.dart';
import 'package:notes/ScreenHelpers/HiddenScreen.dart';
import 'package:notes/ScreenHelpers/HomeScreen.dart';
import 'package:notes/ScreenHelpers/SettingsScreen.dart';
import 'package:notes/ScreenHelpers/TrashScreen.dart';
import 'package:notes/main.dart';

class DrawerManager with ChangeNotifier {
  double xOffSet = 0;
  double yOffSet = 0;
  double angle = 0;
  bool isOpened = false;
  bool isIgnoring = false;
  static int animationTime = 350;
  static int SecondLayerAnimationTime = 600;

  void callback(bool isOpen) {
    if (isOpen) {
      xOffSet = 0;
      yOffSet = 0;
      angle = 0;
      isOpened = false;
      isIgnoring = false;
      secondLayer.animate();
      animatedDrawer();
    } else {
      xOffSet = 150;
      yOffSet = 80;
      angle = -0.2;
      isOpened = true;
      isIgnoring = true;
      secondLayer.animate();
      animatedDrawer();
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

  void animatedDrawer() {
    String currentScreen = myNotes.myRouteObserver.currentScreen;
    switch (currentScreen) {
      case "/":
        {
          homeScreen.animate();
        }
        break;
      case "/about":
        {
          aboutMe.animate();
        }
        break;
      case "/archive":
        {
          archive.animate();
        }
        break;
      case "/trash":
        {
          trash.animate();
        }
        break;
      case "/hidden":
        {
          hidden.animate();
        }
        break;
      case "/backup":
        {
          backup.animate();
        }
        break;
      case "/settings":
        {
          settings.animate();
        }
        break;
    }
  }
}
