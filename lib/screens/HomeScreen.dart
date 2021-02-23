import 'package:flutter/material.dart';
import 'package:notes/AnimatedDrawerHelper/Drawer.dart';
import 'package:notes/AnimatedDrawerHelper/FirstLayer.dart';
import 'package:notes/AnimatedDrawerHelper/SecondLayer.dart';
import 'package:notes/ScreenHelpers/HomeScreen.dart';
import 'package:notes/screens/LockScreen.dart';
import 'package:notes/util/Utilites.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();

  HomeScreen() {
    LockChecker.updateDetails();
    LockChecker.bioAvailCheck();
    Utilities.addBoolToSF("passwordSet", false);
  }
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        body: Stack(
          children: [
            FirstLayer(),
            SecondLayer(),
            ThirdLayer(),
            HomeScreenHelper(),
          ],
        ),
      ),
    );
  }
}