import 'package:amt/utils/json_utils.dart';
import 'package:hive/hive.dart';

part 'character_profile.g.dart';

@HiveType(typeId: 2, adapterName: "CharacterProfileAdapter")
class CharacterProfile {
  @HiveField(0)
  late int fatigue;
  @HiveField(1)
  late int hitPoints;
  @HiveField(2)
  late int regeneration;
  @HiveField(3)
  late String name;
  @HiveField(4)
  late String category;
  @HiveField(5)
  late String level;
  @HiveField(6)
  late String kind;
  @HiveField(7)
  late int speed;
  @HiveField(8)
  late bool? isNpc;
  @HiveField(9)
  late String? image;

  CharacterProfile(
      {this.fatigue = 6,
      this.hitPoints = 60,
      this.regeneration = 1,
      this.name = "",
      this.category = "",
      this.level = "",
      this.kind = "",
      this.speed = 6,
      this.isNpc = false,
      this.image = ""});

  CharacterProfile.fromJson(Map<String, dynamic> json) {
    fatigue = JsonUtils.integer(json['cansancio'], 6);
    hitPoints = JsonUtils.integer(json['puntosDeVida'], 60);
    regeneration = JsonUtils.integer(json['regeneracion'], 1);
    name = json['nombre'] ?? "";
    category = json['categoria'] ?? "";
    level = json['nivel'] ?? "";
    kind = json['clase'] ?? "";
    speed = JsonUtils.integer(json['movimiento'], 6);
    isNpc = false;
    image = json['imagen'] ?? "";
  }

  CharacterProfile copy({bool? isNpc, int? number}) {
    return CharacterProfile(
      fatigue: fatigue,
      hitPoints: hitPoints,
      regeneration: regeneration,
      name: number != null ? '$name #$number' : name,
      category: category,
      level: level,
      kind: kind,
      speed: speed,
      isNpc: isNpc ?? this.isNpc,
    );
  }
}
