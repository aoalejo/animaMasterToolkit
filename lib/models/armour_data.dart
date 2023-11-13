import 'package:amt/models/armour.dart';
import 'package:amt/utils/json_utils.dart';

class ArmourData {
  int? movementRestriction;
  int? naturalPenalty;
  int? requeriment;
  int? physicalPenalty;
  int? finalNaturalPenalty;
  late Armour calculatedArmour;
  late List<Armour> armours;

  ArmourData(
      {this.movementRestriction,
      this.naturalPenalty,
      this.requeriment,
      this.physicalPenalty,
      this.finalNaturalPenalty,
      required this.calculatedArmour,
      required this.armours});

  ArmourData.fromJson(Map<String, dynamic> json) {
    movementRestriction = JsonUtils.integer(json['restriccionMov'], 0);
    naturalPenalty = JsonUtils.integer(json['penNatural'], 0);
    requeriment = JsonUtils.integer(json['requisito'], 0);
    physicalPenalty = JsonUtils.integer(json['penAccionFisica'], 0);
    finalNaturalPenalty = JsonUtils.integer(json['penNaturalFinal'], 0);
    calculatedArmour = json['armaduraTotal'] != null
        ? Armour?.fromJson(json['armaduraTotal'])
        : Armour(
            fil: 2,
            con: 2,
            pen: 2,
            cal: 2,
            ele: 2,
            fri: 2,
            ene: 2,
          );
    if (json['armaduras'] != null) {
      armours = <Armour>[];
      json['armaduras'].forEach((v) {
        armours.add(Armour.fromJson(v));
      });
    }
  }
}
