import 'dart:convert';
import 'dart:io';

import 'package:amt/models/character/character.dart';
import 'package:amt/utils/excel_parser.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class _CloudExcelService {
  static const isDev = false;

  static Uri get getUri {
    if (isDev) {
      return Uri.http("127.0.0.1:5001", "/amt-v3/us-central1/convertSheet");
    } else {
      return Uri.https("convertsheet-y5zbymdrcq-uc.a.run.app", "/convertSheet");
    }
  }
}

class CloudExcelParser implements ExcelParser {
  CloudExcelParser.fromFile(this.file);
  CloudExcelParser.fromBytes(this.bytes);

  @override
  List<int>? bytes;

  @override
  File? file;

  @override
  Future<Character?> parse() async {
    bytes ??= await file!.readAsBytes();
    return await convertExcelFromBytes(bytes!);
  }

  Future<Character?> convertExcelFromBytes(List<int> bytes) async {
    final multipart = http.MultipartRequest("POST", _CloudExcelService.getUri);
    multipart.files.add(http.MultipartFile.fromBytes(
      "sheet",
      bytes,
      filename: "sheet",
      contentType: MediaType("application", "vnd.openxmlformats-officedocument.spreadsheetml.sheet"),
    ));

    final streamedResponse = await multipart.send();

    if (streamedResponse.statusCode != 200) {
      print("Failed! with error ${streamedResponse.statusCode}");
    } else {
      var response = await http.Response.fromStream(streamedResponse);

      final json = jsonDecode(response.body) as Map<String, dynamic>;

      final character = json['sheet'];

      return Character.fromJson(character);
    }

    return null;
  }
}