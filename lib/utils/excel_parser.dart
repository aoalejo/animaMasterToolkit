import 'dart:io';

import 'package:amt/models/character/character.dart';

abstract class ExcelParser {
  ExcelParser.fromFile(this.file);
  ExcelParser.fromBytes(this.bytes);

  File? file;
  List<int>? bytes;

  Future<Character?> parse();
}
