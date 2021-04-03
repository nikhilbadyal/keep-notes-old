import 'package:flutter/material.dart';
import 'package:notes/AnimatedDrawerHelper/Drawer.dart';
import 'package:notes/AnimatedDrawerHelper/FirstLayer.dart';
import 'package:notes/AnimatedDrawerHelper/SecondLayer.dart';
import 'package:notes/ScreenHelpers/TrashScreen.dart';

class TrashScreen extends StatefulWidget {
  @override
  _TrashScreenState createState() => _TrashScreenState();
}

class _TrashScreenState extends State<TrashScreen> {
  @override
  Widget build(BuildContext context) {
    debugPrint('building 30');
    return Scaffold(
      body: Stack(
        children: [
          const FirstLayer(),
          const SecondLayer(),
          const ThirdLayer(),
          TrashScreenHelper(),
        ],
      ),
    );
  }
}
