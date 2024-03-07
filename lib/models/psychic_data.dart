import 'package:amt/utils/json_utils.dart';
import 'package:hive/hive.dart';

part 'psychic_data.g.dart';

@HiveType(typeId: 11, adapterName: 'PsychicDataAdapter')
class PsychicData {
  PsychicData({
    this.freeCvs = 0,
    this.disciplines = const <String, dynamic>{},
    this.patterns = const <String, dynamic>{},
    this.powers = const <String, dynamic>{},
    this.innate = const <String, dynamic>{},
  });

  static PsychicData? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return PsychicData(
      freeCvs: JsonUtils.integer(json['cvsLibres'], 0),
      disciplines: Map<String, String>.from(json.getMap('Disciplinas') ?? {}),
      patterns: Map<String, String>.from(json.getMap('Patrones') ?? {}),
      powers: Map<String, String>.from(json.getMap('Poderes') ?? {}),
      innate: Map<String, String>.from(json.getMap('Innatos') ?? {}),
    );
  }

  @HiveField(0)
  int freeCvs;
  @HiveField(1)
  Map<String, dynamic> disciplines;
  @HiveField(2)
  Map<String, dynamic> patterns;
  @HiveField(3)
  Map<String, dynamic> powers;
  @HiveField(4)
  Map<String, dynamic> innate;

  PsychicData copy() {
    return PsychicData(
      freeCvs: freeCvs,
      disciplines: disciplines,
      patterns: patterns,
      powers: powers,
      innate: innate,
    );
  }
}
