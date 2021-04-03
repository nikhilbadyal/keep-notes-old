import 'package:flutter/material.dart';
import 'package:notes/AnimatedDrawerHelper/Drawer.dart';
import 'package:notes/AnimatedDrawerHelper/FirstLayer.dart';
import 'package:notes/AnimatedDrawerHelper/SecondLayer.dart';
import 'package:notes/ScreenHelpers/ArchiveScreen.dart';

class ArchiveScreen extends StatefulWidget {
  @override
  _ArchiveScreenState createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  @override
  Widget build(BuildContext context) {
    debugPrint('building 19');
    return Scaffold(
      body: Stack(
        children: [
          const FirstLayer(),
          const SecondLayer(),
          const ThirdLayer(),
          ArchiveScreenHelper(),
        ],
      ),
    );
  }
}
