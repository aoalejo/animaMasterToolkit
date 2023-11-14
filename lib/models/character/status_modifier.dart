import 'package:amt/utils/json_utils.dart';

class StatusModifier {
  late String name;
  late int attack;
  late int dodge;
  late int parry;
  late int turn;
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
}
