import 'package:amt/utils/json_utils.dart';
import 'package:hive/hive.dart';

part 'status_modifier.g.dart';

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
  @HiveField(6)
  late bool? isOfCritical;
  @HiveField(7)
  late int? midValue;

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

  StatusModifier.fromJson(Map<String, dynamic> json) {
    name = json['name'];

    attack = JsonUtils.integer(json['attack'], 0);
    dodge = JsonUtils.integer(json['dodge'], 0);
    parry = JsonUtils.integer(json['parry'], 0);
    turn = JsonUtils.integer(json['turn'], 0);
    physicalAction = JsonUtils.integer(json['physicalAction'], 0);
    isOfCritical = false;
    midValue = 0;
  }

  String description({String separator = " "}) {
    var description = "";

    if (attack != 0) {
      description = '$description${separator}Ataque: $attack';
    }
    if (parry != 0) {
      description = '$description${separator}Parada: $attack';
    }
    if (dodge != 0) {
      description = '$description${separator}Esquiva: $dodge';
    }
    if (turn != 0) {
      description = '$description${separator}Turno: $turn';
    }
    if (physicalAction != 0) {
      description = '$description${separator}Acciones Fisicas: $physicalAction';
    }

    if (isOfCritical == true && midValue != null) {
      if (attack == midValue) {
        description =
            '$description${separator}Se recuperó hasta la mitad de su valor';
      } else {
        description =
            '$description${separator}Se recupera hasta: $midValue a 5/turno';
      }
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
