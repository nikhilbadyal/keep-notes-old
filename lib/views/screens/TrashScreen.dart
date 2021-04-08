import 'package:flutter/material.dart';
import 'package:notes/views/ScreenHelpers/TrashScreen.dart';

import '../TopWidget.dart';

class TrashScreen extends StatefulWidget {
  @override
  _TrashScreenState createState() => _TrashScreenState();
}

class _TrashScreenState extends State<TrashScreen> {
  @override
  Widget build(BuildContext context) {
    //debugPrint('building 30');
    return ScreenContainer(
      topScreen: TrashScreenHelper(),
    );
  }
}
