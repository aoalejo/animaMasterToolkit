import 'package:amt/models/attributes_list.dart';
import 'package:amt/utils/json_utils.dart';
import 'package:hive/hive.dart';

part 'character_ki.g.dart';

@HiveType(typeId: 9, adapterName: 'CharacterKiAdapter')
class CharacterKi {
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

  static CharacterKi? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;

    return CharacterKi(
      accumulationsPerAttribute: AttributesList.fromJson(json.getMap('Acumulaciones')) ?? AttributesList(),
      maximumPerAttribute: AttributesList.fromJson(json.getMap('Maximos')) ?? AttributesList(),
      skills: json.getMap('Habilidades') ?? <String, String>{},
      maximumAccumulation: JsonUtils.integer(json['acumulacionMax'], 0),
      genericAccumulation: JsonUtils.integer(json['acumulacionGenerica'], 0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Acumulaciones': accumulationsPerAttribute.toJson(),
      'Maximos': maximumPerAttribute.toJson(),
      'Habilidades': skills,
      'acumulacionMax': maximumAccumulation,
      'acumulacionGenerica': genericAccumulation,
    };
  }

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

  CharacterKi copy() {
    return CharacterKi(
      accumulationsPerAttribute: accumulationsPerAttribute.copy(),
      maximumPerAttribute: maximumPerAttribute.copy(),
      skills: skills,
      maximumAccumulation: maximumAccumulation,
      genericAccumulation: genericAccumulation,
    );
  }
}
