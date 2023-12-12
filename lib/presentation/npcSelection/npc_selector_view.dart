import 'package:amt/models/character/character.dart';
import 'package:amt/presentation/npcSelection/npc_card_view.dart';
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
    var characters0 = characters;
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
                            content:
                                Text("Seguro que desea borrar todos los NPC?"),
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
                    for (var character in characters0)
                      CharacterNPCCard(
                        character,
                        theme,
                        onSelected: onSelected,
                        onRemove: (character) {
                          setState(() => characters0.remove(character));
                          onRemove(character);
                        },
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
