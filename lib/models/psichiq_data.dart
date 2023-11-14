import 'package:amt/utils/json_utils.dart';

class PsichiqData {
  int freeCvs;
  Map<String, dynamic> disciplines;
  Map<String, dynamic> patterns;
  Map<String, dynamic> powers;
  Map<String, dynamic> innates;

  PsichiqData({
    this.freeCvs = 0,
    this.disciplines = const <String, dynamic>{},
    this.patterns = const <String, dynamic>{},
    this.powers = const <String, dynamic>{},
    this.innates = const <String, dynamic>{},
  });

  factory PsichiqData.fromJson(Map<String, dynamic> json) {
    return PsichiqData(
      freeCvs: JsonUtils.integer(json['cvsLibres'], 0),
      disciplines: Map<String, String>.from(json['Disciplinas']),
      patterns: Map<String, String>.from(json['Patrones']),
      powers: Map<String, String>.from(json['Poderes']),
      innates: Map<String, String>.from(json['Innatos']),
    );
  }
}
