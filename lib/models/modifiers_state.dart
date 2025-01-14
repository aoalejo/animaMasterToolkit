import 'package:amt/models/character_model/status_modifier.dart';
import 'package:amt/models/enums.dart';
import 'package:amt/resources/modifiers.dart';
import 'package:amt/utils/json_utils.dart';
import 'package:amt/utils/key_value.dart';
import 'package:hive/hive.dart';

part 'modifiers_state.g.dart';

@HiveType(typeId: 13)
class ModifiersState {
  @HiveField(0)
  List<StatusModifier> _modifiers = [];

  List<StatusModifier> getAll() {
    return _modifiers;
  }

  Map<String, dynamic> toJson() {
    return {
      'modifiers': _modifiers.map((e) => e.toJson()).toList(),
    };
  }

  static ModifiersState? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;

    return ModifiersState()..setAll(json.getList('modifiers').map(StatusModifier.fromJson).nonNulls.toList());
  }

  // ignore: use_setters_to_change_properties
  void setAll(List<StatusModifier> modifiers) {
    _modifiers = modifiers;
  }

  bool containsModifier(StatusModifier modifier) {
    for (final element in _modifiers) {
      if (element.name == modifier.name) {
        return true;
      }
    }
    return false;
  }

  void add(StatusModifier modifier) {
    _modifiers.add(modifier);
  }

  void clear() {
    _modifiers.clear();
  }

  void removeModifier(StatusModifier modifier) {
    _modifiers.removeWhere((element) => element.name == modifier.name);
  }

  String totalAttackingDescription() {
    final totalModifier = StatusModifier(name: 'total');
    for (final modifier in _modifiers) {
      totalModifier.attack = totalModifier.attack + modifier.attack;
    }

    return totalModifier.description().isEmpty ? '0' : totalModifier.description();
  }

  String totalDefendingDescription(DefenseType type) {
    final totalModifier = StatusModifier(name: 'total');

    for (final modifier in _modifiers) {
      totalModifier.attack = totalModifier.attack + modifier.attack;
    }

    return totalModifier.description();
  }

  int getAllModifiersForType(ModifiersType type) {
    var total = 0;

    for (final modifier in _modifiers) {
      switch (type) {
        case ModifiersType.attack:
          total = total + modifier.attack;
        case ModifiersType.turn:
          total = total + modifier.turn;
        case ModifiersType.action:
          total = total + modifier.physicalAction;
        case ModifiersType.parry:
          total = total + modifier.parry;
        case ModifiersType.dodge:
          total = total + modifier.dodge;
      }
    }

    return total;
  }

  List<KeyValue> getAllModifiersString() {
    return totalModifier().descriptionKeyValue();
  }

  String getAllModifiersForTypeString(ModifiersType type) {
    var total = '';

    for (final modifier in _modifiers) {
      switch (type) {
        case ModifiersType.attack:
          if (modifier.attack != 0) {
            total = '$total${modifier.attack > 0 ? '+${modifier.attack}' : '${modifier.attack}'}';
          }
        case ModifiersType.turn:
          if (modifier.turn != 0) {
            total = '$total${modifier.turn > 0 ? '+${modifier.turn}' : '${modifier.turn}'}';
          }
        case ModifiersType.action:
          if (modifier.physicalAction != 0) {
            total = '$total${modifier.physicalAction > 0 ? '+${modifier.physicalAction}' : '${modifier.physicalAction}'}';
          }
        case ModifiersType.parry:
          if (modifier.parry != 0) {
            total = '$total${modifier.parry > 0 ? '+${modifier.parry}' : '${modifier.parry}'}';
          }
        case ModifiersType.dodge:
          if (modifier.dodge != 0) {
            total = '$total${modifier.dodge > 0 ? '+${modifier.dodge}' : '${modifier.dodge}'}';
          }
      }
    }

    return total;
  }

  int getAllModifiersForDefense(DefenseType type) {
    var total = 0;

    for (final modifier in _modifiers) {
      switch (type) {
        case DefenseType.parry:
          total = total + modifier.parry;
        case DefenseType.dodge:
          total = total + modifier.dodge;
      }
    }

    return total;
  }

  StatusModifier totalModifier() {
    final totalModifier = StatusModifier(name: 'total');
    for (final modifier in _modifiers) {
      totalModifier
        ..attack = totalModifier.attack + modifier.attack
        ..dodge = totalModifier.dodge + modifier.dodge
        ..parry = totalModifier.parry + modifier.parry
        ..turn = totalModifier.turn + modifier.turn
        ..physicalAction = totalModifier.physicalAction + modifier.physicalAction;
    }

    return totalModifier;
  }

  String totalModifierDescription() {
    return totalModifier().description();
  }
}
