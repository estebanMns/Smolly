import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import '../models/player_model.dart';
import '../config/app_constants.dart';

class LocalStorageHelper {
  static Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/${AppConstants.fileGameProgress}');
  }

  static Future<File> _getPlayerFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/${AppConstants.filePlayerProfile}');
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
    // Fallback: check if we have a player profile saved
    final localPlayer = await loadPlayer();
    if (localPlayer != null) {
      return localPlayer.maxUnlockedLevel;
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

  static Future<PlayerModel?> loadPlayer() async {
    try {
      final file = await _getPlayerFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        final Map<String, dynamic> json = jsonDecode(content);
        return PlayerModel.fromJson(json);
      }
    } catch (e) {
      print('Error reading local player profile: $e');
    }
    return null;
  }

  static Future<void> savePlayer(PlayerModel player) async {
    try {
      final file = await _getPlayerFile();
      final content = jsonEncode(player.toJson());
      await file.writeAsString(content);
    } catch (e) {
      print('Error saving local player profile: $e');
    }
  }

  static Future<bool> hasSeenStory() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/seen_story.txt');
      if (await file.exists()) {
        final content = await file.readAsString();
        return content.trim() == 'true';
      }
    } catch (e) {
      print('Error reading seen_story file: $e');
    }
    return false;
  }

  static Future<void> setSeenStory(bool value) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/seen_story.txt');
      await file.writeAsString(value.toString());
    } catch (e) {
      print('Error saving seen_story file: $e');
    }
  }

  static Future<bool> hasSeenCap1() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/seen_cap1.txt');
      if (await file.exists()) {
        final content = await file.readAsString();
        return content.trim() == 'true';
      }
    } catch (e) {
      print('Error reading seen_cap1 file: $e');
    }
    return false;
  }

  static Future<void> setSeenCap1(bool value) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/seen_cap1.txt');
      await file.writeAsString(value.toString());
    } catch (e) {
      print('Error saving seen_cap1 file: $e');
    }
  }
}
