import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';
import '../../theme/glass_tokens.dart';
import 'glass_surface.dart';

/// Structured glass panel with title header, trailing action, and content body.
class GlassPanel extends StatelessWidget {
  final String? title;
  final Widget? leading;
  final Widget? trailing;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const GlassPanel({
    super.key,
    this.title,
    this.leading,
    this.trailing,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    return GlassSurface(
      depthLevel: GlassDepthLevel.card,
      margin: margin,
      padding: padding,
      borderRadius: AppRadius.brLg,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null || leading != null || trailing != null) ...[
            Row(
              children: [
                if (leading != null) ...[
                  leading!,
                  const SizedBox(width: 10),
                ],
                if (title != null)
                  Expanded(
                    child: Text(
                      title!,
                      style: AppTypography.titleMedium.copyWith(
                        color: titleColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ?trailing,
              ],
            ),
            const SizedBox(height: 14),
          ],
          child,
        ],
      ),
    );
  }
}
