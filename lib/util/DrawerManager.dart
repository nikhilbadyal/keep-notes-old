import 'package:flutter/material.dart';
import 'package:notes/AnimatedDrawerHelper/SecondLayer.dart';
import 'package:notes/ScreenHelpers/AboutMeScreen.dart';
import 'package:notes/ScreenHelpers/ArchiveScreen.dart';
import 'package:notes/ScreenHelpers/BackupRestore.dart';
import 'package:notes/ScreenHelpers/HiddenScreen.dart';
import 'package:notes/ScreenHelpers/HomeScreen.dart';
import 'package:notes/ScreenHelpers/SuggestionScreen.dart';
import 'package:notes/ScreenHelpers/TrashScreen.dart';
import 'package:notes/main.dart';

class DrawerManager {
  double xOffSet = 0;
  double yOffSet = 0;
  double angle = 0;
  bool localIsOpen = false;
  bool isIgnoring = false;

  void callback(bool isOpen){
    if (isOpen) {
      xOffSet = 0;
      yOffSet = 0;
      angle = 0;
      localIsOpen = false;
      isIgnoring = false;
      secondLayer.callSetState(0, 0, 0);
      callSetState();
    } else {
      xOffSet = 150;
      yOffSet = 80;
      angle = -0.2;
      localIsOpen = true;
      isIgnoring = true;
      secondLayer.callSetState(123, 110, -0.275);
      callSetState();
    }
  }

  void resetDrawerState(){
    xOffSet = 0;
    yOffSet = 0;
    angle = 0;
    localIsOpen = false;
    isIgnoring = false;
  }

  void  openDrawer(){
    debugPrint("Open drawer");
    callback(false);
  }

  void closeDrawer() {
    debugPrint("Close drawer");
    callback(true);
  }


  void callSetState() {
    String currentScreen = myNotes.myRouteObserver.currentScreen ;
    switch(currentScreen){
      case "/":{
        homeScreen.callSetState();
      }
      break;
      case "/about":{
        aboutMe.callSetState();
      }
      break;
      case "/archive":{
        archive.callSetState();
      }
      break;
      case "/suggestions":{
        suggestion.callSetState();
      }
      break;
      case "/trash":{
        trash.callSetState();
    }
      break;
      case "/hidden":{
        hidden.callSetState();
    }
      break;
      case "/backup":{
        backup.callSetState();
    }
      break;
    }
  }

}
