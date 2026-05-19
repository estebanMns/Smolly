import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'login_screen.dart';

class Home extends StatelessWidget {
  const Home({super.key});
   // Cambiamos a Future<void> para poder esperar a que el audio inicie
  Future<void> _playHomeSound() async {
    final player = AudioPlayer();
    // Usamos await para asegurar que el comando de play se envíe correctamente
    await player.play(AssetSource('audio/Home.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/fondoinicial.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.35,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.65),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.055),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.015),
                    child: Icon(
                      i == 2 ? Icons.auto_awesome : Icons.star_rounded,
                      color: i == 2
                          ? const Color(0xFFFFE566)
                          : Colors.white.withValues(alpha: 0.6),
                      size: i == 2 ? screenWidth * 0.06 : screenWidth * 0.035,
                    ),
                  )),
                ),

                SizedBox(height: screenHeight * 0.008),

                Text(
                  'subtitle_home'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.032,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withValues(alpha: 0.85),
                    letterSpacing: 2.8,
                    shadows: const [
                      Shadow(color: Color(0xFFAA00FF), blurRadius: 12),
                    ],
                  ),
                ),

                SizedBox(height: screenHeight * 0.014),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      
                      Text(
                        'title_home'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth * 0.115,
                          fontWeight: FontWeight.w900,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 14
                            ..color = const Color(0xFF3D006E),
                          height: 1.1,
                          letterSpacing: 1.5,
                        ),
                      ),

                      Text(
                        'title_home'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth * 0.115,
                          fontWeight: FontWeight.w900,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 5
                            ..color = Colors.white.withValues(alpha: 0.9),
                          height: 1.1,
                          letterSpacing: 1.5,
                        ),
                      ),

                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            Color(0xFFFFFFCC),
                            Color(0xFFFFE566),
                            Color(0xFFFFD700),
                            Color(0xFFFFA500),
                            Color(0xFFFF8C00),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ).createShader(bounds),
                        child: Text(
                          'title_home'.tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: screenWidth * 0.115,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.1,
                            letterSpacing: 1.5,
                            shadows: const [
                              Shadow(
                                color: Color(0xFF2D0050),
                                blurRadius: 8,
                                offset: Offset(3, 5),
                              ),
                              Shadow(
                                color: Color(0xFFAA00FF),
                                blurRadius: 30,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenHeight * 0.045), 

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.15),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Login()),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.018,
                        horizontal: screenWidth * 0.08,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFFFE135),
                            Color(0xFFFFAB00),
                            Color(0xFFFF6F00),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.75),
                          width: 2.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFFAB00).withValues(alpha: 0.8),
                            blurRadius: 24,
                            spreadRadius: 4,
                            offset: const Offset(0, 4),
                          ),
                          BoxShadow(
                            color: const Color(0xFFFF6F00).withValues(alpha: 0.4),
                            blurRadius: 50,
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.play_circle_filled_rounded,
                            color: Colors.white,
                            size: 34,
                            shadows: [
                              Shadow(
                                color: Color(0xFF7F3500),
                                blurRadius: 4,
                                offset: Offset(1, 2),
                              ),
                            ],
                          ),
                          SizedBox(width: screenWidth * 0.03),
                          Text(
                            'start'.tr,
                            style: TextStyle(
                              fontSize: screenWidth * 0.075,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 4,
                              shadows: const [
                                Shadow(
                                  color: Color(0xFF7F3500),
                                  blurRadius: 6,
                                  offset: Offset(1, 3),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}