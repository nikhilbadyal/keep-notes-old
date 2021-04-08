import 'package:flutter/material.dart';

class FirstLayer extends StatelessWidget {
  const FirstLayer();

  @override
  Widget build(BuildContext context) {
    debugPrint('first layer building 2');
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Color(0xFF235789),
      ),
    );
  }
}
