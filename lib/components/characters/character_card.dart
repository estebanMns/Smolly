import 'package:flutter/material.dart';
import '../../models/character_model.dart';

class CharacterCard extends StatelessWidget {
  final Character character;
  final bool isCurrent;
  final double imageH;
  final double imageW;
  final Animation<double> glowAnimation;
  final Color accentColor;

  const CharacterCard({
    super.key,
    required this.character,
    required this.isCurrent,
    required this.imageH,
    required this.imageW,
    required this.glowAnimation,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildImageWithGlow(),
        const SizedBox(height: 14),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    accentColor.withValues(alpha: 0.25),
                    accentColor.withValues(alpha: 0.15),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: accentColor.withValues(alpha: 0.5),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildName(),
                    const SizedBox(height: 8),
                    _buildRoleBadge(),
                    const SizedBox(height: 12),
                    _buildDescription(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageWithGlow() {
    return AnimatedBuilder(
      animation: glowAnimation,
      builder: (_, _) => Container(
        width: imageW,
        height: imageH,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: isCurrent ? accentColor : Colors.white.withValues(alpha: 0.15),
            width: isCurrent ? 2.5 : 1.5,
          ),
          boxShadow: isCurrent ? [
            BoxShadow(
              color: accentColor.withValues(alpha: 0.6 * glowAnimation.value),
              blurRadius: 30,
              spreadRadius: 4,
            ),
          ] : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: Image.asset(character.image, fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _buildName() {
    return ShaderMask(
      shaderCallback: (rect) => LinearGradient(
        colors: [const Color(0xFFE0C3FF), accentColor],
      ).createShader(rect),
      child: Text(
        character.name,
        style: const TextStyle(fontSize: 26.0, fontWeight: FontWeight.w900, color: Colors.white),
      ),
    );
  }

  Widget _buildRoleBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accentColor.withValues(alpha: 0.4)),
      ),
      child: Text(
        character.role,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
      ),
    );
  }

  Widget _buildDescription() {
    return Text(
      character.description,
      textAlign: TextAlign.center,
      style: const TextStyle(color: Colors.white70, fontSize: 13.0, height: 1.4),
    );
  }
}