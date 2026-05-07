// Archivo: lib/components/player_profile_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Importaciones optimizadas
import 'package:juego_movil/models/player_model.dart';
import 'package:juego_movil/auth/service/supabase_service.dart';

class PlayerProfileController extends GetxController with GetSingleTickerProviderStateMixin {
  
  final SupabaseService _supabaseService = SupabaseService();

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

  void _loadPlayerData() async {
    isLoading.value = true;
    
    try {
      final profileData = await _supabaseService.getUserProfile().timeout(
        const Duration(seconds: 5),
        onTimeout: () => null,
      );
      
      if (profileData != null) {
        String rawAvatar = profileData['avatar_url'] ?? '';
        // Si el avatar guardado no es una URL real, usamos kobu por defecto
        String finalAvatar = rawAvatar.startsWith('http') 
            ? rawAvatar 
            : 'https://tvjdkuitdsmqiyymzjto.supabase.co/storage/v1/object/public/avatares/kobu.jpeg';

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
        );
      } else {
        print("Aviso: No se encontró perfil para este usuario. Usando datos por defecto.");
        _setFallbackPlayerData();
      }
    } catch (e) {
      print("Error cargando perfil (posiblemente usuario nuevo): $e");
      _setFallbackPlayerData();
    } finally {
      isLoading.value = false;
    }
  }

  void _setFallbackPlayerData() {
    player.value = const PlayerModel(
      uid: 'u001',
      username: 'Perro Blanco',
      avatarUrl: 'https://tvjdkuitdsmqiyymzjto.supabase.co/storage/v1/object/public/avatares/kobu.jpeg',
      coins: 0,
      level: 0,
      xp: 0,
      xpToNextLevel: 1000,
      rank: 'COMANDANTE GALÁCTICO',
      scanAccuracy: 0,
      totalScans: 0,
      dogsCollected: 0,
    );
  }

  void _loadAvailableAvatars() async {
    print("Iniciando carga de avatares disponibles...");
    try {
      final urls = await _supabaseService.getAvailableAvatars();
      print("Avatares cargados desde servicio: ${urls.length}");
      for (var url in urls) {
        print("URL disponible: $url");
      }
      availableAvatars.assignAll(urls);
    } catch (e) {
      print("Error cargando avatares en el controlador: $e");
    }
  }

  // --- MÉTODOS DE ACCIÓN ---
  
  Future<void> updateAvatar(String newUrl) async {
    print("Intentando cambiar avatar a: $newUrl");
    if (player.value == null) {
      print("Error: El jugador es nulo");
      return;
    }

    try {
      // 1. Actualizar en Supabase
      await _supabaseService.updateUserAvatar(newUrl);
      print("Avatar actualizado en Supabase");
      
      // 2. Actualizar estado local para UI instantánea
      final p = player.value!;
      player.value = PlayerModel(
        uid: p.uid,
        username: p.username,
        avatarUrl: newUrl,
        coins: p.coins,
        level: p.level,
        xp: p.xp,
        xpToNextLevel: p.xpToNextLevel,
        rank: p.rank,
        scanAccuracy: p.scanAccuracy,
        totalScans: p.totalScans,
        dogsCollected: p.dogsCollected,
      );
      
      if (Get.isBottomSheetOpen ?? false) Get.back(); 
      
      Get.snackbar('Éxito', '¡Avatar actualizado correctamente!', 
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      print("Error en updateAvatar: $e");
      Get.snackbar('Error', 'No se pudo actualizar el avatar: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    }
  }

  void refreshStats() {
    _loadPlayerData();
  }

  double get xpProgress => (player.value?.xp ?? 0) / (player.value?.xpToNextLevel ?? 1);

  @override
  void onClose() {
    pulseController.dispose(); 
    super.onClose();
  }
}