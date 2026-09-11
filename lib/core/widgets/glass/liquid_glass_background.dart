import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

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

    final baseColor = isDark ? const Color(0xFF020408) : AppColors.lightBackground;
    final secondaryBase = isDark ? const Color(0xFF070B14) : const Color(0xFFF1F5F9);

    final orb1Color = isDark
        ? const Color(0xFF0D9488).withValues(alpha: 0.28)
        : const Color(0xFFCBD5E1).withValues(alpha: 0.40);
    final orb2Color = isDark
        ? const Color(0xFF3B82F6).withValues(alpha: 0.24)
        : const Color(0xFFE2E8F0).withValues(alpha: 0.50);
    final orb3Color = isDark
        ? const Color(0xFFD97706).withValues(alpha: 0.18)
        : const Color(0xFFF1F5F9).withValues(alpha: 0.30);

    return Container(
      color: baseColor,
      child: Stack(
        fit: StackFit.expand,
        children: [

          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [baseColor, secondaryBase],
              ),
            ),
          ),

          if (showAmbientOrbs) ...[

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

            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 75, sigmaY: 75),
              child: const SizedBox.expand(),
            ),
          ],

          child,
        ],
      ),
    );
  }
}
