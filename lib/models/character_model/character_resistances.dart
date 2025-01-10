import 'package:amt/utils/json_utils.dart';
import 'package:amt/utils/key_value.dart';
import 'package:hive/hive.dart';

part 'character_resistances.g.dart';

@HiveType(typeId: 21, adapterName: 'CharacterResistancesAdapter')
class CharacterResistances {
  CharacterResistances({
    this.presence = 0,
    this.physicalResistance = 0,
    this.diseasesResistance = 0,
    this.poisonResistance = 0,
    this.magicalResistance = 0,
    this.physicResistance = 0,
  });

  CharacterResistances.withDefault(int value) {
    presence = value;

    physicalResistance = value;
    diseasesResistance = value;
    poisonResistance = value;
    magicalResistance = value;
    physicResistance = value;
  }

  static CharacterResistances? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;

    return CharacterResistances(
      presence: JsonUtils.integer(json['Pres. Base'], 0),
      physicalResistance: JsonUtils.integer(json['RF'], 0),
      diseasesResistance: JsonUtils.integer(json['RE'], 0),
      poisonResistance: JsonUtils.integer(json['RV'], 0),
      magicalResistance: JsonUtils.integer(json['RM'], 0),
      physicResistance: JsonUtils.integer(json['RP'], 0),
    );
  }

  @HiveField(0)
  late int presence;
  @HiveField(1)
  late int physicalResistance;
  @HiveField(2)
  late int diseasesResistance;
  @HiveField(3)
  late int poisonResistance;
  @HiveField(4)
  late int magicalResistance;
  @HiveField(5)
  late int physicResistance;

  Map<String, dynamic> toJson() {
    return {
      'Pres. Base': presence,
      'RF': physicalResistance,
      'RE': diseasesResistance,
      'RV': poisonResistance,
      'RM': magicalResistance,
      'RP': physicResistance,
    };
  }

  void editResistance(KeyValue element) {
    switch (element.key) {
      case 'Pres':
        presence = int.tryParse(element.value) ?? presence;
      case 'RF':
        physicalResistance = int.tryParse(element.value) ?? physicalResistance;
      case 'RE':
        diseasesResistance = int.tryParse(element.value) ?? diseasesResistance;
      case 'RV':
        poisonResistance = int.tryParse(element.value) ?? poisonResistance;
      case 'RM':
        magicalResistance = int.tryParse(element.value) ?? magicalResistance;
      case 'RP':
        physicResistance = int.tryParse(element.value) ?? physicResistance;
    }
  }

  List<KeyValue> toKeyValue() {
    return <KeyValue>[
      KeyValue(key: 'Pres', value: presence.toString()),
      KeyValue(key: 'RF', value: physicalResistance.toString()),
      KeyValue(key: 'RE', value: diseasesResistance.toString()),
      KeyValue(key: 'RV', value: poisonResistance.toString()),
      KeyValue(key: 'RM', value: magicalResistance.toString()),
      KeyValue(key: 'RP', value: physicResistance.toString()),
    ];
  }

  CharacterResistances copy() {
    return CharacterResistances(
      presence: presence,
      physicResistance: physicResistance,
      physicalResistance: physicalResistance,
      diseasesResistance: diseasesResistance,
      magicalResistance: magicalResistance,
      poisonResistance: poisonResistance,
    );
  }
}
