import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import '../components/settings_controller.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  final SettingsController _settingsController = Get.find<SettingsController>();

  Future<void> play(String assetPath, {bool loop = false}) async {
    if (!_settingsController.isSoundOn.value) return;
    
    await _audioPlayer.setReleaseMode(loop ? ReleaseMode.loop : ReleaseMode.stop);
    await _audioPlayer.play(AssetSource(assetPath));
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> resume() async {
    if (!_settingsController.isSoundOn.value) return;
    await _audioPlayer.resume();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
}
