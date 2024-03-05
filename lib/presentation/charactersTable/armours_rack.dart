import 'package:amt/models/armour.dart';
import 'package:amt/models/armour_data.dart';
import 'package:amt/resources/armours.dart';
import 'package:amt/utils/amt_bottom_sheet.dart';
import 'package:amt/utils/amt_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:function_tree/function_tree.dart';

class ArmoursRack extends StatelessWidget {
  final Function(ArmourData) onEdit;
  final ArmourData armourBase;

  ArmoursRack({required this.onEdit, required this.armourBase});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final style = theme.textTheme.bodySmall!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    final armour = armourBase;

    return GestureDetector(
      onTap: () => {
        showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return AMTBottomSheet(
                  title: Text("Modificar Armadura"),
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    AMTTextFormField(
                      label: "Nombre",
                      text: armour.armours.firstOrNull?.name ?? "Sin armadura",
                      onChanged: (value) {
                        if (armour.armours.firstOrNull == null) {
                          armour.armours.add(Armour());
                        }
                        armour.armours.first.name = value;
                        onEdit(armour);
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: AMTTextFormField(
                            label: "Filo",
                            text: armour.calculatedArmour.fil.toString(),
                            onChanged: (value) {
                              armour.calculatedArmour.fil = _parseInput(value);
                              onEdit(armour);
                            },
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Flexible(
                          child: AMTTextFormField(
                            label: "Penetrante",
                            text: armour.calculatedArmour.pen.toString(),
                            onChanged: (value) {
                              armour.calculatedArmour.pen = _parseInput(value);
                              onEdit(armour);
                            },
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Flexible(
                          child: AMTTextFormField(
                            label: "Contundente",
                            text: armour.calculatedArmour.con.toString(),
                            onChanged: (value) {
                              armour.calculatedArmour.con = _parseInput(value);
                              onEdit(armour);
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: AMTTextFormField(
                            label: "Frio",
                            text: armour.calculatedArmour.fri.toString(),
                            onChanged: (value) {
                              armour.calculatedArmour.fri = _parseInput(value);
                              onEdit(armour);
                            },
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Flexible(
                          child: AMTTextFormField(
                            label: "Calor",
                            text: armour.calculatedArmour.cal.toString(),
                            onChanged: (value) {
                              armour.calculatedArmour.cal = _parseInput(value);
                              onEdit(armour);
                            },
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Flexible(
                          child: AMTTextFormField(
                            label: "Electricidad",
                            text: armour.calculatedArmour.ele.toString(),
                            onChanged: (value) {
                              armour.calculatedArmour.ele = _parseInput(value);
                              onEdit(armour);
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    AMTTextFormField(
                      label: "Energía",
                      text: armour.calculatedArmour.ene.toString(),
                      onChanged: (value) {
                        armour.calculatedArmour.ene = _parseInput(value);
                        onEdit(armour);
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() => armour.calculatedArmour.changeForAll(add: -1));
                            onEdit(armour);
                          },
                          child: Row(
                            children: [Icon(Icons.remove), Text("Eliminar 1 TA a todo")],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() => armour.calculatedArmour.changeForAll(add: 1));

                            onEdit(armour);
                          },
                          child: Row(
                            children: [Icon(Icons.remove), Text("Añadir 1 TA a todo")],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text("Reemplazar por otra:"),
                    for (var preset in Armours.getPresetArmours())
                      _armourLister(theme, preset, (newArmour) {
                        setState(() {
                          armour.calculatedArmour = newArmour;

                          if (armour.armours.firstOrNull == null) {
                            armour.armours.add(Armour());
                          }

                          armour.armours.firstOrNull?.name = newArmour.name;
                        });
                        onEdit(armour);
                      }),
                  ],
                );
              },
            );
          },
        )
      },
      child: Tooltip(
        textAlign: TextAlign.start,
        message: armour.armours.map((e) => e.name).join(", "),
        child: Card(
          color: theme.colorScheme.primary,
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    armour.armours.firstOrNull?.name ?? "Sin armadura",
                    style: style,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.edit,
                  color: theme.colorScheme.onPrimary,
                  size: 18,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _armourLister(ThemeData theme, Armour armour, Function(Armour) onSelect) {
    final subtitleButton = theme.textTheme.bodySmall;

    return TextButton(
      onPressed: () => onSelect(armour),
      child: Padding(
        padding: EdgeInsets.all(4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(armour.name ?? ""),
                Text(
                  armour.description(),
                  style: subtitleButton,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  int _parseInput(String value) {
    try {
      return value.interpret().toInt();
    } catch (e) {
      return 0;
    }
  }
}
