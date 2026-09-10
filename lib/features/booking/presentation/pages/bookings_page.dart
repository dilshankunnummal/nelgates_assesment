import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/common/app_empty_view.dart';
import '../../../../core/widgets/common/app_error_view.dart';
import '../../../../core/widgets/glass/glass_alert_dialog.dart';
import '../../../../core/widgets/glass/glass_snackbar.dart';
import '../../../../core/widgets/glass/liquid_glass_background.dart';
import '../../../../core/widgets/skeleton/booking_skeleton.dart';
import '../../domain/entities/booking.dart';
import '../cubits/bookings_cubit.dart';
import '../widgets/booking_card.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<BookingsCubit>().loadBookings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _confirmCancelBooking(BuildContext context, Booking booking) async {
    final confirmed = await showGlassAlertDialog(
      context: context,
      title: 'Cancel Booking?',
      message: 'Are you sure you want to cancel your stay at ${booking.hotelName}? This will free your room reservation.',
      confirmLabel: 'Yes, Cancel',
      cancelLabel: 'Keep Stay',
      isDestructive: true,
      icon: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 28),
      ),
    );

    if (confirmed == true && context.mounted) {
      final success = await context.read<BookingsCubit>().cancelBooking(booking.id);
      if (context.mounted) {
        showGlassSnackBar(
          context,
          message: success
              ? 'Booking ${booking.id} has been successfully cancelled.'
              : 'Failed to cancel booking. Please try again.',
          type: success ? GlassSnackBarType.success : GlassSnackBarType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.primaryLight : AppColors.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: primary,
          labelColor: primary,
          unselectedLabelColor: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          labelStyle: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w700),
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: LiquidGlassBackground(
        child: BlocBuilder<BookingsCubit, BookingsState>(
          builder: (context, state) {
            if (state is BookingsLoading && state.allBookings.isEmpty) {
              return const BookingListSkeleton();
            }

            if (state is BookingsFailure && state.allBookings.isEmpty) {
              return AppErrorView(
                message: state.message,
                onRetry: () => context.read<BookingsCubit>().loadBookings(),
              );
            }

            return TabBarView(
              controller: _tabController,
              children: [
                _buildBookingList(context, state.upcomingBookings, 'upcoming'),
                _buildBookingList(context, state.completedBookings, 'completed'),
                _buildBookingList(context, state.cancelledBookings, 'cancelled'),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBookingList(BuildContext context, List<Booking> list, String tabType) {
    if (list.isEmpty) {
      String title = 'No Upcoming Stays';
      String message = 'You have no upcoming reservations. Explore our luxury resorts to plan your next vacation.';
      if (tabType == 'completed') {
        title = 'No Past Bookings';
        message = 'You do not have any past completed hotel stays yet.';
      } else if (tabType == 'cancelled') {
        title = 'No Cancelled Stays';
        message = 'You have not cancelled any bookings.';
      }

      return AppEmptyView(
        icon: Icons.hotel_outlined,
        title: title,
        message: message,
        actionText: tabType == 'upcoming' ? 'Explore Hotels' : null,
        onAction: tabType == 'upcoming' ? () => context.go(RouteNames.hotels) : null,
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await context.read<BookingsCubit>().loadBookings();
      },
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
        itemCount: list.length,
        separatorBuilder: (context, _) => AppSpacing.gapH12,
        itemBuilder: (context, index) {
          final booking = list[index];
          return BookingCard(
            booking: booking,
            onTap: () {
              context.push('${RouteNames.bookingDetails}/${booking.id}', extra: booking);
            },
            onCancel: booking.isUpcoming
                ? () => _confirmCancelBooking(context, booking)
                : null,
          );
        },
      ),
    );
  }
}
