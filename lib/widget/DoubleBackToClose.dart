import 'package:flutter/material.dart';
import 'package:notes/main.dart';
import 'package:notes/util/DrawerManager.dart';
import 'package:notes/widget/AppBar.dart';

class DoubleBackToCloseWidget extends StatefulWidget {
  final Widget child;
  final DrawerManager drawerManager;

  const DoubleBackToCloseWidget({@required this.child, this.drawerManager});

  @override
  _DoubleBackToCloseWidgetState createState() =>
      _DoubleBackToCloseWidgetState();
}

class _DoubleBackToCloseWidgetState extends State<DoubleBackToCloseWidget> {
  int _lastTimeBackButtonWasTapped;
  static const exitTimeInMillis = 1;

  bool get _isAndroid => Theme.of(context).platform == TargetPlatform.android;

  @override
  Widget build(BuildContext context) {
    if (_isAndroid) {
      return WillPopScope(
        onWillPop: _handleWillPop,
        child: widget.child,
      );
    } else {
      return widget.child;
    }
  }

  Future<bool> _handleWillPop() async {
    final _currentTime = DateTime.now().millisecondsSinceEpoch;

    if (_lastTimeBackButtonWasTapped != null &&
        (_currentTime - _lastTimeBackButtonWasTapped) < exitTimeInMillis) {
      appBar.callSetState();
      myNotes.drawerManager.closeDrawer();

      return true;
    } else {
      _lastTimeBackButtonWasTapped = DateTime.now().millisecondsSinceEpoch;
      if (!myNotes.drawerManager.localIsOpen) {
        appBar.callSetState();
        myNotes.drawerManager.openDrawer();
      } else {
        appBar.callSetState();
        myNotes.drawerManager.closeDrawer();
      }
      return false;
    }
  }
}
