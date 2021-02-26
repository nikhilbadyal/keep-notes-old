import 'package:flutter/material.dart';
import 'package:notes/AnimatedDrawerHelper/Drawer.dart';
import 'package:notes/AnimatedDrawerHelper/FirstLayer.dart';
import 'package:notes/AnimatedDrawerHelper/SecondLayer.dart';
import 'package:notes/ScreenHelpers/AboutMeScreen.dart';
import 'package:notes/util/DrawerManager.dart';

class AboutMeScreen extends StatefulWidget {
  final DrawerManager drawerManager ;

  AboutMeScreen(this.drawerManager);
  @override
  _AboutMeScreenState createState() => _AboutMeScreenState();
}

class _AboutMeScreenState extends State<AboutMeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FirstLayer(),
          SecondLayer(),
          ThirdLayer(),
          AboutMeScreenHelper(widget.drawerManager),
        ],
      ),
    );
  }
}
