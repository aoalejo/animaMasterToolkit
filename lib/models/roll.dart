import 'dart:math';

import 'package:hive/hive.dart';

part 'roll.g.dart';

@HiveType(typeId: 4, adapterName: "RollAdapter")
class Roll {
  @HiveField(0)
  late int roll;
  @HiveField(1)
  late String description;
  @HiveField(2)
  late List<int> rolls;

  Roll.turn() {
    Roll.roll(turnFumble: true);
  }

  Roll.d10Roll() {
    roll = Random().nextInt(10) + 1;
    description = "";
    rolls = [];
  }

  Roll.roll({
    int base = 0,
    bool canCrit = true,
    bool canFumble = true,
    int critLevel = 90,
    int fumbleLevel = 5,
    bool turnFumble = false,
  }) {
    rolls = [];

    int thisRoll = Random().nextInt(100) + 1;
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

  Roll({required this.description, required this.roll, required this.rolls});

  String getRollsAsString() {
    String output = "";
    bool first = true;

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
