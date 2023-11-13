import 'package:amt/utils/json_utils.dart';

class Mystical {
  int zeonRegeneration;
  int act;
  int zeon;
  Map<String, String> paths;
  Map<String, String> subPaths;
  Map<String, String> metamagia;
  Map<String, String> spellsMaintained;
  Map<String, String> spellsPurchased;

  Mystical({
    required this.zeonRegeneration,
    required this.act,
    required this.zeon,
    required this.paths,
    required this.subPaths,
    required this.metamagia,
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
      metamagia: Map<String, String>.from(json['Metamagia']),
      spellsMaintained: Map<String, String>.from(json['Conjuros']),
      spellsPurchased: Map<String, String>.from(json['Libres']),
    );
  }
}
