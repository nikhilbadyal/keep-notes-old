import 'package:flutter/material.dart';
import 'package:notes/views/ScreenHelpers/ArchiveScreen.dart';
import 'package:notes/views/TopWidget.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({Key key, this.fab}) : super(key: key);

  final Widget fab;

  @override
  _ArchiveScreenState createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  @override
  Widget build(BuildContext context) {
    //debugPrint('building 19');
    return ScreenContainer(topScreen: ArchiveScreenHelper());
  }
}
