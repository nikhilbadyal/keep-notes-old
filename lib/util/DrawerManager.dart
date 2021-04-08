import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:notes/Animations/AnimatedDrawerHelper/SecondLayer.dart';
import 'package:notes/views/TopWidget.dart';
import 'package:notes/widget/AppBar.dart';
import 'package:provider/provider.dart';

class DrawerManager with ChangeNotifier {
  double xOffSet = 0;
  double yOffSet = 0;
  double angle = 0;
  bool isOpened = false;
  bool isIgnoring = false;
  static int animationTime = 300;
  static int secondLayerAnimationTime = 500;

  void callback(BuildContext context, bool isOpen) {
    // final status = Provider.of<AppbarStatus>(context, listen: false);
    if (isOpen) {
      xOffSet = 0;
      yOffSet = 0;
      angle = 0;
      isOpened = false;
      isIgnoring = false;
      secondLayer.callSetState(0, 0, 0);
      // secondLayer.animate();
      animatedDrawer();
      // status.close();
    } else {
      //   print('opening');
      xOffSet = 150;
      yOffSet = 80;
      angle = -0.2;
      isOpened = true;
      isIgnoring = true;
      secondLayer.callSetState(123, 110, -0.275);
      // secondLayer.animate();
      animatedDrawer();
      // status.open();
    }
  }

  void openDrawer(BuildContext context) {
    callback(context, false);
  }

  void closeDrawer(BuildContext context) {
    callback(context, true);
  }

  void resetDrawerState(BuildContext context) {
    xOffSet = 0;
    yOffSet = 0;
    angle = 0;
    isOpened = false;
    isIgnoring = false;
    final status = Provider.of<AppbarStatus>(context, listen: false);
    status.toggle();
  }

  void animatedDrawer() {
    topWidgetState.animate();
  }
}
