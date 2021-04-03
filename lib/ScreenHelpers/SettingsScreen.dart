import 'package:flutter/material.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:notes/main.dart';
import 'package:notes/util/DrawerManager.dart';
import 'package:notes/widget/AppBar.dart';
import 'package:notes/widget/DoubleBackToClose.dart';
import 'package:notes/widget/Navigations.dart';

_SettingsScreenHelperState settings;

class SettingsScreenHelper extends StatefulWidget {
  @override
  _SettingsScreenHelperState createState() {
    return _SettingsScreenHelperState();
  }

  const SettingsScreenHelper();
}

class _SettingsScreenHelperState extends State<SettingsScreenHelper>
    with TickerProviderStateMixin {
  AnimationController _xController;
  AnimationController _yController;
  AnimationController _angleController;

  @override
  void initState() {
    _xController = AnimationController(
      duration: Duration(milliseconds: DrawerManager.animationTime),
      vsync: this,
      lowerBound: 0,
      upperBound: 150,
    );
    _yController = AnimationController(
      duration: Duration(milliseconds: DrawerManager.animationTime),
      vsync: this,
      lowerBound: 0,
      upperBound: 80,
    );
    _angleController = AnimationController(
      duration: Duration(milliseconds: DrawerManager.animationTime),
      vsync: this,
      lowerBound: 0,
      upperBound: 0.2,
    );
    super.initState();
  }

  animate() {
    if (_xController.isCompleted) {
      _xController.reverse();
      _yController.reverse();
      _angleController.reverse();
    } else {
      _xController.forward(from: 0);
      _yController.forward(from: 0);
      _angleController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _xController.dispose();
    _yController.dispose();
    _angleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('building 11');
    settings = this;
    return AnimatedBuilder(
      animation: _xController,
      builder: (BuildContext context, Widget child) {
        return Transform(
          transform: Matrix4Transform()
              .translate(x: _xController.value, y: _yController.value)
              .rotate(-_angleController.value)
              .matrix4,
          child: child,
        );
      },
      child: DoubleBackToCloseWidget(
        child: Scaffold(
          appBar: MyAppBar(
            title: "Settings",
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
      ),
    );
  }

  Widget body(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: const Text(
            "Change Password",
          ),
          leading: Icon(Icons.fingerprint_outlined),
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
