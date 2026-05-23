import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config/app_colors.dart';
import '../utils/avatar_helper.dart';
import 'player_profile_controller.dart';

class AvatarPickerSheet extends StatelessWidget {
  const AvatarPickerSheet({super.key});

  static void show(BuildContext context) {
    // Aseguramos que el controlador esté disponible
    if (!Get.isRegistered<PlayerProfileController>()) {
      Get.put(PlayerProfileController());
    }
    
    Get.bottomSheet(
      const AvatarPickerSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.7),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PlayerProfileController>();
    
    return Material(
      color: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.55,
        decoration: BoxDecoration(
          color: AppColors.background.withValues(alpha: 0.9),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
          border: Border.all(color: AppColors.cyan.withValues(alpha: 0.3), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.cyan.withValues(alpha: 0.15),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 25),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [AppColors.cyan, AppColors.purple2],
                  ).createShader(bounds),
                  child: const Text(
                    'SELECCIONA TU AVATAR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 3,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Elige la imagen que mejor te represente',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: Obx(() {
                    if (controller.availableAvatars.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(color: AppColors.cyan),
                            SizedBox(height: 15),
                            Text('Cargando avatares...', style: TextStyle(color: Colors.white70)),
                          ],
                        ),
                      );
                    }
                    
                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 1,
                      ),
                      itemCount: controller.availableAvatars.length,
                      itemBuilder: (context, index) {
                        final url = controller.availableAvatars[index];
                        final isSelected = controller.player.value?.avatarUrl == url;
                        
                        return _AvatarOption(
                          url: url,
                          isSelected: isSelected,
                          onTap: () {
                            print("Avatar pulsado: $url");
                            controller.updateAvatar(url);
                          },
                        );
                      },
                    );
                  }),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AvatarOption extends StatelessWidget {
  final String url;
  final bool isSelected;
  final VoidCallback onTap;

  const _AvatarOption({
    required this.url,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? AppColors.cyan : Colors.white10,
              width: isSelected ? 3 : 1.5,
            ),
            boxShadow: isSelected ? [
              BoxShadow(
                color: AppColors.cyan.withValues(alpha: 0.4),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ] : [],
          ),
          padding: const EdgeInsets.all(4),
          child: ClipOval(
            child: Image(
              image: getAvatarImageProvider(url),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.error_outline, color: Colors.white24),
            ),
          ),
        ),
      ),
    );
  }
}
