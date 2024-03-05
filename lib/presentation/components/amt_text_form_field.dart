import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AMTTextFormField extends StatelessWidget {
  final String? text;
  final String? label;
  final TextInputType? inputType;
  final void Function(String)? onChanged;
  final Widget? suffixIcon;
  final InputDecoration? decoration;
  final TextStyle? style;
  final TextAlign? align;
  final bool? enabled;
  final int maxLength;

  AMTTextFormField({
    super.key,
    this.text,
    this.label,
    this.inputType,
    this.onChanged,
    this.suffixIcon,
    this.decoration,
    this.style,
    this.align,
    this.enabled,
  }) : maxLength = inputType == TextInputType.number ? 4 : 20;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      enabled: enabled ?? true,
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
      inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
      style: style,
      textAlign: align ?? TextAlign.start,
      decoration: decoration ??
          InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelText: label,
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.all(8),
            suffixIcon: suffixIcon,
          ),
    );
  }
}
