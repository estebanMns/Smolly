import 'package:get/get.dart';
import '../models/level_model.dart';

class FallbackLevelData {
  static const List<int> storyUnlockLevelIds = [1, 4, 8, 12, 17, 20, 21];

  static LevelModel getFallbackLevel(int id) {
    final bool hasStory = storyUnlockLevelIds.contains(id);
    List<TargetItem> targets;
    double limit = 60.0;
    String name;

    if (id == 0) {
      name = 'molly_tutorial'.tr;
      targets = [TargetItem(targetObject: "dog", displayName: 'molly_tutorial'.tr)];
      limit = 120.0;
    } else if (id == 1) {
      name = 'game_ball'.tr;
      targets = [
        TargetItem(targetObject: "sports ball", displayName: 'game_ball'.tr),
        TargetItem(targetObject: "bottle", displayName: 'water_bottle'.tr),
        TargetItem(targetObject: "cup", displayName: 'coffee_cup'.tr),
      ];
    } else if (id == 2) {
      name = 'food_bowl'.tr;
      targets = [
        TargetItem(targetObject: "bowl", displayName: 'food_bowl'.tr),
        TargetItem(targetObject: "book", displayName: 'book'.tr),
        TargetItem(targetObject: "keyboard", displayName: 'keyboard'.tr),
      ];
      limit = 75.0;
    } else if (id == 3) {
      name = 'water_bottle'.tr;
      targets = [
        TargetItem(targetObject: "bottle", displayName: 'water_bottle'.tr),
        TargetItem(targetObject: "cell phone", displayName: 'cell_phone'.tr),
        TargetItem(targetObject: "mouse", displayName: 'mouse'.tr),
      ];
      limit = 50.0;
    } else if (id == 4) {
      name = 'coffee_cup'.tr;
      targets = [
        TargetItem(targetObject: "cup", displayName: 'coffee_cup'.tr),
        TargetItem(targetObject: "laptop", displayName: 'laptop'.tr),
        TargetItem(targetObject: "chair", displayName: 'chair'.tr),
      ];
      limit = 45.0;
    } else if (id == 21) {
      name = 'Nivel extra 21';
      targets = [
        TargetItem(targetObject: "person", displayName: 'human'.tr),
        TargetItem(targetObject: "tv", displayName: 'tv'.tr),
        TargetItem(targetObject: "backpack", displayName: 'backpack'.tr),
      ];
      limit = 35.0;
    } else {
      name = '${'level'.tr} $id';
      targets = [
        TargetItem(targetObject: "person", displayName: 'human'.tr),
        TargetItem(targetObject: "tv", displayName: 'tv'.tr),
        TargetItem(targetObject: "backpack", displayName: 'backpack'.tr),
      ];
      limit = (60 - id).clamp(20, 60).toDouble();
    }

    return LevelModel(
      id: id,
      levelName: name,
      targets: targets,
      timeLimit: limit,
      isHard: id % 5 == 0,
      itemsToCollect: 4 + (id % 3),
      coinsReward: 50 + (id * 10),
      unlocksStory: hasStory,
      cameraNotice: "",
    );
  }
}
