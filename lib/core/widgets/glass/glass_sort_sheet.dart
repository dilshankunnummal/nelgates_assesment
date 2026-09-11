import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import 'glass_bottom_sheet.dart';

class GlassSortOption {
  final String key;
  final String label;
  final IconData icon;

  const GlassSortOption({
    required this.key,
    required this.label,
    required this.icon,
  });
}

class GlassSortSheet extends StatelessWidget {
  final String currentSort;
  final List<GlassSortOption> options;
  final ValueChanged<String> onSelected;

  const GlassSortSheet({
    super.key,
    required this.currentSort,
    required this.options,
    required this.onSelected,
  });

  static Future<String?> show({
    required BuildContext context,
    required String currentSort,
    required List<GlassSortOption> options,
  }) {
    return showGlassBottomSheet<String>(
      context: context,
      isScrollControlled: false,
      child: GlassSortSheet(
        currentSort: currentSort,
        options: options,
        onSelected: (val) => Navigator.of(context).pop(val),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.primaryLight : AppColors.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Text(
            'Sort Hotels By',
            style: AppTypography.titleLarge.copyWith(
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...options.map((option) {
          final isSelected = option.key == currentSort;
          return InkWell(
            onTap: () => onSelected(option.key),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              margin: const EdgeInsets.symmetric(vertical: 3),
              decoration: BoxDecoration(
                color: isSelected
                    ? primary.withValues(alpha: isDark ? 0.22 : 0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    option.icon,
                    size: 20,
                    color: isSelected
                        ? primary
                        : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      option.label,
                      style: AppTypography.bodyMedium.copyWith(
                        color: isSelected
                            ? primary
                            : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Icon(Icons.check_circle_rounded, color: primary, size: 20),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
