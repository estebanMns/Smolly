import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:get/get.dart';

class StoryScreen extends StatelessWidget {
  const StoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo Galáctico
          Positioned.fill(
            child: Image.asset(
              'assets/images/FondoLobby.jpg', 
              fit: BoxFit.cover,
            ),
          ),
          
          // Overlay para mejorar legibilidad
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.5),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      _buildCircularButton(context, Icons.arrow_back_ios_new, () => Navigator.pop(context)),
                      Expanded(
                        child: Text(
                          'stellar_log'.tr,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white, 
                            fontSize: 22, 
                            fontWeight: FontWeight.bold, 
                            letterSpacing: 3
                          ),
                        ),
                      ),
                      const SizedBox(width: 45),
                    ],
                  ),
                ),

                Text(
                  'molly_mission_log'.tr,
                  style: const TextStyle(color: Color(0xFFCE93D8), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                ),

                const SizedBox(height: 20),

                // Lista de Capítulos
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    children: [
                      _buildStoryChapter(
                        'chapter_1'.tr, 'chapter_1_title'.tr, 
                        'chapter_1_desc'.tr, 
                        'two_images'.tr, Icons.blur_on, const Color(0xFF40C4FF)
                      ),
                      _buildStoryChapter(
                        'chapter_2'.tr, 'chapter_2_title'.tr, 
                        'chapter_2_desc'.tr, 
                        'two_images'.tr, Icons.explore_rounded, const Color(0xFF69F0AE)
                      ),
                      _buildStoryChapter(
                        'chapter_3'.tr, 'chapter_3_title'.tr, 
                        'chapter_3_desc'.tr, 
                        'three_images'.tr, Icons.thunderstorm_rounded, const Color(0xFFFFD740)
                      ),
                      _buildStoryChapter(
                        'chapter_4'.tr, 'chapter_4_title'.tr, 
                        'chapter_4_desc'.tr, 
                        'three_images'.tr, Icons.visibility_rounded, const Color(0xFFFF5252)
                      ),
                      _buildStoryChapter(
                        'chapter_5'.tr, 'chapter_5_title'.tr, 
                        'chapter_5_desc'.tr, 
                        'two_images'.tr, Icons.favorite_rounded, const Color(0xFFEA80FC)
                      ),
                      _buildStoryChapter(
                        'chapter_6'.tr, 'chapter_6_title'.tr, 
                        'chapter_6_desc'.tr, 
                        'three_images'.tr, Icons.auto_awesome_rounded, Colors.white
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularButton(BuildContext context, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildStoryChapter(String cap, String title, String desc, String imgs, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 80, width: 60,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color.withValues(alpha: 0.2)),
                  ),
                  child: Icon(icon, color: color, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(cap, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                          Text(imgs, style: const TextStyle(color: Colors.white54, fontSize: 10)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text(
                        desc, 
                        style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.3),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}