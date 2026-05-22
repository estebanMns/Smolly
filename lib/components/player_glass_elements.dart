// lib/components/player_glass_elements.dart
// Responsabilidad: Widgets de estilo "vidrio" (glassmorphism) reutilizables
// en la pantalla de perfil del jugador.

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:juego_movil/config/app_colors.dart';

// ---------------------------------------------------------------------------
// Tarjeta de vidrio con blur
// ---------------------------------------------------------------------------

class PlayerGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;

  const PlayerGlassCard({super.key, required this.child, this.padding, this.color});

  @override
  Widget build(BuildContext context) {
    final hasColor = color != null;
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: hasColor
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      color!.withValues(alpha: 0.25),
                      color!.withValues(alpha: 0.15),
                    ],
                  )
                : null,
            color: hasColor ? null : AppColors.surface,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: hasColor ? color!.withValues(alpha: 0.5) : AppColors.border,
              width: hasColor ? 1.5 : 1.0,
            ),
            boxShadow: hasColor
                ? [
                    BoxShadow(
                      color: color!.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: child,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Chip de vidrio (etiqueta pequeña)
// ---------------------------------------------------------------------------

/// Pequeña etiqueta pill con fondo semitransparente.
class PlayerGlassChip extends StatelessWidget {
  final Widget child;

  const PlayerGlassChip({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceStrong,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}

// ---------------------------------------------------------------------------
// Botón circular de vidrio con ícono
// ---------------------------------------------------------------------------

/// Botón circular con efecto glassmorphism y un ícono centrado.
class PlayerGlassButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const PlayerGlassButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}