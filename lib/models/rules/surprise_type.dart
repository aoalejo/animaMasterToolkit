import 'package:amt/models/character_model/character.dart';

enum SurpriseType {
  attacker,
  defender,
  none;

  static SurpriseType calculate({
    required Character? attacker,
    required Character? defendant,
  }) {
    final attackerRoll = attacker?.state.currentTurn.roll ?? 0;
    final defenderRoll = defendant?.state.currentTurn.roll ?? 0;

    if (attackerRoll - 150 > defenderRoll) {
      return SurpriseType.attacker;
    }

    if (defenderRoll - 150 > attackerRoll) {
      return SurpriseType.defender;
    }

    return SurpriseType.none;
  }
}
