import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import 'app_button.dart';

class AppErrorView extends StatelessWidget {
  final String? title;
  final String message;
  final VoidCallback? onRetry;
  final String retryText;
  final IconData icon;

  const AppErrorView({
    super.key,
    this.title,
    required this.message,
    this.onRetry,
    this.retryText = 'Try Again',
    this.icon = Icons.error_outline_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isNetworkError = _isNetworkError(message) || _isNetworkError(title ?? '');
    final displayIcon = isNetworkError ? Icons.wifi_off_rounded : icon;
    final displayTitle = title ?? (isNetworkError ? 'No Internet Connection' : 'Something Went Wrong');
    final accentColor = isNetworkError ? AppColors.warning : AppColors.error;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                displayIcon,
                size: 44,
                color: accentColor,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              displayTitle,
              textAlign: TextAlign.center,
              style: AppTypography.titleMedium.copyWith(
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: 170,
                child: AppButton(
                  onPressed: onRetry,
                  text: retryText,
                  height: 46,
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  bool _isNetworkError(String text) {
    final lower = text.toLowerCase();
    return lower.contains('internet') ||
        lower.contains('network') ||
        lower.contains('connect') ||
        lower.contains('offline') ||
        lower.contains('unavailable');
  }
}
