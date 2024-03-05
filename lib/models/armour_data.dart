import 'package:amt/models/armour.dart';
import 'package:amt/utils/json_utils.dart';
import 'package:hive/hive.dart';

part 'armour_data.g.dart';

@HiveType(typeId: 7, adapterName: 'ArmourDataAdapter')
class ArmourData {
  ArmourData({
    required this.calculatedArmour,
    required this.armours,
    this.movementRestriction,
    this.naturalPenalty,
    this.requirement,
    this.physicalPenalty,
    this.finalNaturalPenalty,
  });

  ArmourData.fromJson(Map<String, dynamic> json) {
    movementRestriction = JsonUtils.integer(json['restriccionMov'], 0);
    naturalPenalty = JsonUtils.integer(json['penNatural'], 0);
    requirement = JsonUtils.integer(json['requisito'], 0);
    physicalPenalty = JsonUtils.integer(json['penAccionFisica'], 0);
    finalNaturalPenalty = JsonUtils.integer(json['penNaturalFinal'], 0);
    calculatedArmour = json['armaduraTotal'] != null
        ? Armour?.fromJson(
            json['armaduraTotal'] as Map<String, dynamic>,
          )
        : Armour();
    if (json['armaduras'] != null) {
      armours = <Armour>[];
      for (final v in json['armaduras'] as List<Map<String, dynamic>>) {
        armours.add(Armour.fromJson(v));
      }
    } else {
      armours = <Armour>[
        Armour(
          name: 'Sin armadura',
        ),
      ];
    }
  }
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
}
