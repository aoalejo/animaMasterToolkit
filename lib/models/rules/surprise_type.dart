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

    final attackerDifference = attacker?.profile.uroboros ?? false ? 100 : 150;
    final defenderDifference = defendant?.profile.uroboros ?? false ? 100 : 150;

    if (attackerRoll - attackerDifference > defenderRoll) {
      return SurpriseType.attacker;
    }

    if (defenderRoll - defenderDifference > attackerRoll) {
      return SurpriseType.defender;
    }

    return SurpriseType.none;
  }
}
