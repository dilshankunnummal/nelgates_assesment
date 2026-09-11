import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';
import '../../theme/glass_tokens.dart';
import '../../utils/date_utils.dart';
import 'glass_bottom_sheet.dart';
import 'glass_button.dart';
import 'glass_surface.dart';

class GlassDatePicker extends StatefulWidget {
  final DateTime initialCheckIn;
  final DateTime initialCheckOut;
  final ValueChanged<DateTimeRange> onSelected;

  const GlassDatePicker({
    super.key,
    required this.initialCheckIn,
    required this.initialCheckOut,
    required this.onSelected,
  });

  static Future<DateTimeRange?> show(
    BuildContext context, {
    required DateTime initialCheckIn,
    required DateTime initialCheckOut,
  }) {
    return showGlassBottomSheet<DateTimeRange>(
      context: context,
      child: GlassDatePicker(
        initialCheckIn: initialCheckIn,
        initialCheckOut: initialCheckOut,
        onSelected: (range) => Navigator.of(context).pop(range),
      ),
    );
  }

  @override
  State<GlassDatePicker> createState() => _GlassDatePickerState();
}

class _GlassDatePickerState extends State<GlassDatePicker> {
  late DateTime _checkIn;
  late DateTime _checkOut;

  @override
  void initState() {
    super.initState();
    _checkIn = widget.initialCheckIn;
    _checkOut = widget.initialCheckOut;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.primaryLight : AppColors.primary;
    final nights = AppDateUtils.calculateNights(_checkIn, _checkOut);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Stay Dates',
          style: AppTypography.titleLarge.copyWith(
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: GlassSurface(
                depthLevel: GlassDepthLevel.control,
                padding: const EdgeInsets.all(12),
                borderRadius: AppRadius.brMd,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CHECK-IN',
                      style: AppTypography.labelSmall.copyWith(
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppDateUtils.formatDate(_checkIn),
                      style: AppTypography.titleMedium.copyWith(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Icon(Icons.arrow_forward_rounded, size: 18, color: primary),
                  Text(
                    '$nights night${nights > 1 ? 's' : ''}',
                    style: AppTypography.labelSmall.copyWith(
                      color: primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GlassSurface(
                depthLevel: GlassDepthLevel.control,
                padding: const EdgeInsets.all(12),
                borderRadius: AppRadius.brMd,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CHECK-OUT',
                      style: AppTypography.labelSmall.copyWith(
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppDateUtils.formatDate(_checkOut),
                      style: AppTypography.titleMedium.copyWith(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        Row(
          children: [
            _buildPresetChip('Weekend', 2),
            const SizedBox(width: 8),
            _buildPresetChip('3 Nights', 3),
            const SizedBox(width: 8),
            _buildPresetChip('1 Week', 7),
          ],
        ),
        const SizedBox(height: 24),
        GlassButton(
          onPressed: () {
            widget.onSelected(DateTimeRange(start: _checkIn, end: _checkOut));
          },
          label: 'Confirm Dates ($nights Nights)',
          isPrimary: true,
          width: double.infinity,
          height: 52,
        ),
      ],
    );
  }

  Widget _buildPresetChip(String label, int days) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.primaryLight : AppColors.primary;
    final isSelected = _checkOut.difference(_checkIn).inDays == days;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _checkOut = _checkIn.add(Duration(days: days));
          });
        },
        child: GlassSurface(
          depthLevel: GlassDepthLevel.control,
          padding: const EdgeInsets.symmetric(vertical: 10),
          borderRadius: AppRadius.brMd,
          tintColor: isSelected ? primary.withValues(alpha: isDark ? 0.28 : 0.16) : null,
          borderColor: isSelected ? primary : null,
          child: Center(
            child: Text(
              label,
              style: AppTypography.labelMedium.copyWith(
                color: isSelected
                    ? primary
                    : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
