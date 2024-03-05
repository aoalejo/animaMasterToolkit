import 'package:amt/models/character/character.dart';
import 'package:amt/models/enums.dart';
import 'package:amt/presentation/amt_text_form_field.dart';
import 'package:amt/utils/key_value.dart';
import 'package:flutter/material.dart';
import 'package:function_tree/function_tree.dart';

class ShowCharacterInfo {
  static call(BuildContext context, Character character, {required Function(Character) onEdit}) {
    var theme = Theme.of(context);
    var skills = character.skills.list();
    var attributes = character.attributes.toKeyValue();
    var resistances = character.resistances.toKeyValue();

    // Optional lists:

    // Mystical
    var paths = character.mystical?.paths.list();
    var subPaths = character.mystical?.subPaths.list();
    var metamagic = character.mystical?.metamagic.list();
    var spellsMaintained = character.mystical?.spellsMaintained.list();
    var spellsPurchased = character.mystical?.spellsPurchased.list(
      interchange: true,
    );

    // Ki
    var kiSkills = character.ki?.skills.list();

    // Psychic
    var disciplines = character.psychic?.disciplines.list();
    var innate = character.psychic?.innate.list();
    var patterns = character.psychic?.patterns.list();
    var powers = character.psychic?.powers.list();

    var search = "";

    onAttributeEdit(KeyValue element) {
      character.attributes.edit(element);
      onEdit(character);
    }

    onResistanceEdit(KeyValue element) {
      character.resistances.editResistance(element);
      onEdit(character);
    }

    onSkillEdit(KeyValue element) {
      character.skills[element.key] = element.value;
      onEdit(character);
    }

    return showModalBottomSheet(
      context: context,
      constraints: BoxConstraints.tight(Size(1200, 600)),
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
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
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
                                icon: Icon(Icons.close),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: AMTTextFormField(
                                    text: search,
                                    suffixIcon: Icon(Icons.search),
                                    onChanged: (value) => {
                                          setState(
                                            () => search = value,
                                          )
                                        }),
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
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          for (var row in _table(
                            "Atributo",
                            attributes,
                            theme,
                            search,
                            diffDivisor: 10,
                            onEdit: onAttributeEdit,
                          ))
                            row,
                          for (var row in _table("Resistencias", resistances, theme, search, onEdit: onResistanceEdit)) row,
                          for (var row in _table("Habilidad", skills, theme, search, onEdit: onSkillEdit)) row,
                          for (var row in _table("Vias", paths, theme, search, onEdit: null)) row,
                          for (var row in _table("Sub-Vias", subPaths, theme, search, onEdit: null)) row,
                          for (var row in _table("Meta-magia", metamagic, theme, search, onEdit: null)) row,
                          for (var row in _table("Hechizos mantenidos", spellsMaintained, theme, search, onEdit: null)) row,
                          for (var row in _table("Hechizos comprados", spellsPurchased, theme, search, onEdit: null)) row,
                          for (var row in _table("habilidades de Ki", kiSkills, theme, search, onEdit: null)) row,
                          for (var row in _table("Disciplinas", disciplines, theme, search, onEdit: null)) row,
                          for (var row in _table("Innatos", innate, theme, search, onEdit: null)) row,
                          for (var row in _table("Patrones", patterns, theme, search, onEdit: null)) row,
                          for (var row in _table("Poderes", powers, theme, search, onEdit: null)) row,
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  static Widget _row(
    List<StringFlex> values, {
    bool title = false,
    bool odd = false,
    required ThemeData theme,
    required Function(String)? onEdit,
  }) {
    return Card(
      color: title
          ? theme.colorScheme.primary
          : odd
              ? theme.colorScheme.secondaryContainer
              : theme.colorScheme.background,
      child: SizedBox(
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (var value in values)
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
                            ? theme.textTheme.bodySmall!.copyWith(color: title ? theme.colorScheme.onPrimary : theme.colorScheme.onBackground)
                            : theme.textTheme.bodyLarge!.copyWith(color: title ? theme.colorScheme.onPrimary : theme.colorScheme.onBackground),
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
    List<DifficultyEnum> difficulties = SecondaryDifficulties.values,
    int diffDivisor = 1,
    required Function(KeyValue)? onEdit,
  }) {
    if (list == null) return [];

    var listFiltered = search.isEmpty ? list : list.where((element) => element.key.toLowerCase().contains(search.toLowerCase())).toList();

    if (listFiltered.isEmpty) return [];

    return [
      _row([
        StringFlex(name, flex: 4),
        StringFlex("Valor", flex: 2),
        for (var diff in difficulties) StringFlex("${diff.abbreviated}\n(${(diff.difficulty / diffDivisor).toStringAsFixed(0)})", flex: 1)
      ], theme: theme, title: true, onEdit: null),
      for (var i = 0; i < listFiltered.length; i++)
        _row(
          [
            StringFlex(listFiltered[i].key, flex: 4),
            StringFlex(listFiltered[i].value, flex: 2, editable: true),
            for (var diff in difficulties) StringFlex(_differenceTo(listFiltered[i].value, diff.difficulty ~/ diffDivisor), flex: 1),
          ],
          theme: theme,
          odd: i % 2 == 0,
          onEdit: onEdit == null
              ? null
              : (value) {
                  onEdit(KeyValue(key: listFiltered[i].key, value: value));
                },
        )
    ];
  }

  static String _differenceTo(String value, int difficulty) {
    try {
      var numericValue = difficulty - value.interpret().toInt();

      if (numericValue > 0) {
        return numericValue.toString();
      } else {
        return "-";
      }
    } catch (e) {
      return "-";
    }
  }

  static Color _colorForBackground(ThemeData theme, KeyValue value, List<KeyValue> values) {
    return values.indexOf(value) % 2 == 0 ? theme.colorScheme.onPrimary : theme.colorScheme.primaryContainer;
  }
}

class StringFlex {
  final String text;
  final int flex;
  final bool editable;

  StringFlex(
    this.text, {
    required this.flex,
    this.editable = false,
  });
}
