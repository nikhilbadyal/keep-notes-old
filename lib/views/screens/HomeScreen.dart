import 'package:flutter/material.dart';
import 'package:notes/views/ScreenHelpers/HomeScreen.dart';
import 'package:notes/views/TopWidget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    //debugPrint('home building 22');
    return ScreenContainer(
      topScreen: HomeScreenHelper(),
    );
  }
}
