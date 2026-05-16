import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ============================================================
// LEVEL DETAIL MODEL
// ============================================================

class LevelDetailInfo {
  final int id;
  final int itemsToCollect;
  final int coinsReward;
  final bool unlocksStory;
  final String cameraNotice;

  LevelDetailInfo({
    required this.id,
    required this.itemsToCollect,
    required this.coinsReward,
    required this.unlocksStory,
    this.cameraNotice = "",
  });
}

// ============================================================
// DATA SOURCE (LIST OF LEVELS)
// ============================================================

final List<LevelDetailInfo> levelDetailsList = List.generate(21, (index) {
  // Specific levels that unlock a story fragment: 0, 3, 10, 17, 20
  final bool hasStory = [0, 3, 10, 17, 20].contains(index);
  
  return LevelDetailInfo(
    id: index,
    itemsToCollect: 4 + (index % 3), 
    coinsReward: 50 + (index * 10),  
    unlocksStory: hasStory,
  );
});

// ============================================================
// LEVEL DETAIL SCREEN
// ============================================================

class LevelDetailScreen extends StatelessWidget {
  const LevelDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Receiving arguments from the Map screen
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    // Protección: Si no hay argumentos, volvemos atrás para evitar el crash
    if (args == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final int levelId = args['levelId'];
    final String levelName = args['levelName'];

    // Finding the specific data for this level
    final detail = levelDetailsList.firstWhere((element) => element.id == levelId);

    return Scaffold(
      body: Stack(
        children: [
          // 1. BACKGROUND IMAGE
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/fondoiker.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // 2. SEMI-TRANSPARENT OVERLAY
          Container(color: Colors.black.withValues(alpha: 0.5)),

          // 3. MAIN CONTENT CARD
          Center(
            child: _buildDetailCard(context, levelName, detail),
          ),

          // 4. CLOSE BUTTON (X)
          _buildCloseButton(context),
        ],
      ),
    );
  }

  Widget _buildDetailCard(BuildContext context, String name, LevelDetailInfo detail) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Text(
            name.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              shadows: [Shadow(color: Colors.cyanAccent, blurRadius: 10)],
            ),
          ),
          const Divider(color: Colors.white24, height: 30),

          // Level Info Rows
          _buildInfoRow(Icons.category_rounded, "${'items_to_collect'.tr}: ${detail.itemsToCollect}"),
          _buildInfoRow(Icons.monetization_on_rounded, "${'reward'.tr}: ${detail.coinsReward} ${'coins'.tr}"),
          
          if (detail.unlocksStory)
            _buildInfoRow(Icons.auto_stories_rounded, 'story_fragment'.tr, isHighlight: true),

          const SizedBox(height: 15),
          
          // Camera Warning
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.videocam_rounded, color: Colors.amberAccent),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    detail.cameraNotice.isNotEmpty ? detail.cameraNotice : 'camera_notice'.tr,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // START BUTTON - CORREGIDO
          ElevatedButton(
            onPressed: () {
              // Navegación hacia la pantalla de juego pasando el ID del nivel
              Navigator.pushNamed(
                context, 
                '/game-screen', 
                arguments: {'levelId': detail.id},
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyanAccent,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 10,
            ),
            child: Text(
              'start_caps'.tr,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: isHighlight ? Colors.pinkAccent : Colors.white, size: 24),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              color: isHighlight ? Colors.pinkAccent : Colors.white,
              fontSize: 16,
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
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
            color: Colors.white.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}