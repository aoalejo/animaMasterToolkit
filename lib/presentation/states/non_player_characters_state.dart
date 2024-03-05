import 'dart:convert';
import 'dart:io';

import 'package:amt/models/character/character.dart';
import 'package:enough_convert/windows.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

class NonPlayerCharactersState extends ChangeNotifier {

  NonPlayerCharactersState() {
    initAsync();
  }
  late Box<Character> _box;
  List<Character> characters = [];

  Future<void> initAsync() async {
    try {
      _box = await Hive.openBox('non_player_characters');
      characters.addAll(_box.values.toList());

      if (characters.isEmpty) {
        final preloadedNPC = await loadNpc();
        characters.addAll(preloadedNPC);
        for (final element in preloadedNPC) {
          await _box.add(element);
        }
      }

      Logger().d('Loaded NPCS: ${characters.length}');
      notifyListeners();
    } catch (e) {
      await Hive.deleteBoxFromDisk('non_player_characters');
      _box = await Hive.openBox('non_player_characters');
      notifyListeners();
      Logger().d(e);
    }

    Logger().d('Loaded NPCS: ${characters.length}');
  }

  Future<List<Character>> loadNpc() async {
    final charactersString = await rootBundle.loadString(
      'assets/characters.json',
    );

    final charactersWrapper = CharacterList.fromJson(jsonDecode(charactersString));

    return charactersWrapper.characters;
  }

  Future<void> getCharacters() async {
    final var result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      allowMultiple: true,
    );

    try {
      if (result != null) {
        if (result.files.first.bytes != null) {
          // For web
          final var files = result.files.map((file) => const Windows1252Codec().decode(file.bytes!.toList())).toList();

          for (final file in files) {
            final character = Character.fromJson(jsonDecode(file));
            characters.add(character);
            await _box.add(character);
          }
        } else {
          // For desktop
          final files = result.paths.map((path) => File(path ?? '')).toList();

          for (final file in files) {
            final json = await file.readAsString(encoding: const Windows1252Codec());
            final character = Character.fromJson(jsonDecode(json));
            Logger().d(character);
            characters.add(character);
            Logger().d('character added');

            await _box.add(character);
          }
        }
      }
    } catch (e) {}

    notifyListeners();
  }

  removeNPC(Character character) {
    characters.remove(character);
    character.delete();
    notifyListeners();
  }
}
