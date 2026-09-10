import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';
import '../../theme/glass_tokens.dart';
import 'glass_bottom_sheet.dart';
import 'glass_button.dart';
import 'glass_icon_button.dart';
import 'glass_surface.dart';

class GuestCount {
  final int adults;
  final int children;

  const GuestCount({required this.adults, required this.children});
}

/// True Liquid Glass Guest Selector Sheet.
class GlassGuestSelector extends StatefulWidget {
  final int initialAdults;
  final int initialChildren;
  final ValueChanged<GuestCount> onSelected;

  const GlassGuestSelector({
    super.key,
    required this.initialAdults,
    required this.initialChildren,
    required this.onSelected,
  });

  static Future<GuestCount?> show(
    BuildContext context, {
    required int initialAdults,
    required int initialChildren,
  }) {
    return showGlassBottomSheet<GuestCount>(
      context: context,
      child: GlassGuestSelector(
        initialAdults: initialAdults,
        initialChildren: initialChildren,
        onSelected: (count) => Navigator.of(context).pop(count),
      ),
    );
  }

  @override
  State<GlassGuestSelector> createState() => _GlassGuestSelectorState();
}

class _GlassGuestSelectorState extends State<GlassGuestSelector> {
  late int _adults;
  late int _children;

  @override
  void initState() {
    super.initState();
    _adults = widget.initialAdults;
    _children = widget.initialChildren;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Guests & Occupancy',
          style: AppTypography.titleLarge.copyWith(
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        _buildCounterRow(
          title: 'Adults',
          subtitle: 'Ages 13 or above',
          count: _adults,
          min: 1,
          max: 8,
          onChanged: (val) => setState(() => _adults = val),
        ),
        const SizedBox(height: 12),
        _buildCounterRow(
          title: 'Children',
          subtitle: 'Ages 0–12',
          count: _children,
          min: 0,
          max: 6,
          onChanged: (val) => setState(() => _children = val),
        ),
        const SizedBox(height: 24),
        GlassButton(
          onPressed: () {
            widget.onSelected(GuestCount(adults: _adults, children: _children));
          },
          label: 'Apply Guests ($_adults Adults${_children > 0 ? ', $_children Children' : ''})',
          isPrimary: true,
          width: double.infinity,
          height: 52,
        ),
      ],
    );
  }

  Widget _buildCounterRow({
    required String title,
    required String subtitle,
    required int count,
    required int min,
    required int max,
    required ValueChanged<int> onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlassSurface(
      depthLevel: GlassDepthLevel.control,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: AppRadius.brMd,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.titleMedium.copyWith(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
          ),
          GlassIconButton(
            size: 34,
            icon: const Icon(Icons.remove_rounded, size: 18),
            onPressed: count > min ? () => onChanged(count - 1) : null,
          ),
          SizedBox(
            width: 38,
            child: Center(
              child: Text(
                '$count',
                style: AppTypography.titleMedium.copyWith(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          GlassIconButton(
            size: 34,
            icon: const Icon(Icons.add_rounded, size: 18),
            onPressed: count < max ? () => onChanged(count + 1) : null,
          ),
        ],
      ),
    );
  }
}
