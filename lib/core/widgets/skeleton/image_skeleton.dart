import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import 'shimmer_container.dart';

class ImageSkeleton extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const ImageSkeleton({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ShimmerContainer(
      width: width,
      height: height,
      borderRadius: borderRadius,
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: (height != null && height! < 70) ? 20 : 32,
          color: isDark
              ? AppColors.darkTextMuted.withValues(alpha: 0.4)
              : AppColors.lightTextMuted.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}
