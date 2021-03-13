import 'package:flutter/material.dart';
import 'package:notes/main.dart';
import 'package:notes/util/DrawerManager.dart';

class DoubleBackToCloseWidget extends StatefulWidget {
  final Widget child; // Make Sure this child has a Scaffold widget as parent.
  final DrawerManager drawerManager;

  const DoubleBackToCloseWidget({@required this.child, this.drawerManager});

  @override
  _DoubleBackToCloseWidgetState createState() =>
      _DoubleBackToCloseWidgetState();
}

class _DoubleBackToCloseWidgetState extends State<DoubleBackToCloseWidget> {
  bool isDrawerOpened = false;
  int _lastTimeBackButtonWasTapped;
  static const exitTimeInMillis = 700;

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
      myNotes.drawerManager.closeDrawer();
      return true;
    } else {
      _lastTimeBackButtonWasTapped = DateTime.now().millisecondsSinceEpoch;
      if (!isDrawerOpened) {
        myNotes.drawerManager.openDrawer();
      } else {
        myNotes.drawerManager.closeDrawer();
      }
      isDrawerOpened = !isDrawerOpened;
      // Scaffold.of(context).removeCurrentSnackBar();
      /*Scaffold.of(context).showSnackBar(
        _getExitSnackBar(context),
      );*/
      return false;
    }
  }
/*SnackBar _getExitSnackBar(
      BuildContext context,
      ) {
    return SnackBar(
      content: Text(
        'Press BACK again to exit!',
      ),
      backgroundColor: Colors.red,
      duration: const Duration(
        seconds: 2,
      ),
      behavior: SnackBarBehavior.floating,
    );
  }*/
}
