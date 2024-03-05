import 'package:amt/models/enums.dart';
import 'package:amt/utils/json_utils.dart';
import 'package:hive/hive.dart';

part 'weapon.g.dart';

@HiveType(typeId: 6, adapterName: 'WeaponAdapter')
class Weapon {

  Weapon({
    required this.name,
    required this.turn, required this.attack, required this.defense, required this.defenseType, required this.damage, this.type,
    this.known,
    this.size,
    this.principalDamage,
    this.secondaryDamage,
    this.endurance,
    this.breakage,
    this.presence,
    this.quality,
    this.characteristic,
    this.warning,
    this.ammunition,
    this.special,
    this.variableDamage = false,
  });

  Weapon.fromJson(Map<String, dynamic> json) {
    name = json['nombre'] ?? '';
    type = json['tipo'] ?? '';
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
    variableDamage = JsonUtils.boolean(json['variable'], false);
  }

  Weapon.blank() {
    name = '';
    turn = 0;

    attack = 0;
    defense = 0;
    defenseType = DefenseType.dodge;
    damage = 0;
  }
  @HiveField(0)
  late String name;
  @HiveField(1)
  String? type;
  @HiveField(2)
  KnownType? known;
  @HiveField(3)
  WeaponSize? size;
  @HiveField(4)
  DamageTypes? principalDamage;
  @HiveField(5)
  DamageTypes? secondaryDamage;
  @HiveField(6)
  int? endurance;
  @HiveField(7)
  int? breakage;
  @HiveField(8)
  int? presence;
  @HiveField(9)
  late int turn;
  @HiveField(10)
  late int attack;
  @HiveField(11)
  late int defense;
  @HiveField(12)
  late DefenseType defenseType;
  @HiveField(13)
  late int damage;
  @HiveField(14)
  int? quality;
  @HiveField(15)
  String? characteristic;
  @HiveField(16)
  String? warning;
  @HiveField(17)
  String? ammunition;
  @HiveField(18)
  String? special;
  @HiveField(19)
  bool? variableDamage;

  String description({bool lineBreak = false}) {
    return "$name ${lineBreak ? '\n' : ''}HA: $attack ${lineBreak ? '\n' : ''}${defenseType == DefenseType.dodge ? "HE" : "HP"}: $defense ${lineBreak ? '\n' : ''}T: $turn ${lineBreak ? '\n' : ''}DMG: $damage ${principalDamage?.name()}/${secondaryDamage?.name()} ";
  }

  Weapon copy() {
    return Weapon(
      name: name,
      turn: turn,
      attack: attack,
      defense: defense,
      defenseType: defenseType,
      damage: damage,
    );
  }
}
