import 'package:amt/utils/json_utils.dart';
import 'package:amt/utils/key_value.dart';
import 'package:hive/hive.dart';

part 'attributes_list.g.dart';

@HiveType(typeId: 1, adapterName: 'AttributesListAdapter')
class AttributesList {
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

  static AttributesList? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;

    return AttributesList(
      agility: JsonUtils.integer(json['AGI'], 0),
      constitution: JsonUtils.integer(json['CON'], 0),
      dexterity: JsonUtils.integer(json['DES'], 0),
      strength: JsonUtils.integer(json['FUE'], 0),
      intelligence: JsonUtils.integer(json['INT'], 0),
      perception: JsonUtils.integer(json['PER'], 0),
      might: JsonUtils.integer(json['POD'], 0),
      willpower: JsonUtils.integer(json['VOL'], 0),
    );
  }

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

  List<int> orderedList() {
    return [agility, constitution, dexterity, strength, intelligence, perception, might, willpower];
  }

  static List<String> names() {
    return ['AGI', 'CON', 'DES', 'STR', 'INT', 'PER', 'POD', 'VOL'];
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
    return <KeyValue>[
      (KeyValue(key: abbreviated ? 'AGI' : 'Agilidad', value: agility.toString())),
      KeyValue(key: abbreviated ? 'CON' : 'Constitución', value: constitution.toString()),
      KeyValue(key: abbreviated ? 'DES' : 'Destreza', value: dexterity.toString()),
      KeyValue(key: abbreviated ? 'FUE' : 'Fuerza', value: strength.toString()),
      KeyValue(key: abbreviated ? 'INT' : 'Inteligencia', value: intelligence.toString()),
      KeyValue(key: abbreviated ? 'PER' : 'Percepción', value: perception.toString()),
      KeyValue(key: abbreviated ? 'POD' : 'Poder', value: might.toString()),
      KeyValue(key: abbreviated ? 'VOL' : 'Voluntad', value: willpower.toString()),
    ];
  }

  void edit(KeyValue value) {
    final parsed = int.tryParse(value.value);

    switch (value.key) {
      case 'Agilidad':
      case 'AGI':
        agility = parsed ?? agility;

      case 'Constitución':
      case 'CON':
        constitution = parsed ?? constitution;

      case 'Destreza':
      case 'DES':
        dexterity = parsed ?? dexterity;

      case 'Fuerza':
      case 'FUE':
        strength = parsed ?? strength;

      case 'Inteligencia':
      case 'INT':
        intelligence = parsed ?? intelligence;

      case 'Percepción':
      case 'PER':
        perception = parsed ?? perception;

      case 'Poder':
      case 'POD':
        might = parsed ?? might;

      case 'Voluntad':
      case 'VOL':
        willpower = parsed ?? willpower;
    }
  }

  @override
  String toString() {
    final buffer = StringBuffer();

    final names = AttributesList.names();
    final values = orderedList();
    for (var i = 0; i < names.length; i++) {
      buffer.write(' ${names[i]}: ${values[i]}, ');
    }
    return buffer.toString();
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
