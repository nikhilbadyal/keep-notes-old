import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  const BottomBar();

  @override
  Widget build(BuildContext context) {
    // debugPrint('Bottom bar building 32');
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: Container(
        height: 60.0,
        padding: const EdgeInsets.symmetric(horizontal: 15),
      ),
    );
  }

}
