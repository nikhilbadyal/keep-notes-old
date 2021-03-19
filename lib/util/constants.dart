import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const grey = Color(0xFFEAEAEA);
const grey2 = Color(0xFF6D6D6D);
const black = Color(0xFF1C1C1C);
const black2 = Color(0xFF424242);
const headerColor = Colors.blue;

// const headerColor = Color(0xFFFD5872);
const white = Colors.white;

var shadow = [
  BoxShadow(
    color: Colors.grey[200],
    blurRadius: 30,
    offset: Offset(0, 10),
  )
];
var createTitle = GoogleFonts.roboto(
  textStyle: TextStyle(
    fontSize: 10.0,
    //fontWeight: FontWeight.w900,
  ),
);
var itemTitle = GoogleFonts.roboto(
  textStyle: TextStyle(
    fontSize: 18.0,
    color: black,
    fontWeight: FontWeight.bold,
  ),
);
var itemDateStyle = GoogleFonts.roboto(
  textStyle: TextStyle(
    fontSize: 11.0,
    color: grey2,
  ),
);
var itemContentStyle = GoogleFonts.roboto(
  textStyle: TextStyle(
    fontSize: 15.0,
    color: grey2,
  ),
);
var viewTitleStyle = GoogleFonts.roboto(
  fontWeight: FontWeight.w900,
  fontSize: 28.0,
);
var viewContentStyle = GoogleFonts.roboto(
    letterSpacing: 1.0,
    fontSize: 20.0,
    height: 1.5,
    fontWeight: FontWeight.w400);
