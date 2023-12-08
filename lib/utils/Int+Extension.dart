import 'package:flutter/material.dart';

extension color on int {
  Color get percentageColor {
    if (this > 90) return Colors.transparent;
    if (this > 75) return Color.fromARGB(255, 86, 240, 0);
    if (this > 50) return Color.fromARGB(255, 252, 232, 58);
    if (this > 25) return Color.fromARGB(255, 255, 179, 2);
    return Color.fromARGB(255, 255, 56, 56);
  }
}
