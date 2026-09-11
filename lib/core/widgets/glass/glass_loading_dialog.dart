import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';
import '../../theme/glass_tokens.dart';

Future<void> showGlassLoadingDialog(
  BuildContext context, {
  String message = 'Processing...',
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (context) => PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 40),
        child: _GlassLoadingDialogContent(message: message),
      ),
    ),
  );
}

void hideGlassLoadingDialog(BuildContext context) {
  if (Navigator.of(context, rootNavigator: true).canPop()) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}

class _GlassLoadingDialogContent extends StatelessWidget {
  final String message;

  const _GlassLoadingDialogContent({required this.message});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.primaryLight : AppColors.primary;

    return Center(
      child: ClipRRect(
        borderRadius: AppRadius.brXl,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: GlassTokens.blurDeep, sigmaY: GlassTokens.blurDeep),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            decoration: BoxDecoration(
              color: isDark
                  ? GlassTokens.darkSurfaceColor(GlassDepthLevel.floating, adjustedOpacity: 0.88)
                  : Colors.white.withValues(alpha: 0.90),
              borderRadius: AppRadius.brXl,
              border: Border.all(
                color: GlassTokens.borderColor(context),
                width: GlassTokens.borderWidthHairline,
              ),
              boxShadow: GlassTokens.elevation(GlassDepthLevel.floating, isDark: isDark),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 44,
                  height: 44,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        strokeWidth: 3.2,
                        valueColor: AlwaysStoppedAnimation<Color>(primary),
                      ),
                      Icon(
                        Icons.hotel_rounded,
                        size: 20,
                        color: primary.withValues(alpha: 0.8),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
