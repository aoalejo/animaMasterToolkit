import 'package:amt/models/character/consumable_state.dart';
import 'package:amt/models/enums.dart';
import 'package:amt/presentation/components/components.dart';
import 'package:flutter/material.dart';

class ConsumableCard extends StatelessWidget {

  const ConsumableCard(
    this.consumable, {required this.onChangedMax, required this.onChangedActual, required this.onDelete, super.key,
  });
  final ConsumableState consumable;
  final void Function(String) onChangedMax;
  final void Function(String) onChangedActual;
  final void Function(ConsumableState) onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final styleS = theme.textTheme.bodySmall;
    final styleM = theme.textTheme.bodyMedium;

    final header = Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (consumable.type == ConsumableType.other)
            InkWell(
              child: const Icon(
                Icons.delete,
                size: 14,
                color: Colors.grey,
              ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Borrar consumible'),
                        content: Text('Seguro que desea borrar ${consumable.name}?'),
                        actions: [
                          OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              onDelete(consumable);
                            },
                            child: const Text('Borrar'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancelar'),
                          ),
                        ],
                      );
                    },);
              },
            ),
          Expanded(
            child: Text(
              consumable.name,
              style: styleM,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (consumable.step > 0 || consumable.description.isNotEmpty) const Icon(
                  Icons.info,
                  size: 16,
                ) else const SizedBox.square(dimension: 16),
        ],
      ),
    );

    return Card(
      color: theme.colorScheme.secondaryContainer,
      child: Column(
        children: [
          if (consumable.step > 0 || consumable.description.isNotEmpty) Tooltip(
                  textAlign: TextAlign.center,
                  message:
                      '${consumable.step > 0 ? 'incremento: ${consumable.step}\n' : ''}${consumable.description.isNotEmpty ? consumable.description : ''}',
                  child: header,) else header,
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    onChangedActual((consumable.actualValue - consumable.step).toString());
                  },
                  icon: const Icon(Icons.remove),),
              Expanded(
                  child: AMTTextFormField(
                align: TextAlign.center,
                decoration: const InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(4),
                ),
                style: consumable.actualValue > 999 ? styleS : styleM,
                text: consumable.actualValue.toString(),
                onChanged: onChangedActual,
              ),),
              const Text('/'),
              Expanded(
                child: AMTTextFormField(
                  align: TextAlign.center,
                  decoration: const InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(4),
                  ),
                  style: consumable.maxValue > 999 ? styleS : styleM,
                  text: consumable.maxValue.toString(),
                  onChanged: onChangedMax,
                ),
              ),
              IconButton(
                  onPressed: () {
                    onChangedActual((consumable.actualValue + consumable.step).toString());
                  },
                  icon: const Icon(Icons.add),),
            ],
          ),
        ],
      ),
    );
  }
}
