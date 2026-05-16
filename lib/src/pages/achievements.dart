import 'package:flutter/material.dart';
import 'package:juego_movil/models/achievement_model.dart';
import 'package:juego_movil/components/achievements/achievement_medal.dart';
import 'package:get/get.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista de datos (esto podría venir de un controlador después)
    final List<Achievement> achievementsList = [
      Achievement(title: 'first_flight'.tr, icon: Icons.rocket_launch, color: const Color(0xFFFF6B6B), isUnlocked: true),
      Achievement(title: 'star_hunter'.tr, icon: Icons.star, color: const Color(0xFFFFD93D), isUnlocked: true),
      Achievement(title: 'time_traveler'.tr, icon: Icons.timer, color: const Color(0xFFFF8E53)),
      Achievement(title: 'molly_master'.tr, icon: Icons.pets, color: const Color(0xFF69F0AE)),
      Achievement(title: 'galactic_warrior'.tr, icon: Icons.shield, color: const Color(0xFF7C4DFF)),
      Achievement(title: 'living_legend'.tr, icon: Icons.emoji_events, color: const Color(0xFFFF4081)),
    ];

    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                const SizedBox(height: 10),
                _buildProgressCard(),
                const SizedBox(height: 25),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      padding: const EdgeInsets.only(bottom: 20),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.85,
                      ),
                      physics: const BouncingScrollPhysics(),
                      itemCount: achievementsList.length,
                      itemBuilder: (context, index) => AchievementMedal(achievement: achievementsList[index]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Métodos privados para mantener el build ordenado
  Widget _buildBackground() {
    return Stack(
      children: [
        Positioned.fill(child: Image.asset('assets/images/fondoperroblanco.png', fit: BoxFit.cover)),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.2),
                  const Color(0xFF4A1D6D).withValues(alpha: 0.4),
                  const Color(0xFF2D1B4E).withValues(alpha: 0.6),
                  Colors.black.withValues(alpha: 0.8),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _buildCircularButton(Icons.arrow_back_ios_new, () => Navigator.pop(context)),
          Expanded(
            child: Text(
              'achievements_caps'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 3.5),
            ),
          ),
          const SizedBox(width: 45),
        ],
      ),
    );
  }

  Widget _buildCircularButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }

  Widget _buildProgressCard() {
    return Container(/* ... tu código de la tarjeta de progreso ... */);
  }
}