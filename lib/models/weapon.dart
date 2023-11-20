import 'package:amt/utils/json_utils.dart';

class Weapon {
  late String name;
  String? type;
  KnownType? known;
  WeaponSize? size;
  DamageTypes? principalDamage;
  DamageTypes? secondaryDamage;
  int? endurance;
  int? breakage;
  int? presence;
  late int turn;
  late int attack;
  late int defense;
  late DefenseType defenseType;
  late int damage;
  int? quality;
  String? characteristic;
  String? warning;
  String? ammunition;
  String? special;

  Weapon(
      {required this.name,
      this.type,
      this.known,
      this.size,
      this.principalDamage,
      this.secondaryDamage,
      this.endurance,
      this.breakage,
      this.presence,
      required this.turn,
      required this.attack,
      required this.defense,
      required this.defenseType,
      required this.damage,
      this.quality,
      this.characteristic,
      this.warning,
      this.ammunition,
      this.special});

  Weapon.fromJson(Map<String, dynamic> json) {
    name = json['nombre'] ?? "";
    type = json['tipo'] ?? "";
    known = JsonUtils.knownType(json['conocimiento'].toString());
    size = JsonUtils.weaponSize(json['tamanio']);
    principalDamage = JsonUtils.damage(json['critPrincipal']);
    secondaryDamage = JsonUtils.damage(json['critSecundario']);
    endurance = JsonUtils.integer(json['entereza'], 5);
    breakage = JsonUtils.integer(json['rotura'], 5);
    presence = JsonUtils.integer(json['presencia'], 10);
    turn = JsonUtils.integer(json['turno'], 10);
    attack = JsonUtils.integer(json['ataque'], 10);
    defense = JsonUtils.integer(json['defensa'], 10);
    defenseType = JsonUtils.defenseType(json['defensaTipo']);
    damage = JsonUtils.integer(json['danio'], 25);
    quality = JsonUtils.integer(json['calidad'], 0);
    characteristic = json['caracteristica'];
    warning = json['advertencia'];
    ammunition = json['municion'];
    special = json['especial'];
  }

  String description({bool lineBreak = false}) {
    return "$name ${lineBreak ? '\n' : ''}HA: $attack ${lineBreak ? '\n' : ''}${defenseType == DefenseType.dodge ? "HE" : "HP"}: $defense ${lineBreak ? '\n' : ''}T: $turn ${lineBreak ? '\n' : ''}DMG: $damage";
  }
}
