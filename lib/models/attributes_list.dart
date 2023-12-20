import 'package:amt/models/character/character.dart';
import 'package:amt/utils/Key_value.dart';
import 'package:amt/utils/json_utils.dart';
import 'package:hive/hive.dart';

part 'attributes_list.g.dart';

@HiveType(typeId: 1, adapterName: "AttributesListAdapter")
class AttributesList {
  @HiveField(0)
  late int agility;
  @HiveField(1)
  late int constitution;
  @HiveField(2)
  late int dexterity;
  @HiveField(3)
  late int strength;
  @HiveField(4)
  late int intelligence;
  @HiveField(5)
  late int perception;
  @HiveField(6)
  late int might;
  @HiveField(7)
  late int willpower;

  AttributesList({
    this.agility = 0,
    this.constitution = 0,
    this.dexterity = 0,
    this.strength = 0,
    this.intelligence = 0,
    this.perception = 0,
    this.might = 0,
    this.willpower = 0,
  });

  AttributesList.withDefault(int defaultValue) {
    agility = defaultValue;
    constitution = defaultValue;
    dexterity = defaultValue;
    strength = defaultValue;
    intelligence = defaultValue;
    perception = defaultValue;
    might = defaultValue;
    willpower = defaultValue;
  }

  AttributesList.fromJson(Map<String, dynamic> json) {
    agility = JsonUtils.integer(json['AGI'], 0);
    constitution = JsonUtils.integer(json['CON'], 0);
    dexterity = JsonUtils.integer(json['DES'], 0);
    strength = JsonUtils.integer(json['FUE'], 0);
    intelligence = JsonUtils.integer(json['INT'], 0);
    perception = JsonUtils.integer(json['PER'], 0);
    might = JsonUtils.integer(json['POD'], 0);
    willpower = JsonUtils.integer(json['VOL'], 0);
  }

  List<int> orderedList() {
    return [agility, constitution, dexterity, strength, intelligence, perception, might, willpower];
  }

  static List<String> names() {
    return ["AGI", "CON", "DES", "STR", "INT", "PER", "POD", "VOL"];
  }

  List<int> get values => [
        agility,
        constitution,
        dexterity,
        strength,
        intelligence,
        perception,
        might,
        willpower,
      ];

  bool hasAValueWithMoreThanZero() {
    if (agility > 0 || constitution > 0 || dexterity > 0 || strength > 0 || intelligence > 0 || perception > 0 || might > 0 || willpower > 0) {
      return true;
    }
    return false;
  }

  List<KeyValue> toKeyValue({bool abbreviated = false}) {
    List<KeyValue> list = [];

    list.add(KeyValue(key: abbreviated ? "AGI" : "Agilidad", value: agility.toString()));
    list.add(KeyValue(key: abbreviated ? "CON" : "Constitución", value: constitution.toString()));
    list.add(KeyValue(key: abbreviated ? "DES" : "Destreza", value: dexterity.toString()));
    list.add(KeyValue(key: abbreviated ? "FUE" : "Fuerza", value: strength.toString()));
    list.add(KeyValue(key: abbreviated ? "INT" : "Inteligencia", value: intelligence.toString()));
    list.add(KeyValue(key: abbreviated ? "PER" : "Percepción", value: perception.toString()));
    list.add(KeyValue(key: abbreviated ? "POD" : "Poder", value: might.toString()));
    list.add(KeyValue(key: abbreviated ? "VOL" : "Voluntad", value: willpower.toString()));

    return list;
  }

  @override
  String toString() {
    var string = "";
    var names = AttributesList.names();
    var values = orderedList();
    for (int i = 0; i < names.length; i++) {
      string = "$string ${names[i]}: ${values[i]}, ";
    }
    return string;
  }

  AttributesList copy() {
    return AttributesList(
      agility: agility,
      constitution: constitution,
      dexterity: dexterity,
      strength: strength,
      intelligence: intelligence,
      perception: perception,
      might: might,
      willpower: willpower,
    );
  }
}
