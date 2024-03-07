import 'package:flutter/material.dart';
import 'package:function_tree/function_tree.dart';

extension Extensions on int {
  Color percentageColor({bool lastTransparent = true}) {
    if (this > 99) {
      return lastTransparent ? Colors.transparent : const Color.fromARGB(255, 0, 226, 0);
    }
    if (this > 75) return const Color.fromARGB(255, 0, 226, 0);
    if (this > 50) return const Color.fromARGB(255, 250, 216, 0);
    if (this > 25) return const Color.fromARGB(255, 255, 175, 61);
    return const Color.fromARGB(255, 255, 42, 4);
  }

  int get roundToTens {
    return (this / 10).floor() * 10;
  }

  int get roundToFives {
    return (this / 5).floor() * 5;
  }
}

extension Interpret on String {
  int get safeInterpret {
    try {
      return interpret().toInt();
    } catch (e) {
      return 0;
    }
  }
}
