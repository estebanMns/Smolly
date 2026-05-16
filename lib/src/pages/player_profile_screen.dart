import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:juego_movil/config/app_colors.dart';
import 'package:juego_movil/components/player_profile_controller.dart';
import 'package:juego_movil/components/avatar_picker_sheet.dart';
import 'package:juego_movil/components/player_top_bar.dart';
import 'package:juego_movil/components/player_galaxy_background.dart';
import 'package:juego_movil/components/player_stats_widgets.dart';

class PlayerProfileScreen extends StatelessWidget {
  const PlayerProfileScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PlayerProfileController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── 1. Imagen de fondo principal ────────────────────────────
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/fondoperroblanco.png'),
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
          ),

          // ── 2. Fondo galáctico animado ──────────────────────────────
          PlayerGalaxyBackground(controller: controller),

          // ── 3. Contenido principal ──────────────────────────────────
          SafeArea(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.cyan),
                );
              }

              if (controller.player.value == null) {
                return const Center(
                  child: Text('Error al cargar datos del jugador', style: TextStyle(color: Colors.white)),
                );
              }

              final p = controller.player.value!;

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // Barra superior: retroceso, monedas, compartir
                    const PlayerTopBar(),

                    const SizedBox(height: 40),

                    // Avatar con anillo y badge de nivel
                    PlayerAvatar(
                      avatarUrl: p.avatarUrl, 
                      level: p.level,
                      onTap: () => AvatarPickerSheet.show(context),
                      onPencilTap: () => _showEditNameDialog(context, controller, p.username),
                    ),

                    const SizedBox(height: 15),

                    // Nombre del jugador (Editable)
                    GestureDetector(
                      onTap: () => _showEditNameDialog(context, controller, p.username),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            p.username,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.edit, color: AppColors.cyan, size: 18),
                        ],
                      ),
                    ),

                    // Rango del jugador
                    Text(
                      p.rank.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.cyan,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 4,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Recuadro de selección de avatares
                    _AvatarSelectionBox(controller: controller),

                    const SizedBox(height: 20),

                    // Barra de progreso de experiencia
                    PlayerLevelProgressCard(
                      xp: p.xp,
                      nextLevel: p.xpToNextLevel,
                    ),

                    const SizedBox(height: 25),

                    // Grid de estadísticas: precisión, scans, niveles
                    PlayerStatsGrid(
                      accuracy: p.scanAccuracy,
                      totalScans: p.totalScans,
                      dogs: p.dogsCollected,
                    ),

                    const SizedBox(height: 40),

                    // Botón de cerrar sesión
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: TextButton.icon(
                        onPressed: () => controller.logout(),
                        icon: const Icon(Icons.logout_rounded, color: AppColors.error, size: 20),
                        label: const Text(
                          'CERRAR SESIÓN',
                          style: TextStyle(
                            color: AppColors.error,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.error.withValues(alpha: 0.1),
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(color: AppColors.error.withValues(alpha: 0.3)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showEditNameDialog(BuildContext context, PlayerProfileController controller, String currentName) {
    final textController = TextEditingController(text: currentName);

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.background.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColors.cyan.withValues(alpha: 0.3)),
            boxShadow: [
              BoxShadow(
                color: AppColors.cyan.withValues(alpha: 0.1),
                blurRadius: 20,
                spreadRadius: 5,
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'CAMBIAR NOMBRE',
                style: TextStyle(
                  color: AppColors.cyan,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: textController,
                autofocus: true,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                decoration: InputDecoration(
                  hintText: 'Nuevo nombre...',
                  hintStyle: const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.white10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: AppColors.cyan),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('CANCELAR', style: TextStyle(color: Colors.white54)),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (textController.text.trim().isNotEmpty) {
                        controller.updateUsername(textController.text.trim());
                        Get.back();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.cyan,
                      foregroundColor: AppColors.background,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: const Text('GUARDAR', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvatarSelectionBox extends StatelessWidget {
  final PlayerProfileController controller;

  const _AvatarSelectionBox({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 8, bottom: 4),
            child: Text(
              'ELIJE TU AVATAR',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 9,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.availableAvatars.isEmpty) {
                return const Center(child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.cyan));
              }

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: controller.availableAvatars.length,
                itemBuilder: (context, index) {
                  final url = controller.availableAvatars[index];
                  final isSelected = controller.player.value?.avatarUrl == url;
                  
                  return _SmallAvatarOption(
                    url: url,
                    isSelected: isSelected,
                    onTap: () => controller.updateAvatar(url),
                  );
                },
              );
            }),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _SmallAvatarOption extends StatelessWidget {
  final String url;
  final bool isSelected;
  final VoidCallback onTap;

  const _SmallAvatarOption({
    required this.url,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? AppColors.cyan : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: AppColors.cyan.withValues(alpha: 0.3),
              blurRadius: 8,
              spreadRadius: 1,
            )
          ] : [],
        ),
        child: ClipOval(
          child: Image.network(
            url,
            width: 45,
            height: 45,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, size: 20, color: Colors.white24),
          ),
        ),
      ),
    );
  }
}
