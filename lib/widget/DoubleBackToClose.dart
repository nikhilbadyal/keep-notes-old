import 'package:flutter/material.dart';
import 'package:notes/main.dart';
import 'package:notes/util/DrawerManager.dart';
import 'package:notes/util/Utilites.dart';
import 'package:notes/widget/AppBar.dart';

// ignore: must_be_immutable  //TODO, must_be_immutable
class DoubleBackToCloseWidget extends StatefulWidget {
  final Widget child;
  final DrawerManager drawerManager;

  DoubleBackToCloseWidget({@required this.child, this.drawerManager});

  static const exitTimeInMillis = 1500;

  @override
  _DoubleBackToCloseWidgetState createState() =>
      _DoubleBackToCloseWidgetState();
}

class _DoubleBackToCloseWidgetState extends State<DoubleBackToCloseWidget> {
  int _lastTimeBackButtonWasTapped;

  @override
  Widget build(BuildContext context) {
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

            if(myNotes.drawerManager.isOpened){
              Utilities.showSnackbar(
                  context,
                  "Press twice to exit",
                  Colors.black87,
                  Duration(
                      milliseconds: DoubleBackToCloseWidget.exitTimeInMillis),
                  Colors.white60);
            }else{
              appBar.callSetState();
              myNotes.drawerManager.openDrawer();
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

/* Future<bool> _handleWillPop() async {
    final _currentTime = DateTime.now().millisecondsSinceEpoch;

    if (_lastTimeBackButtonWasTapped != null &&
        (_currentTime - _lastTimeBackButtonWasTapped) < exitTimeInMillis) {
      await appBar.callSetState();
      await myNotes.drawerManager.closeDrawer();
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
      Utilities.showSnackbar(context, "Press back again to exit",
          Colors.black87, Duration(milliseconds: 3000), Colors.white60);
      return false;
    }
  }*/
