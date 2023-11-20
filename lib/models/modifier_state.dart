import 'package:amt/models/character/status_modifier.dart';
import 'package:amt/resources/modifiers.dart';

class ModifiersState {
  Set<StatusModifier> _modifiers = {};

  Set<StatusModifier> getAll() {
    return _modifiers;
  }

  bool containsModifier(StatusModifier modifier) {
    for (var element in _modifiers) {
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
    StatusModifier totalModifier = StatusModifier(name: "total");
    for (var modifier in _modifiers) {
      totalModifier.attack = totalModifier.attack + modifier.attack;
    }

    return totalModifier.description();
  }

  int getAllModifiersForType(ModifiersType type) {
    var total = 0;

    for (var modifier in _modifiers) {
      switch (type) {
        case ModifiersType.attack:
          total = total + modifier.attack;
        case ModifiersType.parry:
          total = total + modifier.parry;
        case ModifiersType.dodge:
          total = total + modifier.dodge;
        case ModifiersType.turn:
          total = total + modifier.turn;
        case ModifiersType.action:
          total = total + modifier.physicalAction;
      }
    }

    return total;
  }

  String totalModifierDescription() {
    StatusModifier totalModifier = StatusModifier(name: "total");
    for (var modifier in _modifiers) {
      totalModifier.attack = totalModifier.attack + modifier.attack;
      totalModifier.dodge = totalModifier.dodge + modifier.dodge;
      totalModifier.parry = totalModifier.parry + modifier.parry;
      totalModifier.turn = totalModifier.turn + modifier.turn;
      totalModifier.physicalAction =
          totalModifier.physicalAction + modifier.physicalAction;
    }

    return totalModifier.description();
  }
}
