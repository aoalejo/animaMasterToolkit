import 'package:amt/models/character/character.dart';
import 'package:amt/models/character_profile.dart';
import 'package:flutter/material.dart';

class NPCSelector {
  static open(
    BuildContext context,
    ThemeData theme, {
    required List<Character> characters,
    required Function(Character) onSelected,
    required Function() onRemoveAll,
    required Function() onAddNpc,
    required Function(Character) onRemove,
  }) {
    var _characters = characters;
    showDialog(
        context: context,
        builder: (builder) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: Row(
                  children: [
                    Expanded(child: Text("Añadir NPC")),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onAddNpc();
                      },
                      icon: Icon(Icons.upload_file),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Borrar personajes"),
                              content: Text(
                                  "Seguro que desea borrar todos los NPC?"),
                              actions: [
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    onRemoveAll();
                                  },
                                  child: Text("Borrar"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Cancelar"),
                                )
                              ],
                            );
                          },
                        );
                      },
                      icon: Icon(Icons.delete),
                    )
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Cerrar"))
                ],
                content: SizedBox(
                  height: 500,
                  width: 500,
                  child: GridView.count(
                    crossAxisCount: 1,
                    childAspectRatio: 1.5,
                    children: [
                      for (var character in _characters)
                        CharacterNPCCard(
                          character,
                          theme,
                          onSelected: onSelected,
                          onRemove: (character) {
                            setState(() => _characters.remove(character));
                            onRemove(character);
                          },
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }
}

class CharacterNPCCard extends StatelessWidget {
  final Character character;
  final ThemeData theme;
  final Function(Character) onSelected;
  final Function(Character) onRemove;

  CharacterNPCCard(
    this.character,
    this.theme, {
    required this.onSelected,
    required this.onRemove,
  });
  CharacterProfile get profile => character.profile;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(
                profile.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )),
              IconButton(
                  onPressed: () => onRemove(character),
                  icon: Icon(
                    Icons.delete,
                  )),
            ],
          ),
          Row(
            children: [
              Card(
                color: theme.primaryColor,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                  child: Text(
                    'Lv. ${profile.level}',
                    style: theme.textTheme.bodySmall!
                        .copyWith(color: theme.colorScheme.onPrimary),
                  ),
                ),
              ),
              Card(
                color: theme.primaryColor,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                  child: Text(
                    profile.category,
                    style: theme.textTheme.bodySmall!
                        .copyWith(color: theme.colorScheme.onPrimary),
                  ),
                ),
              )
            ],
          ),
          Text(character.getResumedCombatState()),
          Text(character.getResumedAttributes()),
          Text(character.getResumedResistances()),
          Text(
            character.getResumedSkills(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Expanded(
              child: ColoredBox(
            color: Colors.amber,
          )),
          TextButton(
              onPressed: () {
                onSelected(character);
              },
              child: Text("Añadir"))
        ],
      ),
    ));
  }
}
