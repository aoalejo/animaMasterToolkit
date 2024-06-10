import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Assets {
  static Widget anatomy = SvgPicture.asset(
    'assets/anatomy.svg',
    semanticsLabel: 'status icon',
  );

  static final Widget attack = SvgPicture.asset(
    'assets/attack.svg',
    semanticsLabel: 'attack icon',
  );

  static final Widget dodging = SvgPicture.asset(
    'assets/dodging.svg',
    semanticsLabel: 'dodge icon',
  );

  static final Widget parry = SvgPicture.asset(
    'assets/parry.svg',
    semanticsLabel: 'parry icon',
  );

  static final Widget diceRoll = SvgPicture.asset(
    'assets/d100_dice.svg',
    semanticsLabel: 'dice rolling icon',
  );

  static final Widget shield = SvgPicture.asset(
    'assets/shield.svg',
    semanticsLabel: 'shield icon',
  );

  static final Widget knife = SvgPicture.asset(
    'assets/knife.svg',
    semanticsLabel: 'knife icon',
  );

  static final Widget github = SvgPicture.asset(
    'assets/github.svg',
    semanticsLabel: 'github icon',
  );

  static final Widget uprising = SvgPicture.asset(
    'assets/uprising.svg',
    semanticsLabel: 'uprising icon',
  );

  static final Widget faceToFace = SvgPicture.asset(
    'assets/face-to-face.svg',
    semanticsLabel: 'face-to-face icon',
  );

  static final Widget excelConvert = Image.asset(
    'assets/convert.png',
  );

  static Image surprised(Color color) => Image.asset(
        'assets/surprised.png',
        color: color,
      );
}
