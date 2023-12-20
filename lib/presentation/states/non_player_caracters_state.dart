import 'dart:convert';
import 'dart:io';

import 'package:amt/models/character/character.dart';
import 'package:enough_convert/windows.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

class NonPlayerCharactersState extends ChangeNotifier {
  late Box<Character> _box;
  List<Character> characters = [];

  NonPlayerCharactersState() {
    initAsync();
  }

  void initAsync() async {
    try {
      _box = await Hive.openBox('non_player_characters');
      characters.addAll(_box.values.toList());

      if (characters.isEmpty) {
        var preloadedNPC = await loadNpc();
        characters.addAll(preloadedNPC);
        for (var element in preloadedNPC) {
          _box.add(element);
        }
      }

      print("Loaded NPCS: ${characters.length}");
      notifyListeners();
    } catch (e) {
      Hive.deleteBoxFromDisk('non_player_characters');
      _box = await Hive.openBox('non_player_characters');
      notifyListeners();
      print(e);
    }

    print("Loaded NPCS: ${characters.length}");
  }

  Future<List<Character>> loadNpc() async {
    var charactersString = await rootBundle.loadString(
      'assets/characters.json',
    );

    var charactersWrapper = CharacterList.fromJson(jsonDecode(charactersString));

    return charactersWrapper.characters;
  }

  void getCharacters() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      allowMultiple: true,
    );

    try {
      if (result != null) {
        if (result.files.first.bytes != null) {
          // For web
          List<String> files = result.files.map((file) => Windows1252Codec().decode(file.bytes!.toList())).toList();

          for (var file in files) {
            var character = Character.fromJson(jsonDecode(file));
            characters.add(character);
            _box.add(character);
          }
        } else {
          // For desktop
          List<File> files = result.paths.map((path) => File(path ?? "")).toList();

          for (var file in files) {
            final json = await file.readAsString(encoding: Windows1252Codec());
            var character = Character.fromJson(jsonDecode(json));
            print(character.toString());
            characters.add(character);
            print("character added");

            _box.add(character);
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
