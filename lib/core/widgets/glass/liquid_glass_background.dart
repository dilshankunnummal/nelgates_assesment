import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Premium ambient background that gives True Liquid Glass components
/// depth and optical refraction.
///
/// NOTE: Gradients are strictly allowed ONLY in this root background layer.
class LiquidGlassBackground extends StatelessWidget {
  final Widget child;
  final bool showAmbientOrbs;

  const LiquidGlassBackground({
    super.key,
    required this.child,
    this.showAmbientOrbs = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Neutral base colors
    final baseColor = isDark ? const Color(0xFF020408) : AppColors.lightBackground;
    final secondaryBase = isDark ? const Color(0xFF070B14) : const Color(0xFFF1F5F9);

    // Ambient orb colors (subtle, non-neon, elegant neutral tones)
    final orb1Color = isDark
        ? const Color(0xFF0D9488).withValues(alpha: 0.28) // Luxury emerald-teal
        : const Color(0xFFCBD5E1).withValues(alpha: 0.40);
    final orb2Color = isDark
        ? const Color(0xFF3B82F6).withValues(alpha: 0.24) // Royal sapphire
        : const Color(0xFFE2E8F0).withValues(alpha: 0.50);
    final orb3Color = isDark
        ? const Color(0xFFD97706).withValues(alpha: 0.18) // Warm amber gold
        : const Color(0xFFF1F5F9).withValues(alpha: 0.30);

    return Container(
      color: baseColor,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Soft neutral background gradient (Allowed ONLY here)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [baseColor, secondaryBase],
              ),
            ),
          ),

          // 2. Ambient blurred optical shapes for glass refraction
          if (showAmbientOrbs) ...[
            // Top-right ambient orb
            Positioned(
              top: -60,
              right: -80,
              child: Container(
                width: 360,
                height: 360,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: orb1Color,
                ),
              ),
            ),
            // Center-left ambient orb
            Positioned(
              top: 320,
              left: -120,
              child: Container(
                width: 380,
                height: 380,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: orb2Color,
                ),
              ),
            ),
            // Bottom-right ambient orb
            Positioned(
              bottom: -40,
              right: -60,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: orb3Color,
                ),
              ),
            ),
            // Deep smooth diffusion blur for ambient orbs
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 75, sigmaY: 75),
              child: const SizedBox.expand(),
            ),
          ],

          // 3. Child application content
          child,
        ],
      ),
    );
  }
}
