import 'dart:math';

class Roll {
  late final int roll;
  late final String description;
  late final List<int> rolls;

  Roll.roll({
    int base = 0,
    bool canCrit = true,
    bool canFumble = true,
    int critLevel = 90,
    int fumbleLevel = 5,
    bool turnFumble = false,
  }) {
    rolls = [];

    int thisRoll = Random().nextInt(99) + 1;
    String thisRollDescription = "";
    rolls.add(thisRoll);

    if (base != 0) thisRollDescription = "Base: $base";
    thisRollDescription = "$thisRollDescription\nTirada: $thisRoll";

    if (canCrit && thisRoll >= critLevel) {
      Roll crit = Roll.roll(
        canFumble: false,
        critLevel: critLevel + 1,
      );

      rolls.addAll(crit.rolls);

      thisRollDescription = "$thisRollDescription\nCritico: ${crit.roll}";
      thisRoll = thisRoll + crit.roll;
    }

    if (canFumble && thisRoll <= fumbleLevel) {
      if (turnFumble) {
        var handicap = 0;
        switch (thisRoll) {
          case 1:
            handicap = -125;
          case 2:
            handicap = -100;
          case 3:
            handicap = -75;
        }

        rolls.add(handicap);
        thisRollDescription = "$thisRollDescription\nPifia: $handicap";
        thisRoll = -handicap;
      } else {
        Roll fumble = Roll.roll(
          canCrit: false,
          canFumble: false,
        );

        rolls.addAll(fumble.rolls.map((e) => -e).toList());

        thisRollDescription = "$thisRollDescription\nPifia: ${fumble.roll}";
        thisRoll = -fumble.roll;
      }
    }

    description = thisRollDescription;
    roll = base + thisRoll;
  }

  Roll({required this.description, required this.roll});

  String getRollsAsString() {
    String output = "";
    bool first = true;
    print(rolls);
    for (var roll in rolls) {
      if (first) {
        output = roll.toString();
        first = false;
      } else {
        if (roll >= 0) {
          output = "$output+$roll";
        } else {
          output = "$output$roll";
        }
      }
    }

    return output;
  }
}
