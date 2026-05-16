import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuItemData {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const MenuItemData({required this.label, required this.icon, required this.color, required this.onTap});
}

class CenterMenuIcons extends StatelessWidget {
  final VoidCallback onCharacterTap, onShopTap, onRewardsTap, onAchievementsTap, onStoryTap;

  const CenterMenuIcons({
    super.key, required this.onCharacterTap, required this.onShopTap, 
    required this.onRewardsTap, required this.onAchievementsTap, required this.onStoryTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = (screenWidth - 48) / 3;

    final menuItems = [
      MenuItemData(label: 'story'.tr, icon: Icons.auto_stories_rounded, color: const Color(0xFF40C4FF), onTap: onStoryTap),
      MenuItemData(label: 'characters'.tr, icon: Icons.people_rounded, color: const Color(0xFFE040FB), onTap: onCharacterTap),
      MenuItemData(label: 'achievements'.tr, icon: Icons.emoji_events_rounded, color: const Color(0xFFFFD740), onTap: onAchievementsTap),
      MenuItemData(label: 'rewards'.tr, icon: Icons.card_giftcard_rounded, color: const Color(0xFF69F0AE), onTap: onRewardsTap),
      MenuItemData(label: 'shop'.tr, icon: Icons.storefront_rounded, color: const Color(0xFFFF6D00), onTap: onShopTap),
      MenuItemData(label: 'collection'.tr, icon: Icons.collections_bookmark_rounded, color: const Color(0xFFEA80FC), onTap: () {}),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 12, runSpacing: 12,
        children: menuItems.map((item) => SizedBox(
          width: buttonWidth > 100 ? 100 : buttonWidth,
          child: MenuIconButton(item: item),
        )).toList(),
      ),
    );
  }
}

class MenuIconButton extends StatefulWidget {
  final MenuItemData item;
  const MenuIconButton({super.key, required this.item});
  @override
  State<MenuIconButton> createState() => _MenuIconButtonState();
}

class _MenuIconButtonState extends State<MenuIconButton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 120));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.88).animate(_controller);
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTap: widget.item.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          height: 85,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.black.withValues(alpha: 0.6),
            border: Border.all(color: widget.item.color.withValues(alpha: 0.7), width: 2),
            boxShadow: [BoxShadow(color: widget.item.color.withValues(alpha: 0.2), blurRadius: 8)],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.item.icon, color: widget.item.color, size: 28),
              const SizedBox(height: 4),
              Text(widget.item.label.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 1)),
            ],
          ),
        ),
      ),
    );
  }
}