import 'package:flutter/material.dart';

class  BottomBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      child: Container(
        height: 60.0,
        padding: EdgeInsets.symmetric(horizontal: 15),
      ),
    );
  }

}
