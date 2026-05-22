import 'package:flutter/material.dart';
import 'package:juego_movil/config/app_colors.dart';
import 'package:juego_movil/models/shop_item_model.dart';
import 'package:juego_movil/components/shop/shop_card.dart';
import 'package:juego_movil/src/pages/time_shop.dart';
import 'package:juego_movil/src/pages/rewards_screen.dart';
import 'package:get/get.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ShopItem> menuItems = [
      ShopItem(
        title: 'time_boosters'.tr,
        subtitle: 'time_boosters_desc'.tr,
        icon: Icons.access_time_filled,
        gradientColors: [AppColors.shopPurple1, AppColors.shopPurple2],
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TimeShop())),
      ),
      ShopItem(
        title: 'upgrades'.tr,
        subtitle: 'upgrades_desc'.tr,
        icon: Icons.auto_fix_high,
        gradientColors: [AppColors.shopBlue1, AppColors.shopBlue2],
        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('coming_soon'.tr), backgroundColor: Colors.white70),
        ),
      ),
      ShopItem(
        title: 'rewards'.tr,
        subtitle: 'shop_rewards_desc'.tr,
        icon: Icons.card_giftcard_rounded,
        gradientColors: [AppColors.gold, AppColors.achOrange],
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RewardsScreen())),
      ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/fondoniveles.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Magical Forest Overlay Gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.deepPurple.withValues(alpha: 0.6),
                    Colors.blue.withValues(alpha: 0.4),
                    Colors.teal.withValues(alpha: 0.2),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                const SizedBox(height: 20),
                _buildTitle(),
                const SizedBox(height: 40),
                ...menuItems.map((item) => ShopCard(item: item)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCircularButton(Icons.arrow_back_ios_new, () => Navigator.pop(context)),
          Row(
            children: [
              _buildCoinCounter(0),
              const SizedBox(width: 12),
              _buildRewardsHeaderButton(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCircularButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
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
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildRewardsHeaderButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const RewardsScreen()),
      ),
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: AppColors.gold.withValues(alpha: 0.15),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.gold.withValues(alpha: 0.5),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.gold.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: const Icon(Icons.card_giftcard_rounded, color: AppColors.gold, size: 22),
      ),
    );
  }

  Widget _buildCoinCounter(int amount) {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(22.5),
        border: Border.all(
          color: AppColors.gold.withValues(alpha: 0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.monetization_on_rounded, color: AppColors.gold, size: 22),
          const SizedBox(width: 8),
          Text(
            "$amount",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'stellar_shop'.tr.toUpperCase(),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 30,
        fontWeight: FontWeight.bold,
        letterSpacing: 3.0,
        shadows: [
          Shadow(
            blurRadius: 15,
            color: Color(0xFF9C27B0),
            offset: Offset(0, 0),
          ),
        ],
      ),
    );
  }
}