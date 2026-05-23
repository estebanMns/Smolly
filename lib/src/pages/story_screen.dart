import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'lobby_screen.dart';

class StoryScreen extends StatelessWidget {
  const StoryScreen({super.key});

  Future<void> _completeStoryIntro(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen_intro_story', true);
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Lobby()),
      );
    }
  }

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
                    const Color(0xFF13172E).withValues(alpha: 0.8),
                    const Color(0xFF1F1135).withValues(alpha: 0.75),
                    const Color(0xFF381554).withValues(alpha: 0.65),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Título
                const Text(
                  'HISTORIA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                    shadows: [
                      Shadow(
                        blurRadius: 15,
                        color: Color(0xFFFFA776),
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Lore text card
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Container(
                      padding: const EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFF13172E).withValues(alpha: 0.85),
                            const Color(0xFF1F1135).withValues(alpha: 0.75),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: const Color(0xFF5C93FC).withValues(alpha: 0.4),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF5C93FC).withValues(alpha: 0.25),
                            blurRadius: 20,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.auto_awesome,
                                  color: Color(0xFFFFA776),
                                  size: 24,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "EL ROBO DE MOLLY",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "En una aldea mágica llena de perritos y gatitos mágicos, Iker protegía el equilibrio entre el bien y el mal usando las Esferas de Lunaris.\n\n"
                              "Pero una noche, cuando Iker y sus amigos estaban divirtiéndose, Molly robó las esferas y las rompió en cientos de fragmentos ocultándolos por toda la aldea.\n\n"
                              "Desde entonces, Iker se debilita poco a poco, ya que las esferas controlaban su energía vital. Sin ellas, Iker podría morir.\n\n"
                              "Ahora él y sus amigos recorren distintos lugares buscando los objetos brillantes en los que se transformaron los fragmentos.\n\n"
                              "Si no logran recuperarlos antes que Molly… la oscuridad consumirá la aldea para siempre.\n\n"
                              "Nota:\n"
                              "Tu misión es recolectar los objetos que Lunaris te pida. Salva a Iker y a su aldea antes de que sea tarde.",
                              style: TextStyle(
                                color: Colors.white90,
                                fontSize: 14.5,
                                height: 1.6,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Botón "Comenzar aventura"
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton(
                      onPressed: () => _completeStoryIntro(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFA776),
                        foregroundColor: const Color(0xFF13142B),
                        elevation: 10,
                        shadowColor: const Color(0xFFFFA776).withValues(alpha: 0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        side: const BorderSide(
                          color: Colors.white70,
                          width: 1.5,
                        ),
                      ),
                      child: const Text(
                        "Comenzar aventura",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
