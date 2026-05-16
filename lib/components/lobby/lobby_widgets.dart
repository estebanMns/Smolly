import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../player_profile_controller.dart';
import '../avatar_picker_sheet.dart';

// --- HUD SUPERIOR ---
class TopHud extends StatelessWidget {
  final Animation<double> floatAnimation;
  final VoidCallback onAvatarTap;
  const TopHud({super.key, required this.floatAnimation, required this.onAvatarTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedBuilder(
          animation: floatAnimation,
          builder: (_, _) => Transform.translate(
            offset: Offset(0, floatAnimation.value * 0.3),
            child: GestureDetector(
              onTap: onAvatarTap,
              child: _AvatarDisplay(),
            ),
          ),
        ),
        const SizedBox(width: 10),
        const _PlayerInfoDisplay(),
        const Spacer(),
        const _HudBadge(icon: Icons.stars_rounded, value: '120', color: Color(0xFFFFD740)),
        const SizedBox(width: 10),
        const _HudBadge(icon: Icons.rocket_launch_rounded, value: 'Lv.3', color: Color(0xFF69F0AE)),
      ],
    );
  }
}

class _AvatarDisplay extends StatelessWidget {
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
              border: Border.all(color: const Color(0xFFE040FB), width: 2.5),
              boxShadow: [
                BoxShadow(
                    color: const Color(0xFFE040FB).withValues(alpha: 0.6),
                    blurRadius: 12,
                    spreadRadius: 2)
              ],
            ),
            child: CircleAvatar(
              radius: 26,
              backgroundImage: NetworkImage(
                avatarUrl.startsWith('http') ? avatarUrl : 'https://tvjdkuitdsmqiyymzjto.supabase.co/storage/v1/object/public/avatares/kobu.jpeg',
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
                  color: Color(0xFF00E5FF),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
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

class _PlayerInfoDisplay extends StatelessWidget {
  const _PlayerInfoDisplay();
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PlayerProfileController>();

    return Obx(() {
      final username = controller.player.value?.username ?? 'pilot'.tr;
      final rank = controller.player.value?.rank ?? 'explorer'.tr;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(username.toUpperCase(),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2)),
          Text(rank.toUpperCase(),
              style: const TextStyle(
                  color: Color(0xFFCE93D8), fontSize: 10, letterSpacing: 1.5)),
        ],
      );
    });
  }
}

class _HudBadge extends StatelessWidget {
  final IconData icon; final String value; final Color color;
  const _HudBadge({required this.icon, required this.value, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.black.withValues(alpha: 0.45),
        border: Border.all(color: color.withValues(alpha: 0.6), width: 1.3),
      ),
      child: Row(children: [Icon(icon, color: color, size: 17), const SizedBox(width: 5), Text(value, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.bold))]),
    );
  }
}

// --- BOTÓN PLAY ---
class PlayButton extends StatefulWidget {
  final double glowRadius; final VoidCallback onTap;
  const PlayButton({super.key, required this.glowRadius, required this.onTap});
  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> with SingleTickerProviderStateMixin {
  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(vsync: this, duration: const Duration(milliseconds: 120));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.90).animate(_scaleController);
  }
  @override
  void dispose() { _scaleController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _scaleController.forward(),
      onTapUp: (_) => _scaleController.reverse(),
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: 200, height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            gradient: const LinearGradient(colors: [Color(0xFFE040FB), Color(0xFF7C4DFF)]),
            boxShadow: [BoxShadow(color: const Color(0xFFE040FB).withValues(alpha: 0.65), blurRadius: widget.glowRadius, spreadRadius: 2)],
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.rocket_launch, color: Colors.white, size: 24), const SizedBox(width: 10), Text('play'.tr, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 4))]),
        ),
      ),
    );
  }
}

// --- NAV INFERIOR ---
class BottomNavigationCustom extends StatelessWidget {
  final VoidCallback onSettingsTap;
  const BottomNavigationCustom({super.key, required this.onSettingsTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 16, top: 16, left: 40, right: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _BottomNavItem(icon: Icons.settings_rounded, label: 'settings_nav'.tr, color: const Color(0xFF69F0AE), onTap: onSettingsTap),
          _BottomNavItem(icon: Icons.help_outline_rounded, label: 'help_nav'.tr, color: const Color(0xFF40C4FF), onTap: () {}),
        ],
      ),
    );
  }
}

class _BottomNavItem extends StatefulWidget {
  final IconData icon; final String label; final Color color; final VoidCallback onTap;
  const _BottomNavItem({required this.icon, required this.label, required this.color, required this.onTap});
  @override
  State<_BottomNavItem> createState() => _BottomNavItemState();
}

class _BottomNavItemState extends State<_BottomNavItem> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.90).animate(_controller);
  }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(shape: BoxShape.circle, color: widget.color.withValues(alpha: 0.15)), child: Icon(widget.icon, color: widget.color, size: 26)),
          Text(widget.label, style: TextStyle(color: widget.color, fontSize: 11)),
        ]),
      ),
    );
  }
}