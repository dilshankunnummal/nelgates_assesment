import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';
import '../../theme/glass_tokens.dart';
import 'glass_bottom_sheet.dart';
import 'glass_button.dart';
import 'glass_icon_button.dart';
import 'glass_surface.dart';

/// True Liquid Glass Room Count Selector Sheet.
class GlassRoomSelector extends StatefulWidget {
  final int initialRooms;
  final ValueChanged<int> onSelected;

  const GlassRoomSelector({
    super.key,
    required this.initialRooms,
    required this.onSelected,
  });

  static Future<int?> show(BuildContext context, {required int initialRooms}) {
    return showGlassBottomSheet<int>(
      context: context,
      child: GlassRoomSelector(
        initialRooms: initialRooms,
        onSelected: (val) => Navigator.of(context).pop(val),
      ),
    );
  }

  @override
  State<GlassRoomSelector> createState() => _GlassRoomSelectorState();
}

class _GlassRoomSelectorState extends State<GlassRoomSelector> {
  late int _rooms;

  @override
  void initState() {
    super.initState();
    _rooms = widget.initialRooms;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Rooms',
          style: AppTypography.titleLarge.copyWith(
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        GlassSurface(
          depthLevel: GlassDepthLevel.control,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          borderRadius: AppRadius.brMd,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rooms',
                      style: AppTypography.titleMedium.copyWith(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Max 4 rooms per booking',
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
                onPressed: _rooms > 1 ? () => setState(() => _rooms--) : null,
              ),
              SizedBox(
                width: 38,
                child: Center(
                  child: Text(
                    '$_rooms',
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
                onPressed: _rooms < 4 ? () => setState(() => _rooms++) : null,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        GlassButton(
          onPressed: () => widget.onSelected(_rooms),
          label: 'Confirm $_rooms Room${_rooms > 1 ? 's' : ''}',
          isPrimary: true,
          width: double.infinity,
          height: 52,
        ),
      ],
    );
  }
}
