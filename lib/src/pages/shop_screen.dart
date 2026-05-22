import 'package:flutter/material.dart';
import 'package:juego_movil/config/app_colors.dart';
import 'package:juego_movil/models/shop_item_model.dart';
import 'package:juego_movil/components/shop/shop_card.dart';
import 'package:juego_movil/src/pages/time_shop.dart';
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
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/fondomolly.png'), fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 20),
              _buildTitle(),
              const SizedBox(height: 50),
              ...menuItems.map((item) => ShopCard(item: item)),
            ],
          ),
        ),
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
          _buildCoinCounter(0),
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
          color: Colors.white.withValues(alpha: 0.2),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }

  Widget _buildCoinCounter(int amount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.monetization_on, color: AppColors.gold, size: 20),
          const SizedBox(width: 6),
          Text("$amount", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'stellar_shop'.tr,
      style: TextStyle(
        color: Colors.white,
        fontSize: 30,
        fontWeight: FontWeight.bold,
        letterSpacing: 3.0,
        shadows: [Shadow(color: AppColors.shopTitleShadow, blurRadius: 15)],
      ),
    );
  }
}