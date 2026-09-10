import 'package:flutter/material.dart';

class AppColors {
  // Brand luxury accents
  static const Color primary = Color(0xFF0F766E); // Deep Teal / Emerald luxury
  static const Color primaryLight = Color(0xFF14B8A6);
  static const Color primaryDark = Color(0xFF115E59);
  static const Color accent = Color(0xFFD97706); // Amber / Warm Gold
  static const Color accentLight = Color(0xFFFBBF24);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Star Rating
  static const Color starGold = Color(0xFFFFB800);

  // Light Theme Colors
  static const Color lightBackground = Color(0xFFF4F7F6);
  static const Color lightSurface = Colors.white;
  static const Color lightSurfaceCard = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF0F172A); // Slate 900
  static const Color lightTextSecondary = Color(0xFF475569); // Slate 600
  static const Color lightTextMuted = Color(0xFF94A3B8); // Slate 400
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightDivider = Color(0xFFE2E8F0);

  // Dark Theme Colors (Deep luxury obsidian)
  static const Color darkBackground = Color(0xFF030508); // Deep midnight obsidian
  static const Color darkSurface = Color(0xFF080C16); // Smoked dark obsidian
  static const Color darkSurfaceCard = Color(0xFF0B101E); // Elevated dark glass card
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFFA0ABBA);
  static const Color darkTextMuted = Color(0xFF64748B);
  static const Color darkBorder = Color(0xFF1E283D); // Deep midnight slate border (dark, non-light)
  static const Color darkDivider = Color(0xFF151C2B); // Deep dark divider

  // Glass tokens for Light
  static const Color glassLightSurface = Color(0xCCFFFFFF); // 80% opacity white
  static const Color glassLightSurfaceSubtle = Color(0x99FFFFFF); // 60% opacity white
  static const Color glassLightBorder = Color(0x66FFFFFF); // 40% white border
  static const Color glassLightHighlight = Color(0x99FFFFFF);

  // Glass tokens for Dark (Deep, rich, non-light dark borders)
  static const Color glassDarkSurface = Color(0x330B101E);
  static const Color glassDarkSurfaceSubtle = Color(0x240E1528);
  static const Color glassDarkBorder = Color(0xFF1E2A40); // Deep slate glass border (dark, non-light)
  static const Color glassDarkHighlight = Color(0x402A3A54); // Subtle dark glass sheen
}
