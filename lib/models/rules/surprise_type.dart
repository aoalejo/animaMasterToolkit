import 'package:amt/models/character/character.dart';

enum SurpriseType {
  attacker,
  defender,
  none;

  static calculate({
    required Character? attacker,
    required Character? defendant,
  }) {
    var attackerRoll = attacker?.state.currentTurn.roll ?? 0;
    var defenderRoll = defendant?.state.currentTurn.roll ?? 0;

    if (attackerRoll - 150 > defenderRoll) {
      return SurpriseType.attacker;
    }

    if (defenderRoll - 150 > attackerRoll) {
      return SurpriseType.defender;
    }

    return SurpriseType.none;
  }
}
