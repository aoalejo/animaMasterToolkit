import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:amt/models/character/character.dart';
import 'package:amt/utils/excel_parser.dart';
import 'package:http/http.dart' as http;

final _functionUrl = Uri.https("convertsheet-y5zbymdrcq-uc.a.run.app", "/convertSheet");
// For Local testing
// final _functionUrl = Uri.http("127.0.0.1:5001", "/amt-v3/us-central1/convertSheet");

class CloudExcelParser implements ExcelParser {
  CloudExcelParser.fromFile(this.file);
  CloudExcelParser.fromBytes(this.bytes);

  @override
  List<int>? bytes;

  @override
  File? file;

  @override
  Future<Character?> parse() async {
    String base64;
    print("bytes $bytes");
    print("file $file");

    return Isolate.run(() async {
      try {
        if (bytes != null) {
          base64 = base64Encode(bytes!);
        } else {
          base64 = base64Encode(await file!.readAsBytes());
        }

        print("Encoded to b64 ${base64.length}");

        return await convertExcel(base64);
      } catch (e) {
        return null;
      }
    });
  }

  Future<Character> convertExcel(String base64) async {
    print("Sending to $_functionUrl");

    String body = '{"sheet": "$base64"}';

    final response = await http.post(_functionUrl, body: body, headers: {
      "Content-Type": "application/json",
      "Accept-Encoding": "gzip, deflate, br",
    });

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    print("time: " + json['time']);

    final character = json['sheet'];

    print("character: $character");

    return Character.fromJson(character);
  }
}
