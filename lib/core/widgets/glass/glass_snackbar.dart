import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';
import '../../theme/glass_tokens.dart';
import 'glass_surface.dart';

enum GlassSnackBarType {
  info,
  success,
  warning,
  error,
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showGlassSnackBar(
  BuildContext context, {
  required String message,
  GlassSnackBarType type = GlassSnackBarType.info,
  String? actionLabel,
  VoidCallback? onAction,
  Duration duration = const Duration(seconds: 4),
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  Color statusColor;
  IconData statusIcon;

  switch (type) {
    case GlassSnackBarType.success:
      statusColor = AppColors.success;
      statusIcon = Icons.check_circle_rounded;
      break;
    case GlassSnackBarType.warning:
      statusColor = AppColors.warning;
      statusIcon = Icons.warning_rounded;
      break;
    case GlassSnackBarType.error:
      statusColor = AppColors.error;
      statusIcon = Icons.error_rounded;
      break;
    case GlassSnackBarType.info:
      statusColor = isDark ? AppColors.primaryLight : AppColors.primary;
      statusIcon = Icons.info_rounded;
      break;
  }

  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();

  return messenger.showSnackBar(
    SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: EdgeInsets.zero,
      duration: duration,
      content: GlassSurface(
        depthLevel: GlassDepthLevel.floating,
        borderRadius: AppRadius.brXl,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        borderColor: isDark
            ? statusColor.withValues(alpha: 0.35)
            : Colors.white.withValues(alpha: 0.8),
        shadows: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.40 : 0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: statusColor.withValues(alpha: isDark ? 0.22 : 0.12),
            blurRadius: 20,
            offset: const Offset(0, 2),
          ),
        ],
        child: Row(
          children: [

            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: statusColor.withValues(alpha: isDark ? 0.20 : 0.12),
                border: Border.all(
                  color: statusColor.withValues(alpha: 0.4),
                  width: 1,
                ),
              ),
              child: Icon(
                statusIcon,
                color: statusColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Text(
                message,
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            if (actionLabel != null && onAction != null) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  messenger.hideCurrentSnackBar();
                  onAction();
                },
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    actionLabel,
                    style: AppTypography.labelMedium.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}
