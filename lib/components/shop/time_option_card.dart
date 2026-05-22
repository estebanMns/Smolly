import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:get/get.dart';
import '../../models/time_option_model.dart';
import '../../config/app_colors.dart';
import '../player_profile_controller.dart';

class TimeOptionCard extends StatelessWidget {
  final TimeOption option;

  const TimeOptionCard({super.key, required this.option});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PlayerProfileController>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                final success = controller.buyBooster(option);
                if (success) {
                  Get.snackbar(
                    'Compra Exitosa',
                    'Has comprado ${option.label} por ${option.coinCost} monedas.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green.withValues(alpha: 0.8),
                    colorText: Colors.white,
                  );
                } else {
                  Get.snackbar(
                    'Fondos Insuficientes',
                    'No tienes suficientes monedas para realizar esta compra.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red.withValues(alpha: 0.8),
                    colorText: Colors.white,
                  );
                }
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
                ),
                child: Column(
                  children: [
                    Text(option.label, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.timePrimary, AppColors.timeSecondary],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(option.price, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}