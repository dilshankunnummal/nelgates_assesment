import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/currency_utils.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/common/app_text_field.dart';
import '../../../../core/widgets/common/section_header.dart';
import '../../../../core/widgets/glass/app_glass_card.dart';
import '../../../../core/widgets/glass/glass_button.dart';
import '../../../../core/widgets/glass/liquid_glass_background.dart';
import '../../domain/entities/guest.dart';
import '../cubits/booking_cubit.dart';
import '../widgets/booking_price_breakdown.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController(text: 'Alex');
  final _lastNameController = TextEditingController(text: 'Mercer');
  final _emailController = TextEditingController(text: 'employee@hotel.com');
  final _phoneController = TextEditingController(text: '+91 9876543210');
  final _specialRequestsController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _specialRequestsController.dispose();
    super.dispose();
  }

  Future<void> _pickDates(BuildContext context, BookingDraft draft) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(start: draft.checkIn, end: draft.checkOut),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.primary,
                  onPrimary: Colors.white,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      if (!context.mounted) return;
      context.read<BookingCubit>().updateDates(
            checkIn: picked.start,
            checkOut: picked.end,
          );
    }
  }

  void _onProceed(BookingDraft draft) {
    if (_formKey.currentState?.validate() ?? false) {
      final guest = Guest(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        specialRequests: _specialRequestsController.text.trim().isNotEmpty
            ? _specialRequestsController.text.trim()
            : null,
      );

      context.read<BookingCubit>().updateGuestDetails(guest);
      context.push(RouteNames.bookingSummary);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.primaryLight : AppColors.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configure Booking'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: LiquidGlassBackground(
        child: BlocBuilder<BookingCubit, BookingState>(
        builder: (context, state) {
          final draft = state.draft;
          if (draft == null) {
            return const Center(child: Text('No active booking. Please select a hotel first.'));
          }

          final breakdown = draft.priceBreakdown;

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hotel & Room summary badge
                    AppGlassCard(
                      padding: const EdgeInsets.all(16),
                      borderRadius: AppRadius.brLg,
                      child: Row(
                        children: [
                          Icon(Icons.hotel_rounded, size: 26, color: primary),
                          AppSpacing.gapW12,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  draft.hotel.name,
                                  style: AppTypography.titleSmall.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                  ),
                                ),
                                Text(
                                  draft.room.name,
                                  style: AppTypography.bodySmall.copyWith(
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppSpacing.gapH20,

                    // Dates Configuration
                    const SectionHeader(title: 'Stay Dates'),
                    AppSpacing.gapH8,
                    GestureDetector(
                      onTap: () => _pickDates(context, draft),
                      child: AppGlassCard(
                        padding: const EdgeInsets.all(16),
                        borderRadius: AppRadius.brLg,
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_month_rounded, color: AppColors.info, size: 24),
                            AppSpacing.gapW12,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Check-in to Check-out',
                                    style: AppTypography.labelSmall.copyWith(
                                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                    ),
                                  ),
                                  AppSpacing.gapH2,
                                  Text(
                                    AppDateUtils.formatRange(draft.checkIn, draft.checkOut),
                                    style: AppTypography.titleSmall.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'Change',
                              style: AppTypography.labelSmall.copyWith(
                                color: primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    AppSpacing.gapH20,

                    // Guests & Rooms Configuration
                    const SectionHeader(title: 'Guests & Rooms'),
                    AppSpacing.gapH8,
                    AppGlassCard(
                      padding: const EdgeInsets.all(16),
                      borderRadius: AppRadius.brLg,
                      child: Column(
                        children: [
                          _buildStepper(
                            'Rooms',
                            'Total rooms reserved',
                            draft.roomsCount,
                            AppConstants.minRooms,
                            AppConstants.maxRooms,
                            (val) => context.read<BookingCubit>().updateGuests(roomsCount: val),
                            isDark,
                          ),
                          const Divider(height: 24),
                          _buildStepper(
                            'Adults',
                            'Age 13 and above',
                            draft.adults,
                            AppConstants.minAdults,
                            AppConstants.maxAdults,
                            (val) => context.read<BookingCubit>().updateGuests(adults: val),
                            isDark,
                          ),
                          const Divider(height: 24),
                          _buildStepper(
                            'Children',
                            'Age 0 to 12',
                            draft.children,
                            AppConstants.minChildren,
                            AppConstants.maxChildren,
                            (val) => context.read<BookingCubit>().updateGuests(children: val),
                            isDark,
                          ),
                        ],
                      ),
                    ),
                    AppSpacing.gapH20,

                    // Guest Information Form
                    const SectionHeader(title: 'Primary Guest Information'),
                    AppSpacing.gapH8,
                    AppGlassCard(
                      padding: const EdgeInsets.all(18),
                      borderRadius: AppRadius.brLg,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: AppTextField(
                                    controller: _firstNameController,
                                    label: 'First Name',
                                    validator: (v) => Validators.validateName(v, 'First name'),
                                  ),
                                ),
                                AppSpacing.gapW12,
                                Expanded(
                                  child: AppTextField(
                                    controller: _lastNameController,
                                    label: 'Last Name',
                                    validator: (v) => Validators.validateName(v, 'Last name'),
                                  ),
                                ),
                              ],
                            ),
                            AppSpacing.gapH14,
                            AppTextField(
                              controller: _emailController,
                              label: 'Email Address',
                              keyboardType: TextInputType.emailAddress,
                              validator: Validators.validateEmail,
                            ),
                            AppSpacing.gapH14,
                            AppTextField(
                              controller: _phoneController,
                              label: 'Mobile Phone',
                              keyboardType: TextInputType.phone,
                              validator: Validators.validatePhone,
                            ),
                            AppSpacing.gapH14,
                            AppTextField(
                              controller: _specialRequestsController,
                              label: 'Special Requests (Optional)',
                              hintText: 'Early check-in, high floor, quiet room, etc.',
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                    AppSpacing.gapH20,

                    // Dynamic Live Pricing Breakdown
                    BookingPriceBreakdownWidget(breakdown: breakdown),
                  ],
                ),
              ),

              // Bottom Confirmation bar
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
                                'Total Amount',
                                style: AppTypography.labelSmall.copyWith(
                                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                ),
                              ),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  CurrencyUtils.format(breakdown.grandTotal),
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
                            onPressed: () => _onProceed(draft),
                            label: 'Review Summary',
                            isPrimary: true,
                            height: 48,
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

  Widget _buildStepper(
    String title,
    String subtitle,
    int value,
    int min,
    int max,
    ValueChanged<int> onChanged,
    bool isDark,
  ) {
    final primary = isDark ? AppColors.primaryLight : AppColors.primary;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTypography.titleSmall.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            Text(
              subtitle,
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                fontSize: 11,
              ),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline_rounded),
              onPressed: value > min ? () => onChanged(value - 1) : null,
              color: value > min ? primary : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
            ),
            Text(
              '$value',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline_rounded),
              onPressed: value < max ? () => onChanged(value + 1) : null,
              color: value < max ? primary : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
            ),
          ],
        ),
      ],
    );
  }
}
