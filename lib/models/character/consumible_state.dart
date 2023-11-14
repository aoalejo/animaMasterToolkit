import 'package:function_tree/function_tree.dart';

class ConsumibleState {
  String name = "";
  int maxValue = 100;
  int actualValue = 10;
  int step = 10;
  String description = "";

  void updateMax(String newValue) {
    try {
      maxValue = newValue.interpret().toInt();
    } catch (e) {
      maxValue = 0;
    }
  }

  void updateActual(String newValue) {
    try {
      actualValue = newValue.interpret().toInt();
    } catch (e) {
      actualValue = 0;
    }
  }

  ConsumibleState({
    required this.name,
    required this.maxValue,
    required this.actualValue,
    required this.step,
    required this.description,
  });
}
