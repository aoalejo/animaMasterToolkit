import 'package:amt/models/character_model/character.dart';
import 'package:amt/presentation/presentation.dart';
import 'package:flutter/material.dart';

class NPCSelector {
  static void open(
    BuildContext context,
    ThemeData theme, {
    required List<Character> characters,
    required void Function(Character) onSelected,
    required void Function() onRemoveAll,
    required void Function() onAddNpc,
    required void Function(Character) onRemove,
  }) {
    final characters0 = characters;
    var filter = '';

    showDialog<void>(
      context: context,
      builder: (builder) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Row(
                children: [
                  const Expanded(child: Text('Añadir NPC')),
                  Flexible(
                    child: AMTTextFormField(
                      suffixIcon: const Icon(Icons.search),
                      text: filter,
                      onChanged: (newFilter) => setState(() => filter = newFilter),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onAddNpc();
                    },
                    icon: const Icon(Icons.upload_file),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      showDialog<void>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Borrar todos los NPC'),
                            content: const Text('¿seguro que desea borrar todos los NPC de la lista de personajes activos?'),
                            actions: [
                              OutlinedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  onRemoveAll();
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
                        },
                      );
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cerrar'),
                ),
              ],
              content: SizedBox(
                height: 500,
                width: 500,
                child: GridView.count(
                  crossAxisCount: 1,
                  childAspectRatio: 1.5,
                  children: [
                    for (final character in characters0.where((element) => element.isOn(filter)))
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
