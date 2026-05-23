import 'package:get/get.dart';
import '../models/level_model.dart';
import '../auth/service/supabase_service.dart';
import '../config/fallback_level_data.dart';

class LevelsController extends GetxController {
  static LevelsController get to => Get.find();

  final SupabaseService _supabaseService = SupabaseService();
  final levels = <LevelModel>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadLevels();
  }

  Future<void> loadLevels() async {
    isLoading.value = true;
    try {
      final data = await _supabaseService.fetchLevels();
      levels.assignAll(data.map((json) => LevelModel.fromJson(json)).toList());
    } catch (e) {
      print('Error loading levels: $e');
    } finally {
      isLoading.value = false;
    }
  }

  LevelModel getLevel(int id) {
    final original = levels.firstWhere(
      (l) => l.id == id,
      orElse: () => _getFallbackLevel(id),
    );
    final hasStory = const [1, 4, 8, 12, 17, 20, 21].contains(id);
    return LevelModel(
      id: original.id,
      levelName: original.levelName,
      targets: original.targets,
      timeLimit: original.timeLimit,
      isHard: original.isHard,
      itemsToCollect: original.itemsToCollect,
      coinsReward: original.coinsReward,
      unlocksStory: hasStory,
      cameraNotice: original.cameraNotice,
    );
  }

  LevelModel _getFallbackLevel(int id) {
    return FallbackLevelData.getFallbackLevel(id);
  }
}
