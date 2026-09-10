import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/glass_tokens.dart';
import 'glass_surface.dart';

/// Floating circular or rounded liquid glass icon button.
class GlassIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onPressed;
  final double size;
  final String? tooltip;
  final Color? iconColor;
  final Color? tintColor;
  final Color? borderColor;
  final bool isCircle;

  const GlassIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 42,
    this.tooltip,
    this.iconColor,
    this.tintColor,
    this.borderColor,
    this.isCircle = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultIconColor = iconColor ??
        (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary);

    final effectiveBorderRadius = isCircle
        ? BorderRadius.circular(GlassTokens.radiusPill)
        : BorderRadius.circular(GlassTokens.radiusMd);

    Widget button = GlassSurface(
      depthLevel: GlassDepthLevel.floating,
      width: size,
      height: size,
      borderRadius: effectiveBorderRadius,
      tintColor: tintColor,
      borderColor: borderColor,
      onTap: onPressed,
      hasHighlight: true,
      child: Center(
        child: IconTheme(
          data: IconThemeData(
            color: defaultIconColor,
            size: size * 0.52,
          ),
          child: icon,
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: button);
    }

    return button;
  }
}
