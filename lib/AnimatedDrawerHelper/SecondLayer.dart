import 'package:flutter/material.dart';
import 'package:matrix4_transform/matrix4_transform.dart';

SecondLayerState secondLayer;

class SecondLayer extends StatefulWidget {
  @override
  SecondLayerState createState() => SecondLayerState();
}

class SecondLayerState extends State<SecondLayer> {
  double xOffSet = 0;
  double yOffSet = 0;
  double angle = 0;
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    secondLayer = this;
    return AnimatedContainer(
        transform: Matrix4Transform()
            .translate(x: xOffSet, y: yOffSet)
            .rotate(angle)
            .matrix4,
        duration: Duration(milliseconds: 550),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(0xFFBAFF29),
        ),
        child: Column(
          children: [
            Row(
              children: [],
            )
          ],
        ));
  }
}
