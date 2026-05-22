import 'package:flutter/material.dart';
import 'package:juego_movil/models/time_option_model.dart';
import 'package:juego_movil/components/shop/time_option_card.dart';
import 'package:juego_movil/components/player_profile_controller.dart';
import 'package:get/get.dart';

class TimeShop extends StatelessWidget {
  const TimeShop({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista de opciones de tiempo con su identificador de tipo
    final List<TimeOption> options = [
      TimeOption(type: '30s', label: 'plus_30_sec'.tr, price: '200_coins'.tr, coinCost: 200),
      TimeOption(type: '1m', label: 'plus_1_min'.tr, price: '350_coins'.tr, coinCost: 350),
      TimeOption(type: '2m', label: 'plus_2_min'.tr, price: '600_coins'.tr, coinCost: 600),
    ];

    final controller = Get.find<PlayerProfileController>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fondohorus.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 10),
              _buildTitle(),
              const SizedBox(height: 8),
              _buildSubtitle(),
              const SizedBox(height: 20),
              _buildInventorySummary(controller),
              const SizedBox(height: 25),
              // Generamos las opciones automáticamente
              Expanded(
                child: ListView.separated(
                  itemCount: options.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) => TimeOptionCard(option: options[index]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final controller = Get.find<PlayerProfileController>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
              ),
              child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 22),
            ),
          ),
          Obx(() => Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.amber.withValues(alpha: 0.5)),
            ),
            child: Row(
              children: [
                const Icon(Icons.monetization_on, color: Colors.amber, size: 20),
                const SizedBox(width: 6),
                Text(
                  "${controller.player.value?.coins ?? 0}",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )),
          const SizedBox(width: 45), // To balance the back button visually
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'more_time'.tr,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 32,
        fontWeight: FontWeight.bold,
        letterSpacing: 3,
        shadows: [
          Shadow(color: Color.fromARGB(255, 63, 81, 181), blurRadius: 20),
        ],
      ),
    );
  }

  Widget _buildSubtitle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'need_extra_seconds'.tr,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  Widget _buildInventorySummary(PlayerProfileController controller) {
    return Obx(() {
      final p = controller.player.value;
      if (p == null) return const SizedBox.shrink();

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 30),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            const Text(
              "TUS POTENCIADORES",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInventoryItem(Icons.bolt, "+30s", p.boosters30s, Colors.orangeAccent),
                _buildInventoryItem(Icons.speed, "+1m", p.boosters1m, Colors.cyanAccent),
                _buildInventoryItem(Icons.hourglass_full, "+2m", p.boosters2m, Colors.greenAccent),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildInventoryItem(IconData icon, String name, int count, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 4),
        Text(
          name,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            "$count",
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
      ],
    );
  }
}