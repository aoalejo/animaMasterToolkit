import 'dart:math';

import 'package:amt/models/character/character.dart';
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
    final turnRoll = Roll.roll(
      turnFumble: true,
      fumbleLevel: -1,
      nature: 0,
    );

    roll = turnRoll.roll;
    description = turnRoll.description;
    rolls = turnRoll.rolls;
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
    int fumbleLevel = 3,
    int nature = 0,
    bool turnFumble = false,
  }) {
    rolls = [];

    int thisRoll = Random().nextInt(100) + 1;
    String thisRollDescription = "";
    rolls.add(thisRoll);

    if (base != 0) thisRollDescription = "Base: $base";
    thisRollDescription = "$thisRollDescription\nTirada: $thisRoll";

    if (thisRoll.isPalindrome && nature > 15) {
      var newRoll = Roll.d10Roll();
      thisRollDescription = "$thisRollDescription\nTirada adicional: ${newRoll.roll}";
      rolls.add(newRoll.roll);

      if (thisRoll.toString()[0] == newRoll.roll.toString()) {
        thisRollDescription = "$thisRollDescription\nCritico adicional transforma la tirada en 100";
        thisRoll = 100;
      }
    }

    if (canCrit && thisRoll >= critLevel) {
      Roll crit = Roll.roll(
        canFumble: false,
        fumbleLevel: -1,
        critLevel: nature >= 5 ? critLevel + 1 : 999,
        nature: nature,
      );

      rolls.addAll(crit.rolls);

      thisRollDescription = "$thisRollDescription\nCritico: ${crit.roll}";
      thisRoll = thisRoll + crit.roll;
    }

    if (canFumble && thisRoll <= fumbleLevel) {
      if (turnFumble) {
        var handicap = -75 - (fumbleLevel - thisRoll) * 25;

        rolls.add(handicap);
        thisRollDescription = "$thisRollDescription\nPifia: $handicap";
        thisRoll = handicap;
      } else {
        Roll fumble = Roll.roll(
          canCrit: false,
          canFumble: false,
          fumbleLevel: -1,
          nature: nature,
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

extension Rolls on Character {
  Roll roll() {
    return Roll.roll(fumbleLevel: profile.fumbleLevel ?? 3, nature: profile.nature ?? 5);
  }
}

extension on int {
  bool get isPalindrome {
    var str = toString();

    if (str.length < 2) {
      return false;
    }

    return str[0] == str[1];
  }
}
