import 'package:flutter/material.dart';
import 'package:notes/AnimatedDrawerHelper/Drawer.dart';
import 'package:notes/AnimatedDrawerHelper/FirstLayer.dart';
import 'package:notes/AnimatedDrawerHelper/SecondLayer.dart';
import 'package:notes/ScreenHelpers/ArchiveScreen.dart';
import 'package:notes/util/DrawerManager.dart';

class ArchiveScreen extends StatefulWidget {
  final DrawerManager drawerManager ;

  ArchiveScreen(this.drawerManager);
  @override
  _ArchiveScreenState createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FirstLayer(),
          SecondLayer(),
          ThirdLayer(),
          ArchiveScreenHelper(widget.drawerManager),
        ],
      ),
    );
  }
}
