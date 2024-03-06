import 'package:amt/utils/json_utils.dart';
import 'package:hive/hive.dart';

part 'mystical.g.dart';

@HiveType(typeId: 10)
class Mystical {
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

  static Mystical? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;

    return Mystical(
      zeonRegeneration: JsonUtils.integer(json['regen'], 0),
      act: JsonUtils.integer(json['act'], 0),
      zeon: JsonUtils.integer(json['zeon'], 0),
      paths: Map<String, String>.from(json.getMap('Vias') ?? {}),
      subPaths: Map<String, String>.from(json.getMap('SubVias') ?? {}),
      metamagic: Map<String, String>.from(json.getMap('Metamagia') ?? {}),
      spellsMaintained: Map<String, String>.from(json.getMap('Conjuros') ?? {}),
      spellsPurchased: Map<String, String>.from(json.getMap('Libres') ?? {}),
    );
  }

  @HiveField(0)
  int zeonRegeneration;
  @HiveField(1)
  int act;
  @HiveField(2)
  int zeon;
  @HiveField(3)
  Map<String, String> paths;
  @HiveField(4)
  Map<String, String> subPaths;
  @HiveField(5)
  Map<String, String> metamagic;
  @HiveField(6)
  Map<String, String> spellsMaintained;
  @HiveField(7)
  Map<String, String> spellsPurchased;

  Mystical copy() {
    return Mystical(
      zeonRegeneration: zeonRegeneration,
      act: act,
      zeon: zeon,
      paths: paths,
      subPaths: subPaths,
      metamagic: metamagic,
      spellsMaintained: spellsMaintained,
      spellsPurchased: spellsPurchased,
    );
  }
}
