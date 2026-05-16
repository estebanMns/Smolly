import 'package:flutter/material.dart';
import '../../models/character_model.dart';
import '../../components/characters/character_card.dart';
import '../../components/characters/galactic_background.dart';
import '../../config/app_colors.dart';
import 'package:get/get.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({super.key});
  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController(viewportFraction: 0.80);
  int _currentPage = 0;
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  final List<Character> characters = [
    Character(name: 'Iker', image: 'assets/images/iker.jpeg', role: 'main_character'.tr, description: 'iker_desc'.tr),
    Character(name: 'Kovu', image: 'assets/images/kovu.jpeg', role: 'space_warrior'.tr, description: 'kovu_desc'.tr),
    Character(name: 'Horus', image: 'assets/images/horus.jpeg', role: 'quantum_master'.tr, description: 'horus_desc'.tr),
    Character(name: 'Matias', image: 'assets/images/perroblanco.png', role: 'neural_navigator'.tr, description: 'matias_desc'.tr),
    Character(name: 'Molly', image: 'assets/images/molly.jpeg', role: 'dark_renegade'.tr, description: 'molly_desc'.tr),
  ];

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(duration: const Duration(seconds: 2), vsync: this)..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(CurvedAnimation(parent: _glowController, curve: Curves.easeInOut));
    _pageController.addListener(() => setState(() => _currentPage = _pageController.page?.round() ?? 0));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          GalacticBackground(screenSize: size),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 56),
                _buildTitle(),
                const SizedBox(height: 20),
                _buildCarousel(),
                const Spacer(),
                _buildDots(),
                const SizedBox(height: 12),
              ],
            ),
          ),
          _buildBackButton(),
        ],
      ),
    );
  }

  Widget _buildCarousel() {
    return Expanded(
      child: PageView.builder(
        controller: _pageController,
        itemCount: characters.length,
        itemBuilder: (context, index) => AnimatedScale(
          scale: index == _currentPage ? 1.0 : 0.88,
          duration: const Duration(milliseconds: 350),
          child: CharacterCard(
            character: characters[index],
            isCurrent: index == _currentPage,
            imageH: 300, imageW: 240, // Tamaños fijos para limpiar el código
            glowAnimation: _glowAnimation,
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: AppColors.charTitleBorder.withValues(alpha: 0.7), width: 1.5),
        gradient: const LinearGradient(colors: [AppColors.charTitleBg1, AppColors.charTitleBg2]),
      ),
      child: Text('characters_caps'.tr, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 5, color: Colors.white)),
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(characters.length, (i) => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: i == _currentPage ? 28 : 8,
        height: 8,
        decoration: BoxDecoration(color: i == _currentPage ? AppColors.charGlowSecondary : Colors.white24, borderRadius: BorderRadius.circular(4)),
      )),
    );
  }

  Widget _buildBackButton() {
    return Positioned(
      top: 50, left: 16,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
        ),
      ),
    );
  }
}