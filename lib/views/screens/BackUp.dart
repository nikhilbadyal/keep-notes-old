import 'package:flutter/material.dart';
import 'package:notes/views/ScreenHelpers/BackupRestore.dart';

import '../TopWidget.dart';

class BackUpScreen extends StatefulWidget {
  @override
  _BackUpScreenState createState() => _BackUpScreenState();
}

class _BackUpScreenState extends State<BackUpScreen> {
  @override
  Widget build(BuildContext context) {
    //debugPrint('building 20');
    return ScreenContainer(
      topScreen: BackUpScreenHelper(),
    );
  }
}
