import 'package:amt/utils/json_utils.dart';

class CharacterProfile {
  late int fatigue;
  late int hitPoints;
  late int regeneration;
  late String name;
  late String category;
  late String level;
  late String kind;
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
