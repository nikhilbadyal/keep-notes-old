import 'package:flutter/material.dart';
import 'package:notes/views/ScreenHelpers/HiddenScreen.dart';
import 'package:notes/views/TopWidget.dart';

class HiddenScreen extends StatefulWidget {
  @override
  _HiddenScreenState createState() => _HiddenScreenState();
}

class _HiddenScreenState extends State<HiddenScreen> {
  @override
  Widget build(BuildContext context) {
    //debugPrint('building 21 ');
    return ScreenContainer(
      topScreen: HiddenScreenHelper(),
    );
  }
}
