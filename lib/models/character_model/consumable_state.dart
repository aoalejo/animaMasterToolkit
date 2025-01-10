import 'dart:math';

import 'package:amt/lib.dart';
import 'package:amt/models/enums.dart';
import 'package:function_tree/function_tree.dart';
import 'package:hive/hive.dart';

part 'consumable_state.g.dart';

@HiveType(typeId: 12, adapterName: 'ConsumableStateAdapter')
class ConsumableState {
  ConsumableState({
    required this.name,
    required this.maxValue,
    required this.actualValue,
    required this.step,
    required this.description,
    this.type = ConsumableType.other,
  });

  ConsumableState.from({required this.name, required int value, required this.type}) {
    maxValue = value;
    actualValue = value;
    step = max(value ~/ 10, 1);
  }

  @HiveField(0)
  String name = '';
  @HiveField(1)
  int maxValue = 100;
  @HiveField(2)
  int actualValue = 10;
  @HiveField(3)
  int step = 10;
  @HiveField(4)
  String description = '';
  @HiveField(5)
  ConsumableType type = ConsumableType.other;

  Map<String, dynamic> toJson() {
    return {
      'max': maxValue,
      'actual': actualValue,
      'name': name,
      'step': step,
      'description': description,
      'type': type.name,
    };
  }

  static ConsumableState? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;

    return ConsumableState(
      name: JsonUtils.string(json['name'], '-'),
      maxValue: JsonUtils.integer(json['max'], 0),
      actualValue: JsonUtils.integer(json['actual'], 0),
      step: JsonUtils.integer(json['step'], 0),
      description: JsonUtils.string(json['description'], '-'),
      type: ConsumableType.values.firstWhere((e) => e.name == json['type'], orElse: () => ConsumableType.other),
    );
  }

  void update({String? max, String? actual}) {
    if (max != null) {
      try {
        maxValue = max.interpret().toInt();
      } catch (e) {
        maxValue = 0;
      }
    }

    if (actual != null) {
      try {
        actualValue = actual.interpret().toInt();
      } catch (e) {
        actualValue = 0;
      }
    }
  }

  ConsumableState copy() {
    return ConsumableState(
      name: name,
      maxValue: maxValue,
      actualValue: actualValue,
      step: step,
      description: description,
      type: type,
    );
  }
}
