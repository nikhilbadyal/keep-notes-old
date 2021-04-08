import 'package:flutter/material.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:notes/util/DrawerManager.dart';

import '../Animations/AnimatedDrawerHelper/Drawer.dart';
import '../Animations/AnimatedDrawerHelper/FirstLayer.dart';
import '../Animations/AnimatedDrawerHelper/SecondLayer.dart';
import '../app.dart';

_ScreenContainerState topWidgetState;

class ScreenContainer extends StatefulWidget {
  const ScreenContainer({Key key, @required this.topScreen}) : super(key: key);

  final Widget topScreen;

  @override
  _ScreenContainerState createState() => _ScreenContainerState();
}

class _ScreenContainerState extends State<ScreenContainer>
    with TickerProviderStateMixin {
  Widget w1;
  Widget w2;
  Widget w3;

  /* AnimationController _xController;
  AnimationController _yController;
  AnimationController _angleController;*/

  @override
  void initState() {
    w1 = const FirstLayer();
    w2 = SecondLayer();
    w3 = const ThirdLayer();
    /*_xController = AnimationController(
      duration: const Duration(milliseconds: DrawerManager.animationTime),
      vsync: this,
      lowerBound: 0,
      upperBound: 150,
    );
    _yController = AnimationController(
      duration: const Duration(milliseconds: DrawerManager.animationTime),
      vsync: this,
      lowerBound: 0,
      upperBound: 80,
    );
    _angleController = AnimationController(
      duration: const Duration(milliseconds: DrawerManager.animationTime),
      vsync: this,
      lowerBound: 0,
      upperBound: 0.2,
    );*/
    super.initState();
  }

  void animate() {
    setState(() {});
    /*if (_xController.isCompleted) {
      _xController.reverse();
      _yController.reverse();
      _angleController.reverse();
    } else {
      _xController.forward(from: 0);
      _yController.forward(from: 0);
      _angleController.forward(from: 0);
    }*/
  }

  /*@override
  void dispose() {
    _xController.dispose();
    _yController.dispose();
    _angleController.dispose();
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    topWidgetState = this;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          w1,
          w2,
          w3,
          AnimatedContainer(
            transform: Matrix4Transform()
                .translate(
                    x: myNotes.drawerManager.xOffSet,
                    y: myNotes.drawerManager.yOffSet)
                .rotate(myNotes.drawerManager.angle)
                .matrix4,
            duration: Duration(milliseconds: DrawerManager.animationTime),
            child: widget.topScreen,
          ),
          /* AnimatedBuilder(
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
            child: widget.topScreen,
          )*/
        ],
      ),
    );
  }
}
