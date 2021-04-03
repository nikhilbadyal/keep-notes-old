import 'package:flutter/material.dart';
// import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:notes/AnimatedDrawerHelper/Drawer.dart';
import 'package:notes/AnimatedDrawerHelper/FirstLayer.dart';
import 'package:notes/AnimatedDrawerHelper/SecondLayer.dart';
import 'package:notes/ScreenHelpers/HiddenScreen.dart';

class HiddenScreen extends StatefulWidget {
  @override
  _HiddenScreenState createState() => _HiddenScreenState();
}

class _HiddenScreenState extends State<HiddenScreen> {
  @override
  Widget build(BuildContext context) {
    debugPrint('building 21 ');
    return Scaffold(
      body: Stack(
        children: [
          const FirstLayer(),
          const SecondLayer(),
          const ThirdLayer(),
          HiddenScreenHelper(),
        ],
      ),
    );
  }
}
