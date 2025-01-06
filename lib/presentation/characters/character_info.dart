import 'package:amt/models/character_model/character.dart';
import 'package:amt/models/enums.dart';
import 'package:amt/presentation/components/components.dart';
import 'package:amt/utils/key_value.dart';
import 'package:flutter/material.dart';
import 'package:function_tree/function_tree.dart';

class ShowCharacterInfo {
  static Future<void> call(BuildContext context, Character character, {required void Function(Character) onEdit}) {
    final theme = Theme.of(context);
    final skills = character.skills.list();
    final attributes = character.attributes.toKeyValue();
    final resistances = character.resistances.toKeyValue();

    // Optional lists:

    // Mystical
    final paths = character.mystical?.paths.list();
    final subPaths = character.mystical?.subPaths.list();
    final metamagic = character.mystical?.metamagic.list();
    final spellsMaintained = character.mystical?.spellsMaintained.list();
    final spellsPurchased = character.mystical?.spellsPurchased.list(
      interchange: true,
    );

    // Ki
    final kiSkills = character.ki?.skills.list();

    // Psychic
    final disciplines = character.psychic?.disciplines.list();
    final innate = character.psychic?.innate.list();
    final patterns = character.psychic?.patterns.list();
    final powers = character.psychic?.powers.list();

    var search = '';

    void onAttributeEdit(KeyValue element) {
      character.attributes.edit(element);
      onEdit(character);
    }

    void onResistanceEdit(KeyValue element) {
      character.resistances.editResistance(element);
      onEdit(character);
    }

    void onSkillEdit(KeyValue element) {
      character.skills[element.key] = element.value;
      onEdit(character);
    }

    return showModalBottomSheet(
      context: context,
      constraints: BoxConstraints.tight(const Size(1200, 600)),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SizedBox(
              height: 600,
              width: 1200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: 120,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(character.profile.name),
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.close),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: AMTTextFormField(
                                  text: search,
                                  suffixIcon: const Icon(Icons.search),
                                  onChanged: (value) => {
                                    setState(
                                      () => search = value,
                                    ),
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 400,
                    width: 1200,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          for (final row in _table(
                            'Atributo',
                            attributes,
                            theme,
                            search,
                            diffDivisor: 10,
                            onEdit: onAttributeEdit,
                          ))
                            row,
                          for (final row in _table('Resistencias', resistances, theme, search, onEdit: onResistanceEdit)) row,
                          for (final row in _table('Habilidad', skills, theme, search, onEdit: onSkillEdit)) row,
                          for (final row in _table('Vias', paths, theme, search, onEdit: null)) row,
                          for (final row in _table('Sub-Vias', subPaths, theme, search, onEdit: null)) row,
                          for (final row in _table('Meta-magia', metamagic, theme, search, onEdit: null)) row,
                          for (final row in _table('Hechizos mantenidos', spellsMaintained, theme, search, onEdit: null)) row,
                          for (final row in _table('Hechizos comprados', spellsPurchased, theme, search, onEdit: null)) row,
                          for (final row in _table('habilidades de Ki', kiSkills, theme, search, onEdit: null)) row,
                          for (final row in _table('Disciplinas', disciplines, theme, search, onEdit: null)) row,
                          for (final row in _table('Innatos', innate, theme, search, onEdit: null)) row,
                          for (final row in _table('Patrones', patterns, theme, search, onEdit: null)) row,
                          for (final row in _table('Poderes', powers, theme, search, onEdit: null)) row,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  static Widget _row(
    List<AMTStringFlex> values, {
    required ThemeData theme,
    required void Function(String)? onEdit,
    bool title = false,
    bool odd = false,
  }) {
    return Card(
      color: title
          ? theme.colorScheme.primary
          : odd
              ? theme.colorScheme.secondaryContainer
              : theme.colorScheme.surface,
      child: SizedBox(
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (final value in values)
              Expanded(
                flex: value.flex,
                child: (value.editable && onEdit != null)
                    ? AMTTextFormField(
                        text: value.text,
                        inputType: TextInputType.number,
                        onChanged: (value) {
                          onEdit(value);
                        },
                      )
                    : Text(
                        value.text,
                        textAlign: TextAlign.center,
                        style: value.flex == 1
                            ? theme.textTheme.bodySmall!.copyWith(color: title ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface)
                            : theme.textTheme.bodyLarge!.copyWith(color: title ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface),
                      ),
              ),
          ],
        ),
      ),
    );
  }

  static List<Widget> _table(
    String name,
    List<KeyValue>? list,
    ThemeData theme,
    String search, {
    required void Function(KeyValue)? onEdit,
    List<DifficultyEnum> difficulties = SecondaryDifficulties.values,
    int diffDivisor = 1,
  }) {
    if (list == null) return [];

    final listFiltered = search.isEmpty ? list : list.where((element) => element.key.toLowerCase().contains(search.toLowerCase())).toList();

    if (listFiltered.isEmpty) return [];

    return [
      _row(
        [
          AMTStringFlex(name, flex: 4),
          AMTStringFlex('Valor', flex: 2),
          for (final diff in difficulties) AMTStringFlex('${diff.abbreviated}\n(${(diff.difficulty / diffDivisor).toStringAsFixed(0)})', flex: 1),
        ],
        theme: theme,
        title: true,
        onEdit: null,
      ),
      for (var i = 0; i < listFiltered.length; i++)
        _row(
          [
            AMTStringFlex(listFiltered[i].key, flex: 4),
            AMTStringFlex(listFiltered[i].value, flex: 2, editable: true),
            for (final diff in difficulties) AMTStringFlex(_differenceTo(listFiltered[i].value, diff.difficulty ~/ diffDivisor), flex: 1),
          ],
          theme: theme,
          odd: i.isEven,
          onEdit: onEdit == null
              ? null
              : (value) {
                  onEdit(KeyValue(key: listFiltered[i].key, value: value));
                },
        ),
    ];
  }

  static String _differenceTo(String value, int difficulty) {
    try {
      final numericValue = difficulty - value.interpret().toInt();

      if (numericValue > 0) {
        return numericValue.toString();
      } else {
        return '-';
      }
    } catch (e) {
      return '-';
    }
  }
}
