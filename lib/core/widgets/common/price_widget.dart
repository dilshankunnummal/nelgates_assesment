import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../utils/currency_utils.dart';

class PriceWidget extends StatelessWidget {
  final double price;
  final double? originalPrice;
  final bool showPerNight;
  final TextStyle? priceStyle;
  final TextStyle? suffixStyle;

  const PriceWidget({
    super.key,
    required this.price,
    this.originalPrice,
    this.showPerNight = true,
    this.priceStyle,
    this.suffixStyle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.primaryLight : AppColors.primary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        if (originalPrice != null && originalPrice! > price) ...[
          Text(
            CurrencyUtils.format(originalPrice!),
            style: AppTypography.bodySmall.copyWith(
              decoration: TextDecoration.lineThrough,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(width: 6),
        ],
        Text(
          CurrencyUtils.format(price),
          style: priceStyle ??
              AppTypography.titleLarge.copyWith(
                color: primary,
                fontWeight: FontWeight.w700,
              ),
        ),
        if (showPerNight) ...[
          const SizedBox(width: 3),
          Text(
            '/ night',
            style: suffixStyle ??
                AppTypography.bodySmall.copyWith(
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                ),
          ),
        ],
      ],
    );
  }
}
