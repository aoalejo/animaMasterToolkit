import 'package:amt/models/armour.dart';
import 'package:amt/utils/json_utils.dart';
import 'package:hive/hive.dart';

part 'armour_data.g.dart';

@HiveType(typeId: 7, adapterName: "ArmourDataAdapter")
class ArmourData {
  @HiveField(0)
  int? movementRestriction;
  @HiveField(1)
  int? naturalPenalty;
  @HiveField(2)
  int? requirement;
  @HiveField(3)
  int? physicalPenalty;
  @HiveField(4)
  int? finalNaturalPenalty;
  @HiveField(5)
  late Armour calculatedArmour;
  @HiveField(6)
  late List<Armour> armours;

  ArmourData(
      {this.movementRestriction,
      this.naturalPenalty,
      this.requirement,
      this.physicalPenalty,
      this.finalNaturalPenalty,
      required this.calculatedArmour,
      required this.armours});

  ArmourData.fromJson(Map<String, dynamic> json) {
    movementRestriction = JsonUtils.integer(json['restriccionMov'], 0);
    naturalPenalty = JsonUtils.integer(json['penNatural'], 0);
    requirement = JsonUtils.integer(json['requisito'], 0);
    physicalPenalty = JsonUtils.integer(json['penAccionFisica'], 0);
    finalNaturalPenalty = JsonUtils.integer(json['penNaturalFinal'], 0);
    calculatedArmour = json['armaduraTotal'] != null
        ? Armour?.fromJson(json['armaduraTotal'])
        : Armour(
            fil: 0,
            con: 0,
            pen: 0,
            cal: 0,
            ele: 0,
            fri: 0,
            ene: 0,
          );
    if (json['armaduras'] != null) {
      armours = <Armour>[];
      json['armaduras'].forEach((v) {
        armours.add(Armour.fromJson(v));
      });
    } else {
      armours = <Armour>[
        Armour(
          name: "Sin armadura",
          fil: 0,
          con: 0,
          pen: 0,
          cal: 0,
          ele: 0,
          fri: 0,
          ene: 0,
        )
      ];
    }
  }
}
