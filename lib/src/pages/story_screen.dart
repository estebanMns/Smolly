import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../stories/cap1.dart';
import '../../stories/cap2.dart';
import '../../stories/cap3.dart';
import '../../stories/cap4.dart';
import '../../stories/cap5.dart';
import '../../stories/cap6.dart';
import '../../stories/cap7.dart';

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
              'assets/images/Historias.jpg', 
              fit: BoxFit.cover,
            ),
          ),
          
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.5),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
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
                            'story'.tr.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white, 
                              fontSize: 28, 
                              fontWeight: FontWeight.bold, 
                              letterSpacing: 2
                            ),
                          ),
                        ),
                        const SizedBox(width: 45),
                      ],
                    ),
                  ),

                  // Lore text
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6A4C93).withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Text(
                        'story_lore'.tr,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          height: 1.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Botones de Capítulos en Grid/Wrap
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildStoryButton('magic_in_danger'.tr, () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const Cap1Screen()));
                        }),
                        _buildStoryButton('the_first_fragment'.tr, () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const Cap2Screen()));
                        }),
                        _buildStoryButton('the_clock'.tr, () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const Cap3Screen()));
                        }),
                        _buildStoryButton('the_hidden_truth'.tr, () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const Cap4Screen()));
                        }),
                        _buildStoryButton('the_last_path'.tr, () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const Cap5Screen()));
                        }),
                        _buildStoryButton('final'.tr, () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const Cap6Screen()));
                        }),
                        _buildStoryButton('final_2'.tr, () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const Cap7Screen()));
                        }),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                ],
              ),
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

  Widget _buildStoryButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        height: 80,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF4A3470).withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white38, width: 1.5),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}