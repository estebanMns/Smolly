// lib/components/player_stats_widgets.dart
// Responsabilidad: Widgets de UI que muestran las estadísticas,
// el avatar y la barra de progreso del jugador.

import 'package:flutter/material.dart';
import 'package:juego_movil/config/app_colors.dart';
import 'player_glass_elements.dart';
import '../utils/avatar_helper.dart';

// ---------------------------------------------------------------------------
// Avatar del jugador con badge de nivel
// ---------------------------------------------------------------------------

/// Muestra el avatar circular del jugador con un anillo de luz
/// y un chip con el nivel actual.
class PlayerAvatar extends StatelessWidget {
  final String avatarUrl;
  final int level;
  final VoidCallback? onTap;
  final VoidCallback? onPencilTap;

  const PlayerAvatar({
    super.key,
    required this.avatarUrl,
    required this.level,
    this.onTap,
    this.onPencilTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.cyan.withValues(alpha: 0.5),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cyan.withValues(alpha: 0.2),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: CircleAvatar(
              backgroundImage: getAvatarImageProvider(avatarUrl),
              backgroundColor: Colors.white10,
            ),
          ),
          Positioned(
            bottom: 0,
            child: PlayerGlassChip(
              child: Text(
                'LVL $level',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          if (onTap != null || onPencilTap != null)
            Positioned(
              right: 5,
              bottom: 30,
              child: GestureDetector(
                onTap: onPencilTap ?? onTap,
                child: Container(
                  padding: const EdgeInsets.all(6), // Un poco más de padding
                  decoration: const BoxDecoration(
                    color: AppColors.cyan,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black45, blurRadius: 4, offset: Offset(0, 2)),
                    ],
                  ),
                  child: const Icon(Icons.edit, size: 16, color: Colors.black),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tarjeta de progreso de nivel / experiencia
// ---------------------------------------------------------------------------

/// Muestra la barra de progreso de XP hacia el siguiente nivel.
class PlayerLevelProgressCard extends StatelessWidget {
  final int xp;
  final int nextLevel;

  const PlayerLevelProgressCard({
    super.key,
    required this.xp,
    required this.nextLevel,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = (xp / nextLevel).clamp(0.0, 1.0);

    return PlayerGlassCard(
      color: AppColors.cyan,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'EXP PROGRESO',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 10,
                  letterSpacing: 1,
                ),
              ),
              Text(
                '$xp / $nextLevel',
                style: const TextStyle(
                  color: AppColors.cyan,
                  fontSize: 10,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white10,
            color: AppColors.cyan,
            borderRadius: BorderRadius.circular(10),
            minHeight: 8,
          ),
          const SizedBox(height: 4),
          Text(
            '${(progress * 100).toStringAsFixed(1)}% para el siguiente nivel',
            style: const TextStyle(color: AppColors.textMuted, fontSize: 8),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Grid de estadísticas
// ---------------------------------------------------------------------------

/// Muestra una fila con tres estadísticas: precisión, scans y niveles.
class PlayerStatsGrid extends StatelessWidget {
  final double accuracy;
  final int totalScans;
  final int dogs;

  const PlayerStatsGrid({
    super.key,
    required this.accuracy,
    required this.totalScans,
    required this.dogs,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatItem(
            label: 'PRECISIÓN',
            value: '$accuracy%',
            color: AppColors.accuracy,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatItem(
            label: 'SCANS',
            value: '$totalScans',
            color: AppColors.purple3,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatItem(
            label: 'LEVELS',
            value: '$dogs',
            color: AppColors.gold,
          ),
        ),
      ],
    );
  }
}

/// Ítem individual dentro del grid de estadísticas.
class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return PlayerGlassCard(
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: color,
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
              shadows: [
                Shadow(color: color.withValues(alpha: 0.5), blurRadius: 10),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 8,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
