import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import 'glass_button.dart';

/// Reusable generic glass filter sheet shell with header, scrollable filter body, and actions.
class GlassFilterSheet extends StatelessWidget {
  final String title;
  final Widget content;
  final VoidCallback onApply;
  final VoidCallback onReset;
  final String applyLabel;
  final String resetLabel;

  const GlassFilterSheet({
    super.key,
    this.title = 'Filters',
    required this.content,
    required this.onApply,
    required this.onReset,
    this.applyLabel = 'Apply Filters',
    this.resetLabel = 'Reset',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTypography.titleLarge.copyWith(
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: onReset,
              child: Text(
                resetLabel,
                style: AppTypography.labelMedium.copyWith(
                  color: isDark ? AppColors.primaryLight : AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Flexible(
          child: SingleChildScrollView(
            child: content,
          ),
        ),
        const SizedBox(height: 20),
        GlassButton(
          onPressed: onApply,
          label: applyLabel,
          isPrimary: true,
          width: double.infinity,
          height: 52,
        ),
      ],
    );
  }
}
