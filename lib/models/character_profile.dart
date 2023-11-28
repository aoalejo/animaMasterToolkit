import 'package:amt/utils/json_utils.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 2)
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

  CharacterProfile(
      {this.fatigue = 6,
      this.hitPoints = 60,
      this.regeneration = 1,
      this.name = "",
      this.category = "",
      this.level = "",
      this.kind = "",
      this.speed = 6});

  CharacterProfile.fromJson(Map<String, dynamic> json) {
    fatigue = JsonUtils.integer(json['cansancio'], 6);
    hitPoints = JsonUtils.integer(json['puntosDeVida'], 60);
    regeneration = JsonUtils.integer(json['regeneracion'], 1);
    name = json['nombre'] ?? "";
    category = json['categoria'] ?? "";
    level = json['nivel'] ?? "";
    kind = json['clase'] ?? "";
    speed = JsonUtils.integer(json['movimiento'], 6);
  }
}
