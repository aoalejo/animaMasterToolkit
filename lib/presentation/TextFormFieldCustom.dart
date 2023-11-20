import 'package:flutter/material.dart';

class TextFormFieldCustom extends StatelessWidget {
  final String? text;
  final String? label;
  final TextInputType? inputType;
  final void Function(String)? onChanged;
  final Widget? suffixIcon;

  const TextFormFieldCustom({
    super.key,
    this.text,
    this.label,
    this.inputType,
    this.onChanged,
    this.suffixIcon,
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
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.all(8),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
