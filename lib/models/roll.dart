import 'dart:math';

class Roll {
  late final int roll;
  late final String description;

  Roll.roll({
    int base = 0,
    bool canCrit = true,
    bool canFumble = true,
    int critLevel = 90,
    int fumbleLevel = 5,
  }) {
    int thisRoll = Random().nextInt(99) + 1;
    String thisRollDescription = "";

    if (base != 0) thisRollDescription = "Base: $base";
    thisRollDescription = "$thisRollDescription\nTirada: $thisRoll";

    if (canCrit && thisRoll > critLevel) {
      Roll crit = Roll.roll(
        canFumble: false,
        critLevel: critLevel + 1,
      );

      thisRollDescription = "$thisRollDescription\nCritico: ${crit.roll}";
      thisRoll = thisRoll + crit.roll;
    }

    if (canFumble && thisRoll < fumbleLevel) {
      Roll fumble = Roll.roll(
        canCrit: false,
        canFumble: false,
      );

      thisRollDescription = "$thisRollDescription\nPifia: ${fumble.roll}";
      thisRoll = -fumble.roll;
    }

    description = thisRollDescription;
    roll = base + thisRoll;
  }

  Roll({required this.description, required this.roll});
}
