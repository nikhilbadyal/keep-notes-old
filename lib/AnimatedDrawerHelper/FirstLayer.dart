import 'package:flutter/material.dart';

class FirstLayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color(0xFF235789),
      ),
    );
  }
}