import 'package:flutter/material.dart';
import 'package:notes/AnimatedDrawerHelper/Drawer.dart';
import 'package:notes/AnimatedDrawerHelper/FirstLayer.dart';
import 'package:notes/AnimatedDrawerHelper/SecondLayer.dart';
import 'package:notes/ScreenHelpers/TrashScreen.dart';
import 'package:notes/util/DrawerManager.dart';

class TrashScreen extends StatefulWidget {
  final DrawerManager drawerManager ;

  TrashScreen(this.drawerManager);
  @override
  _TrashScreenState createState() => _TrashScreenState();
}

class _TrashScreenState extends State<TrashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FirstLayer(),
          SecondLayer(),
          ThirdLayer(),
          TrashScreenHelper(widget.drawerManager),
        ],
      ),
    );
  }
}
