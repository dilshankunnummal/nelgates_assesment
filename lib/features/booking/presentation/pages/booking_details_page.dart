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
import '../../../../core/widgets/common/status_badge.dart';
import '../../../../core/widgets/glass/app_glass_card.dart';
import '../../../../core/widgets/glass/glass_alert_dialog.dart';
import '../../../../core/widgets/glass/glass_button.dart';
import '../../../../core/widgets/glass/glass_loading_dialog.dart';
import '../../../../core/widgets/glass/glass_snackbar.dart';
import '../../../../core/widgets/glass/liquid_glass_background.dart';
import '../../domain/entities/booking.dart';
import '../../domain/entities/guest.dart';
import '../../../hotels/domain/entities/room.dart';
import '../cubits/bookings_cubit.dart';

class BookingDetailsPage extends StatefulWidget {
  final String bookingId;
  final Booking? initialBooking;

  const BookingDetailsPage({
    super.key,
    required this.bookingId,
    this.initialBooking,
  });

  @override
  State<BookingDetailsPage> createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  bool _isCancelling = false;

  Future<void> _handleCancelReservation(Booking booking) async {
    final confirmed = await showGlassAlertDialog(
      context: context,
      title: 'Cancel Reservation?',
      message: 'Are you sure you want to cancel this reservation? The status will be updated to Cancelled.',
      confirmLabel: 'Confirm Cancel',
      cancelLabel: 'Keep',
      isDestructive: true,
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isCancelling = true);
    showGlassLoadingDialog(context, message: 'Cancelling reservation...');

    final bookingsCubit = context.read<BookingsCubit>();
    final success = await bookingsCubit.cancelBooking(booking.id);

    if (!mounted) return;
    hideGlassLoadingDialog(context);
    setState(() => _isCancelling = false);

    showGlassSnackBar(
      context,
      message: success
          ? 'Reservation successfully marked as cancelled.'
          : 'Failed to cancel reservation. Please try again.',
      type: success ? GlassSnackBarType.success : GlassSnackBarType.error,
    );

    if (success && mounted) {
      if (context.canPop()) {
        context.pop();
      } else {
        context.go(RouteNames.bookings);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.primaryLight : AppColors.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: LiquidGlassBackground(
        child: BlocBuilder<BookingsCubit, BookingsState>(
          builder: (context, state) {

            final Booking booking = state.allBookings
                    .where((b) => b.id == widget.bookingId)
                    .firstOrNull ??
                widget.initialBooking ??
                _fallbackBooking(widget.bookingId);

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  AppGlassCard(
                    padding: const EdgeInsets.all(18),
                    borderRadius: AppRadius.brXl,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Booking Reference',
                              style: AppTypography.labelSmall.copyWith(
                                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                              ),
                            ),
                            AppSpacing.gapH4,
                            Text(
                              booking.id,
                              style: AppTypography.titleMedium.copyWith(
                                fontWeight: FontWeight.w800,
                                color: primary,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        StatusBadge(status: booking.status),
                      ],
                    ),
                  ),
                  AppSpacing.gapH16,

                  AppGlassCard(
                    padding: const EdgeInsets.all(16),
                    borderRadius: AppRadius.brXl,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppImage(
                          imageUrl: booking.hotelImage,
                          height: 160,
                          width: double.infinity,
                          borderRadius: AppRadius.brLg,
                        ),
                        AppSpacing.gapH16,
                        Text(
                          booking.hotelName,
                          style: AppTypography.titleLarge.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                        AppSpacing.gapH4,
                        Text(
                          booking.hotelAddress,
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                          ),
                        ),
                        const Divider(height: 24),
                        Text(
                          booking.room.name,
                          style: AppTypography.titleSmall.copyWith(
                            fontWeight: FontWeight.w600,
                            color: primary,
                          ),
                        ),
                        AppSpacing.gapH4,
                        Text(
                          booking.room.description,
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppSpacing.gapH16,

                  AppGlassCard(
                    padding: const EdgeInsets.all(18),
                    borderRadius: AppRadius.brXl,
                    child: Column(
                      children: [
                        _buildRow('Check-In', AppDateUtils.formatFull(booking.checkInDate), isDark),
                        const Divider(height: 18),
                        _buildRow('Check-Out', AppDateUtils.formatFull(booking.checkOutDate), isDark),
                        const Divider(height: 18),
                        _buildRow('Duration', '${booking.nights} Nights', isDark),
                        const Divider(height: 18),
                        _buildRow('Reserved', '${booking.roomsCount} Room(s)', isDark),
                        const Divider(height: 18),
                        _buildRow('Guests', '${booking.adults} Adults, ${booking.children} Children', isDark),
                        const Divider(height: 18),
                        _buildRow('Guest Name', booking.guest.fullName, isDark),
                        const Divider(height: 18),
                        _buildRow('Contact Email', booking.guest.email, isDark),
                        const Divider(height: 18),
                        _buildRow('Phone', booking.guest.phone, isDark),
                        if (booking.guest.specialRequests != null) ...[
                          const Divider(height: 18),
                          _buildRow('Special Requests', booking.guest.specialRequests!, isDark),
                        ],
                        if (booking.isCancelled && booking.cancellationReason != null) ...[
                          const Divider(height: 18),
                          _buildRow('Cancellation Reason', booking.cancellationReason!, isDark, isAlert: true),
                        ],
                      ],
                    ),
                  ),
                  AppSpacing.gapH16,

                  AppGlassCard(
                    padding: const EdgeInsets.all(18),
                    borderRadius: AppRadius.brXl,
                    child: Column(
                      children: [
                        _buildRow('Room Subtotal', CurrencyUtils.format(booking.subtotal), isDark),
                        const Divider(height: 16),
                        _buildRow('Taxes (GST 12%)', CurrencyUtils.format(booking.taxAmount), isDark),
                        const Divider(height: 16),
                        _buildRow('Hospitality Fee (5%)', CurrencyUtils.format(booking.serviceChargeAmount), isDark),
                        const Divider(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Grand Total Paid',
                              style: AppTypography.titleSmall.copyWith(
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                            ),
                            Text(
                              CurrencyUtils.format(booking.totalAmount),
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

                  if (booking.isUpcoming)
                    GlassButton(
                      onPressed: _isCancelling ? null : () => _handleCancelReservation(booking),
                      label: _isCancelling ? 'Cancelling...' : 'Cancel Reservation',
                      isLoading: _isCancelling,
                      width: double.infinity,
                      height: 48,
                      isPrimary: false,
                      borderColor: AppColors.error.withValues(alpha: 0.35),
                      textColor: AppColors.error,
                      icon: const Icon(Icons.cancel_outlined, size: 18, color: AppColors.error),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, bool isDark, {bool isAlert = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: isAlert
                ? AppColors.error
                : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: AppTypography.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
              color: isAlert
                  ? AppColors.error
                  : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
            ),
          ),
        ),
      ],
    );
  }

  static Booking _fallbackBooking(String id) {
    return Booking(
      id: id,
      hotelId: 'HTL-KER-001',
      hotelName: 'Grand Hyatt Kochi Bolgatty',
      hotelImage: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800&q=80',
      hotelAddress: 'Mulavukad, Bolgatty Island, Kochi, Kerala 682504',
      room: const Room(
        id: 'RM-KER-001-1',
        hotelId: 'HTL-KER-001',
        name: 'Grand Lake View Room',
        description: 'Private balcony overlooking peaceful Vembanad Lake.',
        pricePerNight: 9499.0,
        capacity: 2,
        bedType: '1 King Bed',
        sizeSqFt: 450,
        amenities: ['Lake View', 'Bathtub', 'Balcony'],
        isAvailable: true,
        images: ['https://images.unsplash.com/photo-1590490360182-c33d57733427?w=800&q=80'],
      ),
      checkInDate: DateTime.now().add(const Duration(days: 3)),
      checkOutDate: DateTime.now().add(const Duration(days: 6)),
      nights: 3,
      adults: 2,
      children: 0,
      roomsCount: 1,
      baseRoomPrice: 9499.0,
      subtotal: 28497.0,
      taxAmount: 3419.64,
      serviceChargeAmount: 1424.85,
      totalAmount: 33341.49,
      guest: const Guest(
        firstName: 'Alex',
        lastName: 'Mercer',
        email: 'employee@hotel.com',
        phone: '+91 9876543210',
      ),
      status: 'upcoming',
      createdAt: DateTime.now(),
    );
  }
}
