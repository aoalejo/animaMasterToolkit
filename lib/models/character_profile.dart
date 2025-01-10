import 'package:amt/utils/json_utils.dart';
import 'package:hive/hive.dart';

part 'character_profile.g.dart';

@HiveType(typeId: 2, adapterName: 'CharacterProfileAdapter')
class CharacterProfile {
  CharacterProfile({
    this.fatigue = 6,
    this.hitPoints = 60,
    this.regeneration = 1,
    this.name = '',
    this.category = '',
    this.level = '',
    this.kind = '',
    this.speed = 6,
    this.isNpc = false,
    this.image = '',
    this.fumbleLevel = 3,
    this.nature = 5,
    this.uroboros = false,
    this.damageAccumulation = false,
    this.critLevel = 90,
  });

  static CharacterProfile? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;

    return CharacterProfile(
      category: JsonUtils.string(json['categoria'], ''),
      fatigue: JsonUtils.integer(json['cansancio'], 6),
      hitPoints: JsonUtils.integer(json['puntosDeVida'], 60),
      regeneration: JsonUtils.integer(json['regeneracion'], 1),
      name: JsonUtils.string(json['nombre'], ''),
      level: JsonUtils.string(json['nivel'], ''),
      kind: JsonUtils.string(json['clase'], ''),
      speed: JsonUtils.integer(json['movimiento'], 6),
      image: JsonUtils.string(json['imagen'], ''),
      fumbleLevel: JsonUtils.integer(json['nivelDePifia'], 3),
      nature: JsonUtils.integer(json['natura'], 5),
      uroboros: JsonUtils.boolean(json['uruboros'], placeholder: false),
      damageAccumulation: JsonUtils.boolean(json['acumulacionDeDanio'], placeholder: false),
      critLevel: JsonUtils.integer(json['nivelDeCritico'], 90),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoria': category,
      'cansancio': fatigue,
      'puntosDeVida': hitPoints,
      'regeneracion': regeneration,
      'nombre': name,
      'nivel': level,
      'clase': kind,
      'movimiento': speed,
      'imagen': image,
      'nivelDePifia': fumbleLevel,
      'natura': nature,
      'uruboros': uroboros,
      'acumulacionDeDanio': damageAccumulation,
      'nivelDeCritico': critLevel,
    };
  }

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
  @HiveField(10)
  late int? fumbleLevel;
  @HiveField(11)
  late int? nature;
  @HiveField(12)
  late bool? uroboros;
  @HiveField(13)
  late bool? damageAccumulation;
  @HiveField(14)
  late int? critLevel;

  CharacterProfile copy({bool? isNpc, int? number}) {
    return CharacterProfile(
      fatigue: fatigue,
      hitPoints: hitPoints,
      regeneration: regeneration,
      name: number != null ? '${name.split('#').first.trim()} #$number' : name,
      category: category,
      level: level,
      kind: kind,
      speed: speed,
      isNpc: isNpc ?? this.isNpc,
      fumbleLevel: fumbleLevel,
      nature: nature,
      uroboros: uroboros,
      damageAccumulation: damageAccumulation,
      critLevel: critLevel,
    );
  }
}
