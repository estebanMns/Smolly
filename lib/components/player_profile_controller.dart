// Archivo: lib/components/player_profile_controller.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:juego_movil/models/player_model.dart';
import 'package:juego_movil/models/time_option_model.dart';
import 'package:juego_movil/auth/service/supabase_service.dart';
import 'package:juego_movil/auth/service/auth_services.dart';
import 'package:juego_movil/utils/local_storage_helper.dart';
import 'package:juego_movil/config/app_constants.dart';
import 'package:juego_movil/config/app_assets.dart';

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
      final localPlayer = await LocalStorageHelper.loadPlayer();
      final int localMaxUnlocked = await LocalStorageHelper.getMaxUnlockedLevel();

      final profileData = await _supabaseService.getUserProfile().timeout(
        const Duration(seconds: 5),
        onTimeout: () => null,
      );
      
      if (profileData != null) {
        String rawAvatar = profileData['avatar_url'] ?? '';
        // Si el avatar guardado no es una URL real ni un asset, usamos kovu por defecto
        String finalAvatar = (rawAvatar.startsWith('http') || rawAvatar.startsWith('assets/')) 
            ? rawAvatar 
            : AppAssets.fallbackAvatarUrl;

        final supabasePlayer = PlayerModel(
          uid: profileData['id'] ?? AppConstants.defaultPlayerUid,
          username: profileData['username'] ?? 'Usuario',
          avatarUrl: finalAvatar, 
          coins: profileData['coins'] ?? 0,
          level: profileData['level'] ?? 0,
          xp: profileData['xp'] ?? 0,
          xpToNextLevel: profileData['xp_to_next_level'] ?? AppConstants.defaultXpToNextLevel,
          rank: profileData['rank'] ?? 'RECLUTA',
          scanAccuracy: (profileData['scan_accuracy'] ?? 0.0).toDouble(),
          totalScans: profileData['total_scans'] ?? 0,
          dogsCollected: profileData['dogs_collected'] ?? 0,
          boosters30s: profileData['boosters_30s'] ?? 0,
          boosters1m: profileData['boosters_1m'] ?? 0,
          boosters2m: profileData['boosters_2m'] ?? 0,
          maxUnlockedLevel: profileData['max_unlocked_level'] ?? localMaxUnlocked,
        );

        PlayerModel chosenPlayer = supabasePlayer;

        // Si tenemos datos locales del mismo usuario, o si es la primera migración desde la cuenta local temporal 'u001'
        if (localPlayer != null && (localPlayer.uid == 'u001' || localPlayer.uid == supabasePlayer.uid)) {
          bool isLocalBetter = false;
          if (localPlayer.maxUnlockedLevel > supabasePlayer.maxUnlockedLevel) {
            isLocalBetter = true;
          } else if (localPlayer.maxUnlockedLevel == supabasePlayer.maxUnlockedLevel) {
            if (localPlayer.level > supabasePlayer.level) {
              isLocalBetter = true;
            } else if (localPlayer.level == supabasePlayer.level) {
              if (localPlayer.xp > supabasePlayer.xp) {
                isLocalBetter = true;
              } else if (localPlayer.xp == supabasePlayer.xp) {
                if (localPlayer.coins > supabasePlayer.coins) {
                  isLocalBetter = true;
                }
              }
            }
          }

          if (isLocalBetter) {
            chosenPlayer = localPlayer.copyWith(
              uid: supabasePlayer.uid, // Asegurarnos de usar la UID de Supabase
              username: (supabasePlayer.username.isNotEmpty && supabasePlayer.username != AppConstants.defaultPlayerUsername)
                  ? supabasePlayer.username 
                  : localPlayer.username,
              avatarUrl: (supabasePlayer.avatarUrl.isNotEmpty && supabasePlayer.avatarUrl != AppAssets.fallbackAvatarUrl)
                  ? supabasePlayer.avatarUrl 
                  : localPlayer.avatarUrl,
            );
            // Sincronizamos inmediatamente a Supabase
            await _supabaseService.updateGameStats(chosenPlayer);
          }
        }

        player.value = chosenPlayer;
        await LocalStorageHelper.savePlayer(chosenPlayer);
        await LocalStorageHelper.saveMaxUnlockedLevel(chosenPlayer.maxUnlockedLevel);
      } else {
        print("Aviso: No se encontró perfil para este usuario o la petición expiró. Cargando datos locales.");
        if (localPlayer != null) {
          player.value = localPlayer;
        } else {
          _setFallbackPlayerData(localMaxUnlocked);
        }
      }
    } catch (e) {
      print("Error cargando perfil: $e. Intentando cargar datos locales.");
      final localPlayer = await LocalStorageHelper.loadPlayer();
      if (localPlayer != null) {
        player.value = localPlayer;
      } else {
        final int localMaxUnlocked = await LocalStorageHelper.getMaxUnlockedLevel();
        _setFallbackPlayerData(localMaxUnlocked);
      }
    } finally {
      isLoading.value = false;
    }
  }

  void _setFallbackPlayerData(int localMaxUnlocked) {
    player.value = PlayerModel(
      uid: AppConstants.defaultPlayerUid,
      username: AppConstants.defaultPlayerUsername,
      avatarUrl: AppAssets.fallbackAvatarUrl,
      coins: 0,
      level: 0,
      xp: 0,
      xpToNextLevel: AppConstants.defaultXpToNextLevel,
      rank: AppConstants.defaultPlayerRank,
      scanAccuracy: 0,
      totalScans: 0,
      dogsCollected: 0,
      boosters30s: 0,
      boosters1m: 0,
      boosters2m: 0,
      maxUnlockedLevel: localMaxUnlocked,
    );
    LocalStorageHelper.savePlayer(player.value!);
  }

  void _loadAvailableAvatars() async {
    print("Iniciando carga de avatares disponibles...");
    try {
      final urls = await _supabaseService.getAvailableAvatars();
      print("Avatares cargados desde servicio: ${urls.length}");
      if (urls.isEmpty) {
        availableAvatars.assignAll([
          AppAssets.avatarKovu,
          AppAssets.avatarMolly,
          AppAssets.avatarHorus,
          AppAssets.avatarIker,
          AppAssets.avatarPerroBlanco,
        ]);
      } else {
        availableAvatars.assignAll(urls);
      }
    } catch (e) {
      print("Error cargando avatares en el controlador: $e");
      availableAvatars.assignAll([
        AppAssets.avatarKovu,
        AppAssets.avatarMolly,
        AppAssets.avatarHorus,
        AppAssets.avatarIker,
        AppAssets.avatarPerroBlanco,
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
    LocalStorageHelper.savePlayer(updatedPlayer);
    _supabaseService.updateGameStats(updatedPlayer);
    return true;
  }

  void addCoins(int amount) {
    if (player.value == null) return;
    final updatedPlayer = player.value!.copyWith(
      coins: player.value!.coins + amount,
    );
    player.value = updatedPlayer;
    LocalStorageHelper.savePlayer(updatedPlayer);
    _supabaseService.updateGameStats(updatedPlayer);
  }

  void addXp(int amount) {
    if (player.value == null) return;
    final updatedPlayer = player.value!.addExperience(amount);
    player.value = updatedPlayer;
    LocalStorageHelper.savePlayer(updatedPlayer);
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
    final updatedPlayer = player.value!.buyBooster(option.coinCost, option.type);
    if (updatedPlayer == null) return false;

    player.value = updatedPlayer;
    LocalStorageHelper.savePlayer(updatedPlayer);
    _supabaseService.updateGameStats(updatedPlayer);
    return true;
  }

  bool consumeBooster(String type) {
    if (player.value == null) return false;
    final updatedPlayer = player.value!.consumeBooster(type);
    if (updatedPlayer == null) return false;

    player.value = updatedPlayer;
    LocalStorageHelper.savePlayer(updatedPlayer);
    _supabaseService.updateGameStats(updatedPlayer);
    return true;
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
      LocalStorageHelper.savePlayer(updatedPlayer);
      
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
      LocalStorageHelper.savePlayer(updatedPlayer);

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
      Get.delete<PlayerProfileController>();
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

    // Calcular nuevo nivel máximo desbloqueado
    int newMaxUnlockedLevel = p.maxUnlockedLevel;
    if (isVictory && levelId != null && levelId >= p.maxUnlockedLevel) {
      newMaxUnlockedLevel = levelId + 1;
      // Guardar localmente
      await LocalStorageHelper.saveMaxUnlockedLevel(newMaxUnlockedLevel);
    }

    int extra30s = 0;
    int extra1m = 0;
    int extra2m = 0;
    String? earnedBooster;

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

    final updatedPlayer = p.applyGameResult(
      score: score,
      coinsEarned: coinsEarned,
      objectsScanned: objectsScanned,
      isVictory: isVictory,
      newMaxUnlockedLevel: newMaxUnlockedLevel,
      extra30s: extra30s,
      extra1m: extra1m,
      extra2m: extra2m,
    );

    // Actualizar estado local
    player.value = updatedPlayer;
    await LocalStorageHelper.savePlayer(updatedPlayer);

    // Persistir en Supabase
    await _supabaseService.updateGameStats(updatedPlayer);

    return earnedBooster;
  }

  Future<bool> resetGameProgress() async {
    if (player.value == null) return false;
    try {
      final resetPlayer = PlayerModel(
        uid: player.value!.uid,
        username: player.value!.username,
        avatarUrl: AppAssets.fallbackAvatarUrl,
        coins: 0,
        level: 0,
        xp: 0,
        xpToNextLevel: AppConstants.defaultXpToNextLevel,
        rank: AppConstants.defaultPlayerRank,
        scanAccuracy: 0.0,
        totalScans: 0,
        dogsCollected: 0,
        boosters30s: 0,
        boosters1m: 0,
        boosters2m: 0,
        maxUnlockedLevel: 1,
      );

      await LocalStorageHelper.savePlayer(resetPlayer);
      await LocalStorageHelper.saveMaxUnlockedLevel(1);
      await _supabaseService.updateGameStats(resetPlayer);

      player.value = resetPlayer;
      return true;
    } catch (e) {
      print("Error resetting game progress: $e");
      return false;
    }
  }

  double get xpProgress => (player.value?.xp ?? 0) / (player.value?.xpToNextLevel ?? 1);

  @override
  void onClose() {
    pulseController.dispose(); 
    super.onClose();
  }
}