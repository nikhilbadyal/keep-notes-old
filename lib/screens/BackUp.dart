import 'package:flutter/material.dart';
import 'package:notes/AnimatedDrawerHelper/Drawer.dart';
import 'package:notes/AnimatedDrawerHelper/FirstLayer.dart';
import 'package:notes/AnimatedDrawerHelper/SecondLayer.dart';
import 'package:notes/ScreenHelpers/BackupRestore.dart';
import 'package:notes/util/DrawerManager.dart';

class BackUpScreen extends StatefulWidget {
  final DrawerManager drawerManager ;

  BackUpScreen(this.drawerManager );
  @override
  _BackUpScreenState createState() => _BackUpScreenState();
}

class _BackUpScreenState extends State<BackUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FirstLayer(),
          SecondLayer(),
          ThirdLayer(),
          BackUpScreenHelper(widget.drawerManager),
        ],
      ),
    );
  }
}
