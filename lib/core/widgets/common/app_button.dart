import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';

class AppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Widget? icon;
  final bool isLoading;
  final bool isOutlined;
  final double? width;
  final double height;
  final Color? backgroundColor;
  final Color? textColor;

  final String? loadingText;

  const AppButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.isLoading = false,
    this.isOutlined = false,
    this.width,
    this.height = 50,
    this.backgroundColor,
    this.textColor,
    this.loadingText,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.primaryLight : AppColors.primary;
    final defaultBg = isDark ? AppColors.primaryLight : AppColors.primary;
    final defaultFg = isDark ? AppColors.darkBackground : Colors.white;

    if (isOutlined) {
      return SizedBox(
        width: width ?? double.infinity,
        height: height,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: backgroundColor ?? primary,
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(borderRadius: AppRadius.brMd),
          ),
          child: _buildChild(textColor ?? (isDark ? AppColors.primaryLight : AppColors.primary)),
        ),
      );
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? defaultBg,
          foregroundColor: textColor ?? defaultFg,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.brMd),
        ),
        child: _buildChild(textColor ?? defaultFg),
      ),
    );
  }

  Widget _buildChild(Color fgColor) {
    if (isLoading) {
      final displayText = loadingText ??
          (text.toLowerCase().contains('sign in') || text.toLowerCase().contains('login')
              ? 'Signing in...'
              : (text.toLowerCase().contains('cancel') ? 'Cancelling...' : 'Processing...'));

      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(fgColor),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            displayText,
            style: AppTypography.labelLarge.copyWith(
              color: fgColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon!,
          const SizedBox(width: 8),
          Text(
            text,
            style: AppTypography.labelLarge.copyWith(
              color: fgColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: AppTypography.labelLarge.copyWith(
        color: fgColor,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
