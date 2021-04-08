import 'package:flutter/material.dart';
import 'package:notes/model/database/NotesHelper.dart';
import 'package:notes/util/DrawerManager.dart';
import 'package:notes/util/LockManager.dart';
import 'package:notes/util/MyRouteObserver.dart';
import 'package:notes/util/Utilites.dart';
import 'package:notes/views/ScreenHelpers/HomeScreen.dart';
import 'package:notes/views/TopWidget.dart';
import 'package:notes/views/screens/LockScreen.dart';
import 'package:notes/views/screens/SetPassword.dart';
import 'package:notes/widget/AppBar.dart';
import 'package:provider/provider.dart';

MyNotes myNotes;

class MyNotes extends StatelessWidget {
  final MyRouteObserver myRouteObserver = MyRouteObserver();
  final DrawerManager drawerManager = DrawerManager();
  final LockChecker lockChecker = LockChecker(Utilities.passLength);

  /*final theme = ThemeData(
    //TODO lern this
  );*/

  @override
  Widget build(BuildContext context) {
    //debugPrint('building main');
    myNotes = this;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NotesHelper>(
          create: (_) => NotesHelper(),
        ),
        ChangeNotifierProvider<AppbarStatus>(
          create: (_) => AppbarStatus(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Notes App',
        navigatorObservers: [myRouteObserver],
        routes: {
          '/': (context) => ScreenContainer(
                topScreen: HomeScreenHelper(),
              ),
          '/lock': (context) => LockScreen(),
          '/setpass': (context) => SetPassword(),
        },
      ),
    );
  }
}
