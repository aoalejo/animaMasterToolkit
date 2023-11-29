import 'package:amt/utils/json_utils.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 14, adapterName: "StatusModifierAdapter")
class StatusModifier extends Object {
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

  StatusModifier(
      {required this.name,
      this.attack = 0,
      this.dodge = 0,
      this.parry = 0,
      this.turn = 0,
      this.physicalAction = 0});

  StatusModifier.fromJson(Map<String, dynamic> json) {
    name = json['name'];

    attack = JsonUtils.integer(json['attack'], 0);
    dodge = JsonUtils.integer(json['dodge'], 0);
    parry = JsonUtils.integer(json['parry'], 0);
    turn = JsonUtils.integer(json['turn'], 0);
    physicalAction = JsonUtils.integer(json['physicalAction'], 0);
  }

  String description() {
    var description = "";

    if (attack != 0) {
      description = '$description Ataque: $attack';
    }
    if (parry != 0) {
      description = '$description Parada: $attack';
    }
    if (dodge != 0) {
      description = '$description Esquiva: $dodge';
    }
    if (turn != 0) {
      description = '$description Turno: $turn';
    }
    if (physicalAction != 0) {
      description = '$description, Acciones Fisicas: $physicalAction';
    }
    return description;
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
