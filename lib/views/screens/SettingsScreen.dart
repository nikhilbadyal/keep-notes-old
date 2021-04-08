import 'package:flutter/material.dart';
import 'package:notes/views/ScreenHelpers/SettingsScreen.dart';

import '../TopWidget.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    //debugPrint('building 29');
    return const ScreenContainer(
      topScreen: SettingsScreenHelper(),
    );
  }
}
