import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../skeleton/image_skeleton.dart';

class AppImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  const AppImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? BorderRadius.zero;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final placeholderBg = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);

    Widget buildErrorFallback() {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: placeholderBg,
          borderRadius: effectiveRadius,
        ),
        child: errorWidget ??
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.hotel_rounded,
                    size: (height != null && height! < 60) ? 20 : 32,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  ),
                  if (height == null || height! >= 60) ...[
                    const SizedBox(height: 4),
                    Text(
                      'LuxeStay',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
      );
    }

    if (imageUrl == null || imageUrl!.trim().isEmpty) {
      return ClipRRect(
        borderRadius: effectiveRadius,
        child: buildErrorFallback(),
      );
    }

    final url = imageUrl!.trim();

    return ClipRRect(
      borderRadius: effectiveRadius,
      child: Image.network(
        url,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return placeholder ??
              ImageSkeleton(
                width: width,
                height: height,
                borderRadius: effectiveRadius,
              );
        },
        errorBuilder: (context, error, stackTrace) {
          return buildErrorFallback();
        },
      ),
    );
  }
}
