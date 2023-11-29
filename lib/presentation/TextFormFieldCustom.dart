import 'package:flutter/material.dart';

class TextFormFieldCustom extends StatelessWidget {
  final String? text;
  final String? label;
  final TextInputType? inputType;
  final void Function(String)? onChanged;
  final Widget? suffixIcon;
  final InputDecoration? decoration;
  final TextStyle? style;

  const TextFormFieldCustom({
    super.key,
    this.text,
    this.label,
    this.inputType,
    this.onChanged,
    this.suffixIcon,
    this.decoration,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      controller: TextEditingController.fromValue(
        TextEditingValue(
          text: text ?? "",
          selection: TextSelection.collapsed(
            offset: text?.length ?? 0,
          ),
        ),
      ),
      textInputAction: TextInputAction.done,
      keyboardType: inputType,
      style: style,
      decoration: decoration ??
          InputDecoration(
            labelText: label,
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.all(8),
            suffixIcon: suffixIcon,
          ),
    );
  }
}
