import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF7621FB);
  static const Color textColor = Color(0xffA188FF);
  static const Color textFieldBorder = Colors.grey;
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
