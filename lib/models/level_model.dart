class LevelModel {
  final int id;
  final String levelName;
  final List<TargetItem> targets;
  final double timeLimit;
  final bool isHard;
  final int itemsToCollect;
  final int coinsReward;
  final bool unlocksStory;
  final String cameraNotice;

  LevelModel({
    required this.id,
    required this.levelName,
    required this.targets,
    required this.timeLimit,
    required this.isHard,
    required this.itemsToCollect,
    required this.coinsReward,
    required this.unlocksStory,
    this.cameraNotice = "",
  });

  factory LevelModel.fromJson(Map<String, dynamic> json) {
    var rawTargets = json['targets'];
    List<TargetItem> targetList = [];
    if (rawTargets != null) {
      if (rawTargets is List) {
        targetList = rawTargets.map((e) {
          if (e is Map) {
            return TargetItem(
              targetObject: e['targetObject']?.toString() ?? e['target_object']?.toString() ?? '',
              displayName: e['displayName']?.toString() ?? e['display_name']?.toString() ?? '',
            );
          }
          return TargetItem(targetObject: e.toString(), displayName: e.toString());
        }).toList();
      }
    }
    return LevelModel(
      id: json['id'] as int,
      levelName: json['level_name'] ?? json['levelName'] ?? '',
      timeLimit: (json['time_limit'] ?? json['timeLimit'] as num?)?.toDouble() ?? 60.0,
      isHard: json['is_hard'] ?? json['isHard'] ?? false,
      itemsToCollect: json['items_to_collect'] ?? json['itemsToCollect'] ?? 3,
      coinsReward: json['coins_reward'] ?? json['coinsReward'] ?? 50,
      unlocksStory: json['unlocks_story'] ?? json['unlocksStory'] ?? false,
      cameraNotice: json['camera_notice'] ?? json['cameraNotice'] ?? '',
      targets: targetList,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'level_name': levelName,
    'time_limit': timeLimit,
    'is_hard': isHard,
    'items_to_collect': itemsToCollect,
    'coins_reward': coinsReward,
    'unlocks_story': unlocksStory,
    'camera_notice': cameraNotice,
    'targets': targets.map((t) => t.toJson()).toList(),
  };
}

class TargetItem {
  final String targetObject;
  final String displayName;

  TargetItem({required this.targetObject, required this.displayName});

  Map<String, dynamic> toJson() => {
    'targetObject': targetObject,
    'displayName': displayName,
  };
}
