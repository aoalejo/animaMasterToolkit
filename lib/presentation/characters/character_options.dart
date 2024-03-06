import 'package:amt/models/character_model/character.dart';
import 'package:amt/presentation/presentation.dart';
import 'package:flutter/material.dart';

class ShowCharacterOptions {
  static Future<void> call(
    BuildContext context,
    Character character, {
    required void Function(Character) onRemove,
    required void Function(Character) onEdit,
  }) {
    final theme = Theme.of(context);

    return showModalBottomSheet(
      context: context,
      constraints: BoxConstraints.tight(const Size(500, 500)),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                      const SizedBox(
                        height: 22,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      AMTTextFormField(
                        label: 'Nombre',
                        text: character.profile.name,
                        onChanged: (value) {
                          character.profile.name = value;
                          onEdit(character);
                        },
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: AMTTextFormField(
                              label: 'Nivel de pifia',
                              text: (character.profile.fumbleLevel ?? 3).toString(),
                              onChanged: (value) {
                                final fumble = int.tryParse(value);
                                if (fumble != null) {
                                  character.profile.fumbleLevel = fumble;
                                }

                                onEdit(character);
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: AMTTextFormField(
                              label: 'Natura',
                              text: (character.profile.nature ?? 5).toString(),
                              onChanged: (value) {
                                final nature = int.tryParse(value);
                                if (nature != null) {
                                  character.profile.nature = nature;
                                }
                                onEdit(character);
                              },
                              suffixIcon: const Tooltip(
                                message: 'menor de 5 no permite más de un crítico '
                                    '\nEntre 5 y 14 usan el sistema normal de criticos'
                                    "\nSuperior a 15 tienen 'Tirada abierta adicional'",
                                child: Icon(Icons.info),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'Valores menores se consideran pifia',
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: Text(
                              'Indica el tipo de tirada critica',
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 48,
                      ),
                      Row(
                        children: [
                          const Text('Borrar personaje'),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);

                              showDialog<void>(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Borrar personaje'),
                                    content: Text('Seguro que desea borrar ${character.profile.name}?'),
                                    actions: [
                                      OutlinedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          onRemove(character);
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
                            icon: const Row(
                              children: [
                                Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 36,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
