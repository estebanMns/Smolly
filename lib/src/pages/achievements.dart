import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/player_profile_controller.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final controller = Get.find<PlayerProfileController>();

    // Definir todos los logros con su ID
    final List<Map<String, dynamic>> allAchievements = [
      {
        'id': 'primer-vuelo',
        'title': 'Fragmento Recuperado',
        'description': 'Consigue tu primer fragmento de Lunaris.',
        'icon': Icons.rocket_launch,
        'color': const Color(0xFFFF6B6B),
      },
      {
        'id': 'cazador-estrellas',
        'title': 'Contra el Tiempo',
        'description': 'Completa un nivel con muy poco tiempo restante.',
        'icon': Icons.star,
        'color': const Color(0xFFFFD93D),
      },
      {
        'id': 'viajero-temporal',
        'title': 'Olfato Legendario',
        'description': 'Encuentra todos los objetos de un nivel sin fallar.',
        'icon': Icons.timer,
        'color': const Color(0xFFFF8E53),
      },
      {
        'id': 'maestro-molly',
        'title': 'La Luz de Lunaris',
        'description': 'Recupera múltiples fragmentos seguidos sin perder.',
        'icon': Icons.pets,
        'color': const Color(0xFF69F0AE),
      },
      {
        'id': 'guerrero-galactico',
        'title': 'Sombras del Eclipse',
        'description': 'Sobrevive a un nivel donde Molly aumenta la dificultad.',
        'icon': Icons.shield,
        'color': const Color(0xFF7C4DFF),
      },
      {
        'id': 'leyenda-viviente',
        'title': 'El Destino de Iker',
        'description': 'Desbloquea el final verdadero salvando a Iker.',
        'icon': Icons.emoji_events,
        'color': const Color(0xFFFF4081),
      },
    ];

    return Scaffold(
      body: Stack(
        children: [
          // Fondo principal
          Positioned.fill(
            child: Image.asset(
              'assets/images/Fondogeneral.jpg',
              fit: BoxFit.cover,
            ),
          ),
          
          // Overlay morado suave
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF1A0B2E).withValues(alpha: 0.7),
                    const Color(0xFF2D1B4E).withValues(alpha: 0.6),
                    const Color(0xFF4A1D6D).withValues(alpha: 0.5),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      _buildBackButton(context),
                      const Expanded(
                        child: Text(
                          'LOGROS',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3,
                            shadows: [
                              Shadow(
                                blurRadius: 10,
                                color: Color(0xFFFFD93D),
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 45),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Tarjeta de Progreso
                Obx(() => _buildProgressCard(
                      screenWidth,
                      controller.player.value?.unlockedAchievements.length ?? 0,
                      allAchievements.length,
                    )),

                const SizedBox(height: 25),

                // Lista de logros
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Obx(() {
                      final unlocked = controller.player.value?.unlockedAchievements ?? const {};
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: allAchievements.length,
                        itemBuilder: (context, index) {
                          final achievement = allAchievements[index];
                          return Column(
                            children: [
                              _buildAchievementCard(
                                achievement['title'],
                                achievement['description'],
                                achievement['icon'],
                                achievement['color'],
                                unlocked.contains(achievement['id']),
                              ),
                              const SizedBox(height: 12),
                            ],
                          );
                        },
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildProgressCard(double screenWidth, int unlockedCount, int totalCount) {
    final progress = totalCount > 0 ? unlockedCount / totalCount : 0.0;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF4A1D6D).withValues(alpha: 0.4),
            const Color(0xFF2D1B4E).withValues(alpha: 0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.auto_awesome,
                color: Color(0xFFFFD93D),
                size: 22,
              ),
              const SizedBox(width: 10),
              const Text(
                "PROGRESO TOTAL",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFFFFD93D),
                  ),
                  minHeight: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD93D).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: const Color(0xFFFFD93D).withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
                child: Text(
                  "$unlockedCount / $totalCount LOGROS",
                  style: const TextStyle(
                    color: Color(0xFFFFD93D),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(
    String title,
    String description,
    IconData icon,
    Color color,
    bool unlocked,
  ) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 300),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.95 + (value * 0.05),
          child: Opacity(
            opacity: 0.9 + (value * 0.1),
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: unlocked
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withValues(alpha: 0.25),
                    color.withValues(alpha: 0.15),
                  ],
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.1),
                    Colors.white.withValues(alpha: 0.05),
                  ],
                ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: unlocked
                ? color.withValues(alpha: 0.5)
                : Colors.white.withValues(alpha: 0.2),
            width: unlocked ? 1.5 : 1,
          ),
          boxShadow: unlocked
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: Row(
          children: [
            // Icono circular
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: unlocked
                    ? color.withValues(alpha: 0.3)
                    : Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: unlocked
                      ? color.withValues(alpha: 0.6)
                      : Colors.white.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Icon(
                icon,
                color: unlocked ? color : Colors.white38,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            // Texto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: unlocked ? Colors.white : Colors.white54,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: unlocked ? Colors.white70 : Colors.white30,
                      fontSize: 12,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
            // Estado
            unlocked
                ? Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 20,
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lock,
                      color: Colors.white38,
                      size: 18,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}