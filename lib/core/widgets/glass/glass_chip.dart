import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';
import '../../theme/glass_tokens.dart';
import 'glass_surface.dart';

class GlassChip extends StatelessWidget {
  final String label;
  final Widget? icon;
  final bool isSelected;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  const GlassChip({
    super.key,
    required this.label,
    this.icon,
    this.isSelected = false,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.primaryLight : AppColors.primary;

    final bgColor = isSelected
        ? primary.withValues(alpha: isDark ? 0.28 : 0.18)
        : null;

    final borderColor = isSelected
        ? primary.withValues(alpha: 0.8)
        : GlassTokens.borderColor(context);

    final textColor = isSelected
        ? primary
        : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary);

    return GlassSurface(
      depthLevel: GlassDepthLevel.control,
      padding: padding,
      borderRadius: AppRadius.brFull,
      tintColor: bgColor,
      borderColor: borderColor,
      borderWidth: isSelected ? 1.4 : 1.0,
      isSelected: isSelected,
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            icon!,
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: AppTypography.labelMedium.copyWith(
              color: textColor,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
