import 'package:amt/utils/json_utils.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 11)
class PsychicData {
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
