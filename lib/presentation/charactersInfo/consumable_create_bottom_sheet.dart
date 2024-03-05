import 'package:amt/models/character/consumable_state.dart';
import 'package:amt/models/enums.dart';
import 'package:amt/utils/amt_bottom_sheet.dart';
import 'package:amt/utils/amt_text_form_field.dart';
import 'package:flutter/material.dart';

class CreateConsumable {
  static show(BuildContext context, Function(ConsumableState) onCreated) {
    var name = "";
    var max = "0";
    var increment = "1";
    var description = "";
    var type = ConsumableType.other;

    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) => AMTBottomSheet(
            title: Text('Crear nuevo consumible'),
            bottomRow: [
              ElevatedButton(
                  child: const Text('Guardar'),
                  onPressed: () {
                    onCreated(
                      _buildConsumable(
                        name,
                        max,
                        increment,
                        description,
                        type,
                      ),
                    );
                    Navigator.pop(context);
                  }),
              ElevatedButton(
                child: const Text('Cerrar'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
            children: [
              ..._row(
                [
                  AMTTextFormField(
                    label: "Nombre",
                    text: name,
                    onChanged: (value) => setState(
                      () => name = value,
                    ),
                  ),
                  AMTTextFormField(
                    label: "Valor máximo",
                    text: max,
                    inputType: TextInputType.number,
                    onChanged: (value) => setState(
                      () => max = value,
                    ),
                  ),
                  AMTTextFormField(
                    label: "Incremento",
                    text: increment,
                    inputType: TextInputType.number,
                    onChanged: (value) => setState(
                      () => increment = value,
                    ),
                  ),
                ],
              ),
              ..._row([
                AMTTextFormField(
                  label: "Descripción",
                  text: description,
                  onChanged: (value) => setState(
                    () => description = value,
                  ),
                ),
              ]),
              _separator,
              Center(
                child: ToggleButtons(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  isSelected: [
                    type == ConsumableType.hitPoints,
                    type == ConsumableType.fatigue,
                    type == ConsumableType.other,
                  ],
                  onPressed: (index) => {
                    setState(
                      () => type = ConsumableType.values[index],
                    )
                  },
                  children: [
                    Text("Vida"),
                    Text("Fatiga"),
                    Text("Otros"),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static ConsumableState _buildConsumable(
    String name,
    String maxValue,
    String step,
    String description,
    ConsumableType type,
  ) {
    return ConsumableState(
      name: name,
      maxValue: maxValue.intValue,
      actualValue: maxValue.intValue,
      step: step.intValue,
      description: description,
      type: type,
    );
  }

  static const _separator = SizedBox(
    height: 12,
    width: 8,
  );

  static List<Widget> _row(List<Widget> children) {
    List<Widget> list = [];

    children.forEach((element) {
      list.add(_separator);
      list.add(Expanded(child: element));
    });

    return [_separator, Row(children: list)];
  }
}

extension on String {
  int get intValue {
    return int.tryParse(this) ?? 0;
  }
}
