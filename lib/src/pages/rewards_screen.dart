import 'package:flutter/material.dart';
import 'dart:ui';
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
              'assets/images/fondokovu.png',
              fit: BoxFit.cover,
            ),
          ),
          
          // Overlay con degradado de colores vibrantes
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF6B1B9A).withValues(alpha: 0.5), // Morado
                    const Color(0xFF00B4D8).withValues(alpha: 0.4), // Cyan
                    const Color(0xFF9C27B0).withValues(alpha: 0.5), // Púrpura
                    const Color(0xFFFF6B6B).withValues(alpha: 0.3), // Rosa/rojo
                    Colors.black.withValues(alpha: 0.7),
                  ],
                  stops: const [0.0, 0.3, 0.6, 0.8, 1.0],
                ),
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                // Header mejorado
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      _buildCircularHeaderButton(
                        context,
                        Icons.arrow_back_ios_new,
                        () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            Color(0xFFFF6B6B),
                            Color(0xFFFFD93D),
                            Color(0xFF6B1B9A),
                          ],
                        ).createShader(bounds),
                        child: Text(
                          'rewards'.tr.toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.5,
                            shadows: [
                              Shadow(
                                blurRadius: 10,
                                color: Color(0xFFFF6B6B),
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      _buildCircularHeaderButton(
                        context,
                        Icons.emoji_events_rounded,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AchievementsScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Tarjeta de Monedas
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: _buildGlassCard(
                    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFD93D), Color(0xFFFF8E53)],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFFD93D).withValues(alpha: 0.5),
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.monetization_on,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Obx(() => Text(
                          '${controller.player.value?.coins ?? 0}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 8,
                                color: Colors.black26,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        )),
                        const SizedBox(width: 8),
                        Text(
                          'coins'.tr,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Título de sección
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFFF6B6B).withValues(alpha: 0.3),
                        const Color(0xFF6B1B9A).withValues(alpha: 0.3),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: const Color(0xFFFFD93D).withValues(alpha: 0.4),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle, color: Color(0xFF69F0AE), size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'completed_missions'.tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
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
                          const Color(0xFF9C27B0),
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

  Widget _buildCircularHeaderButton(
    BuildContext context,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withValues(alpha: 0.2),
              Colors.white.withValues(alpha: 0.1),
            ],
          ),
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFFFFD93D).withValues(alpha: 0.4),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF6B6B).withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }

  Widget _buildGlassCard({
    required Widget child,
    required EdgeInsetsGeometry padding,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.15),
                Colors.white.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.25),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: child,
        ),
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
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 400),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isClaimed ? Colors.transparent : color.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: _buildGlassCard(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isClaimed
                        ? [Colors.grey, Colors.grey.withValues(alpha: 0.6)]
                        : [color, color.withValues(alpha: 0.6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: isClaimed ? Colors.transparent : color.withValues(alpha: 0.5),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: isClaimed ? Colors.white38 : color.withValues(alpha: 0.9),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
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
                    BoxShadow(
                      color: isClaimed ? Colors.black12 : color.withValues(alpha: 0.4),
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
                        isClaimed ? 'claimed'.tr : 'claim'.tr,
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
        ),
      ),
    );
  }
}