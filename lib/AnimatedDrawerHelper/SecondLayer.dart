import 'package:flutter/material.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:notes/util/DrawerManager.dart';

SecondLayerState secondLayer;

class SecondLayer extends StatefulWidget {
  @override
  SecondLayerState createState() => SecondLayerState();

  const SecondLayer();
}

class SecondLayerState extends State<SecondLayer>
    with TickerProviderStateMixin {
  AnimationController _xController;
  AnimationController _yController;
  AnimationController _angleController;

  @override
  void initState() {
    _xController = AnimationController(
      duration: Duration(milliseconds: DrawerManager.SecondLayerAnimationTime),
      vsync: this,
      lowerBound: 0,
      upperBound: 123,
    );
    _yController = AnimationController(
      duration: Duration(milliseconds: DrawerManager.SecondLayerAnimationTime),
      vsync: this,
      lowerBound: 0,
      upperBound: 110,
    );
    _angleController = AnimationController(
      duration: Duration(milliseconds: DrawerManager.SecondLayerAnimationTime),
      vsync: this,
      lowerBound: 0,
      upperBound: 0.275,
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
    debugPrint(' second layer building 3 ');
    secondLayer = this;
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
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFFBAFF29),
        ),
      ),
    );
    /*return AnimatedContainer(
      transform: Matrix4Transform()
          .translate(x: xOffSet, y: yOffSet)
          .rotate(angle)
          .matrix4,
      duration: Duration(milliseconds: 750),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFFBAFF29),
      ),
    );*/
  }
}
