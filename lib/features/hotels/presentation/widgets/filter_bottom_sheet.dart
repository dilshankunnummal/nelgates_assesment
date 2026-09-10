import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/currency_utils.dart';
import '../../../../core/widgets/glass/glass_bottom_sheet.dart';
import '../../../../core/widgets/glass/glass_button.dart';
import '../../../../core/widgets/glass/glass_chip.dart';
import '../cubits/hotel_search_cubit.dart';

class FilterBottomSheet extends StatefulWidget {
  final HotelFilterCriteria initialCriteria;
  final ValueChanged<HotelFilterCriteria> onApply;
  final VoidCallback onReset;

  const FilterBottomSheet({
    super.key,
    required this.initialCriteria,
    required this.onApply,
    required this.onReset,
  });

  static Future<void> show(
    BuildContext context, {
    required HotelFilterCriteria initialCriteria,
    required ValueChanged<HotelFilterCriteria> onApply,
    required VoidCallback onReset,
  }) {
    return showGlassBottomSheet(
      context: context,
      child: FilterBottomSheet(
        initialCriteria: initialCriteria,
        onApply: onApply,
        onReset: onReset,
      ),
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late RangeValues _priceRange;
  late double _minRating;
  late String _sortBy;
  late List<String> _selectedAmenities;

  final List<String> _availableAmenities = [
    'WiFi',
    'Pool',
    'Spa',
    'Restaurant',
    'Bar',
    'Fitness',
    'Parking',
    'Beach',
  ];

  @override
  void initState() {
    super.initState();
    _priceRange = RangeValues(
      widget.initialCriteria.minPrice,
      widget.initialCriteria.maxPrice > 0 ? widget.initialCriteria.maxPrice : 80000,
    );
    _minRating = widget.initialCriteria.minRating;
    _sortBy = widget.initialCriteria.sortBy;
    _selectedAmenities = List.from(widget.initialCriteria.selectedAmenities);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.primaryLight : AppColors.primary;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter & Sort',
                style: AppTypography.titleLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _priceRange = const RangeValues(0, 80000);
                    _minRating = 0;
                    _sortBy = 'popular';
                    _selectedAmenities.clear();
                  });
                  widget.onReset();
                },
                child: Text(
                  'Reset All',
                  style: AppTypography.labelMedium.copyWith(color: AppColors.error),
                ),
              ),
            ],
          ),
          const Divider(height: 24),

          // Sort By
          Text(
            'Sort By',
            style: AppTypography.titleSmall.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          AppSpacing.gapH12,
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildSortChip('popular', 'Popular'),
              _buildSortChip('price_low_high', 'Price: Low-High'),
              _buildSortChip('price_high_low', 'Price: High-Low'),
              _buildSortChip('rating', 'Rating'),
            ],
          ),
          AppSpacing.gapH24,

          // Price Range Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Price Per Night',
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              Text(
                '${CurrencyUtils.format(_priceRange.start)} - ${CurrencyUtils.format(_priceRange.end)}',
                style: AppTypography.labelMedium.copyWith(
                  color: primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          RangeSlider(
            values: _priceRange,
            min: 0,
            max: 80000,
            divisions: 80,
            activeColor: primary,
            inactiveColor: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            onChanged: (values) {
              setState(() {
                _priceRange = values;
              });
            },
          ),
          AppSpacing.gapH16,

          // Minimum Rating
          Text(
            'Minimum Rating',
            style: AppTypography.titleSmall.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          AppSpacing.gapH12,
          Row(
            children: [
              _buildRatingChip(0, 'All'),
              AppSpacing.gapW8,
              _buildRatingChip(3.5, '3.5+ ★'),
              AppSpacing.gapW8,
              _buildRatingChip(4.0, '4.0+ ★'),
              AppSpacing.gapW8,
              _buildRatingChip(4.5, '4.5+ ★'),
            ],
          ),
          AppSpacing.gapH24,

          // Amenities
          Text(
            'Amenities',
            style: AppTypography.titleSmall.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          AppSpacing.gapH12,
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _availableAmenities.map((amenity) {
              final isSelected = _selectedAmenities.contains(amenity);
              return GlassChip(
                label: amenity,
                isSelected: isSelected,
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedAmenities.remove(amenity);
                    } else {
                      _selectedAmenities.add(amenity);
                    }
                  });
                },
              );
            }).toList(),
          ),
          AppSpacing.gapH24,

          // Action button
          GlassButton(
            onPressed: () {
              final updated = widget.initialCriteria.copyWith(
                minPrice: _priceRange.start,
                maxPrice: _priceRange.end,
                minRating: _minRating,
                sortBy: _sortBy,
                selectedAmenities: _selectedAmenities,
              );
              widget.onApply(updated);
              Navigator.of(context).pop();
            },
            label: 'Apply Filters',
            isPrimary: true,
            width: double.infinity,
            height: 50,
          ),
          AppSpacing.gapH12,
        ],
      ),
    );
  }

  Widget _buildSortChip(String key, String label) {
    return GlassChip(
      label: label,
      isSelected: _sortBy == key,
      onTap: () => setState(() => _sortBy = key),
    );
  }

  Widget _buildRatingChip(double rating, String label) {
    return Expanded(
      child: GlassChip(
        label: label,
        isSelected: _minRating == rating,
        onTap: () => setState(() => _minRating = rating),
      ),
    );
  }
}
