import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:juego_movil/components/player_profile_controller.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _hasUpdated = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    if (!_hasUpdated) {
      _hasUpdated = true;
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
      final int score = args['score'] ?? 1000;
      final int coins = args['coins'] ?? 50;
      final int objectsScanned = args['objectsScanned'] ?? 3;
      final bool isVictory = args['isVictory'] ?? true;

      // Actualizar el perfil del jugador
      final controller = Get.put(PlayerProfileController());
      controller.processGameResult(
        score: score,
        coinsEarned: coins,
        objectsScanned: objectsScanned,
        isVictory: isVictory,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
    final int levelId = args['levelId'] ?? 0;
    final int score = args['score'] ?? 1000;
    final int coins = args['coins'] ?? 50;
    final bool isVictory = args['isVictory'] ?? true;

    return Scaffold(
      body: Stack(
        children: [
          // 1. BACKGROUND IMAGE
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/fondo_resultados.png'), // Tu asset aquí
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 2. DARK OVERLAY PARA LEGIBILIDAD
          Container(color: Colors.black.withValues(alpha: 0.6)),

          // 3. MAIN CONTENT
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icono de Victoria
                  _buildResultIcon(isVictory),
                  
                  const SizedBox(height: 20),

                  // Texto de Estado
                  Text(
                    isVictory ? 'mission_complete'.tr : 'mission_failed'.tr,
                    style: TextStyle(
                      color: isVictory ? Colors.cyanAccent : Colors.redAccent,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                      shadows: [
                        Shadow(
                          color: isVictory ? Colors.cyanAccent : Colors.redAccent,
                          blurRadius: 15,
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // CARD DE PUNTAJE (Glassmorphism)
                  _buildScoreCard(context, score, coins),

                  const SizedBox(height: 50),

                  // BOTÓN DE RETORNO
                  _buildReturnButton(context, levelId),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultIcon(bool isVictory) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isVictory ? Colors.cyanAccent : Colors.redAccent,
          width: 4,
        ),
      ),
      child: Icon(
        isVictory ? Icons.emoji_events_rounded : Icons.sentiment_very_dissatisfied,
        color: Colors.white,
        size: 80,
      ),
    );
  }

  Widget _buildScoreCard(BuildContext context, int score, int coins) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          _buildStatRow('score'.tr, score.toString(), Colors.white),
          const Divider(color: Colors.white24, height: 30),
          _buildStatRow('coins_caps'.tr, '+$coins', Colors.amberAccent),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 18, letterSpacing: 1),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildReturnButton(BuildContext context, int levelId) {
    return ElevatedButton(
      onPressed: () {
        // Regresamos al detalle del nivel
        Navigator.pushReplacementNamed(
          context,
          '/level-detail',
          arguments: {
            'levelId': levelId,
            'levelName': '${'level'.tr.toUpperCase()} $levelId',
          },
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.cyanAccent,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        elevation: 10,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          const SizedBox(width: 10),
          Text(
            'back_to_details'.tr,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}