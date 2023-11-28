import 'package:amt/utils/json_utils.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 10)
class Mystical {
  @HiveField(0)
  int zeonRegeneration;
  @HiveField(0)
  int act;
  @HiveField(1)
  int zeon;
  @HiveField(2)
  Map<String, String> paths;
  @HiveField(3)
  Map<String, String> subPaths;
  @HiveField(4)
  Map<String, String> metamagic;
  @HiveField(5)
  Map<String, String> spellsMaintained;
  @HiveField(6)
  Map<String, String> spellsPurchased;

  Mystical({
    required this.zeonRegeneration,
    required this.act,
    required this.zeon,
    required this.paths,
    required this.subPaths,
    required this.metamagic,
    required this.spellsMaintained,
    required this.spellsPurchased,
  });

  factory Mystical.fromJson(Map<String, dynamic> json) {
    return Mystical(
      zeonRegeneration: JsonUtils.integer(json['regen'], 0),
      act: JsonUtils.integer(json['act'], 0),
      zeon: JsonUtils.integer(json['zeon'], 0),
      paths: Map<String, String>.from(json['Vias']),
      subPaths: Map<String, String>.from(json['SubVias']),
      metamagic: Map<String, String>.from(json['Metamagia']),
      spellsMaintained: Map<String, String>.from(json['Conjuros']),
      spellsPurchased: Map<String, String>.from(json['Libres']),
    );
  }
}
