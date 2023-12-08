import 'package:flutter/material.dart';

extension color on int {
  Color get percentageColor {
    if (this > 99) return Colors.transparent;
    if (this > 75) return Color.fromARGB(255, 0, 226, 0);
    if (this > 50) return Color.fromARGB(255, 250, 216, 0);
    if (this > 25) return Color.fromARGB(255, 255, 175, 61);
    return Color.fromARGB(255, 255, 42, 4);
  }
}
