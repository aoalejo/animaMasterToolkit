import 'package:amt/utils/key_value.dart';
import 'package:amt/utils/json_utils.dart';
import 'package:hive/hive.dart';

part 'character_resistances.g.dart';

@HiveType(typeId: 21, adapterName: "CharacterResistancesAdapter")
class CharacterResistances {
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

  CharacterResistances.fromJson(Map<String, dynamic> json) {
    presence = JsonUtils.integer(json['Pres. Base'], 0);
    physicalResistance = JsonUtils.integer(json['RF'], 0);
    diseasesResistance = JsonUtils.integer(json['RE'], 0);
    poisonResistance = JsonUtils.integer(json['RV'], 0);
    magicalResistance = JsonUtils.integer(json['RM'], 0);
    physicResistance = JsonUtils.integer(json['RP'], 0);
  }

  CharacterResistances({
    this.presence = 0,
    this.physicalResistance = 0,
    this.diseasesResistance = 0,
    this.poisonResistance = 0,
    this.magicalResistance = 0,
    this.physicResistance = 0,
  });

  editResistance(KeyValue element) {
    switch (element.key) {
      case "Pres":
        presence = int.tryParse(element.value) ?? presence;
      case "RF":
        physicalResistance = int.tryParse(element.value) ?? physicalResistance;
      case "RE":
        diseasesResistance = int.tryParse(element.value) ?? diseasesResistance;
      case "RV":
        poisonResistance = int.tryParse(element.value) ?? poisonResistance;
      case "RM":
        magicalResistance = int.tryParse(element.value) ?? magicalResistance;
      case "RP":
        physicResistance = int.tryParse(element.value) ?? physicResistance;
    }
  }

  List<KeyValue> toKeyValue() {
    List<KeyValue> list = [];

    list.add(KeyValue(key: "Pres", value: presence.toString()));
    list.add(KeyValue(key: "RF", value: physicalResistance.toString()));
    list.add(KeyValue(key: "RE", value: diseasesResistance.toString()));
    list.add(KeyValue(key: "RV", value: poisonResistance.toString()));
    list.add(KeyValue(key: "RM", value: magicalResistance.toString()));
    list.add(KeyValue(key: "RP", value: physicResistance.toString()));

    return list;
  }

  CharacterResistances.withDefault(int value) {
    presence = value;

    physicalResistance = value;
    diseasesResistance = value;
    poisonResistance = value;
    magicalResistance = value;
    physicResistance = value;
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
