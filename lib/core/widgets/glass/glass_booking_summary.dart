import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';
import '../../utils/currency_utils.dart';
import 'glass_surface.dart';
import '../../theme/glass_tokens.dart';

class GlassBookingSummary extends StatelessWidget {
  final String hotelName;
  final String roomName;
  final String datesText;
  final int nights;
  final int rooms;
  final int guests;
  final double basePrice;
  final double taxes;
  final double serviceFee;
  final double totalAmount;

  const GlassBookingSummary({
    super.key,
    required this.hotelName,
    required this.roomName,
    required this.datesText,
    required this.nights,
    required this.rooms,
    required this.guests,
    required this.basePrice,
    required this.taxes,
    required this.serviceFee,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.primaryLight : AppColors.primary;

    return GlassSurface(
      depthLevel: GlassDepthLevel.card,
      borderRadius: AppRadius.brLg,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hotelName,
            style: AppTypography.titleMedium.copyWith(
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            roomName,
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              _buildBadge(context, Icons.calendar_today_rounded, datesText),
              const SizedBox(width: 8),
              _buildBadge(context, Icons.nightlight_round, '$nights N'),
              const SizedBox(width: 8),
              _buildBadge(context, Icons.person_outline_rounded, '$guests G'),
            ],
          ),
          const SizedBox(height: 16),
          Divider(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            height: 1,
          ),
          const SizedBox(height: 14),
          _buildPriceRow(context, 'Base Fare ($nights nights x $rooms room)', basePrice),
          const SizedBox(height: 8),
          _buildPriceRow(context, 'Taxes & GST (18%)', taxes),
          const SizedBox(height: 8),
          _buildPriceRow(context, 'Service Fee', serviceFee),
          const SizedBox(height: 14),
          Divider(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            height: 1,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Payable',
                style: AppTypography.titleMedium.copyWith(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                CurrencyUtils.format(totalAmount),
                style: AppTypography.titleLarge.copyWith(
                  color: primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(BuildContext context, IconData icon, String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBorder.withValues(alpha: 0.5) : Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(BuildContext context, String label, double amount) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
        ),
        Text(
          CurrencyUtils.format(amount),
          style: AppTypography.bodySmall.copyWith(
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
