import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:amt/models/character_model/character.dart';
import 'package:amt/utils/excel_parser.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:logger/web.dart';

class _CloudExcelService {
  static const isDev = false;

  static Uri get getUri {
    if (isDev) {
      return Uri.http('127.0.0.1:5001', '/amt-v3/us-central1/convertSheet');
    } else {
      return Uri.https('aoalejo.pythonanywhere.com', '/api/v1/excelToJson');
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
    return parseWithBase64();
    // Don't use this code, the new provider is using only base64
    // bytes ??= await file!.readAsBytes();
    // return convertExcelFromBytes(bytes!);
  }

  Future<Character?> parseWithBase64() async {
    String base64;

    try {
      if (bytes != null) {
        base64 = base64Encode(bytes!);
      } else {
        base64 = base64Encode(await file!.readAsBytes());
      }

      return await convertExcelFrom(base64: base64);
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<Character?> convertExcelFrom({required String base64}) async {
    final body = '{"sheet": "$base64"}';

    final response = await http.post(
      _CloudExcelService.getUri,
      body: body,
      headers: {
        'Content-Type': 'application/json',
        'Accept': '*/*',
      },
    );

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    final character = json['sheet'];

    return Character.fromJson(character as Map<String, dynamic>);
  }

  Future<Character?> convertExcelFromBytes(List<int> bytes) async {
    final multipart = http.MultipartRequest('POST', _CloudExcelService.getUri);
    multipart.files.add(
      http.MultipartFile.fromBytes(
        'sheet',
        bytes,
        filename: 'sheet',
        contentType: MediaType('application', 'vnd.openxmlformats-officedocument.spreadsheetml.sheet'),
      ),
    );

    multipart.headers.addAll({
      'Accept': '*/*',
    });

    final streamedResponse = await multipart.send();

    if (streamedResponse.statusCode != 200) {
      Logger().d('Failed! with error ${streamedResponse.statusCode}');
    } else {
      final response = await http.Response.fromStream(streamedResponse);

      final json = jsonDecode(response.body) as Map<String, dynamic>;

      final character = json['sheet'] as Map<String, dynamic>;

      return Character.fromJson(character);
    }

    return null;
  }
}
