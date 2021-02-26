import 'package:flutter/material.dart';
import 'package:notes/AnimatedDrawerHelper/Drawer.dart';
import 'package:notes/AnimatedDrawerHelper/FirstLayer.dart';
import 'package:notes/AnimatedDrawerHelper/SecondLayer.dart';
import 'package:notes/ScreenHelpers/SuggestionScreen.dart';
import 'package:notes/util/DrawerManager.dart';

class SuggestionsScreen extends StatefulWidget {
  final DrawerManager drawerManager ;

  SuggestionsScreen(this.drawerManager);
  @override
  _SuggestionsScreenState createState() => _SuggestionsScreenState();
}

class _SuggestionsScreenState extends State<SuggestionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FirstLayer(),
          SecondLayer(),
          ThirdLayer(),
          SuggestionsScreenHelper(widget.drawerManager),
        ],
      ),
    );
  }
}
