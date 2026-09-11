import 'package:flutter/material.dart';

enum GlassDepthLevel {

  background,

  largeContainer,

  card,

  control,

  floating,
}

class GlassTokens {

  static const double blurSubtle = 16.0;
  static const double blurStandard = 24.0;
  static const double blurMedium = 28.0;
  static const double blurDeep = 36.0;
  static const double blurUltra = 44.0;

  static double blurForLevel(GlassDepthLevel level) {
    switch (level) {
      case GlassDepthLevel.background:
        return 0.0;
      case GlassDepthLevel.largeContainer:
        return blurMedium;
      case GlassDepthLevel.card:
        return blurStandard;
      case GlassDepthLevel.control:
        return blurSubtle;
      case GlassDepthLevel.floating:
        return blurDeep;
    }
  }

  static const double lightSurfaceOpacityPrimary = 0.35;
  static const double lightSurfaceOpacitySecondary = 0.22;
  static const double lightSurfaceOpacitySubtle = 0.12;

  static const Color darkGlassLargeContainer = Color(0xFF040711);
  static const Color darkGlassCard = Color(0xFF060A16);
  static const Color darkGlassControl = Color(0xFF090E1E);
  static const Color darkGlassFloating = Color(0xFF04060E);

  static const double darkSurfaceOpacityPrimary = 0.20;
  static const double darkSurfaceOpacitySecondary = 0.14;
  static const double darkSurfaceOpacitySubtle = 0.08;

  static Color darkSurfaceColor(GlassDepthLevel level, {double? adjustedOpacity}) {
    switch (level) {
      case GlassDepthLevel.background:
        return Colors.transparent;
      case GlassDepthLevel.largeContainer:
        return darkGlassLargeContainer.withValues(alpha: adjustedOpacity ?? darkSurfaceOpacitySecondary);
      case GlassDepthLevel.card:
        return darkGlassCard.withValues(alpha: adjustedOpacity ?? darkSurfaceOpacityPrimary);
      case GlassDepthLevel.control:
        return darkGlassControl.withValues(alpha: adjustedOpacity ?? 0.25);
      case GlassDepthLevel.floating:
        return darkGlassFloating.withValues(alpha: adjustedOpacity ?? 0.42);
    }
  }

  static double surfaceOpacity(BuildContext context, {GlassDepthLevel level = GlassDepthLevel.card}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      switch (level) {
        case GlassDepthLevel.background:
          return 0.0;
        case GlassDepthLevel.largeContainer:
          return darkSurfaceOpacitySecondary;
        case GlassDepthLevel.card:
          return darkSurfaceOpacityPrimary;
        case GlassDepthLevel.control:
          return 0.25;
        case GlassDepthLevel.floating:
          return 0.42;
      }
    } else {
      switch (level) {
        case GlassDepthLevel.background:
          return 0.0;
        case GlassDepthLevel.largeContainer:
          return lightSurfaceOpacitySecondary;
        case GlassDepthLevel.card:
          return lightSurfaceOpacityPrimary;
        case GlassDepthLevel.control:
          return lightSurfaceOpacitySecondary;
        case GlassDepthLevel.floating:
          return 0.65;
      }
    }
  }

  static const Color darkGlassBorder = Color(0xFF1E2A40);
  static const Color darkGlassBorderSubtle = Color(0xFF162032);
  static const double lightBorderOpacity = 0.45;
  static const double darkBorderOpacity = 0.80;
  static const double borderWidthHairline = 1.0;
  static const double borderWidthStandard = 1.2;
  static const double borderWidthFocused = 1.6;

  static Color borderColor(BuildContext context, {double? customOpacity}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {

      final op = customOpacity ?? darkBorderOpacity;
      return darkGlassBorder.withValues(alpha: op);
    }
    final op = customOpacity ?? lightBorderOpacity;
    return Colors.white.withValues(alpha: op);
  }

  static const double lightHighlightOpacity = 0.70;

  static Color highlightColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {

      return const Color(0xFF283652).withValues(alpha: 0.45);
    }
    return Colors.white.withValues(alpha: lightHighlightOpacity);
  }

  static List<BoxShadow> elevation(GlassDepthLevel level, {bool isDark = false}) {
    final baseAlpha = isDark ? 0.45 : 0.06;
    switch (level) {
      case GlassDepthLevel.background:
        return const [];
      case GlassDepthLevel.largeContainer:
        return [
          BoxShadow(
            color: Colors.black.withValues(alpha: baseAlpha * 0.8),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ];
      case GlassDepthLevel.card:
        return [
          BoxShadow(
            color: Colors.black.withValues(alpha: baseAlpha),
            blurRadius: 26,
            spreadRadius: -2,
            offset: const Offset(0, 8),
          ),
        ];
      case GlassDepthLevel.control:
        return [
          BoxShadow(
            color: Colors.black.withValues(alpha: baseAlpha * 0.6),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ];
      case GlassDepthLevel.floating:
        return [
          BoxShadow(
            color: Colors.black.withValues(alpha: baseAlpha * 1.3),
            blurRadius: 36,
            spreadRadius: -2,
            offset: const Offset(0, 16),
          ),
        ];
    }
  }

  static const double radiusSm = 12.0;
  static const double radiusMd = 16.0;
  static const double radiusLg = 22.0;
  static const double radiusXl = 28.0;
  static const double radiusBubble = 32.0;
  static const double radiusPill = 999.0;

  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationStandard = Duration(milliseconds: 250);
  static const Duration durationSheet = Duration(milliseconds: 320);

  static const Curve curveStandard = Curves.easeInOutCubic;
}
