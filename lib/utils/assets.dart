import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Assets {
  static Widget anatomy = SvgPicture.asset(
    'assets/anatomy.svg',
    semanticsLabel: "status icon",
  );

  static final Widget attack = SvgPicture.asset(
    'assets/attack.svg',
    semanticsLabel: "attack icon",
  );

  static final Widget dodging = SvgPicture.asset(
    'assets/dodging.svg',
    semanticsLabel: "dodge icon",
  );

  static final Widget parry = SvgPicture.asset(
    'assets/parry.svg',
    semanticsLabel: "parry icon",
  );

  static final Widget diceRoll = SvgPicture.asset(
    'assets/d100_dice.svg',
    semanticsLabel: "dice rolling icon",
  );
}
