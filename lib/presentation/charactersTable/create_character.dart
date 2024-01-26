import 'package:amt/models/armour.dart';
import 'package:amt/models/armour_data.dart';
import 'package:amt/models/attributes_list.dart';
import 'package:amt/models/character/character.dart';
import 'package:amt/models/character/character_resistances.dart';
import 'package:amt/models/character/character_state.dart';
import 'package:amt/models/character/consumable_state.dart';
import 'package:amt/models/character_profile.dart';
import 'package:amt/models/combat_data.dart';
import 'package:amt/models/enums.dart';
import 'package:amt/models/modifiers_state.dart';
import 'package:amt/models/roll.dart';
import 'package:amt/models/weapon.dart';
import 'package:amt/presentation/bottom_sheet_custom.dart';
import 'package:amt/presentation/text_form_field_custom.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CreateCharacter {
  static show(BuildContext context, Function(Character) onCreated) {
    var name = "";
    var fumble = "3";
    var nature = "5";
    var life = "125";
    var fatigue = "7";
    var zeon = "";
    var ki = "";
    var cv = "";
    var turn = "35";
    var attack = "90";
    var damage = "50";
    var defense = "90";
    var armour = "2";
    var armourEnergy = "0";
    var physicalResistance = "40";
    var defenseType = DefenseType.parry;
    var principalDamage = DamageTypes.con;

    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) => BottomSheetCustom(
            title: Text('Crear nuevo personaje'),
            bottomRow: [
              ElevatedButton(
                  child: const Text('Guardar'),
                  onPressed: () {
                    onCreated(
                      _buildCharacter(
                        name,
                        fumble,
                        nature,
                        life,
                        fatigue,
                        zeon,
                        ki,
                        cv,
                        turn,
                        attack,
                        damage,
                        defense,
                        armour,
                        armourEnergy,
                        physicalResistance,
                        defenseType,
                        principalDamage,
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
                  TextFormFieldCustom(
                    label: "Nombre",
                    text: name,
                    onChanged: (value) => setState(
                      () => name = value,
                    ),
                  ),
                  TextFormFieldCustom(
                    label: "Pifia",
                    text: fumble,
                    onChanged: (value) => setState(
                      () => fumble = value,
                    ),
                  ),
                  TextFormFieldCustom(
                    label: "Natura",
                    text: nature,
                    onChanged: (value) => setState(
                      () => nature = value,
                    ),
                  ),
                ],
              ),
              _separator,
              Text(
                "Detalles",
                textAlign: TextAlign.center,
              ),
              ..._row([
                TextFormFieldCustom(
                  label: "Vida",
                  text: life,
                  onChanged: (value) => setState(
                    () => life = value,
                  ),
                ),
                TextFormFieldCustom(
                  label: "Cansancio",
                  text: fatigue,
                  onChanged: (value) => setState(
                    () => fatigue = value,
                  ),
                ),
              ]),
              ..._row([
                TextFormFieldCustom(
                  label: "Zeon",
                  text: zeon,
                  onChanged: (value) => setState(
                    () => zeon = value,
                  ),
                ),
                TextFormFieldCustom(
                  label: "Ki",
                  text: ki,
                  onChanged: (value) => setState(
                    () => ki = value,
                  ),
                ),
                TextFormFieldCustom(
                  label: "CV",
                  text: cv,
                  onChanged: (value) => setState(
                    () => cv = value,
                  ),
                ),
              ]),
              _separator,
              Text(
                "Combate",
                textAlign: TextAlign.center,
              ),
              ..._row([
                TextFormFieldCustom(
                  label: "Turno",
                  text: turn,
                  onChanged: (value) => setState(
                    () => turn = value,
                  ),
                ),
                TextFormFieldCustom(
                  label: "Ataque",
                  text: attack,
                  onChanged: (value) => setState(
                    () => attack = value,
                  ),
                ),
                TextFormFieldCustom(
                  label: "Daño",
                  text: damage,
                  onChanged: (value) => setState(
                    () => damage = value,
                  ),
                ),
                TextFormFieldCustom(
                  label: "RF",
                  text: physicalResistance,
                  onChanged: (value) => setState(
                    () => physicalResistance = value,
                  ),
                ),
              ]),
              _separator,
              Center(
                child: ToggleButtons(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  isSelected: [
                    principalDamage == DamageTypes.fil,
                    principalDamage == DamageTypes.pen,
                    principalDamage == DamageTypes.con,
                    principalDamage == DamageTypes.fri,
                    principalDamage == DamageTypes.cal,
                    principalDamage == DamageTypes.ele,
                    principalDamage == DamageTypes.ene,
                  ],
                  onPressed: (index) => {
                    setState(
                      () => principalDamage = DamageTypes.values[index],
                    )
                  },
                  children: [
                    Text("fil"),
                    Text("pen"),
                    Text("con"),
                    Text("fri"),
                    Text("cal"),
                    Text("ele"),
                    Text("ene"),
                  ],
                ),
              ),
              _separator,
              ..._row(
                [
                  TextFormFieldCustom(
                    label: "Defensa",
                    text: defense,
                    onChanged: (value) => setState(
                      () => defense = value,
                    ),
                  ),
                  TextFormFieldCustom(
                    label: "TA",
                    text: armour,
                    onChanged: (value) => setState(
                      () => armour = value,
                    ),
                  ),
                  TextFormFieldCustom(
                    label: "TA Energia",
                    text: armourEnergy,
                    onChanged: (value) => setState(
                      () => armourEnergy = value,
                    ),
                  ),
                  ToggleButtons(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    isSelected: [
                      defenseType == DefenseType.parry,
                      defenseType == DefenseType.dodge,
                    ],
                    onPressed: (index) => {
                      setState(
                        () => defenseType = DefenseType.values[index],
                      )
                    },
                    children: [
                      Padding(padding: EdgeInsets.all(8), child: Text("Parada")),
                      Padding(padding: EdgeInsets.all(8), child: Text("Esquiva")),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static Character _buildCharacter(
    String name,
    String fumble,
    String nature,
    String life,
    String fatigue,
    String zeon,
    String ki,
    String cv,
    String turn,
    String attack,
    String damage,
    String defense,
    String armour,
    String armourEnergy,
    String physicalResistance,
    DefenseType defenseType,
    DamageTypes principalDamage,
  ) {
    List<ConsumableState> consumables = [];

    consumables.add(ConsumableState.from(name: "Vida", value: life.intValue, type: ConsumableType.hitPoints));
    consumables.add(ConsumableState.from(name: "Cansancio", value: fatigue.intValue, type: ConsumableType.fatigue));

    if (ki.isNotEmpty) {
      consumables.add(ConsumableState.from(name: "Ki", value: ki.intValue, type: ConsumableType.other));
    }

    if (cv.isNotEmpty) {
      consumables.add(ConsumableState.from(name: "Cv", value: cv.intValue, type: ConsumableType.other));
    }

    if (zeon.isNotEmpty) {
      consumables.add(ConsumableState.from(name: "Zeon", value: zeon.intValue, type: ConsumableType.other));
    }

    return Character(
        uuid: Uuid().v4(),
        attributes: AttributesList.withDefault(6),
        skills: Map.fromEntries([]),
        profile: CharacterProfile(
          fatigue: fatigue.intValue,
          name: name,
          nature: nature.intValue,
          fumbleLevel: fumble.intValue,
        ),
        combat: CombatData(
          armour: ArmourData(
            calculatedArmour: Armour.fromValue(
              name: "Armadura",
              physical: armour.intValue,
              energy: armourEnergy.intValue,
            ),
            armours: [Armour(name: "Armadura")],
          ),
          weapons: [
            Weapon(
              name: "Arma",
              turn: turn.intValue,
              attack: attack.intValue,
              defense: defense.intValue,
              defenseType: defenseType,
              damage: damage.intValue,
              principalDamage: principalDamage,
              secondaryDamage: principalDamage,
            )
          ],
        ),
        state: CharacterState(
          currentTurn: Roll.turn(),
          consumables: consumables,
          modifiers: ModifiersState(),
        ),
        ki: null,
        mystical: null,
        psychic: null,
        resistances: CharacterResistances.withDefault(physicalResistance.intValue));
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
