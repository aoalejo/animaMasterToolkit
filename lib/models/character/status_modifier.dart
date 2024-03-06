import 'package:amt/utils/json_utils.dart';
import 'package:amt/utils/key_value.dart';
import 'package:hive/hive.dart';

part 'status_modifier.g.dart';

@HiveType(typeId: 14, adapterName: 'StatusModifierAdapter')
class StatusModifier extends Object {
  StatusModifier({
    required this.name,
    this.attack = 0,
    this.dodge = 0,
    this.parry = 0,
    this.turn = 0,
    this.physicalAction = 0,
    this.isOfCritical = false,
    this.midValue = 0,
  });

  static StatusModifier? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;

    return StatusModifier(
      name: JsonUtils.string(json['name'], ''),
      attack: JsonUtils.integer(json['attack'], 0),
      dodge: JsonUtils.integer(json['dodge'], 0),
      parry: JsonUtils.integer(json['parry'], 0),
      turn: JsonUtils.integer(json['turn'], 0),
      physicalAction: JsonUtils.integer(json['physicalAction'], 0),
    );
  }

  @HiveField(0)
  late String name;
  @HiveField(1)
  late int attack;
  @HiveField(2)
  late int dodge;
  @HiveField(3)
  late int parry;
  @HiveField(4)
  late int turn;
  @HiveField(5)
  late int physicalAction;
  @HiveField(6)
  late bool? isOfCritical;
  @HiveField(7)
  late int? midValue;

  String description({String separator = ' '}) {
    return descriptionKeyValue().join(separator);
  }

  List<KeyValue> descriptionKeyValue() {
    final list = <KeyValue>[];
    if (attack != 0) {
      list.add(KeyValue(key: 'Ataque', value: attack.toString()));
    }
    if (parry != 0) {
      list.add(KeyValue(key: 'Parada', value: parry.toString()));
    }
    if (dodge != 0) {
      list.add(KeyValue(key: 'Esquiva', value: dodge.toString()));
    }
    if (turn != 0) {
      list.add(KeyValue(key: 'Turno', value: turn.toString()));
    }
    if (physicalAction != 0) {
      list.add(KeyValue(key: 'Acc. Físicas', value: physicalAction.toString()));
    }

    if (isOfCritical == true && midValue != null) {
      if (attack != midValue) {
        list.add(KeyValue(key: 'Recuperación', value: 'hasta: $midValue a 5/turno'));
      }
    }

    return list;
  }

  @override
  String toString() {
    return name;
  }

  @override
  bool operator ==(Object other) {
    if (other is StatusModifier) {
      return other.name == name;
    }
    return false;
  }

  @override
  int get hashCode => name.hashCode;
}
