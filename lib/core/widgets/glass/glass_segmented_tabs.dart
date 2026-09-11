import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';
import '../../theme/glass_tokens.dart';
import 'glass_surface.dart';

class GlassTabItem {
  final String label;
  final IconData? icon;
  final IconData? activeIcon;
  final int? count;

  const GlassTabItem({
    required this.label,
    this.icon,
    this.activeIcon,
    this.count,
  });
}

class GlassSegmentedTabs extends StatelessWidget implements PreferredSizeWidget {
  final TabController controller;
  final List<GlassTabItem> tabs;
  final EdgeInsets padding;
  final double height;

  const GlassSegmentedTabs({
    super.key,
    required this.controller,
    required this.tabs,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.height = 48,
  });

  @override
  Size get preferredSize => Size.fromHeight(height + padding.vertical);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.primaryLight : AppColors.primary;

    return Padding(
      padding: padding,
      child: GlassSurface(
        depthLevel: GlassDepthLevel.card,
        borderRadius: AppRadius.brFull,
        blur: GlassTokens.blurDeep,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        hasHighlight: false,
        shadows: GlassTokens.elevation(GlassDepthLevel.floating, isDark: isDark),
        child: SizedBox(
          height: height,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final totalWidth = constraints.maxWidth;
              final tabCount = tabs.length;
              if (tabCount == 0 || totalWidth <= 0) return const SizedBox.shrink();

              final tabWidth = totalWidth / tabCount;

              return AnimatedBuilder(
                animation: controller.animation ?? controller,
                builder: (context, _) {
                  final animValue = controller.animation?.value ?? controller.index.toDouble();
                  final leftOffset = (animValue * tabWidth + 2).clamp(2.0, totalWidth - tabWidth + 2);

                  return Stack(
                    alignment: Alignment.centerLeft,
                    children: [

                      Positioned(
                        left: leftOffset,
                        top: 2,
                        bottom: 2,
                        width: tabWidth - 4,
                        child: Stack(
                          children: [

                            Container(
                              decoration: BoxDecoration(
                                borderRadius: AppRadius.brFull,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: isDark
                                      ? [
                                          const Color(0xFF334E72).withValues(alpha: 0.50),
                                          const Color(0xFF1C2C42).withValues(alpha: 0.30),
                                          const Color(0xFF142233).withValues(alpha: 0.45),
                                        ]
                                      : [
                                          Colors.white.withValues(alpha: 0.70),
                                          Colors.white.withValues(alpha: 0.45),
                                          Colors.white.withValues(alpha: 0.60),
                                        ],
                                ),
                                border: Border.all(
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.15)
                                      : Colors.white.withValues(alpha: 0.50),
                                  width: 0.8,
                                ),
                                boxShadow: [

                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.12),
                                    blurRadius: 9,
                                    offset: const Offset(0, 3),
                                  ),

                                  BoxShadow(
                                    color: primary.withValues(alpha: isDark ? 0.35 : 0.18),
                                    blurRadius: 18,
                                    spreadRadius: 1.5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),

                            Positioned(
                              top: 4,
                              left: 12,
                              child: Container(
                                width: 14,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: isDark ? 0.60 : 0.75),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),

                            Positioned(
                              bottom: 3.5,
                              right: 12,
                              child: Container(
                                width: 10,
                                height: 3,
                                decoration: BoxDecoration(
                                  color: (isDark ? Colors.white : primary).withValues(alpha: isDark ? 0.22 : 0.25),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Row(
                        children: List.generate(tabs.length, (index) {
                          final tab = tabs[index];
                          final isSelected = controller.index == index;

                          final displayIcon = isSelected
                              ? (tab.activeIcon ?? tab.icon)
                              : tab.icon;

                          return Expanded(
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                if (controller.index != index) {
                                  HapticFeedback.selectionClick();
                                  controller.animateTo(index);
                                }
                              },
                              child: Center(
                                child: AnimatedScale(
                                  scale: isSelected ? 1.05 : 0.95,
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeOutCubic,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (displayIcon != null) ...[
                                        Icon(
                                          displayIcon,
                                          size: 16,
                                          color: isSelected
                                              ? primary
                                              : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                                        ),
                                        const SizedBox(width: 5),
                                      ],
                                      Text(
                                        tab.label,
                                        style: AppTypography.labelMedium.copyWith(
                                          color: isSelected
                                              ? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)
                                              : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                      if (tab.count != null && tab.count! > 0) ...[
                                        const SizedBox(width: 5),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? primary.withValues(alpha: isDark ? 0.35 : 0.20)
                                                : (isDark
                                                    ? Colors.white.withValues(alpha: 0.08)
                                                    : Colors.black.withValues(alpha: 0.05)),
                                            borderRadius: AppRadius.brFull,
                                          ),
                                          child: Text(
                                            '${tab.count}',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              color: isSelected
                                                  ? primary
                                                  : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
