import 'package:amt/generated/l10n.dart';
import 'package:amt/models/armour.dart';
import 'package:amt/models/armour_data.dart';
import 'package:amt/presentation/components/components.dart';
import 'package:amt/resources/armours.dart';
import 'package:flutter/material.dart';
import 'package:function_tree/function_tree.dart';

class ArmoursRack extends StatelessWidget {
  const ArmoursRack({required this.onEdit, required this.armourBase, super.key});
  final void Function(ArmourData) onEdit;
  final ArmourData armourBase;

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
                  title: Text(S.of(context).modifyArmor),
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    AMTTextFormField(
                      label: S.of(context).name,
                      text: armour.armours.firstOrNull?.name ?? S.of(context).withoutArmour,
                      onChanged: (value) {
                        if (armour.armours.firstOrNull == null) {
                          armour.armours.add(Armour());
                        }
                        armour.armours.first.name = value;
                        onEdit(armour);
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: AMTTextFormField(
                            label: S.of(context).damageFIL,
                            text: armour.calculatedArmour.fil.toString(),
                            onChanged: (value) {
                              armour.calculatedArmour.fil = _parseInput(value);
                              onEdit(armour);
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Flexible(
                          child: AMTTextFormField(
                            label: S.of(context).damagePEN,
                            text: armour.calculatedArmour.pen.toString(),
                            onChanged: (value) {
                              armour.calculatedArmour.pen = _parseInput(value);
                              onEdit(armour);
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Flexible(
                          child: AMTTextFormField(
                            label: S.of(context).damageCON,
                            text: armour.calculatedArmour.con.toString(),
                            onChanged: (value) {
                              armour.calculatedArmour.con = _parseInput(value);
                              onEdit(armour);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: AMTTextFormField(
                            label: S.of(context).damageFRI,
                            text: armour.calculatedArmour.fri.toString(),
                            onChanged: (value) {
                              armour.calculatedArmour.fri = _parseInput(value);
                              onEdit(armour);
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Flexible(
                          child: AMTTextFormField(
                            label: S.of(context).damageCAL,
                            text: armour.calculatedArmour.cal.toString(),
                            onChanged: (value) {
                              armour.calculatedArmour.cal = _parseInput(value);
                              onEdit(armour);
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Flexible(
                          child: AMTTextFormField(
                            label: S.of(context).damageELE,
                            text: armour.calculatedArmour.ele.toString(),
                            onChanged: (value) {
                              armour.calculatedArmour.ele = _parseInput(value);
                              onEdit(armour);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    AMTTextFormField(
                      label: S.of(context).damageENE,
                      text: armour.calculatedArmour.ene.toString(),
                      onChanged: (value) {
                        armour.calculatedArmour.ene = _parseInput(value);
                        onEdit(armour);
                      },
                    ),
                    const SizedBox(
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
                            children: [const Icon(Icons.remove), Text(S.of(context).removeTAtoAll)],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() => armour.calculatedArmour.changeForAll(add: 1));

                            onEdit(armour);
                          },
                          child: Row(
                            children: [const Icon(Icons.remove), Text(S.of(context).addTAtoAll)],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(S.of(context).replaceForAnother),
                    for (final preset in Armours.getPresetArmours())
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
        ),
      },
      child: Tooltip(
        textAlign: TextAlign.start,
        message: armour.armours.map((e) => e.name).join(', '),
        child: Card(
          color: theme.colorScheme.primary,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    armour.armours.firstOrNull?.name ?? S.of(context).withoutArmour,
                    style: style,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.edit,
                  color: theme.colorScheme.onPrimary,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _armourLister(ThemeData theme, Armour armour, void Function(Armour) onSelect) {
    final subtitleButton = theme.textTheme.bodySmall;

    return TextButton(
      onPressed: () => onSelect(armour),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(armour.name ?? ''),
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
