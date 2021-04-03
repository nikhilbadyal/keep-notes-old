import 'package:flutter/material.dart';
import 'package:notes/AnimatedDrawerHelper/Drawer.dart';
import 'package:notes/AnimatedDrawerHelper/FirstLayer.dart';
import 'package:notes/AnimatedDrawerHelper/SecondLayer.dart';
import 'package:notes/ScreenHelpers/AboutMeScreen.dart';

class AboutMeScreen extends StatefulWidget {
  @override
  _AboutMeScreenState createState() => _AboutMeScreenState();
}

class _AboutMeScreenState extends State<AboutMeScreen> {
  @override
  Widget build(BuildContext context) {
    debugPrint('building 18');
    return Scaffold(
      body: Stack(
        children: [
          const FirstLayer(),
          const SecondLayer(),
          const ThirdLayer(),
          const AboutMeScreenHelper(),
        ],
      ),
    );
  }
}
