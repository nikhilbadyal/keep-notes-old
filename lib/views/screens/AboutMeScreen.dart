import 'package:flutter/material.dart';
import 'package:notes/views/ScreenHelpers/AboutMeScreen.dart';

import '../TopWidget.dart';

class AboutMeScreen extends StatefulWidget {
  @override
  _AboutMeScreenState createState() => _AboutMeScreenState();
}

class _AboutMeScreenState extends State<AboutMeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //debugPrint('building 18');
    return const ScreenContainer(
      topScreen: AboutMeScreenHelper(),
    );
  }
}
