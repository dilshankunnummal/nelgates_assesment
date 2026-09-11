import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/currency_utils.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/common/app_button.dart';
import '../../../../core/widgets/glass/app_glass_card.dart';
import '../../../../core/widgets/glass/liquid_glass_background.dart';
import '../../domain/entities/booking.dart';

class BookingConfirmationPage extends StatelessWidget {
  final Booking? booking;

  const BookingConfirmationPage({super.key, this.booking});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.primaryLight : AppColors.primary;

    if (booking == null) {
      return Scaffold(
        body: LiquidGlassBackground(
          child: Center(
            child: AppButton(
              onPressed: () => context.go(RouteNames.home),
              text: 'Return Home',
            ),
          ),
        ),
      );
    }

    final b = booking!;

    return Scaffold(
      body: LiquidGlassBackground(
        child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.success.withValues(alpha: 0.15),
                      border: Border.all(color: AppColors.success.withValues(alpha: 0.4), width: 2),
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: AppColors.success,
                      size: 44,
                    ),
                  ),
                  AppSpacing.gapH16,

                  Text(
                    'Booking Confirmed!',
                    style: AppTypography.displayMedium.copyWith(
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  AppSpacing.gapH4,
                  Text(
                    'Your reservation has been securely confirmed.',
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                  ),
                  AppSpacing.gapH24,

                  AppGlassCard(
                    padding: const EdgeInsets.all(22),
                    borderRadius: AppRadius.brXl,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: primary.withValues(alpha: 0.12),
                            borderRadius: AppRadius.brMd,
                            border: Border.all(color: primary.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Booking Reference',
                                style: AppTypography.labelSmall.copyWith(
                                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                ),
                              ),
                              Text(
                                b.id,
                                style: AppTypography.titleSmall.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: primary,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        AppSpacing.gapH16,

                        _buildInfoRow('Property', b.hotelName, isDark, isBold: true),
                        const Divider(height: 16),
                        _buildInfoRow('Room Type', b.room.name, isDark),
                        const Divider(height: 16),
                        _buildInfoRow('Check-In', AppDateUtils.format(b.checkInDate), isDark),
                        const Divider(height: 16),
                        _buildInfoRow('Check-Out', AppDateUtils.format(b.checkOutDate), isDark),
                        const Divider(height: 16),
                        _buildInfoRow('Stay Details', '${b.nights} Nights • ${b.roomsCount} Room', isDark),
                        const Divider(height: 16),
                        _buildInfoRow('Guests', '${b.adults} Adults, ${b.children} Children', isDark),
                        const Divider(height: 16),
                        _buildInfoRow('Primary Guest', b.guest.fullName, isDark),
                        const Divider(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Amount Paid',
                              style: AppTypography.titleSmall.copyWith(
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                            ),
                            Text(
                              CurrencyUtils.format(b.totalAmount),
                              style: AppTypography.titleLarge.copyWith(
                                fontWeight: FontWeight.w800,
                                color: primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  AppSpacing.gapH24,

                  AppButton(
                    onPressed: () => context.go(RouteNames.bookings),
                    text: 'View My Bookings',
                  ),
                  AppSpacing.gapH12,
                  AppButton(
                    onPressed: () => context.go(RouteNames.home),
                    text: 'Back to Home',
                    isOutlined: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
  }

  Widget _buildInfoRow(String label, String value, bool isDark, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: AppTypography.bodySmall.copyWith(
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
