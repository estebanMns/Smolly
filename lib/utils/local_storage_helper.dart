import 'dart:io';
import 'package:path_provider/path_provider.dart';

class LocalStorageHelper {
  static Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/game_progress.json');
  }

  static Future<int> getMaxUnlockedLevel() async {
    try {
      final file = await _getLocalFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        return int.tryParse(content) ?? 1;
      }
    } catch (e) {
      print('Error reading local max unlocked level: $e');
    }
    return 1;
  }

  static Future<void> saveMaxUnlockedLevel(int level) async {
    try {
      final file = await _getLocalFile();
      await file.writeAsString(level.toString());
    } catch (e) {
      print('Error saving local max unlocked level: $e');
    }
  }
}
