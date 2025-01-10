import 'dart:math';

import 'package:amt/lib.dart';
import 'package:amt/models/character_model/character.dart';
import 'package:hive/hive.dart';

part 'roll.g.dart';

@HiveType(typeId: 4, adapterName: 'RollAdapter')
class Roll {
  Roll({required this.description, required this.roll, required this.rolls});

  Roll.turn() {
    final turnRoll = Roll.roll(
      turnFumble: true,
      fumbleLevel: -1,
    );

    roll = turnRoll.roll;
    description = turnRoll.description;
    rolls = turnRoll.rolls;
  }

  Roll.d10Roll() {
    roll = Random().nextInt(10) + 1;
    description = '';
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
    bool firstRoll = true,
  }) {
    rolls = [];

    var thisRoll = Random().nextInt(100) + 1;
    var thisRollDescription = '';
    rolls.add(thisRoll);

    if (base != 0) thisRollDescription = 'Base: $base';
    thisRollDescription = '$thisRollDescription${firstRoll ? "\nTirada: " : ""}$thisRoll';

    if (thisRoll.isPalindrome && nature > 15) {
      final newRoll = Roll.d10Roll();
      thisRollDescription = '$thisRollDescription\nTirada adicional: ${newRoll.roll}';
      rolls.add(newRoll.roll);

      if (thisRoll.toString()[0] == newRoll.roll.toString()) {
        thisRollDescription = '$thisRollDescription\nCritico adicional transforma la tirada en 100';
        thisRoll = 100;
      }
    }

    if (canCrit && thisRoll >= critLevel) {
      final crit = Roll.roll(
        canFumble: false,
        fumbleLevel: -1,
        critLevel: nature >= 5 ? critLevel + 1 : 999,
        nature: nature,
        firstRoll: false,
      );

      rolls.addAll(crit.rolls);

      thisRollDescription =
          '$thisRollDescription\n ${firstRoll ? "Critico ($critLevel) ${crit.description}" : "   ++($critLevel) ${crit.description}"}';
      thisRoll = thisRoll + crit.roll;
    }

    if (canFumble && thisRoll <= fumbleLevel) {
      if (turnFumble) {
        final handicap = -75 - (fumbleLevel - thisRoll) * 25;

        rolls.add(handicap);
        thisRollDescription = '$thisRollDescription\nPifia: $handicap';
        thisRoll = handicap;
      } else {
        final fumble = Roll.roll(
          canCrit: false,
          canFumble: false,
          fumbleLevel: -1,
          nature: nature,
        );

        rolls.addAll(fumble.rolls.map((e) => -e).toList());

        thisRollDescription = '$thisRollDescription\nPifia: ${fumble.roll}';
        thisRoll = -fumble.roll;
      }
    }

    description = thisRollDescription;
    roll = base + thisRoll;
  }
  @HiveField(0)
  late int roll;
  @HiveField(1)
  late String description;
  @HiveField(2)
  late List<int> rolls;

  Map<String, dynamic> toJson() {
    return {
      'roll': roll,
      'description': description,
      'rolls': rolls,
    };
  }

  static Roll? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;

    return Roll(
      roll: JsonUtils.integer(json['roll'], 0),
      description: JsonUtils.string(json['description'], ''),
      rolls: json.getList('rolls').map((e) => e as int).toList(),
    );
  }

  String getRollsAsString() {
    var output = '';
    var first = true;

    for (final roll in rolls) {
      if (first) {
        output = roll.toString();
        first = false;
      } else {
        if (roll >= 0) {
          output = '$output+$roll';
        } else {
          output = '$output$roll';
        }
      }
    }

    return output;
  }
}

extension Rolls on Character {
  Roll roll() {
    return Roll.roll(fumbleLevel: profile.fumbleLevel ?? 3, critLevel: profile.critLevel ?? 90, nature: profile.nature ?? 5);
  }
}

extension on int {
  bool get isPalindrome {
    final str = toString();

    if (str.length < 2) {
      return false;
    }

    return str[0] == str[1];
  }
}
