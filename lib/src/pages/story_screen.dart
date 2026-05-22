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
          // Fondo Galáctico / de Niveles
          Positioned.fill(
            child: Image.asset(
              'assets/images/fondoniveles.jpg', 
              fit: BoxFit.cover,
            ),
          ),
          // Magical Forest Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF1A0B2E).withValues(alpha: 0.7),
                    const Color(0xFF2D1B4E).withValues(alpha: 0.6),
                    const Color(0xFF4A1D6D).withValues(alpha: 0.5),
                  ],
                ),
              ),
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
                          'story'.tr.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white, 
                            fontSize: 28, 
                            fontWeight: FontWeight.bold, 
                            letterSpacing: 3,
                            shadows: [
                              Shadow(
                                blurRadius: 10,
                                color: Color(0xFFFFD93D),
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 45),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Lore text card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF4A1D6D).withValues(alpha: 0.4),
                          const Color(0xFF2D1B4E).withValues(alpha: 0.3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.auto_awesome,
                              color: Color(0xFFFFD93D),
                              size: 22,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'story'.tr.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'story_lore'.tr,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Botones de Capítulos en Grid Responsivo
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final double totalWidth = constraints.maxWidth;
                        final double buttonWidth = (totalWidth - 16) / 2;
                        return ListView(
                          physics: const BouncingScrollPhysics(),
                          children: [
                            Wrap(
                              spacing: 16,
                              runSpacing: 16,
                              alignment: WrapAlignment.center,
                              children: [
                                _buildStoryButton(buttonWidth, 'magic_in_danger'.tr, const Color(0xFF69F0AE), () {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => const Cap1Screen()));
                                }),
                                _buildStoryButton(buttonWidth, 'the_first_fragment'.tr, const Color(0xFF40C4FF), () {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => const Cap2Screen()));
                                }),
                                _buildStoryButton(buttonWidth, 'the_clock'.tr, const Color(0xFFFFD93D), () {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => const Cap3Screen()));
                                }),
                                _buildStoryButton(buttonWidth, 'the_hidden_truth'.tr, const Color(0xFFFF8E53), () {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => const Cap4Screen()));
                                }),
                                _buildStoryButton(buttonWidth, 'the_last_path'.tr, const Color(0xFFFF6B6B), () {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => const Cap5Screen()));
                                }),
                                _buildStoryButton(buttonWidth, 'final'.tr, const Color(0xFFE040FB), () {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => const Cap6Screen()));
                                }),
                                _buildStoryButton(totalWidth, 'final_2'.tr, const Color(0xFF7C4DFF), () {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => const Cap7Screen()));
                                }),
                              ],
                            ),
                            const SizedBox(height: 20),
                          ],
                        );
                      },
                    ),
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
        child: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildStoryButton(double width, String text, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: 90,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withValues(alpha: 0.25),
              color.withValues(alpha: 0.15),
            ],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: color.withValues(alpha: 0.5),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          text.toUpperCase(),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
            shadows: [
              Shadow(
                color: Colors.black38,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}