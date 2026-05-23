import 'package:flutter/material.dart';
import '../../utils/local_storage_helper.dart';
import 'level_map.dart';

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
              'assets/images/fondoniveles.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Overlay mágico oscuro
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF1A0B2E).withValues(alpha: 0.85),
                    const Color(0xFF2D1B4E).withValues(alpha: 0.75),
                    const Color(0xFF4A1D6D).withValues(alpha: 0.65),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icono mágico
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD93D).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFFFD93D).withValues(alpha: 0.4),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                const Color(0xFFFFD93D).withValues(alpha: 0.2),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.auto_stories_rounded,
                        color: Color(0xFFFFD93D),
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Card del Lore (Glassmorphism)
                    Container(
                      padding: const EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFF4A1D6D).withValues(alpha: 0.45),
                            const Color(0xFF2D1B4E).withValues(alpha: 0.35),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Text(
                        "En una aldea mágica llena de perritos y gatitos mágicos, Iker protegía el equilibrio entre el bien y el mal usando las Esferas de Lunaris.\n\n"
                        "Pero una noche, cuando Iker y sus amigos estaban divirtiéndose, Molly robó las esferas y las rompió en cientos de fragmentos ocultándolos por toda la aldea.\n\n"
                        "Desde entonces, Iker se debilita poco a poco, ya que las esferas controlaban su energía vital. Sin ellas, Iker podría morir.\n\n"
                        "Ahora él y sus amigos recorren distintos lugares buscando los objetos brillantes en los que se transformaron los fragmentos.\n\n"
                        "Si no logran recuperarlos antes que Molly… la oscuridad consumirá la aldea para siempre.\n\n"
                        "Nota:\n"
                        "Tu misión es recolectar los objetos que Lunaris te pida. Salva a Iker y a su aldea antes de que sea tarde.",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          height: 1.6,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.4,
                          shadows: [
                            Shadow(
                              blurRadius: 4.0,
                              color: Colors.black38,
                              offset: Offset(0.0, 1.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),

                    // Botón "Comenzar aventura"
                    _PlayButton(
                      onTap: () async {
                        await LocalStorageHelper.setSeenStory(true);
                        if (context.mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const Levelmap()),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayButton extends StatefulWidget {
  final VoidCallback onTap;

  const _PlayButton({required this.onTap});

  @override
  State<_PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<_PlayButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 0.92).animate(_scaleController);
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _scaleController.forward(),
      onTapUp: (_) => _scaleController.reverse(),
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: 250,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
              colors: [Color(0xFFE040FB), Color(0xFF7C4DFF)],
            ),
            border: Border.all(
              color: const Color(0xFFFFD740).withValues(alpha: 0.8),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFE040FB).withValues(alpha: 0.6),
                blurRadius: 16,
                spreadRadius: 2,
              ),
              BoxShadow(
                color: const Color(0xFFFFD740).withValues(alpha: 0.3),
                blurRadius: 24,
                spreadRadius: 1,
              ),
            ],
          ),
          child: const Center(
            child: Text(
              "Comenzar aventura",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                shadows: [
                  Shadow(
                    color: Colors.black45,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
