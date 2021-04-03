import 'package:flutter/material.dart';
import 'package:notes/main.dart';
import 'package:notes/util/Utilites.dart';
import 'package:notes/widget/AppBar.dart';
import 'package:notes/widget/Navigations.dart';

class DoubleBackToCloseWidget extends StatefulWidget {
  final Widget child;

  const DoubleBackToCloseWidget({@required @required this.child});

  static const exitTimeInMillis = 1500;

  @override
  _DoubleBackToCloseWidgetState createState() =>
      _DoubleBackToCloseWidgetState();
}

class _DoubleBackToCloseWidgetState extends State<DoubleBackToCloseWidget> {
  int _lastTimeBackButtonWasTapped;

  @override
  Widget build(BuildContext context) {
    debugPrint('double back building 34');
    bool _isAndroid = Theme.of(context).platform == TargetPlatform.android;
    if (_isAndroid) {
      return WillPopScope(
        onWillPop: () async {
          final _currentTime = DateTime.now().millisecondsSinceEpoch;
          if (_lastTimeBackButtonWasTapped != null &&
              (_currentTime - _lastTimeBackButtonWasTapped) <
                  DoubleBackToCloseWidget.exitTimeInMillis) {
            return true;
          } else {
            _lastTimeBackButtonWasTapped =
                DateTime.now().millisecondsSinceEpoch;

            if (myNotes.drawerManager.isOpened) {
              Utilities.showSnackbar(
                  context,
                  "Press twice to exit",
                  Colors.black87,
                  Duration(
                      milliseconds: DoubleBackToCloseWidget.exitTimeInMillis),
                  Colors.white60);
            } else {
              if (ModalRoute.of(context).settings.name == '/lock' ||
                  ModalRoute.of(context).settings.name == '/setpass') {
                goToHomeScreen(context);
              } else {
                appBar.drawerNotifier.value = false;
                myNotes.drawerManager.openDrawer();
              }
            }
            return false;
          }
        },
        child: widget.child,
      );
    } else {
      return widget.child;
    }
  }
}
