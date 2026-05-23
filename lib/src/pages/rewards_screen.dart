import 'package:flutter/material.dart';
import 'achievements.dart';
import 'package:juego_movil/components/player_profile_controller.dart';
import 'package:get/get.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PlayerProfileController>();
    
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
                _buildHeader(context),
                const SizedBox(height: 10),

                // Tarjeta de Monedas
                Obx(() => _buildCoinsCard(controller.player.value?.coins ?? 0)),

                const SizedBox(height: 25),

                // Título de sección
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFFFD93D).withValues(alpha: 0.25),
                        const Color(0xFF7C4DFF).withValues(alpha: 0.15),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: const Color(0xFFFFD93D).withValues(alpha: 0.5),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFD93D).withValues(alpha: 0.2),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle_rounded, color: Color(0xFF69F0AE), size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'completed_missions'.tr.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                // Lista de recompensas
                Expanded(
                  child: Obx(() {
                    return ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      physics: const BouncingScrollPhysics(),
                      children: [
                        _buildClaimableRewardTile(
                          'reward_collector_5',
                          'collector_level_5'.tr,
                          'plus_500_coins'.tr,
                          Icons.stars_rounded,
                          const Color(0xFF69F0AE),
                          500,
                          0,
                          controller,
                        ),
                        const SizedBox(height: 12),
                        _buildClaimableRewardTile(
                          'reward_super_star',
                          'super_star'.tr,
                          'plus_1000_exp'.tr,
                          Icons.workspace_premium_rounded,
                          const Color(0xFFFFD93D),
                          0,
                          1000,
                          controller,
                        ),
                        const SizedBox(height: 12),
                        _buildClaimableRewardTile(
                          'reward_time_master',
                          'time_master'.tr,
                          'plus_30_sec'.tr,
                          Icons.timer_rounded,
                          const Color(0xFFFF6B6B),
                          300,
                          0,
                          controller,
                        ),
                        const SizedBox(height: 12),
                        _buildClaimableRewardTile(
                          'reward_mystic_warrior',
                          'mystic_warrior'.tr,
                          'plus_1_power_potion'.tr,
                          Icons.auto_awesome,
                          const Color(0xFFE040FB),
                          500,
                          500,
                          controller,
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          GestureDetector(
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
          ),
          
          // Title
          Text(
            'rewards'.tr.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.5,
              shadows: [
                Shadow(
                  blurRadius: 10,
                  color: Color(0xFFFFD93D),
                  offset: Offset(0, 0),
                ),
              ],
            ),
          ),

          // Achievements button
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AchievementsScreen()),
              );
            },
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
                Icons.emoji_events_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoinsCard(int amount) {
    const Color color = Color(0xFFFFD93D);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.25),
            const Color(0xFFFF8E53).withValues(alpha: 0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: color.withValues(alpha: 0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: color.withValues(alpha: 0.6),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.monetization_on_rounded,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            '$amount',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              shadows: [
                Shadow(
                  blurRadius: 8,
                  color: Colors.black45,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'coins'.tr,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClaimableRewardTile(
    String rewardId,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    int coins,
    int xp,
    PlayerProfileController controller,
  ) {
    final isClaimed = controller.claimedRewards.contains(rewardId);
    final tileColor = isClaimed ? Colors.grey : color;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            tileColor.withValues(alpha: 0.25),
            tileColor.withValues(alpha: 0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: tileColor.withValues(alpha: 0.5),
          width: 1.5,
        ),
        boxShadow: [
          if (!isClaimed)
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Row(
        children: [
          // Left icon container
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: tileColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: tileColor.withValues(alpha: 0.5),
                width: 1.5,
              ),
            ),
            child: Icon(icon, color: tileColor, size: 26),
          ),
          const SizedBox(width: 16),
          
          // Text Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isClaimed ? Colors.white54 : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isClaimed ? Colors.white38 : color.withValues(alpha: 0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // Claim button
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isClaimed
                    ? [Colors.grey.shade600, Colors.grey.shade700]
                    : [color, color.withValues(alpha: 0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                if (!isClaimed)
                  BoxShadow(
                    color: color.withValues(alpha: 0.4),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isClaimed
                    ? null
                    : () {
                        controller.claimReward(rewardId, coins: coins, xp: xp);
                      },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: Text(
                    isClaimed ? 'claimed'.tr.toUpperCase() : 'claim'.tr.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}