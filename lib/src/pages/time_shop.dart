import 'package:flutter/material.dart';
// Cambia 'juego_movil' por el nombre de tu proyecto
import 'package:juego_movil/models/time_option_model.dart';
import 'package:juego_movil/components/shop/time_option_card.dart';
import 'package:get/get.dart';

class TimeShop extends StatelessWidget {
  const TimeShop({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista de opciones de tiempo
    final List<TimeOption> options = [
      TimeOption(label: 'plus_30_sec'.tr, price: '200_coins'.tr),
      TimeOption(label: 'plus_1_min'.tr, price: '350_coins'.tr),
      TimeOption(label: 'plus_2_min'.tr, price: '600_coins'.tr),
    ];

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
              _buildBackButton(context),
              const SizedBox(height: 20),
              _buildTitle(),
              const SizedBox(height: 12),
              _buildSubtitle(),
              const SizedBox(height: 40),
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

  Widget _buildBackButton(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GestureDetector(
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
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'more_time'.tr,
      style: TextStyle(
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
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}