import 'package:amt/models/character/consumable_state.dart';
import 'package:amt/presentation/TextFormFieldCustom.dart';
import 'package:flutter/material.dart';

class ConsumableCard extends StatelessWidget {
  final ConsumableState consumable;
  final void Function(String) onChangedMax;
  final void Function(String) onChangedActual;

  ConsumableCard(
    this.consumable, {
    required this.onChangedMax,
    required this.onChangedActual,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final styleS = theme.textTheme.bodySmall;
    final styleM = theme.textTheme.bodyMedium;

    var header = Row(
      mainAxisAlignment:
          consumable.step > 0 || consumable.description.isNotEmpty
              ? MainAxisAlignment.spaceAround
              : MainAxisAlignment.center,
      children: [
        Text(
          consumable.name,
          style: styleS,
          textAlign: TextAlign.center,
        ),
        consumable.step > 0 || consumable.description.isNotEmpty
            ? Icon(
                Icons.info,
                size: 16,
              )
            : Container(),
      ],
    );

    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          consumable.step > 0 || consumable.description.isNotEmpty
              ? Tooltip(
                  textAlign: TextAlign.center,
                  message:
                      '${consumable.step > 0 ? 'incremento: ${consumable.step.toString()}\n' : ''}${consumable.description.isNotEmpty ? consumable.description : ''}',
                  child: header)
              : header,
          Row(
            children: [
              Expanded(
                  child: TextFormFieldCustom(
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(4),
                ),
                text: consumable.actualValue.toString(),
                onChanged: onChangedActual,
              )),
              Text("/"),
              Expanded(
                child: TextFormField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(4),
                  ),
                  style: consumable.maxValue > 999 ? styleS : styleM,
                  initialValue: consumable.maxValue.toString(),
                  onChanged: onChangedMax,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
