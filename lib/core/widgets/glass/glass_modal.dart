import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import 'glass_dialog.dart';
import 'glass_icon_button.dart';

class GlassModal extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback? onClose;
  final double? maxWidth;

  const GlassModal({
    super.key,
    required this.title,
    required this.child,
    this.onClose,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlassDialog(
      maxWidth: maxWidth,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
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
              GlassIconButton(
                size: 34,
                icon: const Icon(Icons.close_rounded, size: 18),
                onPressed: onClose ?? () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
