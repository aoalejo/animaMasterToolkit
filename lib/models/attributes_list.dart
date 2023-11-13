import 'package:function_tree/function_tree.dart';

class AttributesList {
  late int agility;
  late int constitution;
  late int dextery;
  late int strenght;
  late int intelligence;
  late int perception;
  late int might;
  late int willpower;

  AttributesList({
    this.agility = 0,
    this.constitution = 0,
    this.dextery = 0,
    this.strenght = 0,
    this.intelligence = 0,
    this.perception = 0,
    this.might = 0,
    this.willpower = 0,
  });

  AttributesList.withDefault(int defaultValue) {
    agility = defaultValue;
    constitution = defaultValue;
    dextery = defaultValue;
    strenght = defaultValue;
    intelligence = defaultValue;
    perception = defaultValue;
    might = defaultValue;
    willpower = defaultValue;
  }

  AttributesList.fromJson(Map<String, dynamic> json) {
    agility = json['AGI'].toString().interpret().toInt();
    constitution = json['CON'].toString().interpret().toInt();
    dextery = json['DES'].toString().interpret().toInt();
    strenght = json['FUE'].toString().interpret().toInt();
    intelligence = json['INT'].toString().interpret().toInt();
    perception = json['PER'].toString().interpret().toInt();
    might = json['POD'].toString().interpret().toInt();
    willpower = json['VOL'].toString().interpret().toInt();
  }

  List<int> orderedList() {
    return [
      agility,
      constitution,
      dextery,
      strenght,
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
        dextery > 0 ||
        strenght > 0 ||
        intelligence > 0 ||
        perception > 0 ||
        might > 0 ||
        willpower > 0) {
      return true;
    }
    return false;
  }
}
