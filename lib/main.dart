import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes/database/NotesHelper.dart';
import 'package:notes/screens/AboutMeScreen.dart';
import 'package:notes/screens/ArchiveScreen.dart';
import 'package:notes/screens/BackUp.dart';
import 'package:notes/screens/HiddenScreen.dart';
import 'package:notes/screens/HomeScreen.dart';
import 'package:notes/screens/LockScreen.dart';
import 'package:notes/screens/SetPassword.dart';
import 'package:notes/screens/SuggestionScreen.dart';
import 'package:notes/screens/TrashScreen.dart';
import 'package:notes/util/DrawerManager.dart';
import 'package:notes/util/MyRouteObserver.dart';
import 'package:provider/provider.dart';


MyNotes myNotes;
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    if (kReleaseMode) {
      exit(1);
    }
  };
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(MyNotes());
}

//TODO implement lock screen
class MyNotes extends StatelessWidget {
  final MyRouteObserver myRouteObserver = MyRouteObserver();
  final DrawerManager drawerManager = DrawerManager();
  @override
  Widget build(BuildContext context) {
    myNotes = this;
    return ChangeNotifierProvider.value(
      value: NotesHelper(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Notes App',
        navigatorObservers: [myRouteObserver],
        routes: {
          '/': (context) => HomeScreen(drawerManager), //d
          '/about': (context) => AboutMeScreen(drawerManager), //d
          '/archive': (context) => ArchiveScreen(drawerManager), //d
          '/suggestions': (context) => SuggestionsScreen(drawerManager), //d
          '/trash': (context) => TrashScreen(drawerManager), //d
          '/hidden': (context) => HiddenScreen(drawerManager), //d
          '/backup': (context) => BackUpScreen(drawerManager), //d
          '/lock': (context) => LockScreen(),
          '/setpass': (context) => SetPassword(),

        },
      ),
    );
  }
}
