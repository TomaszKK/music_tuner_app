import 'package:flutter/material.dart';

class FontManager {
  static const String poppins = 'Poppins';
  static const String roboto = 'Roboto';

  static const TextStyle headingStyle = TextStyle(
    fontFamily: poppins,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontFamily: roboto,
    fontSize: 16,
    color: Colors.black,
  );
}
