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
import 'package:provider/provider.dart';

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
  @override
  Widget build(BuildContext context) {
    Colors.blue;
    return ChangeNotifierProvider.value(
      value: NotesHelper(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Notes App',
        routes: {
          '/': (context) => HomeScreen(),
          '/about': (context) => AboutMeScreen(),
          '/archive': (context) => ArchiveScreen(),
          '/suggestions': (context) => SuggestionsScreen(),
          '/trash': (context) => TrashScreen(),
          '/lock': (context) => LockScreen(),
          '/setpass': (context) => SetPassword(),
          '/hidden': (context) => HiddenScreen(),
          '/backup': (context) => BackUpScreen(),
        },
      ),
    );
  }
}
