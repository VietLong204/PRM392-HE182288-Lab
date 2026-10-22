import 'dart:io';
import 'package:path_provider/path_provider.dart';

class StorageService {
  static Future<File> getFile(String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$fileName');
  }

  static Future<String> read(String fileName) async {
    final file = await getFile(fileName);
    if (await file.exists()) {
      return await file.readAsString();
    }
    return '';
  }

  static Future<void> write(String fileName, String content) async {
    final file = await getFile(fileName);
    await file.writeAsString(content);
  }
}
