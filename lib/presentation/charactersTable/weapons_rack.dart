import 'package:amt/models/enums.dart';
import 'package:amt/models/weapon.dart';
import 'package:amt/presentation/components/components.dart';
import 'package:flutter/material.dart';
import 'package:function_tree/function_tree.dart';

class WeaponsRack extends StatelessWidget {

  const WeaponsRack({required this.weapons, required this.selectedWeapon, required this.onEdit, required this.onSelect, super.key,
  });
  final Function(Weapon) onEdit;
  final Function(Weapon) onSelect;

  final List<Weapon> weapons;
  final Weapon selectedWeapon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final style = theme.textTheme.bodySmall!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    final subtitleButton = theme.textTheme.bodySmall;
    final subtitleButtonOnPrimary = theme.textTheme.bodySmall!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return GestureDetector(
      onTap: () => {
        showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return AMTBottomSheet(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Selección/Edición de arma'),
                    TextButton(
                      onPressed: () {
                        final newWeapon = Weapon.blank();
                        weapons.add(newWeapon);
                        Navigator.pop(context);
                        onSelect(newWeapon);
                        _showWeaponEditor(
                          context,
                          weapon: newWeapon,
                          onEdit: onEdit,
                        );
                      },
                      child: const Text('Crear nueva'),
                    ),
                  ],
                ),
                children: [
                  Column(
                    children: [
                      for (final weapon in weapons)
                        TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: weapon == selectedWeapon ? theme.colorScheme.primary : null,
                              foregroundColor: weapon == selectedWeapon ? theme.colorScheme.onPrimary : null,),
                          onPressed: () => {
                            onSelect(weapon),
                            Navigator.pop(context),
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(weapon.name),
                                    Text(
                                      weapon.description(),
                                      style: weapon == selectedWeapon ? subtitleButtonOnPrimary : subtitleButton,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        final copy = weapon.copy();
                                        weapons.add(copy);
                                        Navigator.pop(context);
                                        _showWeaponEditor(
                                          context,
                                          weapon: copy,
                                          onEdit: onEdit,
                                        );
                                      },
                                      icon: const Icon(Icons.copy),
                                    ),
                                    IconButton(
                                      onPressed: () => {Navigator.pop(context), _showWeaponEditor(context, weapon: weapon, onEdit: onEdit)},
                                      icon: const Icon(Icons.edit),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ],);
          },
        ),
      },
      child: Tooltip(
        textAlign: TextAlign.start,
        message: selectedWeapon.description(lineBreak: true),
        child: Card(
          color: theme.colorScheme.primary,
          child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      selectedWeapon.name,
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
              ),),
        ),
      ),
    );
  }

  void _showWeaponEditor(BuildContext context, {required Weapon weapon, required Function(Weapon) onEdit}) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) => AMTBottomSheet(
            title: Text('Modificar ${weapon.name}'),
            children: [
              const SizedBox(
                height: 16,
              ),
              AMTTextFormField(
                label: 'Nombre',
                text: weapon.name,
                onChanged: (value) {
                  weapon.name = value;
                  onEdit(weapon);
                },
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Expanded(
                    child: AMTTextFormField(
                      label: 'Daño base',
                      text: weapon.damage.toString(),
                      enabled: !(weapon.variableDamage ?? false),
                      onChanged: (value) {
                        setState(
                          () => {
                            weapon.damage = _parseInput(value),
                            onEdit(weapon),
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  const Text('Daño variable?:'),
                  Switch(
                    value: weapon.variableDamage ?? false,
                    onChanged: (newValue) {
                      setState(
                        () => {
                          if (newValue) {weapon.damage = 0},
                          weapon.variableDamage = newValue,
                          onEdit(weapon),
                        },
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              AMTTextFormField(
                label: 'Ataque',
                text: weapon.attack.toString(),
                onChanged: (value) {
                  weapon.attack = _parseInput(value);
                  onEdit(weapon);
                },
              ),
              const SizedBox(
                height: 16,
              ),
              AMTTextFormField(
                label: 'Defensa',
                text: weapon.defense.toString(),
                onChanged: (value) {
                  weapon.defense = _parseInput(value);
                  onEdit(weapon);
                },
              ),
              const SizedBox(
                height: 16,
              ),
              AMTTextFormField(
                label: 'Turno',
                text: weapon.turn.toString(),
                onChanged: (value) {
                  weapon.turn = _parseInput(value);
                  onEdit(weapon);
                },
              ),
              const SizedBox(
                height: 16,
              ),
              if (!(weapon.variableDamage ?? false))
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Tipo de daño principal: '),
                    ToggleButtons(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      isSelected: [
                        weapon.principalDamage == DamageTypes.fil,
                        weapon.principalDamage == DamageTypes.pen,
                        weapon.principalDamage == DamageTypes.con,
                        weapon.principalDamage == DamageTypes.fri,
                        weapon.principalDamage == DamageTypes.cal,
                        weapon.principalDamage == DamageTypes.ele,
                        weapon.principalDamage == DamageTypes.ene,
                      ],
                      onPressed: (index) => {
                        setState(
                          () => {
                            weapon.principalDamage = DamageTypes.values[index],
                            onEdit(weapon),
                          },
                        ),
                      },
                      children: const [
                        Text('fil'),
                        Text('pen'),
                        Text('con'),
                        Text('fri'),
                        Text('cal'),
                        Text('ele'),
                        Text('ene'),
                      ],
                    ),
                  ],
                ),
              if (!(weapon.variableDamage ?? false))
                const SizedBox(
                  height: 16,
                ),
              if (!(weapon.variableDamage ?? false))
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Tipo de daño secundario: '),
                    ToggleButtons(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      isSelected: [
                        weapon.secondaryDamage == DamageTypes.fil,
                        weapon.secondaryDamage == DamageTypes.pen,
                        weapon.secondaryDamage == DamageTypes.con,
                        weapon.secondaryDamage == DamageTypes.fri,
                        weapon.secondaryDamage == DamageTypes.cal,
                        weapon.secondaryDamage == DamageTypes.ele,
                        weapon.secondaryDamage == DamageTypes.ene,
                      ],
                      onPressed: (index) => {
                        setState(
                          () => {
                            weapon.secondaryDamage = DamageTypes.values[index],
                            onEdit(weapon),
                          },
                        ),
                      },
                      children: const [
                        Text('fil'),
                        Text('pen'),
                        Text('con'),
                        Text('fri'),
                        Text('cal'),
                        Text('ele'),
                        Text('ene'),
                      ],
                    ),
                  ],
                ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Tipo de defensa: '),
                  StatefulBuilder(
                    builder: (context, setState) => ToggleButtons(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      isSelected: [
                        weapon.defenseType == DefenseType.parry,
                        weapon.defenseType == DefenseType.dodge,
                      ],
                      onPressed: (index) => {
                        setState(
                          () => {
                            weapon.defenseType = DefenseType.values[index],
                            onEdit(weapon),
                          },
                        ),
                      },
                      children: const [
                        Text('Parada'),
                        Text('Esquiva'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        );
      },
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
