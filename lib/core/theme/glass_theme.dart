import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_radius.dart';
import 'glass_tokens.dart';

class GlassTheme {
  static const double blurStandard = GlassTokens.blurStandard;
  static const double blurSubtle = GlassTokens.blurSubtle;
  static const double blurDeep = GlassTokens.blurDeep;

  static const double opacityStandard = GlassTokens.lightSurfaceOpacityPrimary;
  static const double opacitySubtle = GlassTokens.lightSurfaceOpacitySecondary;
  static const double opacityIntense = 0.82;

  static const double borderOpacityStandard = GlassTokens.lightBorderOpacity;
  static const double borderOpacitySubtle = GlassTokens.darkBorderOpacity;

  static const double defaultRadius = AppRadius.lg;

  static Color surfaceColor(BuildContext context, {double? opacity, GlassDepthLevel level = GlassDepthLevel.card}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final op = opacity ?? GlassTokens.surfaceOpacity(context, level: level);
    return isDark
        ? AppColors.darkSurface.withValues(alpha: op)
        : AppColors.lightSurface.withValues(alpha: op);
  }

  static Color borderColor(BuildContext context, {double? opacity}) {
    return GlassTokens.borderColor(context, customOpacity: opacity);
  }

  static Color outlineBorderColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? const Color(0x33334155)
        : const Color(0x1A0F172A);
  }

  static Color highlightColor(BuildContext context) {
    return GlassTokens.highlightColor(context);
  }
}
