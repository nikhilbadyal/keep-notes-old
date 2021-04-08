import 'package:flutter/material.dart';
import 'package:notes/widget/AppBar.dart';
import 'package:notes/widget/DoubleBackToClose.dart';
import 'package:notes/widget/Navigations.dart';

import '../../app.dart';

class SettingsScreenHelper extends StatefulWidget {
  const SettingsScreenHelper();

  @override
  _SettingsScreenHelperState createState() {
    return _SettingsScreenHelperState();
  }
}

class _SettingsScreenHelperState extends State<SettingsScreenHelper>
    with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    //debugPrint('building 11');
    return DoubleBackToCloseWidget(
      child: Scaffold(
        appBar: const MyAppBar(
          title: 'Settings',
        ),
        body: DoubleBackToCloseWidget(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: body(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget body(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      children: <Widget>[
        ListTile(
          title: const Text(
            'Change Password',
          ),
          leading: const Icon(Icons.fingerprint_outlined),
          onTap: () {
            goToSetPasswordScreen(
              context,
              myNotes.lockChecker.password,
            );
          },
        ),
      ],
    );
  }
}
