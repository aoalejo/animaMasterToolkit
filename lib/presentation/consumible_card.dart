import 'package:amt/models/character/consumible_state.dart';
import 'package:flutter/material.dart';

class ConsumibleCard extends StatelessWidget {
  final ConsumibleState consumible;
  final void Function(String) onChangedMax;
  final void Function(String) onChangedActual;

  ConsumibleCard(
    this.consumible, {
    required this.onChangedMax,
    required this.onChangedActual,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final styleS = theme.textTheme.bodySmall;
    final styleM = theme.textTheme.bodyMedium;

    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            consumible.name,
            style: styleS,
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(4),
                  ),
                  style: consumible.maxValue > 999 ? styleS : styleM,
                  initialValue: consumible.maxValue.toString(),
                  onChanged: onChangedActual,
                ),
              ),
              Text("/"),
              Expanded(
                child: TextFormField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(4),
                  ),
                  style: consumible.actualValue > 999 ? styleS : styleM,
                  initialValue: consumible.actualValue.toString(),
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
