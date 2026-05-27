// Ubicación: lib/models/player_model.dart
// =====================================================================================================================================================
import '../config/app_constants.dart';

class PlayerModel {
  final String uid;
  final String username;
  final String avatarUrl;
  final int coins;
  final int level;
  final int xp;
  final int xpToNextLevel;
  final String rank;
  final double scanAccuracy;
  final int totalScans;
  final int dogsCollected;
  final int boosters30s;
  final int boosters1m;
  final int boosters2m;
  final int maxUnlockedLevel;
  final Set<String> unlockedAchievements;

  const PlayerModel({
    required this.uid,
    required this.username,
    required this.avatarUrl,
    required this.coins,
    required this.level,
    required this.xp,
    required this.xpToNextLevel,
    required this.rank,
    required this.scanAccuracy,
    required this.totalScans,
    required this.dogsCollected,
    this.boosters30s = 0,
    this.boosters1m = 0,
    this.boosters2m = 0,
    this.maxUnlockedLevel = 1,
    this.unlockedAchievements = const {},
  });

  PlayerModel copyWith({
    String? uid,
    String? username,
    String? avatarUrl,
    int? coins,
    int? level,
    int? xp,
    int? xpToNextLevel,
    String? rank,
    double? scanAccuracy,
    int? totalScans,
    int? dogsCollected,
    int? boosters30s,
    int? boosters1m,
    int? boosters2m,
    int? maxUnlockedLevel,
    Set<String>? unlockedAchievements,
  }) {
    return PlayerModel(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      coins: coins ?? this.coins,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      xpToNextLevel: xpToNextLevel ?? this.xpToNextLevel,
      rank: rank ?? this.rank,
      scanAccuracy: scanAccuracy ?? this.scanAccuracy,
      totalScans: totalScans ?? this.totalScans,
      dogsCollected: dogsCollected ?? this.dogsCollected,
      boosters30s: boosters30s ?? this.boosters30s,
      boosters1m: boosters1m ?? this.boosters1m,
      boosters2m: boosters2m ?? this.boosters2m,
      maxUnlockedLevel: maxUnlockedLevel ?? this.maxUnlockedLevel,
      unlockedAchievements: unlockedAchievements ?? this.unlockedAchievements,
    );
  }

  factory PlayerModel.fromJson(Map<String, dynamic> json) => PlayerModel(
        uid: json['uid'] as String,
        username: json['username'] as String,
        avatarUrl: json['avatarUrl'] as String,
        coins: json['coins'] as int,
        level: json['level'] as int,
        xp: json['xp'] as int,
        xpToNextLevel: json['xpToNextLevel'] as int,
        rank: json['rank'] as String,
        scanAccuracy: (json['scanAccuracy'] as num).toDouble(),
        totalScans: json['totalScans'] as int,
        dogsCollected: json['dogsCollected'] as int,
        boosters30s: json['boosters30s'] as int? ?? 0,
        boosters1m: json['boosters1m'] as int? ?? 0,
        boosters2m: json['boosters2m'] as int? ?? 0,
        maxUnlockedLevel: json['maxUnlockedLevel'] as int? ?? 1,
        unlockedAchievements: json['unlockedAchievements'] != null
            ? Set<String>.from(json['unlockedAchievements'] as List<dynamic>)
            : const {},
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'username': username,
        'avatarUrl': avatarUrl,
        'coins': coins,
        'level': level,
        'xp': xp,
        'xpToNextLevel': xpToNextLevel,
        'rank': rank,
        'scanAccuracy': scanAccuracy,
        'totalScans': totalScans,
        'dogsCollected': dogsCollected,
        'boosters30s': boosters30s,
        'boosters1m': boosters1m,
        'boosters2m': boosters2m,
        'maxUnlockedLevel': maxUnlockedLevel,
        'unlockedAchievements': unlockedAchievements.toList(),
      };

  // --- MÉTODOS ORIENTADOS A OBJETOS (LOGICA DE DOMINIO) ---

  PlayerModel addExperience(int amount) {
    int newXp = xp + amount;
    int newLevel = level;
    int currentXpToNext = xpToNextLevel;

    while (newXp >= currentXpToNext) {
      newLevel++;
      newXp -= currentXpToNext;
      currentXpToNext += AppConstants.xpIncreasePerLevel;
    }

    return copyWith(
      level: newLevel,
      xp: newXp,
      xpToNextLevel: currentXpToNext,
    );
  }

  PlayerModel? buyBooster(int cost, String type) {
    if (coins < cost) return null;

    int extra30s = type == '30s' ? 1 : 0;
    int extra1m = type == '1m' ? 1 : 0;
    int extra2m = type == '2m' ? 1 : 0;

    return copyWith(
      coins: coins - cost,
      boosters30s: boosters30s + extra30s,
      boosters1m: boosters1m + extra1m,
      boosters2m: boosters2m + extra2m,
    );
  }

  PlayerModel? consumeBooster(String type) {
    if (type == '30s' && boosters30s > 0) {
      return copyWith(boosters30s: boosters30s - 1);
    } else if (type == '1m' && boosters1m > 0) {
      return copyWith(boosters1m: boosters1m - 1);
    } else if (type == '2m' && boosters2m > 0) {
      return copyWith(boosters2m: boosters2m - 1);
    }
    return null;
  }

  PlayerModel applyGameResult({
    required int score,
    required int coinsEarned,
    required int objectsScanned,
    required bool isVictory,
    required int newMaxUnlockedLevel,
    int extra30s = 0,
    int extra1m = 0,
    int extra2m = 0,
  }) {
    final int newCoins = coins + coinsEarned;
    final int newTotalScans = totalScans + objectsScanned;
    final int newDogsCollected = dogsCollected + (isVictory ? 1 : 0);
    final double newAccuracy = newTotalScans > 0 
        ? ((scanAccuracy * totalScans) + objectsScanned) / newTotalScans 
        : scanAccuracy;

    // Calcular la experiencia agregada
    final updatedXpPlayer = addExperience(score);

    return updatedXpPlayer.copyWith(
      coins: newCoins,
      totalScans: newTotalScans,
      dogsCollected: newDogsCollected,
      scanAccuracy: newAccuracy,
      boosters30s: boosters30s + extra30s,
      boosters1m: boosters1m + extra1m,
      boosters2m: boosters2m + extra2m,
      maxUnlockedLevel: newMaxUnlockedLevel,
    );
  }
}
