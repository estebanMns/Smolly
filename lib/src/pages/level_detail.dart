import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/level_model.dart';
import '../../components/levels_controller.dart';
import '../../stories/cap1.dart';
import '../../stories/cap2.dart';
import '../../stories/cap3.dart';
import '../../stories/cap4.dart';
import '../../stories/cap5.dart';
import '../../stories/cap6.dart';
import '../../stories/cap7.dart';

// ============================================================
// LEVEL DETAIL SCREEN
// ============================================================

class LevelDetailScreen extends StatelessWidget {
  const LevelDetailScreen({super.key});

  Widget _getChapterScreen(int levelId) {
    switch (levelId) {
      case 1:
        return const Cap1Screen();
      case 4:
        return const Cap2Screen();
      case 8:
        return const Cap3Screen();
      case 12:
        return const Cap4Screen();
      case 17:
        return const Cap5Screen();
      case 20:
        return const Cap6Screen();
      case 21:
        return const Cap7Screen();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final int levelId = args['levelId'];
    final String initialLevelName = args['levelName'];

    final levelsController = Get.isRegistered<LevelsController>()
        ? Get.find<LevelsController>()
        : Get.put(LevelsController());

    return Scaffold(
      body: Stack(
        children: [
          // 1. BACKGROUND IMAGE
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/detail.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // 2. MAGICAL FOREST OVERLAY
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.deepPurple.withValues(alpha: 0.4),
                  Colors.blue.withValues(alpha: 0.3),
                  Colors.teal.withValues(alpha: 0.2),
                ],
              ),
            ),
          ),

          // 3. MAIN CONTENT CARD
          Center(
            child: Obx(() {
              if (levelsController.isLoading.value && levelsController.levels.isEmpty) {
                return const CircularProgressIndicator(color: Colors.amber);
              }
              final detail = levelsController.getLevel(levelId);
              final levelName = detail.levelName.isNotEmpty ? detail.levelName : initialLevelName;
              return _buildDetailCard(context, levelName, detail, levelId);
            }),
          ),

          // 4. CLOSE BUTTON (X)
          _buildCloseButton(context),
        ],
      ),
    );
  }

  Widget _buildDetailCard(BuildContext context, String name, LevelModel detail, int levelId) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black.withValues(alpha: 0.7),
            Colors.deepPurple.withValues(alpha: 0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.amber.withValues(alpha: 0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withValues(alpha: 0.2),
            blurRadius: 20,
            spreadRadius: 5,
          ),
          BoxShadow(
            color: Colors.cyan.withValues(alpha: 0.1),
            blurRadius: 30,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title with magical glow
          Text(
            name.toUpperCase(),
            style: const TextStyle(
              color: Colors.amber,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              shadows: [
                Shadow(color: Colors.orange, blurRadius: 15),
                Shadow(color: Colors.yellow, blurRadius: 10),
              ],
            ),
          ),
          Divider(color: Colors.amber.withValues(alpha: 0.24), height: 30),

          // Level Info Rows
          _buildInfoRow(Icons.category_rounded, "${'items_to_collect'.tr}: ${detail.itemsToCollect}"),
          _buildInfoRow(Icons.monetization_on_rounded, "${'reward'.tr}: ${detail.coinsReward} ${'coins'.tr}"),
          
          if (detail.unlocksStory)
            _buildInfoRow(Icons.auto_stories_rounded, 'Fragmento de historia incluido', isHighlight: true),

          const SizedBox(height: 15),
          
          // Camera Warning
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.amber.withValues(alpha: 0.3),
                  Colors.orange.withValues(alpha: 0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.withValues(alpha: 0.5), width: 1),
            ),
            child: Row(
              children: [
                const Icon(Icons.videocam_rounded, color: Colors.amberAccent, size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    detail.cameraNotice.isNotEmpty ? detail.cameraNotice : 'camera_notice'.tr,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // START BUTTON - Tema mágico
          ElevatedButton(
            onPressed: () {
              if (detail.unlocksStory) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => _getChapterScreen(levelId)),
                );
              } else {
                Navigator.pushNamed(
                  context, 
                  '/game-screen', 
                  arguments: {'levelId': detail.id},
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black87,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.yellow.withValues(alpha: 0.5), width: 2),
              ),
              elevation: 10,
              shadowColor: Colors.amber.withValues(alpha: 0.6),
            ),
            child: Text(
              'start_caps'.tr,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // ✅ Alineación superior para multi-línea
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isHighlight 
                  ? Colors.pinkAccent.withValues(alpha: 0.2) 
                  : Colors.amber.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isHighlight 
                    ? Colors.pinkAccent.withValues(alpha: 0.5) 
                    : Colors.amber.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: isHighlight ? Colors.pinkAccent : Colors.amberAccent,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: isHighlight ? Colors.pinkAccent : Colors.white,
                fontSize: 16,
                fontWeight: isHighlight ? FontWeight.bold : FontWeight.w500,
                letterSpacing: 0.5,
                height: 1.3, // ✅ Espaciado entre líneas
              ),
              softWrap: true, // ✅ Permite salto de línea
              // ✅ ELIMINADO: overflow: TextOverflow.ellipsis (esto causaba los "...")
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 20,
      right: 20,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.5),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.amber.withValues(alpha: 0.5), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withValues(alpha: 0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(Icons.close_rounded, color: Colors.amber, size: 28),
        ),
      ),
    );
  }
}