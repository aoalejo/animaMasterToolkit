import 'package:amt/utils/json_utils.dart';

class AttributesList {
  late int agility;
  late int constitution;
  late int dexterity;
  late int strength;
  late int intelligence;
  late int perception;
  late int might;
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
    return [
      agility,
      constitution,
      dexterity,
      strength,
      intelligence,
      perception,
      might,
      willpower
    ];
  }

  static List<String> names() {
    return ["AGI", "CON", "DES", "STR", "INT", "PER", "POD", "VOL"];
  }

  bool hasAValueWithMoreThanZero() {
    if (agility > 0 ||
        constitution > 0 ||
        dexterity > 0 ||
        strength > 0 ||
        intelligence > 0 ||
        perception > 0 ||
        might > 0 ||
        willpower > 0) {
      return true;
    }
    return false;
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
}
