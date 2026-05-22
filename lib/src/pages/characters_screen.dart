import 'package:flutter/material.dart';
import '../../models/character_model.dart';
import 'package:get/get.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({super.key});

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  int _currentPage = 0;
  late final AnimationController _glowController;
  late final Animation<double> _glowAnimation;

  final List<Character> characters = [
    Character(
      name: 'Iker',
      image: 'assets/images/iker.jpeg',
      role: 'role_iker'.tr,
      description: 'desc_iker'.tr,
    ),
    Character(
      name: 'Kovu',
      image: 'assets/images/kovu.jpeg',
      role: 'role_kovu'.tr,
      description: 'desc_kovu'.tr,
    ),
    Character(
      name: 'Perro Blanco',
      image: 'assets/images/perroblanco.png',
      role: 'role_perroblanco'.tr,
      description: 'desc_perroblanco'.tr,
    ),
    Character(
      name: 'Horus',
      image: 'assets/images/horus.jpeg',
      role: 'role_horus'.tr,
      description: 'desc_horus'.tr,
    ),
    Character(
      name: 'Molly',
      image: 'assets/images/molly.jpeg',
      role: 'role_molly'.tr,
      description: 'desc_molly'.tr,
    ),
  ];

  final List<Color> characterColors = [
    const Color(0xFF40C4FF), // Iker - Cyan
    const Color(0xFFFF8E53), // Kovu - Orange
    const Color(0xFF69F0AE), // Perro Blanco - Green
    const Color(0xFFFFD93D), // Horus - Gold
    const Color(0xFFFF4081), // Molly - Pink
  ];

  @override
  void initState() {
    super.initState();
    // Use viewportFraction 0.55 to make adjacent items partially visible
    _pageController = PageController(viewportFraction: 0.55);
    
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _glowAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _pageController.addListener(() {
      if (_pageController.hasClients) {
        final newPage = _pageController.page?.round() ?? 0;
        if (newPage != _currentPage && newPage >= 0 && newPage < characters.length) {
          setState(() {
            _currentPage = newPage;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/personajes.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Deep Purple Overlay to matching other screens
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF0F0720).withValues(alpha: 0.85),
                    const Color(0xFF1B0F33).withValues(alpha: 0.75),
                    const Color(0xFF2D164B).withValues(alpha: 0.65),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Safe Header Row (Back Button & Title Pill)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    children: [
                      _buildBackButton(context),
                      Expanded(
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E294B).withValues(alpha: 0.85),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.15),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Text(
                              'characters_caps'.tr.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Symmetric space to center title perfectly
                      const SizedBox(width: 45),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Image Carousel (takes up a fixed proportion or remaining height)
                _buildCarousel(),
                
                const SizedBox(height: 12),
                
                // Dots indicator
                _buildDots(),
                
                const SizedBox(height: 16),
                
                // Active Character description card
                _buildDescriptionCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.3),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.25),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Center(
          child: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildCarousel() {
    return SizedBox(
      height: 250, // Bounded height to ensure no vertical viewport unbound exceptions
      child: PageView.builder(
        controller: _pageController,
        itemCount: characters.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _pageController,
            builder: (context, child) {
              double value = 1.0;
              if (_pageController.position.haveDimensions) {
                value = (_pageController.page! - index);
                value = (1 - (value.abs() * 0.18)).clamp(0.0, 1.0);
              } else {
                value = index == _currentPage ? 1.0 : 0.82;
              }
              
              final double scale = value;
              final double opacity = index == _currentPage ? 1.0 : 0.45;

              return Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: opacity,
                  child: child,
                ),
              );
            },
            child: _buildImageCard(index),
          );
        },
      ),
    );
  }

  Widget _buildImageCard(int index) {
    final character = characters[index];
    final color = characterColors[index];
    final isActive = index == _currentPage;

    return Center(
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return Container(
            width: 180,
            height: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isActive ? color : Colors.white.withValues(alpha: 0.25),
                width: isActive ? 3.0 : 1.5,
              ),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.6 * _glowAnimation.value),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ]
                  : [],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(21),
              child: Image.asset(
                character.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade900,
                    child: const Icon(Icons.person, color: Colors.white, size: 50),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(characters.length, (i) {
        final isActive = i == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? characterColors[i] : Colors.white.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: characterColors[i].withValues(alpha: 0.5),
                      blurRadius: 6,
                    ),
                  ]
                : [],
          ),
        );
      }),
    );
  }

  Widget _buildDescriptionCard() {
    final character = characters[_currentPage];
    final color = characterColors[_currentPage];

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: color.withValues(alpha: 0.5),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.15),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  ShaderMask(
                    shaderCallback: (rect) => LinearGradient(
                      colors: [const Color(0xFFFFFFFF), color],
                    ).createShader(rect),
                    child: Text(
                      character.name.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: color.withValues(alpha: 0.4),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      character.role.toUpperCase(),
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    character.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14.5,
                      height: 1.6,
                    ),
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