import 'package:amt/models/enums.dart';
import 'package:function_tree/function_tree.dart';
import 'package:hive/hive.dart';

part 'consumable_state.g.dart';

@HiveType(typeId: 12, adapterName: "ConsumableStateAdapter")
class ConsumableState {
  @HiveField(0)
  String name = "";
  @HiveField(1)
  int maxValue = 100;
  @HiveField(2)
  int actualValue = 10;
  @HiveField(3)
  int step = 10;
  @HiveField(4)
  String description = "";
  @HiveField(5)
  ConsumableType type = ConsumableType.other;

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

  ConsumableState({
    required this.name,
    required this.maxValue,
    required this.actualValue,
    required this.step,
    required this.description,
    this.type = ConsumableType.other,
  });
}
