import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../utils/local_storage_helper.dart';

// REQUERIMIENTOS BACKEND (Controladores y Hojas de diálogo)
import '../../components/player_profile_controller.dart';
import '../../components/avatar_picker_sheet.dart';

// PANTALLAS DE NAVEGACIÓN DIRECTA
import 'player_profile_screen.dart';
import 'level_map.dart';
import 'characters_screen.dart' as local_characters;
import 'settings_screen.dart';
import 'shop_screen.dart';
import 'rewards_screen.dart';
import 'achievements.dart';
import 'story_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// MAIN LOBBY SCREEN (ORQUESTADOR PRINCIPAL)
// ─────────────────────────────────────────────────────────────────────────────
import '../../components/levels_controller.dart';
import '../../config/app_assets.dart';

class Lobby extends StatefulWidget {
  const Lobby({super.key});

  @override
  State<Lobby> createState() => _LobbyState();
}

class _LobbyState extends State<Lobby> with TickerProviderStateMixin {
  late final AnimationController _floatController;
  late final Animation<double> _floatAnimation;
  late final AnimationController _twinkleController;
  late final AnimationController _glowController;
  late final Animation<double> _glowAnimation;

  late final NavigationService _navigationService;
  late final AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _navigationService = NavigationService(context: context);
    Get.put(PlayerProfileController());
    Get.put(LevelsController());

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _twinkleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 6, end: 22).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _audioPlayer = AudioPlayer();
    _playLobbySong();
  }

  Future<void> _playLobbySong() async {
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(AssetSource(AppAssets.audioLobbySong));
  }

  Future<void> _navigateWithAudio(
    Future<void> Function() navigateAction,
  ) async {
    try {
      await _audioPlayer.pause();
    } catch (e) {
      debugPrint("AudioPlayer pause error: $e");
    }
    await navigateAction();
    // Reanudar la música cuando se regrese al Lobby
    try {
      await _audioPlayer.resume();
    } catch (e) {
      debugPrint("AudioPlayer resume error: $e");
    }
  }

  @override
  void dispose() {
    _floatController.dispose();
    _twinkleController.dispose();
    _glowController.dispose();
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const GalacticBackground(),
          StarField(controller: _twinkleController),
          TopHudSection(
            floatAnimation: _floatAnimation,
            onAvatarTap: () =>
                _navigateWithAudio(_navigationService.navigateToPlayerProfile),
          ),
          HeroSection(floatAnimation: _floatAnimation),
          CenterMenuSection(
            onCharacterTap: () =>
                _navigateWithAudio(_navigationService.navigateToCharacters),
            onShopTap: () =>
                _navigateWithAudio(_navigationService.navigateToShop),
            onAchievementsTap: () =>
                _navigateWithAudio(_navigationService.navigateToAchievements),
          ),
          PlayButtonSection(
            glowAnimation: _glowAnimation,
            onTap: () =>
                _navigateWithAudio(_navigationService.navigateToLevelMap),
          ),
          BottomNavigationSection(
            onSettingsTap: () =>
                _navigateWithAudio(_navigationService.navigateToSettings),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// NAVIGATION SERVICE (OOP - Gestión interna de rutas)
// ─────────────────────────────────────────────────────────────────────────────

class NavigationService {
  final BuildContext context;

  NavigationService({required this.context});

  Future<void> navigateToPlayerProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PlayerProfileScreen()),
    );
  }

  Future<void> navigateToLevelMap() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const Levelmap()),
    );
  }

  Future<void> navigateToCharacters() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const local_characters.CharactersScreen(),
      ),
    );
  }

  Future<void> navigateToSettings() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SettingsScreen()),
    );
  }

  Future<void> navigateToShop() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ShopScreen()),
    );
  }

  Future<void> navigateToRewards() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RewardsScreen()),
    );
  }

  Future<void> navigateToAchievements() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AchievementsScreen()),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BACKGROUND & PARTICLES
// ─────────────────────────────────────────────────────────────────────────────

class GalacticBackground extends StatelessWidget {
  const GalacticBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Image.asset(AppAssets.fondoLobby, fit: BoxFit.cover),
    );
  }
}

class StarField extends StatelessWidget {
  final AnimationController controller;
  const StarField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF13172E).withValues(alpha: 0.7),
              const Color(0xFF2F3E67).withValues(alpha: 0.55),
              const Color(0xFF60436D).withValues(alpha: 0.45),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TOP HUD SECTION (Conexión Supabase & GetX)
// ─────────────────────────────────────────────────────────────────────────────

class TopHudSection extends StatelessWidget {
  final Animation<double> floatAnimation;
  final VoidCallback onAvatarTap;

  const TopHudSection({
    super.key,
    required this.floatAnimation,
    required this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PlayerProfileController>();

    return Positioned(
      top: MediaQuery.of(context).padding.top + 12,
      left: 16,
      right: 16,
      child: Row(
        children: [
          AnimatedBuilder(
            animation: floatAnimation,
            builder: (_, _) => Transform.translate(
              offset: Offset(0, floatAnimation.value * 0.3),
              child: GestureDetector(
                onTap: onAvatarTap,
                child: const AvatarDisplay(),
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(child: PlayerInfoDisplay()),
          Obx(() {
            final coins = controller.player.value?.coins ?? 0;
            return HudBadge(
              icon: Icons.stars_rounded,
              value: '$coins',
              color: const Color(0xFFFFD740),
            );
          }),
          const SizedBox(width: 10),
          Obx(() {
            final level = controller.player.value?.level ?? 0;
            return HudBadge(
              icon: Icons.rocket_launch_rounded,
              value: 'Lv.$level',
              color: const Color(0xFF62C0E0),
            );
          }),
        ],
      ),
    );
  }
}

class AvatarDisplay extends StatelessWidget {
  const AvatarDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PlayerProfileController>();

    return Obx(() {
      final avatarUrl = controller.player.value?.avatarUrl ?? '';
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE097CC), width: 2.5),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE097CC).withValues(alpha: 0.6),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 26,
              backgroundImage: NetworkImage(
                avatarUrl.startsWith('http')
                    ? avatarUrl
                    : AppAssets.fallbackAvatarUrl,
              ),
            ),
          ),
          Positioned(
            right: -2,
            bottom: -2,
            child: GestureDetector(
              onTap: () => AvatarPickerSheet.show(context),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color(0xFF62C0E0),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.edit, size: 12, color: Colors.black),
              ),
            ),
          ),
        ],
      );
    });
  }
}

class PlayerInfoDisplay extends StatelessWidget {
  const PlayerInfoDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PlayerProfileController>();

    return Obx(() {
      final username = controller.player.value?.username ?? 'pilot'.tr;
      final rank = controller.player.value?.rank ?? 'explorer'.tr;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            username.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
          Text(
            rank.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFFCE93D8),
              fontSize: 10,
              letterSpacing: 1.5,
            ),
          ),
        ],
      );
    });
  }
}

class HudBadge extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color color;

  const HudBadge({
    super.key,
    required this.icon,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.black.withValues(alpha: 0.45),
        border: Border.all(color: color.withValues(alpha: 0.6), width: 1.3),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 17),
          const SizedBox(width: 5),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HERO SECTION (Título Reactivo Traducido)
// ─────────────────────────────────────────────────────────────────────────────

class HeroSection extends StatelessWidget {
  final Animation<double> floatAnimation;

  const HeroSection({super.key, required this.floatAnimation});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Positioned(
      top: screenSize.height * 0.12,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: floatAnimation,
        builder: (_, _) => Transform.translate(
          offset: Offset(0, floatAnimation.value),
          child: Column(
            children: [
              ClipOval(
                child: Image.network(
                  AppAssets.fallbackAvatarUrl,
                  width: 130,
                  height: 130,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.rocket_launch_rounded,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'title_login'.tr.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 5,
                  shadows: [
                    Shadow(
                      color: const Color(0xFFE097CC).withValues(alpha: 0.8),
                      blurRadius: 10,
                      offset: const Offset(0, 0),
                    ),
                    Shadow(
                      color: const Color(0xFF6286D1).withValues(alpha: 0.8),
                      blurRadius: 20,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CENTER MENU SECTION (Botones con soporte de idiomas .tr)
// ─────────────────────────────────────────────────────────────────────────────

class CenterMenuSection extends StatelessWidget {
  final VoidCallback onCharacterTap;
  final VoidCallback onShopTap;
  final VoidCallback onAchievementsTap;

  const CenterMenuSection({
    super.key,
    required this.onCharacterTap,
    required this.onShopTap,
    required this.onAchievementsTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final buttonWidth = (screenWidth - 64) / 2;

    final menuItems = [
      MenuItemData(
        label: 'characters'.tr,
        icon: Icons.people_rounded,
        color: const Color(0xFFE097CC),
        onTap: onCharacterTap,
      ),
      MenuItemData(
        label: 'achievements'.tr,
        icon: Icons.emoji_events_rounded,
        color: const Color(0xFF62C0E0),
        onTap: onAchievementsTap,
      ),
      MenuItemData(
        label: 'shop'.tr,
        icon: Icons.storefront_rounded,
        color: const Color(0xFFFD98C6),
        onTap: onShopTap,
      ),
    ];

    return Positioned(
      top: screenSize.height * 0.44,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 16,
          runSpacing: 16,
          children: menuItems
              .map(
                (item) => SizedBox(
                  width: buttonWidth > 150 ? 150 : buttonWidth,
                  child: MenuIconButton(item: item),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class MenuItemData {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const MenuItemData({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

class MenuIconButton extends StatefulWidget {
  final MenuItemData item;

  const MenuIconButton({super.key, required this.item});

  @override
  State<MenuIconButton> createState() => _MenuIconButtonState();
}

class _MenuIconButtonState extends State<MenuIconButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.88).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTap: widget.item.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF13172E).withValues(alpha: 0.8),
                const Color(0xFF1A152B).withValues(alpha: 0.75),
              ],
            ),
            border: Border.all(
              color: widget.item.color.withValues(alpha: 0.55),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.item.color.withValues(alpha: 0.35),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: widget.item.color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.item.color.withValues(alpha: 0.6),
                    width: 2,
                  ),
                ),
                child: Icon(
                  widget.item.icon,
                  color: widget.item.color,
                  size: 26,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.item.label.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.95),
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                  shadows: [
                    Shadow(
                      color: widget.item.color.withValues(alpha: 0.5),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PLAY BUTTON SECTION
// ─────────────────────────────────────────────────────────────────────────────

class PlayButtonSection extends StatelessWidget {
  final Animation<double> glowAnimation;
  final VoidCallback onTap;

  const PlayButtonSection({
    super.key,
    required this.glowAnimation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Positioned(
      bottom: screenSize.height * 0.18,
      left: 0,
      right: 0,
      child: Center(
        child: AnimatedBuilder(
          animation: glowAnimation,
          builder: (_, _) =>
              PlayButton(glowRadius: glowAnimation.value, onTap: onTap),
        ),
      ),
    );
  }
}

class PlayButton extends StatefulWidget {
  final double glowRadius;
  final VoidCallback onTap;

  const PlayButton({super.key, required this.glowRadius, required this.onTap});

  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton>
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
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.90,
    ).animate(_scaleController);
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
          width: 200,
          height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            gradient: const LinearGradient(
              colors: [Color(0xFF6286D1), Color(0xFFE097CC)],
            ),
            border: Border.all(
              color: const Color(0xFFFD98C6).withValues(alpha: 0.8),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6286D1).withValues(alpha: 0.6),
                blurRadius: widget.glowRadius,
                spreadRadius: 2,
              ),
              BoxShadow(
                color: const Color(0xFFE097CC).withValues(alpha: 0.4),
                blurRadius: widget.glowRadius * 1.5,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.rocket_launch, color: Colors.white, size: 24),
              const SizedBox(width: 10),
              Text(
                'play'.tr.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BOTTOM NAVIGATION SECTION
// ─────────────────────────────────────────────────────────────────────────────

class BottomNavigationSection extends StatelessWidget {
  final VoidCallback onSettingsTap;

  const BottomNavigationSection({super.key, required this.onSettingsTap});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 16,
          top: 16,
          left: 40,
          right: 40,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            BottomNavItem(
              icon: Icons.settings_rounded,
              label: 'settings_nav'.tr,
              color: const Color(0xFF62C0E0),
              onTap: onSettingsTap,
            ),
            BottomNavItem(
              icon: Icons.help_outline_rounded,
              label: 'help_nav'.tr,
              color: const Color(0xFFE097CC),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const BottomNavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  State<BottomNavItem> createState() => _BottomNavItemState();
}

class _BottomNavItemState extends State<BottomNavItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.90).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color.withValues(alpha: 0.15),
              ),
              child: Icon(widget.icon, color: widget.color, size: 26),
            ),
            Text(
              widget.label,
              style: TextStyle(color: widget.color, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
