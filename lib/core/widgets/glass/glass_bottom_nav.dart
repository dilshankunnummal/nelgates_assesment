import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';
import '../../theme/glass_tokens.dart';
import 'glass_surface.dart';

class GlassNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const GlassNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

class GlassBottomNavigation extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<GlassNavItem> items;

  const GlassBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  State<GlassBottomNavigation> createState() => _GlassBottomNavigationState();
}

class _GlassBottomNavigationState extends State<GlassBottomNavigation> {
  int? _lastHapticIndex;

  void _handlePointer(double localDx, double totalWidth) {
    if (widget.items.isEmpty || totalWidth <= 0) return;
    final itemWidth = totalWidth / widget.items.length;
    final targetIndex = (localDx / itemWidth).floor().clamp(0, widget.items.length - 1);

    if (targetIndex != widget.currentIndex) {
      if (_lastHapticIndex != targetIndex) {
        _lastHapticIndex = targetIndex;
        HapticFeedback.selectionClick();
      }
      widget.onTap(targetIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.primaryLight : AppColors.primary;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: GlassSurface(
          depthLevel: GlassDepthLevel.card,
          borderRadius: AppRadius.brFull,
          blur: GlassTokens.blurDeep,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          hasHighlight: false,
          shadows: GlassTokens.elevation(GlassDepthLevel.floating, isDark: isDark),
          child: SizedBox(
            height: 64,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final totalWidth = constraints.maxWidth;
                final itemCount = widget.items.length;
                final itemWidth = itemCount > 0 ? totalWidth / itemCount : 0.0;

                return Listener(
                  behavior: HitTestBehavior.opaque,
                  onPointerDown: (event) {
                    _lastHapticIndex = widget.currentIndex;
                    _handlePointer(event.localPosition.dx, totalWidth);
                  },
                  onPointerMove: (event) {
                    _handlePointer(event.localPosition.dx, totalWidth);
                  },
                  onPointerUp: (_) {
                    _lastHapticIndex = null;
                  },
                  onPointerCancel: (_) {
                    _lastHapticIndex = null;
                  },
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [

                      if (itemCount > 0)
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 270),
                          curve: Curves.easeOutCubic,
                          left: widget.currentIndex * itemWidth + 2,
                          top: 6,
                          bottom: 6,
                          width: itemWidth - 4,
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
                                top: 4.5,
                                left: 14,
                                child: Container(
                                  width: 16,
                                  height: 4.5,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: isDark ? 0.60 : 0.75),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),

                              Positioned(
                                bottom: 4,
                                right: 14,
                                child: Container(
                                  width: 12,
                                  height: 3.5,
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
                        children: List.generate(widget.items.length, (index) {
                          final item = widget.items[index];
                          final isSelected = index == widget.currentIndex;

                          return Expanded(
                            child: Center(
                              child: AnimatedScale(
                                scale: isSelected ? 1.05 : 0.95,
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeOutCubic,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      isSelected ? item.activeIcon : item.icon,
                                      color: isSelected
                                          ? primary
                                          : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                                      size: 22,
                                    ),
                                    if (isSelected) ...[
                                      const SizedBox(width: 6),
                                      Flexible(
                                        child: Text(
                                          item.label,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppTypography.labelMedium.copyWith(
                                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.2,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

typedef GlassNavigationBar = GlassBottomNavigation;
