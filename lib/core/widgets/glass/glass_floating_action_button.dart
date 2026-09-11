import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/glass_tokens.dart';
import 'glass_surface.dart';

class GlassFloatingActionButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onPressed;
  final String? label;
  final Color? tintColor;
  final bool isExtended;

  const GlassFloatingActionButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.label,
    this.tintColor,
    this.isExtended = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.primaryLight : AppColors.primary;
    final buttonTint = tintColor ?? primary.withValues(alpha: isDark ? 0.90 : 0.92);

    final effectiveBorder = isDark
        ? AppColors.primaryLight.withValues(alpha: 0.50)
        : Colors.white.withValues(alpha: 0.35);

    if (isExtended && label != null) {
      return GlassSurface(
        depthLevel: GlassDepthLevel.floating,
        borderRadius: BorderRadius.circular(GlassTokens.radiusPill),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        tintColor: buttonTint,
        borderColor: effectiveBorder,
        onTap: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconTheme(
              data: const IconThemeData(color: Colors.white, size: 20),
              child: icon,
            ),
            const SizedBox(width: 8),
            Text(
              label!,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      );
    }

    return GlassSurface(
      depthLevel: GlassDepthLevel.floating,
      width: 56,
      height: 56,
      borderRadius: BorderRadius.circular(GlassTokens.radiusPill),
      tintColor: buttonTint,
      borderColor: effectiveBorder,
      onTap: onPressed,
      child: Center(
        child: IconTheme(
          data: const IconThemeData(color: Colors.white, size: 24),
          child: icon,
        ),
      ),
    );
  }
}
