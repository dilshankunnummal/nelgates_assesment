import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/currency_utils.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/common/app_image.dart';
import '../../../../core/widgets/common/section_header.dart';
import '../../../../core/widgets/glass/app_glass_card.dart';
import '../../../../core/widgets/glass/glass_button.dart';
import '../../../../core/widgets/glass/glass_snackbar.dart';
import '../../../../core/widgets/glass/liquid_glass_background.dart';
import '../cubits/booking_cubit.dart';
import '../widgets/booking_price_breakdown.dart';

class BookingSummaryPage extends StatelessWidget {
  const BookingSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.primaryLight : AppColors.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Summary'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: LiquidGlassBackground(
        child: BlocConsumer<BookingCubit, BookingState>(
          listener: (context, state) {
            if (state is BookingConfirmed) {
              context.go(RouteNames.bookingConfirmation, extra: state.booking);
            } else if (state is BookingFailure) {
              showGlassSnackBar(
                context,
                message: state.message,
                type: GlassSnackBarType.error,
              );
            }
          },
          builder: (context, state) {
            final draft = state.draft;
            if (draft == null || draft.guest == null) {
              return const Center(child: Text('Incomplete booking information.'));
            }

            final breakdown = draft.priceBreakdown;
            final guest = draft.guest!;
            final isLoading = state is BookingSubmitting;

            return Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hotel Overview Card
                      AppGlassCard(
                        padding: const EdgeInsets.all(16),
                        borderRadius: AppRadius.brXl,
                        child: Row(
                          children: [
                            AppImage(
                              imageUrl: draft.hotel.mainImage,
                              width: 80,
                              height: 80,
                              borderRadius: AppRadius.brMd,
                            ),
                            AppSpacing.gapW16,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    draft.hotel.name,
                                    style: AppTypography.titleMedium.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  AppSpacing.gapH4,
                                  Text(
                                    '${draft.hotel.city}, ${draft.hotel.destination}',
                                    style: AppTypography.bodySmall.copyWith(
                                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                    ),
                                  ),
                                  AppSpacing.gapH6,
                                  Text(
                                    draft.room.name,
                                    style: AppTypography.labelSmall.copyWith(
                                      color: primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      AppSpacing.gapH20,

                      // Reservation Details
                      const SectionHeader(title: 'Stay & Guest Details'),
                      AppSpacing.gapH8,
                      AppGlassCard(
                        padding: const EdgeInsets.all(18),
                        borderRadius: AppRadius.brLg,
                        child: Column(
                          children: [
                            _buildDetailRow('Check-In', AppDateUtils.formatFull(draft.checkIn), isDark),
                            const Divider(height: 18),
                            _buildDetailRow('Check-Out', AppDateUtils.formatFull(draft.checkOut), isDark),
                            const Divider(height: 18),
                            _buildDetailRow('Stay Duration', '${draft.nights} Nights', isDark),
                            const Divider(height: 18),
                            _buildDetailRow('Room(s) Count', '${draft.roomsCount} Room', isDark),
                            const Divider(height: 18),
                            _buildDetailRow('Occupancy', '${draft.adults} Adults, ${draft.children} Children', isDark),
                            const Divider(height: 18),
                            _buildDetailRow('Guest Name', guest.fullName, isDark),
                            const Divider(height: 18),
                            _buildDetailRow('Contact Email', guest.email, isDark),
                            const Divider(height: 18),
                            _buildDetailRow('Phone Number', guest.phone, isDark),
                            if (guest.specialRequests != null && guest.specialRequests!.isNotEmpty) ...[
                              const Divider(height: 18),
                              _buildDetailRow('Special Note', guest.specialRequests!, isDark),
                            ],
                          ],
                        ),
                      ),
                      AppSpacing.gapH20,

                      // Price Breakdown
                      BookingPriceBreakdownWidget(breakdown: breakdown),
                      AppSpacing.gapH20,

                      // Cancellation Policy
                      AppGlassCard(
                        padding: const EdgeInsets.all(16),
                        borderRadius: AppRadius.brLg,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.info_outline_rounded,
                              size: 20,
                              color: AppColors.info,
                            ),
                            AppSpacing.gapW12,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Cancellation Policy',
                                    style: AppTypography.titleSmall.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                    ),
                                  ),
                                  AppSpacing.gapH4,
                                  Text(
                                    draft.hotel.cancellationPolicy,
                                    style: AppTypography.bodySmall.copyWith(
                                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Sticky Bottom Confirm Bar
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: AppGlassCard(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
                    child: SafeArea(
                      top: false,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Total Payable',
                                  style: AppTypography.labelSmall.copyWith(
                                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                  ),
                                ),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    CurrencyUtils.format(breakdown.totalAmount),
                                    style: AppTypography.titleLarge.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 160,
                            child: GlassButton(
                              onPressed: isLoading
                                  ? null
                                  : () => context.read<BookingCubit>().confirmBooking(),
                              label: 'Confirm Booking',
                              isPrimary: true,
                              isLoading: isLoading,
                              height: 48,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Centered Confirmation Loading Overlay
                if (isLoading)
                  Container(
                    color: Colors.black.withValues(alpha: 0.55),
                    child: Center(
                      child: AppGlassCard(
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 26),
                        borderRadius: AppRadius.brXl,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 54,
                              height: 54,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: primary.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(primary),
                              ),
                            ),
                            AppSpacing.gapH16,
                            Text(
                              'Confirming your booking...',
                              style: AppTypography.titleMedium.copyWith(
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                            ),
                            AppSpacing.gapH6,
                            Text(
                              'Securing your reservation in Kerala & South India',
                              style: AppTypography.bodySmall.copyWith(
                                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark) {
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
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
