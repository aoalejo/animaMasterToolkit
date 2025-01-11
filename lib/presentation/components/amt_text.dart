import 'package:flutter/material.dart';

class AmtText extends StatelessWidget {
  const AmtText(
    this.text, {
    Key? key,
    this.style = AmtTextStyles.body,
    this.textAlign = TextAlign.left,
  }) : super(key: key);

  final String? text;
  final AmtTextStyles style;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? '',
      textAlign: textAlign,
      style: TextStyle(
        fontSize: style.size,
        fontFamily: style.family,
        fontWeight: style.weight,
      ),
    );
  }
}

enum AmtTextStyles {
  title,
  subtitle,
  emphasis,
  body,
  section;

  String get family {
    switch (this) {
      case AmtTextStyles.title:
        return 'Metamorphous';
      case AmtTextStyles.subtitle:
      case AmtTextStyles.body:
      case AmtTextStyles.emphasis:
      case AmtTextStyles.section:
        return 'NotoSans';
    }
  }

  FontWeight get weight {
    switch (this) {
      case AmtTextStyles.title:
        return FontWeight.w700;
      case AmtTextStyles.subtitle:
        return FontWeight.w600;
      case AmtTextStyles.body:
      case AmtTextStyles.section:
      case AmtTextStyles.emphasis:
        return FontWeight.w400;
    }
  }

  double get size {
    switch (this) {
      case AmtTextStyles.title:
        return 24;
      case AmtTextStyles.subtitle:
        return 20;
      case AmtTextStyles.emphasis:
        return 16;
      case AmtTextStyles.section:
        return 14;
      case AmtTextStyles.body:
        return 12;
    }
  }
}
