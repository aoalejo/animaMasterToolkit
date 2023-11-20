import 'package:amt/utils/json_utils.dart';

class PsychicData {
  int freeCvs;
  Map<String, dynamic> disciplines;
  Map<String, dynamic> patterns;
  Map<String, dynamic> powers;
  Map<String, dynamic> innate;

  PsychicData({
    this.freeCvs = 0,
    this.disciplines = const <String, dynamic>{},
    this.patterns = const <String, dynamic>{},
    this.powers = const <String, dynamic>{},
    this.innate = const <String, dynamic>{},
  });

  factory PsychicData.fromJson(Map<String, dynamic> json) {
    return PsychicData(
      freeCvs: JsonUtils.integer(json['cvsLibres'], 0),
      disciplines: Map<String, String>.from(json['Disciplinas']),
      patterns: Map<String, String>.from(json['Patrones']),
      powers: Map<String, String>.from(json['Poderes']),
      innate: Map<String, String>.from(json['Innatos']),
    );
  }
}
