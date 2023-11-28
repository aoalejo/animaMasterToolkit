import 'package:amt/models/attributes_list.dart';
import 'package:amt/utils/json_utils.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 9)
class CharacterKi {
  @HiveField(0)
  late AttributesList accumulationsPerAttribute;
  @HiveField(1)
  late AttributesList maximumPerAttribute;
  @HiveField(2)
  late Map<String, dynamic> skills;
  @HiveField(3)
  late int maximumAccumulation;
  @HiveField(4)
  late int genericAccumulation;

  CharacterKi({
    required this.accumulationsPerAttribute,
    required this.maximumPerAttribute,
    required this.skills,
    required this.maximumAccumulation,
    required this.genericAccumulation,
  });

  CharacterKi.empty() {
    accumulationsPerAttribute = AttributesList.withDefault(0);
    maximumPerAttribute = AttributesList.withDefault(0);
    skills = <String, String>{};
    maximumAccumulation = 0;
    genericAccumulation = 0;
  }

  CharacterKi.fromJson(Map<String, dynamic> json) {
    accumulationsPerAttribute = json['Acumulaciones'] != null
        ? AttributesList.fromJson(json['Acumulaciones'])
        : AttributesList();
    maximumPerAttribute = json['Maximos'] != null
        ? AttributesList.fromJson(json['Maximos'])
        : AttributesList();
    skills = json['Habilidades'] ?? <String, String>{};

    maximumAccumulation = JsonUtils.integer(json['acumulacionMax'], 0);
    genericAccumulation = JsonUtils.integer(json['acumulacionGenerica'], 0);
  }
}
