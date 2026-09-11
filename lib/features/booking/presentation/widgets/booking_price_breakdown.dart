import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/currency_utils.dart';
import '../../../../core/utils/price_calculator.dart';
import '../../../../core/widgets/glass/app_glass_card.dart';

class BookingPriceBreakdownWidget extends StatelessWidget {
  final PriceBreakdown breakdown;

  const BookingPriceBreakdownWidget({
    super.key,
    required this.breakdown,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.primaryLight : AppColors.primary;

    final nightText = breakdown.nights == 1 ? '1 night' : '${breakdown.nights} nights';
    final roomText = breakdown.rooms == 1 ? '1 room' : '${breakdown.rooms} rooms';

    return AppGlassCard(
      padding: const EdgeInsets.all(18),
      borderRadius: AppRadius.brXl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price Breakdown',
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          AppSpacing.gapH16,

          _buildRow(
            'Base Rate',
            '${CurrencyUtils.format(breakdown.baseRoomPrice)} × $nightText × $roomText',
            CurrencyUtils.format(breakdown.subtotal),
            isDark,
          ),
          AppSpacing.gapH10,

          _buildRow(
            'GST & Luxury Taxes',
            '${(breakdown.taxRate * 100).toInt()}%',
            CurrencyUtils.format(breakdown.taxAmount),
            isDark,
          ),
          AppSpacing.gapH10,

          _buildRow(
            'Hospitality Service Fee',
            '${(breakdown.serviceChargeRate * 100).toInt()}%',
            CurrencyUtils.format(breakdown.serviceChargeAmount),
            isDark,
          ),
          const Divider(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Grand Total',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              Text(
                CurrencyUtils.format(breakdown.grandTotal),
                style: AppTypography.titleLarge.copyWith(
                  fontWeight: FontWeight.w800,
                  color: primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String title, String? subtitle, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTypography.bodyMedium.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: AppTypography.bodySmall.copyWith(
                  fontSize: 11,
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                ),
              ),
            ],
          ],
        ),
        Text(
          value,
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
      ],
    );
  }
}
