import 'dart:io';
import 'package:path_provider/path_provider.dart';

class StorageService {
  static Future<File> _getFile(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$fileName');
  }

  static Future<String> readJson(String fileName) async {
    try {
      final file = await _getFile(fileName);
      if (await file.exists()) {
        return await file.readAsString();
      }
      return '';
    } catch (e) {
      return '';
    }
  }

  static Future<void> writeJson(String fileName, String content) async {
    final file = await _getFile(fileName);
    await file.writeAsString(content);
  }
}
