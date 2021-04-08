import 'package:flutter/material.dart';
import 'package:notes/util/Utilites.dart';
import 'package:notes/widget/Navigations.dart';

import '../app.dart';

class DoubleBackToCloseWidget extends StatefulWidget {
  const DoubleBackToCloseWidget({@required @required this.child});

  final Widget child;

  static const exitTimeInMillis = 1500;

  @override
  _DoubleBackToCloseWidgetState createState() =>
      _DoubleBackToCloseWidgetState();
}

class _DoubleBackToCloseWidgetState extends State<DoubleBackToCloseWidget> {
  int _lastTimeBackButtonWasTapped;

  @override
  Widget build(BuildContext context) {
    //debugPrint('double back building 34');
    final _isAndroid = Theme.of(context).platform == TargetPlatform.android;
    if (_isAndroid) {
      return WillPopScope(
        onWillPop: () async {
          if (myNotes.drawerManager.isOpened) {
            final _currentTime = DateTime.now().millisecondsSinceEpoch;
            if (_lastTimeBackButtonWasTapped != null &&
                (_currentTime - _lastTimeBackButtonWasTapped) <
                    DoubleBackToCloseWidget.exitTimeInMillis) {
              return Future.value(true);
            } else {
              _lastTimeBackButtonWasTapped =
                  DateTime.now().millisecondsSinceEpoch;
              Utilities.showSnackbar(
                  context,
                  'Press twice to exit',
                  Colors.black87,
                  const Duration(
                      milliseconds: DoubleBackToCloseWidget.exitTimeInMillis),
                  Colors.white60);
              return Future.value(false);
            }
          } else {
            _lastTimeBackButtonWasTapped = null;
            if (ModalRoute.of(context).settings.name == '/lock' ||
                ModalRoute.of(context).settings.name == '/setpass') {
              await goToHomeScreen(context);
              return Future.value(true);
            } else {
              myNotes.drawerManager.openDrawer(context);
              return Future.value(false);
            }
          }
        },
        child: widget.child,
      );
    } else {
      return widget.child;
    }
  }
}
