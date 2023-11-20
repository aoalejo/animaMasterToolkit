import 'package:amt/models/attributes_list.dart';
import 'package:amt/utils/json_utils.dart';

class CharacterKi {
  late AttributesList accumulationsPerAttribute;
  late AttributesList maximumPerAttribute;
  late Map<String, dynamic> habilities;
  late int maximumAccumulation;
  late int genericAccumulation;

  CharacterKi({
    required this.accumulationsPerAttribute,
    required this.maximumPerAttribute,
    required this.habilities,
    required this.maximumAccumulation,
    required this.genericAccumulation,
  });

  CharacterKi.empty() {
    accumulationsPerAttribute = AttributesList.withDefault(0);
    maximumPerAttribute = AttributesList.withDefault(0);
    habilities = <String, String>{};
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
    habilities = json['Habilidades'] ?? <String, String>{};

    maximumAccumulation = JsonUtils.integer(json['acumulacionMax'], 0);
    genericAccumulation = JsonUtils.integer(json['acumulacionGenerica'], 0);
  }
}
