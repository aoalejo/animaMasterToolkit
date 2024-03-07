class AMTStringFlex {

  AMTStringFlex(
    this.text, {
    required this.flex,
    this.editable = false,
  });
  final String text;
  final int flex;
  final bool editable;
}
