// Archivo: lib/components/player_profile_controller.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:juego_movil/models/player_model.dart';
import 'package:juego_movil/models/time_option_model.dart';
import 'package:juego_movil/auth/service/supabase_service.dart';
import 'package:juego_movil/auth/service/auth_services.dart';
import 'package:juego_movil/utils/local_storage_helper.dart';

class PlayerProfileController extends GetxController with GetSingleTickerProviderStateMixin {
  
  final SupabaseService _supabaseService = SupabaseService();
  final AuthServices _authServices = AuthServices();

  // --- ESTADO DEL JUGADOR ---
  final player = Rxn<PlayerModel>();
  final isLoading = true.obs;
  
  // Lista de avatares para el selector
  final availableAvatars = <String>[].obs;

  // --- ANIMACIONES DEL HUD ---
  late AnimationController pulseController;
  late Animation<double> orbitAnimation;

  @override
  void onInit() {
    super.onInit();
    
    // Inicialización inmediata de las animaciones para evitar errores de 'late'
    pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    orbitAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(pulseController);
    pulseController.repeat();

    _loadPlayerData();
    _loadAvailableAvatars();
  }

  // A set of claimed rewards to keep track locally
  final claimedRewards = <String>{}.obs;

  void _loadPlayerData() async {
    isLoading.value = true;
    
    try {
      final profileData = await _supabaseService.getUserProfile().timeout(
        const Duration(seconds: 5),
        onTimeout: () => null,
      );
      
      final int localMaxUnlocked = await LocalStorageHelper.getMaxUnlockedLevel();

      if (profileData != null) {
        String rawAvatar = profileData['avatar_url'] ?? '';
        // Si el avatar guardado no es una URL real ni un asset, usamos kovu por defecto
        String finalAvatar = (rawAvatar.startsWith('http') || rawAvatar.startsWith('assets/')) 
            ? rawAvatar 
            : 'assets/images/kovu.jpeg';

        player.value = PlayerModel(
          uid: profileData['id'] ?? 'u001',
          username: profileData['username'] ?? 'Usuario',
          avatarUrl: finalAvatar, 
          coins: profileData['coins'] ?? 0,
          level: profileData['level'] ?? 0,
          xp: profileData['xp'] ?? 0,
          xpToNextLevel: profileData['xp_to_next_level'] ?? 1000,
          rank: profileData['rank'] ?? 'RECLUTA',
          scanAccuracy: (profileData['scan_accuracy'] ?? 0.0).toDouble(),
          totalScans: profileData['total_scans'] ?? 0,
          dogsCollected: profileData['dogs_collected'] ?? 0,
          boosters30s: profileData['boosters_30s'] ?? 0,
          boosters1m: profileData['boosters_1m'] ?? 0,
          boosters2m: profileData['boosters_2m'] ?? 0,
          maxUnlockedLevel: profileData['max_unlocked_level'] ?? localMaxUnlocked,
        );
      } else {
        print("Aviso: No se encontró perfil para este usuario. Usando datos por defecto.");
        _setFallbackPlayerData(localMaxUnlocked);
      }
    } catch (e) {
      print("Error cargando perfil (posiblemente usuario nuevo): $e");
      final int localMaxUnlocked = await LocalStorageHelper.getMaxUnlockedLevel();
      _setFallbackPlayerData(localMaxUnlocked);
    } finally {
      isLoading.value = false;
    }
  }

  void _setFallbackPlayerData(int localMaxUnlocked) {
    player.value = PlayerModel(
      uid: 'u001',
      username: 'Perro Blanco',
      avatarUrl: 'assets/images/kovu.jpeg',
      coins: 0,
      level: 0,
      xp: 0,
      xpToNextLevel: 1000,
      rank: 'COMANDANTE GALÁCTICO',
      scanAccuracy: 0,
      totalScans: 0,
      dogsCollected: 0,
      boosters30s: 0,
      boosters1m: 0,
      boosters2m: 0,
      maxUnlockedLevel: localMaxUnlocked,
    );
  }

  void _loadAvailableAvatars() async {
    print("Iniciando carga de avatares disponibles...");
    try {
      final urls = await _supabaseService.getAvailableAvatars();
      print("Avatares cargados desde servicio: ${urls.length}");
      if (urls.isEmpty) {
        availableAvatars.assignAll([
          'assets/images/kovu.jpeg',
          'assets/images/molly.jpeg',
          'assets/images/horus.jpeg',
          'assets/images/iker.jpeg',
          'assets/images/perroblanco.png',
        ]);
      } else {
        availableAvatars.assignAll(urls);
      }
    } catch (e) {
      print("Error cargando avatares en el controlador: $e");
      availableAvatars.assignAll([
        'assets/images/kovu.jpeg',
        'assets/images/molly.jpeg',
        'assets/images/horus.jpeg',
        'assets/images/iker.jpeg',
        'assets/images/perroblanco.png',
      ]);
    }
  }

  bool deductCoins(int amount) {
    if (player.value == null) return false;
    final currentCoins = player.value!.coins;
    if (currentCoins < amount) return false;

    final updatedPlayer = player.value!.copyWith(
      coins: currentCoins - amount,
    );

    player.value = updatedPlayer;
    _supabaseService.updateGameStats(updatedPlayer);
    return true;
  }

  void addCoins(int amount) {
    if (player.value == null) return;
    final updatedPlayer = player.value!.copyWith(
      coins: player.value!.coins + amount,
    );
    player.value = updatedPlayer;
    _supabaseService.updateGameStats(updatedPlayer);
  }

  void addXp(int amount) {
    if (player.value == null) return;
    final p = player.value!;
    int newXp = p.xp + amount;
    int newLevel = p.level;
    int currentXpToNext = p.xpToNextLevel;
    
    while (newXp >= currentXpToNext) {
      newLevel++;
      newXp -= currentXpToNext;
      currentXpToNext += 500;
    }
    
    final updatedPlayer = p.copyWith(
      level: newLevel,
      xp: newXp,
      xpToNextLevel: currentXpToNext,
    );
    player.value = updatedPlayer;
    _supabaseService.updateGameStats(updatedPlayer);
  }

  void claimReward(String rewardId, {int coins = 0, int xp = 0}) {
    if (claimedRewards.contains(rewardId)) {
      Get.snackbar(
        'Ya reclamado',
        'Ya has reclamado esta recompensa.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
      return;
    }
    
    claimedRewards.add(rewardId);
    if (coins > 0) addCoins(coins);
    if (xp > 0) addXp(xp);
    
    Get.snackbar(
      '¡Enhorabuena!',
      'Has reclamado tu recompensa con éxito.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withValues(alpha: 0.8),
      colorText: Colors.white,
    );
  }

  // --- COMPRA Y USO DE POTENCIADORES ---

  bool buyBooster(TimeOption option) {
    if (player.value == null) return false;
    final currentCoins = player.value!.coins;
    if (currentCoins < option.coinCost) return false;

    int extra30s = option.type == '30s' ? 1 : 0;
    int extra1m = option.type == '1m' ? 1 : 0;
    int extra2m = option.type == '2m' ? 1 : 0;

    final updatedPlayer = player.value!.copyWith(
      coins: currentCoins - option.coinCost,
      boosters30s: player.value!.boosters30s + extra30s,
      boosters1m: player.value!.boosters1m + extra1m,
      boosters2m: player.value!.boosters2m + extra2m,
    );

    player.value = updatedPlayer;
    _supabaseService.updateGameStats(updatedPlayer);
    return true;
  }

  bool consumeBooster(String type) {
    if (player.value == null) return false;
    final p = player.value!;

    if (type == '30s' && p.boosters30s > 0) {
      final updated = p.copyWith(boosters30s: p.boosters30s - 1);
      player.value = updated;
      _supabaseService.updateGameStats(updated);
      return true;
    } else if (type == '1m' && p.boosters1m > 0) {
      final updated = p.copyWith(boosters1m: p.boosters1m - 1);
      player.value = updated;
      _supabaseService.updateGameStats(updated);
      return true;
    } else if (type == '2m' && p.boosters2m > 0) {
      final updated = p.copyWith(boosters2m: p.boosters2m - 1);
      player.value = updated;
      _supabaseService.updateGameStats(updated);
      return true;
    }
    return false;
  }

  // --- MÉTODOS DE ACCIÓN AVATAR / USERNAME ---
  
  Future<void> updateAvatar(String newUrl) async {
    if (player.value == null) return;

    try {
      await _supabaseService.updateUserAvatar(newUrl);
      
      final updatedPlayer = player.value!.copyWith(
        avatarUrl: newUrl,
      );
      player.value = updatedPlayer;
      
      if (Get.isBottomSheetOpen ?? false) Get.back(); 
      
      Get.snackbar('Éxito', '¡Avatar actualizado correctamente!', 
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      print("Error al actualizar avatar: $e");
    }
  }

  Future<void> updateUsername(String newName) async {
    if (newName.isEmpty || player.value == null) return;

    try {
      await _supabaseService.updateUsername(newName);
      
      final updatedPlayer = player.value!.copyWith(
        username: newName,
      );
      player.value = updatedPlayer;

      Get.snackbar('Éxito', '¡Nombre de usuario actualizado!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      print("Error en updateUsername: $e");
      Get.snackbar('Error', 'No se pudo actualizar el nombre: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    }
  }

  Future<void> logout() async {
    try {
      await _authServices.signOut();
      Get.offAllNamed('/home');
    } catch (e) {
      print("Error al cerrar sesión: $e");
      Get.snackbar('Error', 'No se pudo cerrar sesión');
    }
  }

  void refreshStats() {
    _loadPlayerData();
  }

  Future<String?> processGameResult({
    required int score,
    required int coinsEarned,
    required int objectsScanned,
    required bool isVictory,
    int? levelId,
  }) async {
    while (isLoading.value) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    if (player.value == null) {
      print("Error: processGameResult falló porque el jugador es null");
      return null;
    }

    final p = player.value!;

    // Calcular nuevas monedas y XP
    final newCoins = p.coins + coinsEarned;
    int newXp = p.xp + score;

    // Calcular subida de nivel
    int newLevel = p.level;
    int currentXpToNext = p.xpToNextLevel;
    
    while (newXp >= currentXpToNext) {
      newLevel++;
      newXp -= currentXpToNext;
      currentXpToNext += 500;
    }

    final newTotalScans = p.totalScans + objectsScanned;
    final newDogsCollected = p.dogsCollected + (isVictory ? 1 : 0);
    final newAccuracy = newTotalScans > 0 ? ((p.scanAccuracy * p.totalScans) + objectsScanned) / newTotalScans : p.scanAccuracy;

    // Conceder potenciador aleatorio si hay victoria
    String? earnedBooster;
    int extra30s = 0;
    int extra1m = 0;
    int extra2m = 0;

    if (isVictory) {
      final rand = Random().nextDouble();
      if (rand < 0.50) {
        earnedBooster = '30s';
        extra30s = 1;
      } else if (rand < 0.80) {
        earnedBooster = '1m';
        extra1m = 1;
      } else {
        earnedBooster = '2m';
        extra2m = 1;
      }
    }

    // Calcular nuevo nivel máximo desbloqueado
    int newMaxUnlockedLevel = p.maxUnlockedLevel;
    if (isVictory && levelId != null && levelId >= p.maxUnlockedLevel) {
      newMaxUnlockedLevel = levelId + 1;
      // Guardar localmente
      await LocalStorageHelper.saveMaxUnlockedLevel(newMaxUnlockedLevel);
    }

    final updatedPlayer = PlayerModel(
      uid: p.uid,
      username: p.username,
      avatarUrl: p.avatarUrl,
      coins: newCoins,
      level: newLevel,
      xp: newXp,
      xpToNextLevel: currentXpToNext,
      rank: p.rank,
      scanAccuracy: newAccuracy,
      totalScans: newTotalScans,
      dogsCollected: newDogsCollected,
      boosters30s: p.boosters30s + extra30s,
      boosters1m: p.boosters1m + extra1m,
      boosters2m: p.boosters2m + extra2m,
      maxUnlockedLevel: newMaxUnlockedLevel,
    );

    // Actualizar estado local
    player.value = updatedPlayer;

    // Persistir en Supabase
    await _supabaseService.updateGameStats(updatedPlayer);

    return earnedBooster;
  }

  double get xpProgress => (player.value?.xp ?? 0) / (player.value?.xpToNextLevel ?? 1);

  @override
  void onClose() {
    pulseController.dispose(); 
    super.onClose();
  }
}